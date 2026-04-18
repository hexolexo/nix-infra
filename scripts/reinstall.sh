#!/usr/bin/env bash
set -euo pipefail

nix build .#

KEY_DIR=$(mktemp -d)
EXTRA_FILES=$(mktemp -d)
trap 'rm -rf "$KEY_DIR" "$EXTRA_FILES"' EXIT

ssh-keygen -t ed25519 -f "$KEY_DIR/ssh_host_ed25519_key" -C "vault" -N ""
PUB_KEY=$(cat "$KEY_DIR/ssh_host_ed25519_key.pub")

sed -i "s|vault = \"ssh-ed25519.*\";|vault = \"$PUB_KEY\";|" secrets/secrets.nix

cd secrets && agenix -r && cd ..

git add secrets/
git commit -m "chore: rotate vault host key"
git push

mkdir -p "$EXTRA_FILES/etc/ssh"
cp "$KEY_DIR/ssh_host_ed25519_key" "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key"
chmod 600 "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key"

nix run github:nix-community/nixos-anywhere -- \
    --flake .#vault \
    --extra-files "$EXTRA_FILES" \
    root@"$TARGET_IP"
