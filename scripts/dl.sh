#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

TITLE=$(yt-dlp --get-title "$1" 2>/dev/null)

FILENAME=$(gum input --placeholder "Output filename" --value "$TITLE" || exit 1)

if [ -z "$FILENAME" ]; then
    exit 1
fi

yt-dlp -x --audio-format mp3 -o "$HOME/Music/global/${FILENAME}.%(ext)s" --progress "$1"
