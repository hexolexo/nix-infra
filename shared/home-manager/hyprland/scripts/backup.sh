#!/bin/bash
export BORG_REPO="server:~/borg-repo"
export BORG_PASSCOMMAND="pass show backup/borg"

borg create --stats --compression lz4 \
  ::'{hostname}-{now}' \
  ~/.config ~/Documents ~/Programming \
  ~/.password-store ~/Music ~/.ssh ~/.gnupg \
  || { echo "Backup failed"; exit 1; }

borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=6 \
  || { echo "Prune failed"; exit 1; }

borg check --last 3 || echo "Check failed - investigate"
