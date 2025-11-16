#!/usr/bin/env bash
set -euo pipefail

CACHE_DIR="$HOME/.cache"
LOCK_BG_PATH="$CACHE_DIR/lock_background"

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
IMAGE_PICKER_CONFIG="$HOME/.config/rofi/wallpapers.rasi"

mapfile -t WALLPAPERS < <(
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort
)

CURRENT_WALLPAPER=$(basename "$(swww query | awk '/image:/ {print $NF}')")

ROFI_MENU=""
for path in "${WALLPAPERS[@]}"; do
    name=$(basename "$path")
    if [[ "$name" == "$CURRENT_WALLPAPER" ]]; then
        ROFI_MENU+="${name} (current)\0icon\x1f${path}\n"
    else
        ROFI_MENU+="${name}\0icon\x1f${path}\n"
    fi
done

SELECTED=$(printf "%b" "$ROFI_MENU" | rofi -dmenu -theme "$IMAGE_PICKER_CONFIG" -p " ")

[[ -z "$SELECTED" ]] && exit 0

SELECTED_CLEAN=${SELECTED// \(current\)/}

SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_CLEAN"
if [[ ! -f "$SELECTED_PATH" ]]; then
    notify-send "Wallpaper error" "File not found: $SELECTED_PATH"
    exit 1
fi

px=$(shuf -i 0-100 -n 1 | awk '{printf "%.2f", $1/100}')
py=$(shuf -i 0-100 -n 1 | awk '{printf "%.2f", $1/100}')
transition_pos="$px,$py"

swww img -t grow \
    --transition-pos "$transition_pos" \
    --transition-duration 1.8 \
    --transition-step 255 \
    --transition-fps 60 \
    "$SELECTED_PATH"

matugen image "$SELECTED_PATH"

mkdir -p "$CACHE_DIR"
cp "$SELECTED_PATH" "$LOCK_BG_PATH"
