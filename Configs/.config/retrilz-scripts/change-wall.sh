#!/bin/bash

set -euo pipefail

cache_dir="$HOME/.cache"
lock_bg_path="$cache_dir/lock_background"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <wallpapers-folder>"
    exit 1
fi

folder=${1/#\~/$HOME}
if [[ ! -d "$folder" ]]; then
    echo "Error: directory '$folder' does not exist."
    exit 1
fi

mapfile -t all_images < <(
    find "$folder" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | sort
)

if ((${#all_images[@]} == 0)); then
    echo "Error: no images found in '$folder'."
    exit 1
fi

mapfile -t shuffled_images < <(shuf -e "${all_images[@]}")

current_image=$(swww query -a | grep -oP 'image:\s*\K.*' || true)
selected_image=""

for img in "${shuffled_images[@]}"; do
    if [[ "$img" != "$current_image" ]]; then
        selected_image="$img"
        break
    fi
done

if [[ -z "$selected_image" ]]; then
    selected_image="${all_images[RANDOM % ${#all_images[@]}]}"
fi

echo "Selected image: $selected_image"

swww img -t grow \
    --transition-duration 1.8 \
    --transition-step 200 \
    --transition-fps 60 \
    "$selected_image"

matugen image "$selected_image"

mkdir -p "$cache_dir"
cp "$selected_image" "$lock_bg_path"

echo "Lock background saved to: $lock_bg_path"
