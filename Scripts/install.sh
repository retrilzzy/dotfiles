#!/bin/env bash
set -euo pipefail


CYAN='\033[1;36m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'


print_section() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "🔧 $1"
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
    print_section "🗃️ Резервное копирование конфигураций"
    DATE=$(date +%Y-%m-%d_%H:%M:%S)
    BACKUP_DIR=~/.config-backups/"$DATE"
    mkdir -p "$BACKUP_DIR"

    for dir in ~/dotfiles/Configs/.config/*; do
        name=$(basename "$dir")
        if [ -d ~/.config/"$name" ]; then
            cp -r ~/.config/"$name" "$BACKUP_DIR/"
        fi
    done

    cp ~/{.zshrc,.p10k.zsh,.nanorc} "$BACKUP_DIR/" || true
    echo -e "${GREEN}✅ Бэкап сохранён в $BACKUP_DIR${RESET}"
}


clone_repo() {
    print_section "📂 Клонирование репозитория"
    git clone https://github.com/retrilzzy/dotfiles.git ~/dotfiles
    echo -e "${GREEN}✅ Репозиторий склонирован в ~/dotfiles!${RESET}"
}


copy_new_configs() {
    print_section "📂 Применение новых конфигураций"
    cp -r ~/dotfiles/Configs/.config/* ~/.config/
    cp ~/dotfiles/Configs/.zshrc ~/dotfiles/Configs/.p10k.zsh ~/dotfiles/Configs/.nanorc ~/ || true
}


main() {
    echo -e "${CYAN} Запуск установки. 3...${RESET}"
    sleep 1
    echo -e "${CYAN}2...${RESET}"
    sleep 1
    echo -e "${CYAN}1...${RESET}"
    sleep 1


    print_section "🛠️ Git"
    install_pacman git

    ensure_yay

    print_section "🌐 Сетевые инструменты"
    install_pacman networkmanager network-manager-applet

    print_section "🔵 Bluetooth"
    install_pacman bluez bluez-tools blueman

    print_section "🧩 Интеграция с окружением"
    install_pacman xdg-utils xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr

    print_section "🔌 Управление устройствами"
    install_pacman brightnessctl playerctl

    print_section "🔤 Шрифты"
    install_pacman noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono
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
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
    fi
    sudo chsh -s /bin/zsh "$USER"
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || true
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || true

    print_section "🎛️ GTK и Qt оформление"
    install_pacman nwg-look qt5ct qt6ct


    print_section "🏁 Финал"
    backup_configs

    clone_repo
    copy_new_configs

    mkdir -p ~/.themes/Adwaita-Dark/gtk-3.0
    echo '@import url("resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css");' > ~/.themes/Adwaita-Dark/gtk-3.0/gtk.css
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark || true
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark || true
    nwg-look -a || true

    mkdir -p ~/Pictures/Wallpapers
    cp -r ~/dotfiles/Assets/wallpapers/* ~/Pictures/Wallpapers/ || curl -o ~/Pictures/Wallpapers/retrilz-dots_0.jpg https://raw.githubusercontent.com/retrilzzy/dotfiles/refs/heads/main/Assets/wallpapers/retrilz-dots_0.jpg
    waypaper --backend swww --random --folder ~/Pictures/Wallpapers || true

    killall waybar && waybar -c $HOME/.config/waybar/config.jsonc -s $HOME/.config/waybar/styles.css || true

    echo -e "${GREEN}✅ Установка завершена!${RESET}"
    echo -e "${CYAN}🔁 Перезагрузите систему для полного применения изменений.${RESET}"
}

main "$@"
