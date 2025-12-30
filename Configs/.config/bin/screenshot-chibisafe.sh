#!/bin/bash

# Chibisafe
# https://chibisafe.app/

set -e

if [[ -f "$HOME/.config/bin/.env" ]]; then
    source "$HOME/.config/bin/.env"
fi

if [[ -z "$CHIBISAFE_URL" || -z "$CHIBISAFE_API_KEY" ]]; then
    echo "CHIBISAFE_URL or CHIBISAFE_API_KEY is not set. Check the .env file."
    exit 1
fi

FILENAME="$(date +%F_%H-%M-%S).png"
FILE_PATH="/tmp/$FILENAME"

grim -c -g "$(slurp -d)" -t ppm - | satty --filename - --fullscreen --disable-notifications --initial-tool brush --early-exit --output-filename "$FILE_PATH" || exit 1

send_notification() {
    notify-send "Chibisafe Uploader" "$1" -i browser-download -t 2000
}

copy_to_clipboard() {
    echo -n "$1" | wl-copy
}

echo "Uploading $FILENAME..."

response=$(curl -s -X POST "$CHIBISAFE_URL/api/upload" \
    -H "x-api-key: $CHIBISAFE_API_KEY" \
    -H "User-Agent: Mozilla/5.0 Chrome/131.0.0.0 Safari/537.36" \
    -F "file=@$FILE_PATH;type=$(file --mime-type -b "$FILE_PATH")")

url=$(echo "$response" | jq -r '.url // empty')

if [[ -n "$url" ]]; then
    echo "File uploaded successfully."
    echo "Response: $response"

    send_notification "File uploaded successfully"
    copy_to_clipboard "$url"
else
    echo "Upload failed"
    echo "Response: $response"

    send_notification "Upload failed"
    exit 1
fi
