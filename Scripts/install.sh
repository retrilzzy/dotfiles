#!/bin/bash

set -euo pipefail

# Variables
DOTFILES_DIR="$HOME/dotfiles"

# Output functions
RESET="\033[0m"

print_section() {
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "   $1"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

print_info() {
    echo -e "\033[1;34m $1${RESET}"
}

print_warning() {
    echo -e "\033[1;33m $1${RESET}"
}

print_error() {
    echo -e "\033[1;31m $1${RESET}"
}

print_success() {
    echo -e "\033[1;32m $1${RESET}"
}

print_action() {
    echo -e "\033[1;36m $1${RESET}"
}

# Install packages with pacman if they are not already installed
install_pacman() {
    local to_install_pacman=()
    for pkg in "$@"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            print_info "Will install: ${pkg}"
            to_install_pacman+=("$pkg")
        else
            print_warning "Skipped (already installed): ${pkg}"
        fi
    done

    if [ ${#to_install_pacman[@]} -gt 0 ]; then
        print_info "Installing Pacman packages: ${to_install_pacman[*]}"
        sudo pacman -S --noconfirm --needed "${to_install_pacman[@]}"
        print_success "Pacman packages installed: ${to_install_pacman[*]}"
    fi
}

# Install packages with yay if they are not already installed
install_yay() {
    local to_install_yay=()
    for pkg in "$@"; do
        if ! yay -Qq "$pkg" &>/dev/null; then
            print_info "Will install (AUR): ${pkg}"
            to_install_yay+=("$pkg")
        else
            print_warning "Skipped (already installed): ${pkg}"
        fi
    done

    if [ ${#to_install_yay[@]} -gt 0 ]; then
        print_info "Installing AUR packages (Yay): ${to_install_yay[*]}"
        yay -S --noconfirm "${to_install_yay[@]}"
        print_success "AUR packages installed (Yay): ${to_install_yay[*]}"
    fi
}

# Clone or update the dotfiles repository
clone_repo() {
    print_section "Cloning or updating dotfiles repository"
    if [ -d "$DOTFILES_DIR" ]; then
        print_info "Dotfiles directory already exists. Attempting to pull latest changes."
        pushd "$DOTFILES_DIR" >/dev/null
        if git pull --rebase --autostash; then
            print_success "Dotfiles updated successfully."
        else
            print_error "Failed to pull dotfiles. Please check your internet connection or repository access."
            popd >/dev/null
            exit 1
        fi
        popd >/dev/null
    else
        print_info "Cloning dotfiles repository."
        if git clone --depth=10 https://github.com/retrilzzy/dotfiles.git "$DOTFILES_DIR"; then
            print_success "Dotfiles cloned successfully."
        else
            print_error "Failed to clone dotfiles. Please check your internet connection or repository access."
            exit 1
        fi
    fi
}

# Configure pacman and update the system
setup_pacman() {
    print_section "Configuring Pacman"

    read -rp "$(print_warning 'Overwrite /etc/pacman.conf? (Y/n): ')" confirm

    confirm=${confirm:-Y}
    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
        print_info "Creating a backup of /etc/pacman.conf to /etc/pacman.conf.bak"
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak 2>/dev/null

        sudo cp "$DOTFILES_DIR/Configs/etc/pacman.conf" /etc/pacman.conf
        print_success "Pacman.conf overwritten."
    else
        print_warning "Pacman.conf overwrite skipped."
    fi

    print_section "Updating system"

    sudo pacman -Syu --noconfirm

    print_success "Pacman configuration complete"
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
            print_success "Yay installed successfully!"
        else
            print_error "yay installation failed."
            exit 1
        fi
    else
        print_warning "Yay is already installed"
    fi
}

# Install Bibata cursor
install_bibata_cursor() {
    print_section "Installing Bibata cursor"

    print_info "Installing Bibata cursor..."
    local tmp_dir
    tmp_dir=$(mktemp -d)
    if curl -L "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz" -o "$tmp_dir/bibata.tar.xz"; then
        tar -xf "$tmp_dir/bibata.tar.xz" -C "$tmp_dir"
        sudo cp -r "$tmp_dir/Bibata-Modern-Classic" /usr/share/icons/
        print_success "Bibata cursor installed."
    else
        print_error "Failed to download Bibata cursor."
    fi
    rm -rf "$tmp_dir"
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
            print_info "Copying $HOME/.config/$name to $backup_dir/.config/"
            cp -a "$HOME/.config/$name" "$backup_dir/.config/"
        fi
    done

    local home_files=(".zshrc" ".p10k.zsh" ".nanorc")
    for file in "${home_files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            print_info "Copying $HOME/$file to $backup_dir/"
            cp -a "$HOME/$file" "$backup_dir/"
        fi
    done

    for dir in "$DOTFILES_DIR"/Configs/etc/*; do
        local name
        name=$(basename "$dir")
        if [ -d "/etc/$name" ]; then
            print_info "Copying /etc/$name to $backup_dir/etc/"
            cp -a "/etc/$name" "$backup_dir/etc/"
        fi
    done
    shopt -u nullglob

    print_success "Backup saved to $backup_dir"
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

    print_success "New configurations applied."
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

    print_success "Services started."
}

# Download and set up wallpapers
setup_wallpapers() {
    print_section "Wallpapers"

    local wallpaper_dest="$HOME/Pictures/Wallpapers-test"
    mkdir -p "$wallpaper_dest"

    print_info "Downloading 5 random wallpapers"
    print_info "All wallpapers: https://share.rzx.ovh/folder/cmik5z0om005001pc7996irnv"

    curl -s "https://share.rzx.ovh/api/server/folder/cmik5z0om005001pc7996irnv" |
        jq -r '.files[].name' |
        shuf -n 5 |
        while read -r name; do
            [ -z "$name" ] && continue

            local url="https://share.rzx.ovh/raw/$name"
            print_action "Downloading wallpaper: $url"
            curl --connect-timeout 5 --max-time 30 -L -s "$url" -o "$wallpaper_dest/$name" || print_error "Failed to download wallpaper: $name"
        done

    print_success "Wallpapers saved to $wallpaper_dest"

    mkdir "$HOME/.local/share/color-schemes" || true

    "$HOME/.config/bin/change-wall.sh" "$wallpaper_dest"
    print_success "Wallpaper set."
}

# Apply GTK theme
setup_theme() {
    print_section "Applying theme"

    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    nwg-look -a || print_warning "Failed to apply theme via nwg-look."

    print_success "Themes applied."
}

# Reload services after theme and wallpaper changes
reload_services() {
    print_section "Reloading services"

    if pgrep -x "waybar" >/dev/null; then
        killall waybar && sleep 1
    fi
    uwsm app -- waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/styles.css" >/dev/null 2>&1 &
    disown

    print_success "Services reloaded."
}

# Main function
main() {
    # Check if the script is run as root
    if [ "$EUID" -eq 0 ]; then
        print_error "This script should not be run as root or with sudo. Please run it as a regular user."
        exit 1
    fi

    # Check if the script is run in a Wayland session
    if [ -z "${WAYLAND_DISPLAY:-}" ]; then
        print_warning "The script must be run in an active Wayland session (Hyprland)."
        exit 1
    fi

    print_action "Starting installation. 3..." && sleep 1
    print_action "2..." && sleep 1
    print_action "1..." && sleep 1

    print_section "Git"
    install_pacman git

    clone_repo

    setup_pacman

    ensure_yay

    print_section "System and interface"
    install_pacman hyprlock hypridle kitty nwg-look swaync waybar swww hyprshot
    install_yay waypaper wlogout vicinae-bin

    print_section "Utilities and tools"
    install_pacman brightnessctl imagemagick fastfetch grim tar lsd pavucontrol playerctl trash-cli uwsm wl-clipboard wl-clip-persist
    install_yay flameshot-git gpu-screen-recorder nautilus network-manager-applet

    print_section "Networking, audio and portals"
    install_pacman networkmanager bluez blueman pipewire pipewire-pulse pipewire-audio pipewire-alsa polkit-gnome xdg-utils xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal-gnome

    print_section "Appearance and themes"
    install_pacman adw-gtk-theme frameworkintegration inter-font noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra papirus-icon-theme ttf-jetbrains-mono-nerd
    install_yay matugen-bin qt5ct-kde qt6ct-kde darkly-bin ttf-meslo-nerd-font-powerlevel10k
    install_bibata_cursor

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

    print_success "Installation complete!"
    print_action "To fully apply the changes, it is recommended to restart the system."

    exec zsh
}

main "$@"
