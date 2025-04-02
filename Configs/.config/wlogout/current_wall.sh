#!/bin/bash

TARGET_DIR="$HOME/Pictures"

SELECTED_WALLPAPER=$(waypaper --list | waypaper --list | jq -r '.[0].wallpaper')


cp "$SELECTED_WALLPAPER" "$TARGET_DIR/wlogoutbg"
