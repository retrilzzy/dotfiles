#!/bin/bash

TARGET_DIR="$HOME/.cache"

SELECTED_WALLPAPER=$(waypaper --list | waypaper --list | jq -r '.[0].wallpaper')


cp "$SELECTED_WALLPAPER" "$TARGET_DIR/wlogout_background"
