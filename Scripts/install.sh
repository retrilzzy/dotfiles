#!/bin/bash

set -euo pipefail

# Directories
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.config-backups}"
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"

# Colors
C_ACCENT="#5BA3FF"
C_ACCENT_BRIGHT="#5BC0FF"
C_SUCCESS="#00FF7F"
C_WARNING="#FFD700"
C_ERROR="#FF1744"
C_BORDER_HIGHLIGHT="#5BA3FF"
C_BG_DARK="#0A0A0F"
C_BG_MED="#2A2D3E"

export GUM_CHOOSE_CURSOR_FOREGROUND="$C_ACCENT_BRIGHT"
export GUM_CHOOSE_HEADER_FOREGROUND="$C_ACCENT"
export GUM_CHOOSE_SELECTED_FOREGROUND="$C_ACCENT"

export GUM_CONFIRM_PROMPT_FOREGROUND="$C_ACCENT"
export GUM_CONFIRM_SELECTED_BACKGROUND="$C_ACCENT"
export GUM_CONFIRM_SELECTED_FOREGROUND="$C_BG_DARK"
export GUM_CONFIRM_UNSELECTED_BACKGROUND="$C_BG_MED"

export GUM_SPIN_SPINNER_FOREGROUND="$C_ACCENT"

# Error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    local command=$2
    local error_message="Error on line $line_number: command '$command' exited with status $exit_code"

    if command -v gum &>/dev/null; then
        gum style --foreground "$C_ERROR" "$error_message"
    else
        echo -e "\033[1;31m$error_message\033[0m"
    fi

    exit $exit_code
}
trap 'handle_error $LINENO "$BASH_COMMAND"' ERR

# Output helpers
print_section() {
    gum style --border normal --margin "1" --padding "1 2" --border-foreground "$C_BORDER_HIGHLIGHT" "$1"
}

print_info() {
    echo -n "$(gum style --bold --foreground "$C_ACCENT_BRIGHT" 'Info: ')"
    gum style --foreground "$C_ACCENT_BRIGHT" "$1"
}

print_warning() {
    echo -n "$(gum style --bold --foreground "$C_WARNING" 'Warning: ')"
    gum style --foreground "$C_WARNING" "$1"
}

print_error() {
    echo -n "$(gum style --bold --foreground "$C_ERROR" 'Error: ')"
    gum style --foreground "$C_ERROR" "$1"
}

print_success() {
    echo -n "$(gum style --bold --foreground "$C_SUCCESS" 'Success: ')"
    gum style --foreground "$C_SUCCESS" "$1"
}

print_action() {
    echo -n "$(gum style --bold --foreground "$C_ACCENT" 'Action: ')"
    gum style --foreground "$C_ACCENT" "$1"
}

confirm() {
    gum confirm "$1" --affirmative="Yes" --negative="No"
}

# Installation functions
ensure_core_deps() {
    if ! command -v pacman &>/dev/null; then
        echo -e "\033[1;31mError: pacman is not available. This script is for Arch-based distributions.\033[0m"
        exit 1
    fi

    if sudo pacman -S --noconfirm --needed git base-devel gum; then
        echo -e "\033[1;32mCore dependencies ready.\033[0m"
    else
        echo -e "\033[1;31mFailed to install dependencies.\033[0m"
        exit 1
    fi
}

clone_repo() {
    print_section "Cloning or Updating Dotfiles Repository"
    if [ -d "$DOTFILES_DIR" ]; then
        print_info "Dotfiles directory exists. Pulling latest changes."
        pushd "$DOTFILES_DIR" >/dev/null
        if git pull --rebase --autostash; then
            print_success "Dotfiles updated."
            if git diff --name-only 'HEAD@{1}' HEAD | grep -q "Scripts/install.sh"; then
                print_info "Installation script updated. Restarting..."
                exec "$DOTFILES_DIR/Scripts/install.sh"
            fi
        else
            print_error "Failed to pull dotfiles."
            popd >/dev/null
            exit 1
        fi
        popd >/dev/null
    else
        print_info "Cloning dotfiles repository."
        if git clone --depth=10 https://github.com/retrilzzy/dotfiles.git "$DOTFILES_DIR"; then
            print_success "Dotfiles cloned."
        else
            print_error "Failed to clone dotfiles."
            exit 1
        fi
    fi
}

