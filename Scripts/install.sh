#!/bin/bash

set -euo pipefail

# Variables
DOTFILES_DIR="$HOME/dotfiles"

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

# Install packages with pacman if they are not already installed
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

# Install packages with yay if they are not already installed
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

# Clone or update the dotfiles repository
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

# Configure pacman and update the system
setup_pacman() {
    print_section "Configuring Pacman"

    read -rp "$(echo -e "${YELLOW}Overwrite /etc/pacman.conf? (Y/n): ${RESET}")" confirm

    confirm=${confirm:-Y}
    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
        echo -e "${BLUE} Creating a backup of /etc/pacman.conf to /etc/pacman.conf.bak${RESET}"
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

# Install yay if it is not already installed
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

# Setup Zsh, Oh My Zsh and plugins
setup_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
    fi

    sudo chsh -s "$(which zsh)" "$USER"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || true
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || true
}

# Backup existing configurations
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

        if [ "$name" = "discord" ]; then
            continue
        fi

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

# Apply new configurations from the dotfiles repository
apply_new_configs() {
    print_section "Applying new configurations"

    cp -a "$DOTFILES_DIR/Configs/.config/." "$HOME/.config/"

    cp "$DOTFILES_DIR/Configs/.zshrc" \
        "$DOTFILES_DIR/Configs/.p10k.zsh" \
        "$DOTFILES_DIR/Configs/.nanorc" "$HOME/"

    cp -a "$DOTFILES_DIR/Configs/.local/." "$HOME/.local/"

    sudo cp -a "$DOTFILES_DIR/Configs/etc/." /etc/

    echo -e "${GREEN}New configurations applied.${RESET}"
}

# Run essential services
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

    uwsm app -- vicinae server >/dev/null 2>&1 &
    disown

    uwsm app -- swww-daemon >/dev/null 2>&1 &
    disown

    echo -e "${GREEN}Services started.${RESET}"
}

# Download and set up wallpapers
setup_wallpapers() {
    print_section "Wallpapers"

    local wallpaper_dest="$HOME/Pictures/Wallpapers-test"
    mkdir -p "$wallpaper_dest"

    echo -e "${BLUE}Downloading 5 random wallpapers${RESET}"
    echo -e "${BLUE}All wallpapers:${RESET} https://share.rzx.ovh/folder/cmik5z0om005001pc7996irnv"

    curl -s "https://share.rzx.ovh/api/server/folder/cmik5z0om005001pc7996irnv" |
        jq -r '.files[].name' |
        shuf -n 5 |
        while read -r name; do
            [ -z "$name" ] && continue

            local url="https://share.rzx.ovh/raw/$name"
            echo -e "${GREEN} Downloading wallpaper:${RESET} $url"
            curl --connect-timeout 5 --max-time 30 -L -s "$url" -o "$wallpaper_dest/$name" || echo -e "${RED}Failed to download wallpaper:${RESET} $name"
        done

    echo -e "${GREEN}Wallpapers saved to $wallpaper_dest${RESET}"

    mkdir "$HOME/.local/share/color-schemes" || true

    "$HOME/.config/bin/change-wall.sh" "$wallpaper_dest"
    echo -e "${GREEN}Wallpaper set.${RESET}"
}

# Apply GTK theme
setup_theme() {
    print_section "Applying theme"

    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    nwg-look -a || echo -e "${YELLOW}Failed to apply theme via nwg-look.${RESET}"

    echo -e "${GREEN}Themes applied.${RESET}"
}

# Reload services after theme and wallpaper changes
reload_services() {
    print_section "Reloading services"

    if pgrep -x "waybar" >/dev/null; then
        killall waybar && sleep 1
    fi
    uwsm app -- waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/styles.css" >/dev/null 2>&1 &
    disown

    echo -e "${GREEN}Services reloaded.${RESET}"
}

# Main function
main() {
    # Check if the script is run as root
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}Error: This script should not be run as root or with sudo. Please run it as a regular user.${RESET}"
        exit 1
    fi

    # Check if the script is run in a Wayland session
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
    install_pacman hyprlock hypridle kitty nwg-look swaync waybar swww hyprshot
    install_yay waypaper wlogout vicinae-bin

    print_section "Utilities and tools"
    install_pacman brightnessctl imagemagick fastfetch grim lsd pavucontrol playerctl trash-cli uwsm wl-clipboard wl-clip-persist
    git clone https://github.com/flameshot-org/flameshot "$HOME/.cache/yay/flameshot-git/flameshot"
    install_yay flameshot-git gpu-screen-recorder nautilus network-manager-applet

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
    echo -e "${CYAN}To fully apply the changes, it is recommended to restart the system.${RESET}"

    exec zsh
}

main "$@"
