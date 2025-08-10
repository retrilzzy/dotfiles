#!/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

CYAN='[1;36m'
BLUE='[1;34m'
GREEN='[1;32m'
YELLOW='[1;33m'
RESET='[0m'


print_section() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "$1"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}


install_pacman() {
    for pkg in "$@"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            echo -e "${BLUE}📦 Установка: ${pkg}${RESET}"
            sudo pacman -S --noconfirm --needed "$pkg"
            echo -e "${GREEN}✅ Установлено: ${pkg}${RESET}"
        else
            echo -e "${YELLOW}⏭️  Пропущено (уже установлено): ${pkg}${RESET}"
        fi
    done
}


install_yay() {
    for pkg in "$@"; do
        if ! yay -Qq "$pkg" &>/dev/null; then
            echo -e "${BLUE}📦 Установка (AUR): ${pkg}${RESET}"
            yay -S --noconfirm "$pkg"
            echo -e "${GREEN}✅ Установлено (AUR): ${pkg}${RESET}"
        else
            echo -e "${YELLOW}⏭️  Пропущено (уже установлено): ${pkg}${RESET}"
        fi
    done
}


ensure_yay() {
    if ! command -v yay &>/dev/null; then
        print_section "🚀 Установка AUR помощника yay"

        sudo pacman -S --noconfirm --needed base-devel git
        git clone https://aur.archlinux.org/yay.git
        pushd yay
        makepkg -si --noconfirm
        popd
        rm -rf yay
        echo -e "${GREEN}✅ Yay установлен!${RESET}"
    else
        echo -e "${YELLOW}⏭️  Yay уже установлен${RESET}"
    fi
}


backup_configs() {
    print_section "🗃️  Резервное копирование существующих конфигураций"

    local date_now
    date_now=$(date +%Y-%m-%d_%H-%M-%S)
    local backup_dir=~/.config-backups/"$date_now"
    mkdir -p "$backup_dir/.config"

    for dir in "$DOTFILES_DIR"/Configs/.config/*; do
        local name
        name=$(basename "$dir")
        if [ -d ~/.config/"$name" ]; then
            echo -e "${BLUE}↳ Копирование ~/.config/$name в $backup_dir/.config/${RESET}"
            cp -r ~/.config/"$name" "$backup_dir/.config/"
        fi
    done

    local home_files=(".zshrc" ".p10k.zsh" ".nanorc")
    for file in "${home_files[@]}"; do
        if [ -f ~/"$file" ]; then
            echo -e "${BLUE}↳ Копирование ~/$file в $backup_dir/${RESET}"
            cp ~/"$file" "$backup_dir/"
        fi
    done

    echo -e "${GREEN}✅ Бэкап сохранён в $backup_dir${RESET}"
}



clone_repo() {
    print_section "📂 Клонирование репозитория"

    git clone https://github.com/retrilzzy/dotfiles.git "$DOTFILES_DIR" || true
}


apply_new_configs() {
    print_section "📂 Применение новых конфигураций"
    cp -a "$DOTFILES_DIR/Configs/.config/." ~/.config/
    
    cp "$DOTFILES_DIR/Configs/.zshrc" "$DOTFILES_DIR/Configs/.p10k.zsh" "$DOTFILES_DIR/Configs/.nanorc" ~/
    echo -e "${GREEN}✅ Новые конфигурации применены.${RESET}"
}


setup_theme() {
    print_section "🎨 Применение темы"
    
    mkdir -p ~/.themes/Adwaita-Dark/gtk-3.0
    echo '@import url("resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css");' > ~/.themes/Adwaita-Dark/gtk-3.0/gtk.css
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark || echo -e "${YELLOW}⚠️  Не удалось установить color-scheme через gsettings.${RESET}"
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark || echo -e "${YELLOW}⚠️  Не удалось установить gtk-theme через gsettings.${RESET}"
    nwg-look -a || echo -e "${YELLOW}⚠️  Не удалось применить тему через nwg-look.${RESET}"
    echo -e "${GREEN}✅ Тема GTK настроена.${RESET}"
}


setup_wallpapers() {
    local wallpaper_dest=~/Pictures/Wallpapers
    mkdir -p "$wallpaper_dest"
    cp -r "$DOTFILES_DIR/Assets/wallpapers/"* "$wallpaper_dest/"
    echo -e "${GREEN}✅ Обои скопированы в $wallpaper_dest${RESET}"
    
    waypaper --backend swww --random --folder "$wallpaper_dest" || echo -e "${YELLOW}⚠️  Не удалось установить обои через waypaper.${RESET}"
    echo -e "${GREEN}✅ Обои установлены.${RESET}"
}


reload_services() {
    if pgrep -x "waybar" > /dev/null; then
        killall waybar && sleep 1
    fi
    uwsm app -- waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/styles.css > /dev/null 2>&1 & disown || waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/styles.css > /dev/null 2>&1 & disown
    echo -e "${GREEN}✅ Waybar перезапущен.${RESET}"
}


main() {
    if [ -z "${WAYLAND_DISPLAY:-}" ]; then
        echo -e "${YELLOW}⚠️  Скрипт должен запускаться в активной Wayland-сессии (Hyprland).${RESET}"
        exit 1
    fi

    echo -e "${CYAN}Запуск установки. 3...${RESET}" && sleep 1
    echo -e "${CYAN}2...${RESET}" && sleep 1
    echo -e "${CYAN}1...${RESET}" && sleep 1

    print_section "🛠️ Git"
    install_pacman git

    ensure_yay

    print_section "🌐 Сетевые инструменты"
    install_pacman networkmanager network-manager-applet

    print_section "🔊 Установка PipeWire"
    install_pacman pipewire pipewire-pulse pipewire-audio pipewire-alsa pipewire-jack

    print_section "🔵 Bluetooth"
    install_pacman bluez bluez-tools blueman

    print_section "🧩 Интеграция с окружением"
    install_pacman xdg-utils xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr

    print_section "🔌 Управление устройствами"
    install_pacman brightnessctl playerctl

    print_section "🔤 Шрифты"
    install_pacman noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono inter-font
    install_yay ttf-meslo-nerd-font-powerlevel10k

    print_section "🎨 Темы и иконки"
    install_yay rose-pine-cursor rose-pine-hyprcursor
    install_pacman papirus-icon-theme

    print_section "🖥️ Интерфейс и утилиты"
    install_yay wlogout swaync
    install_pacman waybar rofi wl-clipboard cliphist kitty flameshot fastfetch

    print_section "🖼️ Обои и оформление"
    install_yay waypaper swww

    print_section "🎞️ Видео-обои"
    install_yay mpvpaper-git

    print_section "📸 Скриншоты и запись экрана"
    install_pacman grim wf-recorder hyprshot

    print_section "😊 Эмодзи-панель"
    install_yay emote

    print_section "🐚 Zsh и плагины"
    install_pacman zsh
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
    fi
    sudo chsh -s /bin/zsh "$USER"
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || true
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || true

    print_section "🎛️ GTK и Qt оформление"
    install_pacman nwg-look qt5ct qt6ct

    clone_repo
    backup_configs
    apply_new_configs
    setup_theme
    setup_wallpapers
    reload_services

    echo -e "${GREEN}✅ Установка завершена!${RESET}"
    echo -e "${CYAN}🔁 Перезагрузите систему для полного применения изменений.${RESET}"
}

main "$@"
