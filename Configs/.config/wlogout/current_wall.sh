#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
INDEX_FILE="$HOME/.current_wallpaper_index"
TARGET_DIR="$HOME/Pictures"

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--directory)
      WALLPAPER_DIR="$2"
      shift 2
      ;;
    *)
      echo "Неправильный флаг: $1"
      exit 1
      ;;
  esac
done

if [ ! -f "$INDEX_FILE" ] || [ ! -s "$INDEX_FILE" ]; then
  echo 1 > "$INDEX_FILE"
fi

WALLPAPERS=("$WALLPAPER_DIR"/*)
CURRENT_INDEX=$(<"$INDEX_FILE")

SELECTED_WALLPAPER="${WALLPAPERS[$CURRENT_INDEX]}"


cp "$SELECTED_WALLPAPER" "$TARGET_DIR/wlogoutbg"
