#!/usr/bin/env bash
set -euo pipefail

TARGET_HOST="hexolexo-pc"
TARGET_COMMENT="hexolexo-pc"
SECRETS_KEY_PATTERN="hexolexo-pc"

#read -rp "Burn new image? [y/N] " yn
#if [[ "$yn" =~ ^[Yy]$ ]]; then
#nix build .#bootstrap
#caligula burn ./result/iso/*.iso --root always
#fi

read -rp "Boot the target machine and enter its IP once it's up: " TARGET_IP

KEY_DIR=$(mktemp -d)
EXTRA_FILES=$(mktemp -d)
trap 'rm -rf "$KEY_DIR" "$EXTRA_FILES"' EXIT

ssh-keygen -t ed25519 -f "$KEY_DIR/ssh_host_ed25519_key" -C "$TARGET_COMMENT" -N ""
PUB_KEY=$(cat "$KEY_DIR/ssh_host_ed25519_key.pub")

# WARN: this sed is brittle — if the secrets.nix key name doesn't match $SECRETS_KEY_PATTERN exactly, it silently does nothing
sed -i "s|${SECRETS_KEY_PATTERN} = \"ssh-ed25519.*\";|${SECRETS_KEY_PATTERN} = \"$PUB_KEY\";|" machines/desktop/secrets/secrets.nix

cd secrets && agenix -r && cd ..
git add machines/desktop/secrets/
git commit -m "chore: rotate ${TARGET_HOST} host key"

mkdir -p "$EXTRA_FILES/etc/ssh"
cp "$KEY_DIR/ssh_host_ed25519_key" "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key"
chmod 600 "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key"

nix run github:nix-community/nixos-anywhere -- \
    --flake ".#${TARGET_HOST}" \
    --build-on-remote \
    --extra-files "$EXTRA_FILES" \
    root@"$TARGET_IP"
