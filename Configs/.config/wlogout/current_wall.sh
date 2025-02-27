#!/bin/bash

TARGET_DIR="$HOME/Pictures"

SELECTED_WALLPAPER=$(waypaper --list | sed -n 's/.*"wallpaper":\s*"\(.*\)".*/\1/p')


cp "$SELECTED_WALLPAPER" "$TARGET_DIR/wlogoutbg"
