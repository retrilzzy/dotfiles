#!/bin/bash

set -e

if [[ -f "$HOME/.config/hypr/scripts/.env" ]]; then
    source "$HOME/.config/hypr/scripts/.env"
fi

if [[ -z "$CHIBISAFE_URL" || -z "$CHIBISAFE_API_KEY" ]]; then
    echo "❌ CHIBISAFE_URL or CHIBISAFE_API_KEY is not set. Check the .env file."
    exit 1
fi

DIR="/tmp"
FILENAME="$(date +%F_%H-%M-%S)_grim+url.png"
FILE_PATH="$DIR/$FILENAME"

REGION=$(slurp) || exit 1
[ -n "$REGION" ] || exit 1

grim -g "$REGION" "$FILE_PATH" || exit 1

send_notification() {
    notify-send "Chibisafe Uploader" "$1" -t 3000
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
    echo "✅ File uploaded successfully."
    echo "Response: $response"
    
    send_notification "✅ File uploaded successfully"
    copy_to_clipboard "$url"
else
    echo "❌ Upload failed"
    echo "Response: $response"
    
    send_notification "❌ Upload failed"
    exit 1
fi

rm "$FILE_PATH"
