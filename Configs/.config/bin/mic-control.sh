#!/bin/bash

# Display usage help
print_error() {
    cat <<"EOF"
Usage: ./mic-control.sh <action>
Actions:
    i   -- increase sensitivity [+1%]
    d   -- decrease sensitivity [-1%]
    m   -- toggle mute
EOF
    exit 1
}

# Send notification for mute status
notify_mute() {
    mute=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
    if [ "${mute}" = "yes" ]; then
        notify-send "Microphone" "Muted" -i microphone-sensitivity-high-symbolic -t 1000 -r 91191
    else
        notify-send "Microphone" "Unmuted" -i microphone-sensitivity-high-symbolic -t 1000 -r 91191
    fi
}

# Handle sensitivity changes
action_volume() {
    current_vol=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -m1 'Volume:' | awk '{print $5}' | sed 's/%//')

    case "${1}" in
    i)
        if [ "$current_vol" -lt 100 ]; then
            new_vol=$((current_vol + 1))
            [ "$new_vol" -gt 100 ] && new_vol=100
            pactl set-source-volume @DEFAULT_SOURCE@ "${new_vol}%"
        fi
        ;;
    d)
        new_vol=$((current_vol - 1))
        [ "$new_vol" -lt 0 ] && new_vol=0
        pactl set-source-volume @DEFAULT_SOURCE@ "${new_vol}%"
        ;;
    esac
}

# Main execution
case "${1}" in
i) action_volume i ;;
d) action_volume d ;;
m) pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify_mute ;;
*) print_error ;;
esac
