#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

CYAN='\033[1;36m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'
RED='\033[1;31m'

print_section() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "$1"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

install_pacman() {
    local to_install_pacman=()
    for pkg in "$@"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            echo -e "${BLUE}Will install: ${pkg}${RESET}"
            to_install_pacman+=("$pkg")
        else
            echo -e "${YELLOW}Skipped (already installed): ${pkg}${RESET}"
        fi
    done

    if [ ${#to_install_pacman[@]} -gt 0 ]; then
        echo -e "${BLUE}Installing Pacman packages: ${to_install_pacman[*]}${RESET}"
        sudo pacman -S --noconfirm --needed "${to_install_pacman[@]}"
        echo -e "${GREEN}Pacman packages installed: ${to_install_pacman[*]}${RESET}"
    fi
}

install_yay() {
    local to_install_yay=()
    for pkg in "$@"; do
        if ! yay -Qq "$pkg" &>/dev/null; then
            echo -e "${BLUE}Will install (AUR): ${pkg}${RESET}"
            to_install_yay+=("$pkg")
        else
            echo -e "${YELLOW}Skipped (already installed): ${pkg}${RESET}"
        fi
    done

    if [ ${#to_install_yay[@]} -gt 0 ]; then
        echo -e "${BLUE}Installing AUR packages (Yay): ${to_install_yay[*]}${RESET}"
        yay -S --noconfirm "${to_install_yay[@]}"
        echo -e "${GREEN}AUR packages installed (Yay): ${to_install_yay[*]}${RESET}"
    fi
}

clone_repo() {
    print_section "Cloning or updating dotfiles repository"
    if [ -d "$DOTFILES_DIR" ]; then
        echo -e "${YELLOW}Dotfiles directory already exists. Attempting to pull latest changes.${RESET}"
        pushd "$DOTFILES_DIR" >/dev/null
        if git pull --rebase --autostash; then
            echo -e "${GREEN}Dotfiles updated successfully.${RESET}"
        else
            echo -e "${RED}Error: Failed to pull dotfiles. Please check your internet connection or repository access.${RESET}"
            popd >/dev/null
            exit 1
        fi
        popd >/dev/null
    else
        echo -e "${BLUE}Cloning dotfiles repository.${RESET}"
        if git clone --depth=10 https://github.com/retrilzzy/dotfiles.git "$DOTFILES_DIR"; then
            echo -e "${GREEN}Dotfiles cloned successfully.${RESET}"
        else
            echo -e "${RED}Error: Failed to clone dotfiles. Please check your internet connection or repository access.${RESET}"
            exit 1
        fi
    fi
}

setup_pacman() {
    print_section "Configuring Pacman"

    read -rp "$(echo -e "${YELLOW}Overwrite /etc/pacman.conf? (Y/n): ${RESET}")" confirm

    confirm=${confirm:-Y}
    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
        echo -e "${BLUE}Creating a backup of /etc/pacman.conf to /etc/pacman.conf.bak${RESET}"
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak 2>/dev/null

        sudo cp "$DOTFILES_DIR/Configs/etc/pacman.conf" /etc/pacman.conf
        echo -e "${GREEN}Pacman.conf overwritten.${RESET}"
    else
        echo -e "${YELLOW}Pacman.conf overwrite skipped.${RESET}"
    fi

    print_section "Updating system"

    sudo pacman -Syu --noconfirm

    echo -e "${GREEN}Pacman configuration complete${RESET}"
}

ensure_yay() {
    if ! command -v yay &>/dev/null; then
        print_section "Installing Yay"

        sudo pacman -S --noconfirm --needed base-devel

        tmp_dir=$(mktemp -d)
        git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp_dir"

        pushd "$tmp_dir" >/dev/null
        makepkg -si --noconfirm
        popd >/dev/null

        rm -rf "$tmp_dir"

        if command -v yay &>/dev/null; then
            echo -e "${GREEN}Yay installed successfully!${RESET}"
        else
            echo -e "${RED}Error: yay installation failed.${RESET}"
            exit 1
        fi
    else
        echo -e "${YELLOW}Yay is already installed${RESET}"
    fi
}

setup_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
    fi

    sudo chsh -s "$(which zsh)" "$USER"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || true
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || true
}

backup_configs() {
    print_section "Backing up existing configurations"

    local date_now
    date_now=$(date +%Y-%m-%d_%H-%M-%S)
    local backup_dir="$HOME/.config-backups/$date_now"

    mkdir -p "$backup_dir/.config" "$backup_dir/etc"

    shopt -s nullglob
    for dir in "$DOTFILES_DIR"/Configs/.config/*; do
        local name
        name=$(basename "$dir")
        if [ -d "$HOME/.config/$name" ]; then
            echo -e "${BLUE} Copying $HOME/.config/$name to $backup_dir/.config/${RESET}"
            cp -a "$HOME/.config/$name" "$backup_dir/.config/"
        fi
    done

    local home_files=(".zshrc" ".p10k.zsh" ".nanorc")
    for file in "${home_files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            echo -e "${BLUE} Copying $HOME/$file to $backup_dir/${RESET}"
            cp -a "$HOME/$file" "$backup_dir/"
        fi
    done

    for dir in "$DOTFILES_DIR"/Configs/etc/*; do
        local name
        name=$(basename "$dir")
        if [ -d "/etc/$name" ]; then
            echo -e "${BLUE} Copying /etc/$name to $backup_dir/etc/${RESET}"
            cp -a "/etc/$name" "$backup_dir/etc/"
        fi
    done
    shopt -u nullglob

    echo -e "${GREEN}Backup saved to $backup_dir${RESET}"
}

apply_new_configs() {
    print_section "Applying new configurations"

    cp -a "$DOTFILES_DIR/Configs/.config/." "$HOME/.config/"

    cp "$DOTFILES_DIR/Configs/.zshrc" \
        "$DOTFILES_DIR/Configs/.p10k.zsh" \
        "$DOTFILES_DIR/Configs/.nanorc" "$HOME/"

    sudo cp -a "$DOTFILES_DIR/Configs/etc/." /etc/

    sudo cp -a "$DOTFILES_DIR/Configs/.local/." "$HOME/.local/"

    echo -e "${GREEN}New configurations applied.${RESET}"
}

run_services() {
    print_section "Running services"

    if pgrep -x "waybar" >/dev/null; then
        killall waybar && sleep 1
    fi
    uwsm app -- waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/styles.css" >/dev/null 2>&1 &
    disown

    if pgrep -x "dunst" >/dev/null; then
        killall dunst && sleep 1
    fi
    uwsm app -- swaync -c "$HOME/.config/swaync/config.json" >/dev/null 2>&1 &
    disown

    uwsm app -- nm-applet >/dev/null 2>&1 &
    disown

    uwsm app -- wl-paste --type text --watch cliphist -max-items 50 store >/dev/null 2>&1 &
    disown

    uwsm app -- swww-daemon >/dev/null 2>&1 &
    disown

    echo -e "${GREEN}Services started.${RESET}"
}

setup_wallpapers() {
    local wallpaper_dest="$HOME/Pictures/Wallpapers"
    mkdir -p "$wallpaper_dest"
    cp -r "$DOTFILES_DIR/Assets/wallpapers/"* "$wallpaper_dest/"
    echo -e "${GREEN}Wallpapers copied to $wallpaper_dest${RESET}"

    mkdir "$HOME/.local/share/color-schemes" || true

    "$DOTFILES_DIR/Configs/.config/bin/change-wall.sh" ~/Pictures/Wallpapers
    echo -e "${GREEN}Wallpapers set.${RESET}"
}

setup_theme() {
    print_section "Applying theme"

    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    nwg-look -a || echo -e "${YELLOW}Failed to apply theme via nwg-look.${RESET}"

    echo -e "${GREEN}Themes applied.${RESET}"
}

reload_services() {
    print_section "Reloading services"

    if pgrep -x "waybar" >/dev/null; then
        killall waybar && sleep 1
    fi
    uwsm app -- waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/styles.css" >/dev/null 2>&1 &
    disown

    echo -e "${GREEN}Services reloaded.${RESET}"
}

main() {
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}Error: This script should not be run as root or with sudo. Please run it as a regular user.${RESET}"
        exit 1
    fi

    if [ -z "${WAYLAND_DISPLAY:-}" ]; then
        echo -e "${YELLOW}The script must be run in an active Wayland session (Hyprland).${RESET}"
        exit 1
    fi

    echo -e "${CYAN}Starting installation. 3...${RESET}" && sleep 1
    echo -e "${CYAN}2...${RESET}" && sleep 1
    echo -e "${CYAN}1...${RESET}" && sleep 1

    print_section "Git"
    install_pacman git

    clone_repo

    setup_pacman

    ensure_yay

    print_section "System and interface"
    install_pacman hyprlock hypridle kitty nwg-look rofi swaync waybar swww hyprshot
    install_yay waypaper wlogout

    print_section "Utilities and tools"
    install_pacman brightnessctl cliphist fastfetch grim lsd playerctl trash-cli uwsm wl-clipboard wl-clip-persist
    install_yay emote flameshot gpu-screen-recorder nautilus network-manager-applet

    print_section "Networking, audio and portals"
    install_pacman networkmanager bluez blueman pipewire pipewire-pulse pipewire-audio pipewire-alsa polkit-gnome xdg-utils xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal-gnome

    print_section "Appearance and themes"
    install_pacman adw-gtk-theme frameworkintegration inter-font noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra papirus-icon-theme ttf-jetbrains-mono-nerd
    install_yay matugen-bin qt5ct-kde qt6ct-kde darkly-bin rose-pine-cursor rose-pine-hyprcursor ttf-meslo-nerd-font-powerlevel10k

    print_section "Zsh and Plugins"
    install_pacman zsh
    setup_zsh

    backup_configs
    apply_new_configs
    run_services

    sleep 2
    setup_wallpapers
    setup_theme

    reload_services

    echo -e "${GREEN}Installation complete!${RESET}"
    echo -e "${CYAN}It is recommended to reboot the system for changes to fully apply.${RESET}"

    exec zsh
}

main "$@"
