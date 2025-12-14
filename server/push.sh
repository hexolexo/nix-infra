#!/bin/bash
git push "$@" || { echo "Push failed"; exit 1; }

ssh root@server 'cd /etc/nixos && git pull && systemctl start deploy-watchdog && nixos-rebuild test' || {
    echo "Rebuild test failed, not switching"
    ssh root@server 'systemctl stop deploy-watchdog'
    exit 1
}
while ssh root@server 'pgrep nixos-rebuild' 2>/dev/null; do 
    sleep 5
done

sleep 10

ssh root@server 'systemctl stop deploy-watchdog && nixos-rebuild switch'

git push github master 2>/dev/null || echo "GitHub push failed"

