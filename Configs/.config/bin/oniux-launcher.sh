#!/bin/bash

rofi -show drun \
    -theme "$HOME/.config/rofi/launcher.rasi" \
    -display-drun " " \
    -theme-str "#inputbar { border-color: #7C4DFF; }" \
    -run-command "oniux {cmd}"
