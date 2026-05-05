#!/bin/bash
set -euo pipefail

root=~/Programming/sysadmin/nix-infra
cd "$root"

updated=0

for dir in machines/*/; do
    echo -n "Update $dir? [y/N] "
    read -r r
    [[ "$r" =~ ^[Yy]$ ]] || continue
    cd "$dir"
    nix flake update
    cd ../..
    updated=1
done

if [[ $updated -eq 0 ]]; then
    echo "No sub-flakes updated, exiting"
    exit 0
fi

nix flake update

git diff '*/flake.lock' flake.lock
git add '*/flake.lock' flake.lock
git commit -m "flake: update inputs"
git push
