#!/bin/bash
set -euo pipefail

if ! command -v gum &>/dev/null; then
    echo "Error: 'gum' is not installed."
    exit 1
fi

FLAKE_DIR=~/Programming/sysadmin/nix-infra
MACHINES=("desktop" "laptop" "vault")
NATS_SERVER="nats://10.0.0.1:4222"
NATS_KEY="$HOME/.secrets/testkey"

declare -A HOST_FLAKE=(
    ["hexolexo"]="hexolexo"
    ["hexolexo-pc"]="hexolexo-pc"
)
declare -A HOST_MACHINE=(
    ["hexolexo"]="laptop"
    ["hexolexo-pc"]="desktop"
)
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

    echo "Select machines to update (Space to select, Enter to confirm):"
    SELECTED_MACHINES=$(gum choose --no-limit "${MACHINES[@]}")

    if [[ -n "$SELECTED_MACHINES" ]]; then
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

    if echo "$changed_files" | grep -qE '^(flake\.nix|machines/shared/)'; then
        for machine in "${MACHINES[@]}"; do
            CHANGED_MACHINES[$machine]=1
        done
    else
        for machine in "${MACHINES[@]}"; do
            if echo "$changed_files" | grep -q "machines/$machine/"; then
                CHANGED_MACHINES[$machine]=1
            fi
        done
    fi
fi

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
    if ! validate_target "$target"; then
        gum format "## ❌ Validation failed for target: **$target**"
        VALIDATION_FAILED=1
    fi
done

if [[ -n "$HAS_UNTRACKED" ]]; then
    git restore --staged . &>/dev/null || true
fi

if [[ "$VALIDATION_FAILED" -eq 1 ]]; then
    gum format "### Fix errors before committing."
    exit 1
fi

gum format "## ✔ All targets validated successfully!"
echo ""

if gum confirm "Commit, push, and trigger via NATS?"; then
    git add -A
    commits="rebuild triggered for: $(
        IFS=,
        echo "${targets_to_rebuild[*]}"
    )"
    git commit -m "$commits"
    git push

    gum spin --spinner dot --title "Publishing NATS rebuild events..." -- \
        bash -c '
            NATS_KEY="$1"
            NATS_SERVER="$2"
            shift 2
            for target in "$@"; do
                nats pub --nkey="$NATS_KEY" "nix.rebuild.$target" "" --server "$NATS_SERVER" > /dev/null
            done
        ' -- "$NATS_KEY" "$NATS_SERVER" "${targets_to_rebuild[@]}"

    gum format "## Waiting for rebuild status..."
    echo ""

    # Track which targets we're still waiting on
    # WARN: associative arrays need declare -A, not assignment during declare
    declare -A pending=()
    for target in "${targets_to_rebuild[@]}"; do
        pending[$target]=1
    done
    total=${#targets_to_rebuild[@]}
    done_count=0

    while IFS= read -r line; do
        host=$(echo "$line" | grep -o '"host":"[^"]*"' | cut -d'"' -f4)
        status=$(echo "$line" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        message=$(echo "$line" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)

        [[ -z "$host" ]] && continue

        if [[ "$status" == "ok" ]]; then
            gum format "### ✅ $host"
        else
            # err — print the full message so they know what exploded
            gum format "### ❌ $host — $message"
        fi

        for target in "${!pending[@]}"; do
            if [[ "$target" == "$host" ]]; then
                unset "pending[$target]"
                ((done_count++)) || true
                break
            fi
        done

        [[ $done_count -ge $total ]] && break
    done < <(
        nats sub "nix.listen" \
            --nkey="$NATS_KEY" \
            --server="$NATS_SERVER" \
            --count="$total" \
            --timeout=300s \
            2>/dev/null
    )

    # Report anything that never responded
    for target in "${!pending[@]}"; do
        gum format "### ⚠️  $target — no response within timeout"
    done

    gum format "## Done!"
else
    gum format "*Aborted by user.*"
    exit 0
fi
