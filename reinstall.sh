#!/usr/bin/env bash
set -euo pipefail
TARGET_HOST="hexolexo-pc"
read -rp "IP: " TARGET_IP
nix run github:nix-community/nixos-anywhere -- \
    --flake ".#${TARGET_HOST}" \
    --build-on-remote \
    root@"$TARGET_IP"
