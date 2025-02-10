#!/bin/bash

set -e
cd ~

install() {
    read -r -p "Установить $1? (y/N): " choice
    case "$choice" in 
        y|Y|yes|Yes|YES ) eval "$2" ;;
        * ) echo "Пропущено: $1" ;;
    esac
}


echo "Обновление репозиториев и системы..."
sudo pacman -Syu

echo "⚠️ Учтите, что отсутствие некоторых пакетов приведет к некорректной работе системы!"

install "Жизненно необходимые пакеты (git, curl)" \
    "sudo pacman -S --noconfirm git curl"

install "Yay (AUR помощник) [Без Yay вы не сможете установить часть пакетов!]" \
    "sudo pacman -S --needed base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"


install "Xdg-utils, Xdg-desktop-portal (утилиты для работы с XDG)" \
    "sudo pacman -S --noconfirm xdg-utils xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal"


install "Network Manager (сетевые инструменты)" \
    "sudo pacman -S --noconfirm network-manager network-manager-applet"

install "Bluez, Blueman (Bluetooth инструменты)" \
    "sudo pacman -S --noconfirm bluez bluez-tools blueman"


install "Brightnessctl (управления яркостью)" \
    "sudo pacman -S --noconfirm brightnessctl"


install "Grim, Hyprshot (cкриншоты)" \
    "sudo pacman -S --noconfirm grim && yay -S --noconfirm hyprshot"


install "Waybar (панель)" "sudo pacman -S --noconfirm waybar"


install "Rofi (меню запуска)" "sudo pacman -S --noconfirm rofi"

install "Cliphist (буфер обмена)" "sudo pacman -S --noconfirm wl-clipboard cliphist"


install "Wlogout (меню выключения)" "yay -S --noconfirm wlogout"


install "Kitty (терминал)" "sudo pacman -S --noconfirm kitty"

install "Zsh + Oh My Zsh (оболочка)" \
    "sudo pacman -S --noconfirm zsh \
        && sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""

install "Powerlevel10k (тема для Zsh)" \
    "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

install "Плагины для Zsh" \
    "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"


install "Fastfetch (информация о системе)" "sudo pacman -S --noconfirm fastfetch"


install "Nwg-look (настройка GTK3)" "sudo pacman -S --noconfirm nwg-look"


install "Swaync (уведомления)" "sudo pacman -S --noconfirm swaync"


install "Waypaper (обои)" "yay -S --noconfirm waypaper"

install "Swww (статичные обои)" "sudo pacman -S --noconfirm swww"

install "Mpvpaper (видео обои)" "sudo pacman -S --noconfirm mpvpaper"


install "Emote (выбор эмодзи)" "yay -S --noconfirm emote"


install "Flameshot (утилита для скриншотов)" "sudo pacman -S --noconfirm flameshot"


echo "✅ Установка завершена!"
