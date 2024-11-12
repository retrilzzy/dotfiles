#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
INDEX_FILE="$HOME/.current_wallpaper_index"

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--directory)
      WALLPAPER_DIR="$2"
      shift 2
      ;;
    -n|--next)
      ACTION="next"
      shift
      ;;
    -p|--prev)
      ACTION="prev"
      shift
      ;;
    -c|--clear)
      ACTION="clear"
      shift
      ;;
    -r|--random)
      ACTION="random"
      shift
      ;;
    *)
      echo "Неправильный флаг: $1"
      exit 1
      ;;
  esac
done

if [ ! -f "$INDEX_FILE" ]; then
  echo 0 > "$INDEX_FILE"
fi

WALLPAPERS=("$WALLPAPER_DIR"/*)
WALLPAPER_COUNT=${#WALLPAPERS[@]}

CURRENT_INDEX=$(<"$INDEX_FILE")

if [[ "$ACTION" == "next" ]]; then
  ((CURRENT_INDEX=(CURRENT_INDEX + 1) % WALLPAPER_COUNT))
elif [[ "$ACTION" == "prev" ]]; then
  ((CURRENT_INDEX=(CURRENT_INDEX - 1 + WALLPAPER_COUNT) % WALLPAPER_COUNT))
elif [[ "$ACTION" == "clear" ]]; then
  hyprctl hyprpaper unload all
  notify-send "Все обои выгружены."
  exit 0
elif [[ "$ACTION" == "random" ]]; then
  NEW_INDEX=$CURRENT_INDEX
  while [[ $NEW_INDEX -eq $CURRENT_INDEX ]]; do
    NEW_INDEX=$((RANDOM % WALLPAPER_COUNT))
  done
  CURRENT_INDEX=$NEW_INDEX
else
  exit 0
fi

echo "$CURRENT_INDEX" > "$INDEX_FILE"

SELECTED_WALLPAPER="${WALLPAPERS[$CURRENT_INDEX]}"

hyprctl hyprpaper preload "$SELECTED_WALLPAPER"
hyprctl hyprpaper wallpaper "eDP-1,$SELECTED_WALLPAPER"

