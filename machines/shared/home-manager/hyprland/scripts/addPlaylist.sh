#!/usr/bin/env bash
playlist=$(find ~/Music -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | fuzzel --dmenu)
[[ -z "$playlist" ]] && exit

mpc clear
mpc add "$playlist"  # Adds entire folder
[[ -f "$HOME/Music/$playlist/playlistShouldShuffle" ]] && mpc shuffle
mpc play
