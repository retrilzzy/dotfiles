#!/bin/bash

set -euo pipefail

# Colors
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
BLUE="\033[1;34m"
RESET="\033[0m"

# Print a section header
print_section() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "   $1"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# List available backups
list_backups() {
    print_section "Available Backups"
    local backup_dir="$HOME/.config-backups"
    if [ ! -d "$backup_dir" ] || [ -z "$(ls -A "$backup_dir")" ]; then
        echo -e "${RED}No backup directories found in $backup_dir${RESET}"
        exit 1
    fi

    mapfile -t backups < <(ls -1t "$backup_dir")

    for i in "${!backups[@]}"; do
        echo -e "${YELLOW}$((i + 1))) ${backups[$i]}${RESET}"
    done
}

# Restore a backup from the list of available backups
restore_backup() {
    list_backups

    read -rp "$(echo -e "${CYAN}Enter the number of the backup to restore: ${RESET}")" choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#backups[@]}" ]; then
        echo -e "${RED}Invalid selection.${RESET}"
        exit 1
    fi

    local selected_backup_dir="$HOME/.config-backups/${backups[$((choice - 1))]}"
    echo -e "${BLUE}You have selected to restore from: $selected_backup_dir${RESET}"

    read -rp "$(echo -e "${YELLOW}This will overwrite your current configurations. Are you sure? (Y/n): ${RESET}")" confirm
    confirm=${confirm:-Y}
    if [[ ! "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
        echo -e "${YELLOW}Restore operation cancelled.${RESET}"
        exit 0
    fi

    print_section "Restoring configurations"

    if [ -d "$selected_backup_dir/.config" ]; then
        echo -e "${BLUE}Restoring .config files...${RESET}"
        cp -a "$selected_backup_dir/.config/." "$HOME/.config/"
        echo -e "${GREEN}.config files restored.${RESET}"
    fi

    local home_files=(".zshrc" ".p10k.zsh" ".nanorc")
    for file in "${home_files[@]}"; do
        if [ -f "$selected_backup_dir/$file" ]; then
            echo -e "${BLUE}Restoring $file...${RESET}"
            cp -a "$selected_backup_dir/$file" "$HOME/"
            echo -e "${GREEN}$file restored.${RESET}"
        fi
    done

    if [ -d "$selected_backup_dir/etc" ]; then
        echo -e "${BLUE}Restoring /etc files (requires sudo)...${RESET}"
        sudo cp -a "$selected_backup_dir/etc/." /etc/
        echo -e "${GREEN}/etc files restored.${RESET}"
    fi

    echo -e "${GREEN}Restore complete!${RESET}"
    echo -e "${CYAN}To fully apply the changes, it is recommended to restart the system.${RESET}"
}

# Main function
main() {
    # Check if the script is run as root
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}Error: This script should not be run as root or with sudo. Please run it as a regular user.${RESET}"
        exit 1
    fi

    restore_backup
}

main "$@"
