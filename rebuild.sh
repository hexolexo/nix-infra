#!/bin/bash
set -euo pipefail

flake_dir=~/Programming/sysadmin/nix-infra
cd "$flake_dir"

${EDITOR:-nvim} .

if git diff --quiet; then
    echo "No changes made, exiting"
    exit 0
fi

alejandra . 2>&1 | grep -v "ℹ" || true
git diff -U0 '*.nix'

changed_files=$(git diff --name-only '*.nix')
desktop_changed=0
server_changed=0

if echo "$changed_files" | grep -q 'desktop'; then
    desktop_changed=1
fi

if echo "$changed_files" | grep -q 'server'; then
    server_changed=1
fi

echo ""
case "$desktop_changed$server_changed" in
    11) echo "Changes affect both desktop and server" ;;
    10) echo "Changes affect desktop only" ;;
    01) echo "Changes affect server only" ;;
esac

echo -n "Build and switch? [Y/n] "
read -r response
[[ "$response" =~ ^[Yy]$|^$ ]] || exit 0  # Default to yes on empty response

git add -A

commits=""

if [[ $desktop_changed -eq 1 ]]; then
    echo "Building desktop..."
    sudo nixos-rebuild switch --flake ".#hexolexo" |& nom
    gen=$(nixos-rebuild list-generations | head -n2 | tail -n1 | awk '{print $1}')
    commits="desktop: gen $gen"
fi

if [[ $server_changed -eq 1 ]]; then
    echo "Deploying to server..."
    deploy .#vault
    [[ -n "$commits" ]] && commits="$commits, vault deployed" || commits="vault deployed"
fi

if [[ -z "$commits" ]]; then
    echo "No builds executed, nothing to commit"
    exit 1
fi


git commit -m "$commits"
git push

echo "Done"
