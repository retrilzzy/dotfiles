#!/bin/bash

set -e

TEMP_DIR="/tmp"
FILENAME="$(date +%F_%T)-grim.png"
FILE_PATH="$TEMP_DIR/$FILENAME"

# Take the screenshot of the region
grim -c -g "$(slurp)" "$FILE_PATH" || exit 1

# Upload the screenshot to ChibiSafe with Python script
"$HOME/.config/hypr/scripts/.venv/bin/python3.12" "$HOME/.config/hypr/scripts/chibisafe_uploader.py" "$FILE_PATH"

rm "$FILE_PATH"
