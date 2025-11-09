#!/bin/bash

# Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Define configuration directories
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"

# Style selection
wLayout="${confDir}/wlogout/layout"
wlTmplt="${confDir}/wlogout/style.css"

# Detect monitor resolution
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select(.focused == true) | .scale' | sed 's/\.//')

wlColms=6
export mgn=$((y_mon * 38 / hypr_scale))
export hvr=$((y_mon * 33 / hypr_scale))

# Scale font size
export fntSize=$((y_mon * 2 / 100))

# Evaluate hypr border radius
hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
export hypr_border
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

# Evaluate config files
wlStyle=$(envsubst <"$wlTmplt")

# Launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
