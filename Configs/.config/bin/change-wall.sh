#!/bin/bash

set -euo pipefail

CACHE_DIR="$HOME/.cache"
LOCK_BG_PATH="$CACHE_DIR/lock_background"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <wallpapers-folder>"
    exit 1
fi

folder=${1/#\~/$HOME}
if [[ ! -d "$folder" ]]; then
    echo "Error: directory '$folder' does not exist."
    exit 1
fi

# Get a random image from the folder
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

# Get a random transition position
rand() { printf "0.%02d\n" $((RANDOM % 100)); }

px=$(rand)
py=$(rand)
transition_pos="$px,$py"

# Set the selected image
swww img -t grow \
    --transition-pos "$transition_pos" \
    --transition-duration 1.8 \
    --transition-step 255 \
    --transition-fps 60 \
    "$selected_image"

# Generate a color palette
matugen image "$selected_image"

# Set the lock background
mkdir -p "$CACHE_DIR"
cp "$selected_image" "$LOCK_BG_PATH"

echo "Lock background saved to: $LOCK_BG_PATH"
