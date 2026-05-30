#!/bin/bash
set -euo pipefail

# Ensure gum is installed
if ! command -v gum &>/dev/null; then
    echo "Error: 'gum' is not installed."
    exit 1
fi

FLAKE_DIR=~/Programming/sysadmin/nix-infra
MACHINES=("desktop" "laptop" "vault") # bootstrap excluded, ISO-only
NATS_SERVER="nats://10.0.0.1:4222"
NATS_KEY="$HOME/.secrets/testkey"

# Map hostname -> flake target and machine dir
declare -A HOST_FLAKE=(
    ["hexolexo"]="hexolexo"
    ["hexolexo-pc"]="hexolexo-pc"
)
declare -A HOST_MACHINE=(
    ["hexolexo"]="laptop"
    ["hexolexo-pc"]="desktop"
)

# Reverse mapping to get flake target names from machine directories
declare -A MACHINE_TO_FLAKE=(
    ["laptop"]="hexolexo"
    ["desktop"]="hexolexo-pc"
    ["vault"]="vault"
)

HOSTNAME=$(hostname)
LOCAL_FLAKE="${HOST_FLAKE[$HOSTNAME]:-}"
LOCAL_MACHINE="${HOST_MACHINE[$HOSTNAME]:-}"

if [[ -z "$LOCAL_FLAKE" ]]; then
    gum format "## Unknown hostname: $HOSTNAME — add it to HOST_FLAKE/HOST_MACHINE"
    exit 1
fi

cd "$FLAKE_DIR"
${EDITOR:-nvim} .

# Track which machines need a rebuild trigger
declare -A CHANGED_MACHINES=()
for m in "${MACHINES[@]}"; do CHANGED_MACHINES[$m]=0; done

update_flake() {
    local machine=$1
    echo "Updating flake.lock for $machine..."
    nix flake update --flake "$FLAKE_DIR/machines/$machine"
}

has_changes() {
    ! git diff --quiet ||
        ! git diff --cached --quiet ||
        [ -n "$(git ls-files --others --exclude-standard)" ]
}

if ! has_changes; then
    gum format "### No local changes detected."

    # Use gum choose --no-limit for a multi-select checkbox menu
    echo "Select machines to update (Space to select, Enter to confirm):"
    SELECTED_MACHINES=$(gum choose --no-limit "${MACHINES[@]}")

    if [[ -n "$SELECTED_MACHINES" ]]; then
        # Convert newline-separated string from gum into an array
        mapfile -t targets <<<"$SELECTED_MACHINES"
        for machine in "${targets[@]}"; do
            update_flake "$machine"
            CHANGED_MACHINES[$machine]=1
        done
    fi

    if git diff --quiet; then
        gum format "*Flakes already up to date, exiting.*"
        exit 0
    fi
else
    alejandra . 2>&1 | grep -v "ℹ" || true

    changed_files=$(
        git diff --name-only
        git diff --cached --name-only
    )

    # shared/ or root flake changes affect everything
    if echo "$changed_files" | grep -qE '^(flake\.nix|machines/shared/)'; then
        for machine in "${MACHINES[@]}"; do
            CHANGED_MACHINES[$machine]=1
        done
    else
        # Check specific machine folders
        for machine in "${MACHINES[@]}"; do
            if echo "$changed_files" | grep -q "machines/$machine/"; then
                CHANGED_MACHINES[$machine]=1
            fi
        done
    fi
fi

# Determine which systems actually need publishing
targets_to_rebuild=()
for machine in "${MACHINES[@]}"; do
    if [[ ${CHANGED_MACHINES[$machine]} -eq 1 ]]; then
        targets_to_rebuild+=("${MACHINE_TO_FLAKE[$machine]}")
    fi
done

if [[ ${#targets_to_rebuild[@]} -eq 0 ]]; then
    gum format "### Nothing changed, exiting."
    exit 0
fi

echo ""
gum format "### Pending NATS Rebuilds:"
for target in "${targets_to_rebuild[@]}"; do
    echo "  • $target"
done
echo ""
HAS_UNTRACKED=$(git ls-files --others --exclude-standard)
if [[ -n "$HAS_UNTRACKED" ]]; then
    git add -N .
fi

validate_target() {
    local target=$1
    nix eval ".#nixosConfigurations.${target}.config.system.build.toplevel.drvPath" --show-trace >/dev/null
}

export -f validate_target
gum format "### Validating Nix configurations..."

VALIDATION_FAILED=0
for target in "${targets_to_rebuild[@]}"; do
    gum format "### Checking output for **$target**..."

    # Run Nix directly so it retains access to your terminal's TTY
    if ! validate_target "$target"; then
        gum format "## ❌ Validation failed for target: **$target**"
        VALIDATION_FAILED=1
    fi
done

# Undo the temporary git add -N if validation fails or succeeds
if [[ -n "$HAS_UNTRACKED" ]]; then
    git restore --staged . &>/dev/null || true
fi

if [[ "$VALIDATION_FAILED" -eq 1 ]]; then
    gum format "### Fix errors before committing."
    exit 1
fi

gum format "## \e[32m✔ All targets validated successfully!\e[0m"
echo ""
# Use gum confirm for the final verification step
if gum confirm "Commit, push, and trigger via NATS?"; then
    # Git Operations
    git add -A
    commits="rebuild triggered for: $(
        IFS=,
        echo "${targets_to_rebuild[*]}"
    )"
    git commit -m "$commits"
    git push

    # Trigger NATS publications wrapped in a clean gum spin animation
    # We pass the array elements as arguments to the bash -c subshell safely
    gum spin --spinner dot --title "Publishing NATS rebuild events..." -- \
        bash -c '
            NATS_KEY="$1"
            NATS_SERVER="$2"
            shift 2
            for target in "$@"; do
                nats pub --nkey="$NATS_KEY" "nix.rebuild.$target" "" --server "$NATS_SERVER" > /dev/null
            done
        ' -- "$NATS_KEY" "$NATS_SERVER" "${targets_to_rebuild[@]}"

    gum format "## Done!"
else
    gum format "*Aborted by user.*"
    exit 0
fi
