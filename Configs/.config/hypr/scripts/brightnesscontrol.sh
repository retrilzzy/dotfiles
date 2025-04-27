#!/bin/bash

# Print error message for invalid arguments
print_error() {
    cat <<"EOF"
Usage: ./brightnesscontrol.sh <action>
Valid actions are:
    i -- <i>ncrease brightness [+5%]
    d -- <d>ecrease brightness [-5%]
EOF
}

brightness=$(brightnessctl -m | grep -o '[0-9]\+%' | head -c-2)

# Handle options
while getopts o: opt; do
    case "${opt}" in
    o)
        case $OPTARG in
        i) # Increase brightness
            if [[ $brightness -lt 10 ]]; then
                brightnessctl set +1%
            else
                brightnessctl set +5%
            fi
            ;;
        d) # Decrease brightness
            if [[ $brightness -le 1 ]]; then
                brightnessctl set 1%
            elif [[ $brightness -le 10 ]]; then
                brightnessctl set 1%-
            else
                brightnessctl set 5%-
            fi
            ;;
        *)
            print_error
            ;;
        esac
        ;;
    *)
        print_error
        ;;
    esac
done
