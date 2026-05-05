#!/usr/bin/env bash
mpc idleloop player 2>/dev/null | while read event; do
    mpc current | sed 's/\.[^.]*$//' | sed 's|.*/||' 2>/dev/null || echo ''
done