setup_pacman() {
    print_section "Configuring Pacman"
    if confirm "Overwrite /etc/pacman.conf?"; then
        print_info "Backing up /etc/pacman.conf to /etc/pacman.conf.bak"
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak || true
        sudo cp "$DOTFILES_DIR/Configs/etc/pacman.conf" /etc/pacman.conf
        print_success "pacman.conf overwritten."
    else
        print_warning "Skipping pacman.conf overwrite."
    fi

    print_section "Updating System"
    sudo pacman -Syu --noconfirm
    print_success "System updated."
}

ensure_yay() {
    if ! command -v yay &>/dev/null; then
        print_section "Installing AUR Helper (yay)"
        local tmp_dir
        tmp_dir=$(mktemp -d)
        git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp_dir"
        (
            cd "$tmp_dir"
            makepkg -si --noconfirm
        )
        rm -rf "$tmp_dir"
        print_success "Yay installed."
    else
        print_warning "Yay is already installed."
    fi
}

install_pacman() {
    local to_install=()
    for pkg in "$@"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done
    if [ ${#to_install[@]} -gt 0 ]; then
        print_info "Installing Pacman packages: ${to_install[*]}"
        sudo pacman -S --noconfirm --needed "${to_install[@]}"
        print_success "Installed: ${to_install[*]}"
    fi
}

install_yay() {
    local to_install=()
    for pkg in "$@"; do
        if ! yay -Qq "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done
    if [ ${#to_install[@]} -gt 0 ]; then
        print_info "Installing AUR packages: ${to_install[*]}"
        yay -S --noconfirm "${to_install[@]}"
        print_success "Installed: ${to_install[*]}"
    else
        print_warning "packages already installed. (yay)"
    fi
}

run_service() {
    local service_name="$1"
    shift
    local cmd=("$@")

    print_info "Starting service: $service_name"
    if pgrep -x "$service_name" >/dev/null; then
        print_warning "Service $service_name is already running. Killing it first."
        killall "$service_name" && sleep 1
    fi

    local launch_cmd
    if command -v uwsm &>/dev/null && [ -n "${UWSM_SESSION_ID:-}" ]; then
        launch_cmd=(uwsm app -- "${cmd[@]}")
    else
        launch_cmd=("${cmd[@]}")
    fi

    "${launch_cmd[@]}" >/dev/null 2>&1 &
    disown
    print_success "$service_name started."
}

install_bibata_cursor() {
    print_section "Installing Bibata Cursor"
    local tmp_dir
    tmp_dir=$(mktemp -d)
    if gum spin --spinner dot --title "Downloading Bibata cursor..." -- \
        curl -L "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz" -o "$tmp_dir/bibata.tar.xz"; then
        tar -xf "$tmp_dir/bibata.tar.xz" -C "$tmp_dir"
        sudo cp -r "$tmp_dir/Bibata-Modern-Classic" /usr/share/icons/
        print_success "Bibata cursor installed."
    else
        print_error "Failed to download Bibata cursor."
    fi
    rm -rf "$tmp_dir"
}

setup_zsh() {
    print_section "Setting up Zsh & Plugins"
    install_pacman zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    sudo chsh -s "$(which zsh)" "$USER"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || true
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || true
    print_success "Zsh setup complete."
}

backup_configs() {
    print_section "Backing Up Current Configs"

    local date_now
    date_now=$(date +%Y-%m-%d_%H-%M-%S)
    local backup_dir="$BACKUP_DIR/$date_now"
    mkdir -p "$backup_dir/.config" "$backup_dir/etc" "$backup_dir/.local/share/nwg-look"

    print_info "Backing up current configs to $backup_dir"
    shopt -s nullglob

    for dir in "$DOTFILES_DIR"/Configs/.config/*; do
        local name
        name=$(basename "$dir")
        if [ "$name" = "discord" ]; then continue; fi
        if [ -d "$HOME/.config/$name" ]; then
            print_info "Moving $HOME/.config/$name to $backup_dir/.config/"
            mv "$HOME/.config/$name" "$backup_dir/.config/"
        fi
    done

    local home_files=(".zshrc" ".p10k.zsh" ".nanorc")
    for file in "${home_files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            print_info "Moving $HOME/$file to $backup_dir/"
            mv "$HOME/$file" "$backup_dir/"
        fi
    done

    cp "$HOME/.local/share/nwg-look/gsettings" "$backup_dir/.local/share/nwg-look/" || true

    shopt -u nullglob
    print_success "Backup complete."
}

apply_configs() {
    print_section "Applying New Configs"

    print_info "Applying new configurations..."
    mkdir -p "$HOME/.config" "$HOME/.local/share/nwg-look"

    cp -a "$DOTFILES_DIR/Configs/.config/." "$HOME/.config/"
    cp "$DOTFILES_DIR/Configs/.zshrc" "$DOTFILES_DIR/Configs/.p10k.zsh" "$DOTFILES_DIR/Configs/.nanorc" "$HOME/"

    print_success "New configurations applied."
}

run_initial_services() {
    print_section "Running Essential Services"

    if pgrep -x "dunst" >/dev/null; then
        killall dunst && sleep 0.3
    fi
    if pgrep -x "mako" >/dev/null; then
        killall mako && sleep 0.3
    fi
    run_service "swaync" swaync -c "$HOME/.config/swaync/config.json"
    run_service "nm-applet" nm-applet
    run_service "vicinae" vicinae server
    run_service "swww-daemon" swww-daemon
    run_service "waybar" waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/styles.css"
}

setup_wallpapers() {
    print_section "Setting Up Wallpapers"
    mkdir -p "$WALLPAPER_DIR"
    print_info "Downloading a few random wallpapers..."
    print_info "Full collection: https://share.rzx.ovh/folder/cmik5z0om005001pc7996irnv"

    local names
    names=$(curl -s "https://share.rzx.ovh/api/server/folder/cmik5z0om005001pc7996irnv" | jq -r '.files[].name' | shuf -n 5)

    if [ -z "$names" ]; then
        print_error "Could not fetch wallpaper list. Is 'jq' installed and are you online?"
        return 1
    fi

    local downloaded_count=0
    set +e
    while IFS= read -r name; do
        [ -z "$name" ] && continue
        local dest="$WALLPAPER_DIR/$name"
        if [ -f "$dest" ]; then
            print_info "Wallpaper '$name' already exists, skipping."
            ((downloaded_count++))
            continue
        fi

        local url="https://share.rzx.ovh/raw/$name"
        if gum spin --spinner dot --title "Downloading $name" -- \
            curl --fail -L -s --connect-timeout 10 --max-time 60 -o "$dest" "$url"; then
            print_success "Downloaded: $url"
            ((downloaded_count++))
        else
            print_error "Failed to download $url."
            rm -f "$dest"
        fi
    done <<<"$names"
    set -e

    if [ "$downloaded_count" -eq 0 ]; then
        print_error "No wallpapers were downloaded. Cannot set theme."
        return 1
    fi

    print_success "Downloaded $downloaded_count wallpapers to $WALLPAPER_DIR"

    mkdir -p "$HOME/.local/share/color-schemes"
    if "$HOME/.config/bin/change-wall.sh" "$WALLPAPER_DIR"; then
        print_success "Wallpaper and theme set."
    else
        print_warning "Failed to set wallpaper. You can do it manually later."
    fi
}

setup_theme() {
    print_section "Applying GTK Theme"

    cp "$DOTFILES_DIR/Configs/.local/share/nwg-look/gsettings" "$HOME/.local/share/nwg-look/gsettings"

    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    nwg-look -a || print_warning "Failed to apply theme via nwg-look. It might not be critical."

    print_success "GTK theme applied."
}

reload_services() {
    print_section "Reloading Services"
    run_service "waybar" waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/styles.css"
    print_success "Services reloaded."
}

# Entrypoint
main() {
    if [ "$EUID" -eq 0 ]; then
        echo -e "\033[1;31mThis script must not be run as root.\033[0m"
        exit 1
    fi

    if ! sudo -v; then
        echo -e "\033[1;31mSudo privileges are required to run this script.\033[0m"
        exit 1
    fi

    ensure_core_deps
    clear

    if ! [[ "${XDG_CURRENT_DESKTOP:-}" == "Hyprland" && -n "${UWSM_FINALIZE_VARNAMES:-}" ]]; then
        print_warning "This script is optimized for Hyprland with UWSM."
        if ! confirm "You don't seem to be in a UWSM-managed Hyprland session. Some features might not work as expected. Continue anyway?"; then
            exit 0
        fi
    fi

    gum style --border normal --margin "1" --padding "1 2" --border-foreground "$C_ACCENT" "Retrilz's Dotfiles Installer"

    local CHOICES
    CHOICES=$(gum choose --no-limit --height 15 --cursor " > " \
        --header "Select components to install" \
        "Clone/Update Dotfiles Repository" "Configure Pacman & Update System" "Install AUR Helper (yay)" \
        "Install System Interface packages" "Install Utilities & Tools packages" \
        "Install Networking & Audio packages" "Install Appearance & Theme packages" \
        "Setup Zsh & Plugins" "Backup Current Configs" "Apply New Configs" "Run Essential Services" "Setup Wallpapers & GTK Theme" \
        --selected "*")

    if [[ "$CHOICES" == *"Clone/Update Dotfiles Repository"* ]]; then
        clone_repo
    fi

    if [[ "$CHOICES" == *"Configure Pacman & Update System"* ]]; then
        setup_pacman
    fi

    if [[ "$CHOICES" == *"Install AUR Helper (yay)"* ]]; then
        ensure_yay
    fi

    if [[ "$CHOICES" == *"Install System Interface packages"* ]]; then
        print_section "Installing System Interface packages"
        install_pacman hyprlock hypridle kitty nwg-look swaync waybar swww hyprshot
        install_yay waypaper wlogout vicinae-bin
    fi

    if [[ "$CHOICES" == *"Install Utilities & Tools packages"* ]]; then
        print_section "Installing Utilities & Tools"
        install_pacman brightnessctl imagemagick fastfetch grim gnome-keyring tar lsd pavucontrol playerctl satty trash-cli uwsm wl-clipboard wl-clip-persist jq
        install_yay gpu-screen-recorder nautilus network-manager-applet
    fi

    if [[ "$CHOICES" == *"Install Networking & Audio packages"* ]]; then
        print_section "Installing Networking & Audio packages"
        install_pacman networkmanager bluez blueman pipewire pipewire-pulse pipewire-audio pipewire-alsa polkit-gnome xdg-utils xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr
    fi

    if [[ "$CHOICES" == *"Install Appearance & Theme packages"* ]]; then
        print_section "Installing Appearance & Theme packages"
        install_pacman adw-gtk-theme frameworkintegration inter-font noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra papirus-icon-theme ttf-jetbrains-mono-nerd
        install_yay matugen-bin qt5ct-kde qt6ct-kde darkly-bin
        install_bibata_cursor
    fi

    if [[ "$CHOICES" == *"Setup Zsh & Plugins"* ]]; then
        setup_zsh
    fi

    if [[ "$CHOICES" == *"Backup Current Configs"* ]]; then
        backup_configs
    fi

    if [[ "$CHOICES" == *"Apply New Configs"* ]]; then
        apply_configs
    fi

    if [[ "$CHOICES" == *"Run Essential Services"* ]]; then
        run_initial_services
    fi

    if [[ "$CHOICES" == *"Setup Wallpapers & GTK Theme"* ]]; then
        sleep 2
        setup_wallpapers
        setup_theme
        reload_services
    fi

    print_success "Installation complete!"
    print_action "It is recommended to reboot your system to apply all changes."

    if confirm "Switch to zsh now?"; then
        exec zsh
    fi
}

main "$@"
