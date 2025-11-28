#!/bin/bash

FILE="$HOME/.config/hypr/hyprland/rules.conf"

LAYER_RULE="layerrule = noscreenshare,^(.*)$"
WINDOW_RULE="windowrulev2 = noscreenshare, initialClass:^(.*)$"

escape_regex() {
    printf '%s\n' "$1" | sed -e 's/[][\/.^$*]/\\&/g'
}

toggle_rule() {
    local RULE_ESC
    RULE_ESC=$(escape_regex "$1")

    # uncomment if commented
    if grep -q "^# $RULE_ESC" "$FILE"; then
        sed -i "s/^# \(.*$RULE_ESC\)/\1/" "$FILE"
        echo "Enabled"

    # comment if uncommented
    elif grep -q "^$RULE_ESC" "$FILE"; then
        sed -i "s/^\($RULE_ESC\)/# \1/" "$FILE"
        echo "Disabled"
    else
        echo "None"
    fi
}

LAYER_STATE=$(toggle_rule "$LAYER_RULE")
WINDOW_STATE=$(toggle_rule "$WINDOW_RULE")
notify-send "No Screenshare" "Window: $WINDOW_STATE | Layer: $LAYER_STATE" -t 2000

sleep 0.2
hyprctl reload
