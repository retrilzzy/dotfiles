#!/bin/env bash

pgrep -x "wf-recorder" && pkill -INT -x wf-recorder && notify-send "wf-recorder" "Recording stopped" -t 950 && exit 0

notify-send "wf-recorder" "Starting recording..." -t 950

sleep 1.3

dateTime=$(date +%Y-%m-%d_%H-%M)
wf-recorder -g "$(slurp)" --framerate 48 --bframes max_b_frames -f ~/Videos/Recordings/$dateTime.mp4
