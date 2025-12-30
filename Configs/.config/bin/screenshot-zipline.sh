#!/bin/bash

# Zipline
# https://zipline.diced.sh/

set -e

if [[ -f "$HOME/.config/bin/.env" ]]; then
    source "$HOME/.config/bin/.env"
fi

if [[ -z "$ZIPLINE_URL" || -z "$ZIPLINE_API_KEY" || -z "$ZIPLINE_FOLDER_ID" ]]; then
    echo "ZIPLINE_URL or ZIPLINE_API_KEY or ZIPLINE_FOLDER_ID is not set. Check the .env file."
    exit 1
fi

FILENAME="$(date +%F_$((RANDOM % 10000))).png"
FILE_PATH="/tmp/$FILENAME"

grim -c -g "$(slurp -d)" -t ppm - | satty --filename - --fullscreen --disable-notifications --initial-tool brush --early-exit --output-filename "$FILE_PATH" || exit 1

send_notification() {
    notify-send "Zipline Uploader" "$1" -i browser-download -t 2000
}

copy_to_clipboard() {
    echo -n "$1" | wl-copy
}

echo "Uploading $FILENAME..."

response=$(
    curl -s -X POST "$ZIPLINE_URL/api/upload" \
        -H "Authorization: $ZIPLINE_API_KEY" \
        -H "Content-Type: multipart/form-data" \
        -H "User-Agent: Mozilla/5.0 Chrome/131.0.0.0 Safari/537.36" \
        -H "x-zipline-format: random" \
        -H "x-zipline-original-name: true" \
        -H "x-zipline-folder: $ZIPLINE_FOLDER_ID" \
        -F "file=@$FILE_PATH;type=$(file --mime-type -b "$FILE_PATH")"
)

url=$(echo "$response" | jq -r ".files[0].url // empty")

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
