#!/bin/bash
set -euo pipefail

FLAKE_DIR=~/Programming/sysadmin/nix-infra
MACHINES=("desktop" "vault") # bootstrap excluded, ISO-only

cd "$FLAKE_DIR"
${EDITOR:-nvim} .

desktop_changed=0
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
        desktop_changed=1
        vault_changed=1
    else
        for machine in "${MACHINES[@]}"; do
            echo -n "Update $machine flake? [y/N] "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                update_flake "$machine"
                [[ "$machine" == "desktop" ]] && desktop_changed=1
                [[ "$machine" == "vault" ]] && vault_changed=1
            fi
        done
    fi

    # Bail if nothing actually changed after updates
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

    # Root flake.nix or shared affects everyone
    if echo "$changed_files" | grep -qE '^(flake\.nix|machines/shared/)'; then
        desktop_changed=1
        vault_changed=1
    fi
    echo "$changed_files" | grep -q 'machines/desktop/' && desktop_changed=1
    echo "$changed_files" | grep -q 'machines/vault/' && vault_changed=1
fi

echo ""
case "${desktop_changed}${vault_changed}" in
11) echo "Changes affect both desktop and vault" ;;
10) echo "Changes affect desktop only" ;;
01) echo "Changes affect vault only" ;;
00) echo "Nothing changed, exiting" && exit 0 ;;
esac

echo -n "Build and switch? [Y/n] "
read -r response
[[ "$response" =~ ^[Yy]$|^$ ]] || exit 0

commits=""
git add .

if [[ $desktop_changed -eq 1 ]]; then
    echo "Building desktop..."
    sudo -v && sudo nixos-rebuild switch --flake '/home/hexolexo/Programming/sysadmin/nix-infra#hexolexo' |& nom
    gen=$(nixos-rebuild list-generations | awk 'NR==2 {print $1}')
    commits="desktop: gen $gen"
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
