#!/run/current-system/sw/bin/bash

MUSIC_DIR="$HOME/Music"

handle_file() {
    local file="$1"
    dest=$(gum filter -- "$MUSIC_DIR"/*/) || return # user bailed, nothing to do
    ln -- "$file" "$dest"
}

for file in "$MUSIC_DIR"/global/*; do
    name="$(basename "$file")"
    # check every dir at this level (except global) for a file with the same name
    found=false
    for dir in "$MUSIC_DIR"/*/; do
        [[ "$dir" == "$MUSIC_DIR/global/" ]] && continue
        [[ -e "$dir$name" ]] && {
            found=true
            break
        }
    done
    $found && continue

    mpv --no-video --really-quiet "$file" >/dev/null 2>&1 &
    MPV_PID=$!

    read -rp "$name [y/N]: " answer

    kill "$MPV_PID" 2>/dev/null
    wait "$MPV_PID" 2>/dev/null

    case "$answer" in
    [yY]) handle_file "$file" ;;
    *) continue ;;
    esac
done
