#!/bin/bash

TARGET_DIR="$HOME/.cache"

SELECTED_WALLPAPER=$(waypaper --list | jq -r '.[0].wallpaper' 2>/dev/null)

if [[ -n "$SELECTED_WALLPAPER" && -f "$SELECTED_WALLPAPER" ]]; then
    cp "$SELECTED_WALLPAPER" "$TARGET_DIR/lock_background"
else
    echo "Failed to retrieve wallpaper from waypaper" >&2
fi
