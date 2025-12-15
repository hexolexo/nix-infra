#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${1:-.}" 
REMOTE_DIR="/tmp/mutagen-$(basename "$PROJECT_DIR")-$$"

if ! mutagen daemon status &>/dev/null; then
    echo "Starting mutagen daemon..."
    mutagen daemon start
fi

# Create remote dir and start sync
ssh vault "rm -rf $REMOTE_DIR && mkdir -p $REMOTE_DIR"

echo "Starting sync: $PROJECT_DIR -> vault:$REMOTE_DIR"
mutagen sync create \
    --name "dev-$(basename "$PROJECT_DIR")-$$" \
    --ignore '.git' \
    --ignore 'result' \
    --sync-mode two-way-resolved \
    "$PROJECT_DIR" "vault:$REMOTE_DIR"

cleanup() {
    echo "Terminating sync..."
    mutagen sync terminate "dev-$(basename "$PROJECT_DIR")-$$"
}
trap cleanup EXIT

echo "Waiting for initial sync..."
mutagen sync flush "dev-$(basename "$PROJECT_DIR")-$$"

echo "Entering remote shell at $REMOTE_DIR"
ssh -t vault "cd $REMOTE_DIR && exec bash"
