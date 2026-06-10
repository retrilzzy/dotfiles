#!/bin/bash

FILE="$HOME/.config/hypr/hyprland/rules.lua"

LAYER_RULE='hl.layer_rule({ match = { namespace = "^(.*)$" }, no_screen_share = true })'
WINDOW_RULE='hl.window_rule({ match = { initial_class = "^(.*)$" }, no_screen_share = true })'

toggle_rule() {
    local RULE="$1"
    local LINE_NUM

    # Try to find commented version
    LINE_NUM=$(grep -nF -- "-- $RULE" "$FILE" | head -1 | cut -d: -f1)
    if [ -n "$LINE_NUM" ]; then
        sed -i "${LINE_NUM}s/^-- //" "$FILE"
        echo "Enabled"
        return
    fi

    # Try to find uncommented version
    LINE_NUM=$(grep -nF -- "$RULE" "$FILE" | head -1 | cut -d: -f1)
    if [ -n "$LINE_NUM" ]; then
        sed -i "${LINE_NUM}s/^/-- /" "$FILE"
        echo "Disabled"
        return
    fi

    echo "None"
}

LAYER_STATE=$(toggle_rule "$LAYER_RULE")
WINDOW_STATE=$(toggle_rule "$WINDOW_RULE")
notify-send "No Screenshare" "Window: $WINDOW_STATE | Layer: $LAYER_STATE" -t 2000

sleep 0.2
hyprctl reload
