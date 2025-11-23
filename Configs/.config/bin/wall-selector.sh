#!/bin/bash
set -euo pipefail

CACHE_DIR="$HOME/.cache"
LOCK_BG_PATH="$CACHE_DIR/lock_background"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <wallpapers-directory>"
    exit 1
fi

DIR="$1"
if [[ ! -d "$DIR" ]]; then
    echo "Directory not found: $DIR"
    exit 1
fi

SELECTED=$(
    find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) |
        sort |
        vicinae dmenu --no-metadata -p " Pick a wallpaper..."
)
[[ -z "$SELECTED" ]] && exit 0

rand() {
    printf "%.2f" "$(awk -v r=$((RANDOM % 101)) 'BEGIN {print r/100}')"
}

px=$(rand)
py=$(rand)
transition_pos="$px,$py"

swww img "$SELECTED" \
    -t grow \
    --transition-pos "$transition_pos" \
    --transition-duration 1.8 \
    --transition-step 255 \
    --transition-fps 60

matugen image "$SELECTED"

mkdir -p "$CACHE_DIR"
cp "$SELECTED" "$LOCK_BG_PATH"
