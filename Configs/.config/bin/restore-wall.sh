#!/bin/bash

set -euo pipefail

awww restore

state_json=$(awww query -j)

image_path=$(echo "$state_json" | grep -oP '"image":\s*"\K[^"]+' | head -1)

if [[ -z "$image_path" ]]; then
    echo "Error: could not determine current wallpaper image from awww query output."
    exit 1
fi

echo "Current wallpaper: $image_path"

matugen image "$image_path"

echo "Color palette generated for: $image_path"
