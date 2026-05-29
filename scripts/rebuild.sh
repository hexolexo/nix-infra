#!/bin/bash
set -euo pipefail

FLAKE_DIR=~/Programming/sysadmin/nix-infra
MACHINES=("desktop" "laptop" "vault") # bootstrap excluded, ISO-only

# Map hostname -> flake target and machine dir
# HACK: update this if hostnames change
declare -A HOST_FLAKE=(
    ["hexolexo"]="hexolexo"
    ["hexolexo-pc"]="hexolexo-pc"
)
declare -A HOST_MACHINE=(
    ["hexolexo"]="laptop"
    ["hexolexo-pc"]="desktop"
)

HOSTNAME=$(hostname)
LOCAL_FLAKE="${HOST_FLAKE[$HOSTNAME]:-}"
LOCAL_MACHINE="${HOST_MACHINE[$HOSTNAME]:-}"

if [[ -z "$LOCAL_FLAKE" ]]; then
    echo "Unknown hostname: $HOSTNAME — add it to HOST_FLAKE/HOST_MACHINE"
    exit 1
fi

cd "$FLAKE_DIR"
${EDITOR:-nvim} .

local_changed=0
vault_changed=0

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
    echo "No changes made."
    echo -n "Update all flakes? [y/N] "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        for machine in "${MACHINES[@]}"; do
            update_flake "$machine"
        done
        local_changed=1
        vault_changed=1
    else
        for machine in "${MACHINES[@]}"; do
            echo -n "Update $machine flake? [y/N] "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                update_flake "$machine"
                [[ "$machine" == "$LOCAL_MACHINE" ]] && local_changed=1
                [[ "$machine" == "vault" ]] && vault_changed=1
            fi
        done
    fi

    if git diff --quiet; then
        echo "Flakes already up to date, exiting"
        exit 0
    fi
else
    alejandra . 2>&1 | grep -v "ℹ" || true
    git diff --name-only
    git diff --cached --name-only

    changed_files=$(
        git diff --name-only
        git diff --cached --name-only
    )

    # shared/ changes affect local machine too
    if echo "$changed_files" | grep -qE '^(flake\.nix|machines/shared/)'; then
        local_changed=1
        vault_changed=1
    fi

    echo "$changed_files" | grep -q "machines/$LOCAL_MACHINE/" && local_changed=1
    echo "$changed_files" | grep -q 'machines/vault/' && vault_changed=1
fi

echo ""
case "${local_changed}${vault_changed}" in
11) echo "Changes affect $HOSTNAME and vault" ;;
10) echo "Changes affect $HOSTNAME only" ;;
01) echo "Changes affect vault only" ;;
00) echo "Nothing changed, exiting" && exit 0 ;;
esac

echo -n "Build and switch? [Y/n] "
read -r response
[[ "$response" =~ ^[Yy]$|^$ ]] || exit 0

commits=""
git add .

if [[ $local_changed -eq 1 ]]; then
    echo "Building $HOSTNAME..."
    sudo -v && sudo nixos-rebuild switch --flake "$FLAKE_DIR#$LOCAL_FLAKE" |& nom
    gen=$(nixos-rebuild list-generations | awk 'NR==2 {print $1}')
    commits="$LOCAL_MACHINE: gen $gen"
fi

if [[ $vault_changed -eq 1 ]]; then
    echo "Deploying vault..."
    nix develop --command deploy .#vault
    [[ -n "$commits" ]] && commits="$commits, vault deployed" || commits="vault deployed"
fi

if [[ -z "$commits" ]]; then
    echo "No builds executed, nothing to commit"
    exit 1
fi

git add -A
git commit -m "$commits"
git push
echo "Done"
