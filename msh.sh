#!/usr/bin/env bash
set -euo pipefail

WORKING_DIR="$(pwd)"
SESSION_NAME="dev-$(basename "$(pwd)")-$$"
REMOTE_DIR="/tmp/mutagen/$SESSION_NAME"

if ! mutagen daemon status &>/dev/null; then
    echo "Starting mutagen daemon..."
    mutagen daemon start
fi

# Create remote dir and start sync
ssh server "rm -rf $REMOTE_DIR && mkdir -p $REMOTE_DIR"

echo "Starting sync: $SESSION_NAME -> server:$REMOTE_DIR"
mutagen sync create \
    --name "$SESSION_NAME" \
    --ignore '.git' \
    --ignore 'result' \
    --sync-mode two-way-resolved \
    "$WORKING_DIR" "server:$REMOTE_DIR"

cleanup() {
    echo "Terminating sync..."
    mutagen sync terminate "$SESSION_NAME"
}
trap cleanup EXIT

echo "Waiting for initial sync..."
mutagen sync flush "$SESSION_NAME"

echo "Entering remote shell at $REMOTE_DIR"
ssh -t server "cd $REMOTE_DIR && exec bash"
