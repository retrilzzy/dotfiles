#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

INDEX_FILE="$HOME/.current_wallpaper_index"

if [ ! -f "$INDEX_FILE" ]; then
  echo 0 > "$INDEX_FILE"
fi

WALLPAPERS=("$WALLPAPER_DIR"/*)
WALLPAPER_COUNT=${#WALLPAPERS[@]}

CURRENT_INDEX=$(<"$INDEX_FILE")

if [[ "$1" == "-next" ]]; then
  ((CURRENT_INDEX=(CURRENT_INDEX + 1) % WALLPAPER_COUNT))
elif [[ "$1" == "-prev" ]]; then
  ((CURRENT_INDEX=(CURRENT_INDEX - 1 + WALLPAPER_COUNT) % WALLPAPER_COUNT))
else
  exit 0
fi

echo "$CURRENT_INDEX" > "$INDEX_FILE"

SELECTED_WALLPAPER="${WALLPAPERS[$CURRENT_INDEX]}"
CURRENT_WALLPAPER=$(hyprctl -j monitors | jq -r '.[] | select(.name=="eDP-1") | .wallpaper')

if [ "$CURRENT_WALLPAPER" != "$SELECTED_WALLPAPER" ]; then
  hyprctl hyprpaper preload "$SELECTED_WALLPAPER"
  hyprctl hyprpaper wallpaper "eDP-1,$SELECTED_WALLPAPER"
fi
