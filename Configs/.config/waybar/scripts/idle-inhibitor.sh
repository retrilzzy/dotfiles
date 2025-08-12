#!/usr/bin/env bash

PID_FILE="$HOME/.cache/idle_inhibit.pid"

toggle() {
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        kill "$(cat "$PID_FILE")"
        rm -f "$PID_FILE"
    else
        systemd-inhibit --what=idle:sleep --why="Manual Idle Inhibit" sleep infinity &
        echo $! > "$PID_FILE"
    fi
}

status_json() {
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo '{"text":"  ","tooltip":"Idle Inhibitor: On"}'
    else
        echo '{"text":"  ","tooltip":"Idle Inhibitor: Off"}'
    fi
}

case "$1" in
    --toggle) toggle ;;
    *) status_json ;;
esac
