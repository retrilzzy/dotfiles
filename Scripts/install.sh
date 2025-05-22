#!/bin/env bash

install() {
    echo ""
    read -r -p "❔ Установить $1? (y/N): " choice
    case "$choice" in
      y|Y|yes|Yes|YES )
        echo -e "\033[1;34m▶ \033[0m $2"
        eval "$2"
        ;;
      * )
        echo "⏭️  Пропущено: $1"
        ;;
    esac
}


backup_configs() {
    echo "📦 Создание резервной копии текущих конфигураций..."
    echo "ℹ️  Копируются только те, которые затрагиваются этим репозиторием."

    DATE=$(date +%Y-%m-%d_%H:%M:%S)
    BACKUP_DIR=~/.config-backups/"$DATE"
    mkdir -p "$BACKUP_DIR"

    for dir in ~/dotfiles/Configs/.config/*; do
        name=$(basename "$dir")
        if [ -d ~/.config/"$name" ]; then
            cp -r ~/.config/"$name" "$BACKUP_DIR/"
        fi
    done

    cp ~/{.zshrc,.p10k.zsh,.nanorc} "$BACKUP_DIR/" 2>/dev/null || true

    echo "✅ Бэкап сохранён в $BACKUP_DIR"
}


copy_new_configs() {
    echo "📂  Копирование новых конфигураций..."
    cp -r ~/dotfiles/Configs/.config/* ~/.config/
    cp ~/dotfiles/Configs/.zshrc ~/dotfiles/Configs/.p10k.zsh ~/dotfiles/Configs/.nanorc ~/
    echo "✅  Новый конфигурации скопированы!"
}


echo "⚠️  Учтите, что отсутствие некоторых пакетов приведет к некорректной работе системы!"


install "Git, Curl (жизненно необходимые пакеты)" \
    "sudo pacman -S --noconfirm git curl"


install "Yay (AUR помощник) [Без Yay вы не сможете установить часть пакетов!]" \
    "sudo pacman -S --needed base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"


install "Network Manager (сетевые инструменты)" \
    "sudo pacman -S --noconfirm network-manager network-manager-applet"


install "Bluez, Blueman (bluetooth инструменты)" \
    "sudo pacman -S --noconfirm bluez bluez-tools blueman"


install "Xdg-utils, Xdg-desktop-portal (интеграция приложений с рабочим столом)" \
    "sudo pacman -S --noconfirm xdg-utils xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal"


install "Brightnessctl (управления яркостью)" \
    "sudo pacman -S --noconfirm brightnessctl"


install "Playerctl (управление медиа плеером)" \
    "sudo pacman -S --noconfirm playerctl"


install "Шрифты (Noto, JetBrains Mono, Nerd Fonts)" \
    "sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono ttf-nerd-fonts-symbols"


install "Rose Pine (тема курсора)" \
    "yay -S --noconfirm rose-pine-cursor rose-pine-hyprcursor"


install "Papirus (иконки)" \
    "sudo pacman -S --noconfirm papirus-icon-theme"


install "Grim, Hyprshot (cкриншоты)" \
    "sudo pacman -S --noconfirm grim && yay -S --noconfirm hyprshot"


install "wf-recorder (запись экрана)" \
    "sudo pacman -S --noconfirm wf-recorder"


install "Wlogout (меню выключения)" \
    "yay -S --noconfirm wlogout"


install "Waybar (wayland бар)" \
    "sudo pacman -S --noconfirm waybar"


install "Rofi (меню запуска + меню буфера обмена)" \
    "sudo pacman -S --noconfirm rofi"


install "Cliphist (буфер обмена)" \
    "sudo pacman -S --noconfirm wl-clipboard cliphist"


install "Kitty (эмулятор терминала)" \
    "sudo pacman -S --noconfirm kitty"

install "Zsh + Oh My Zsh (оболочка + менеджер плагинов)" \
    "sudo pacman -S --noconfirm zsh \
    && sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \
    && chsh -s $(which zsh)"

install "Powerlevel10k (тема для Zsh)" \
    "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

install "Плагины для Zsh" \
    "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"


install "Nwg-look (настройка GTK)" "sudo pacman -S --noconfirm nwg-look"


install "Swaync (уведомления похожие на GNOME)" "sudo pacman -S --noconfirm swaync"


install "Waypaper (интерфейс для управления обоями)" \
    "yay -S --noconfirm waypaper swww \
    && cp -r ~/dotfiles/Assets/wallpapers/* ~/Pictures/Wallpapers/"

install "Mpvpaper (бэкенд для видео обоев)" "sudo pacman -S --noconfirm mpvpaper"


install "Emote (выбор эмодзи)" "yay -S --noconfirm emote"


install "Flameshot (мощная утилита для скриншотов)" "sudo pacman -S --noconfirm flameshot"


install "Fastfetch (похвастаться линуксом)" "sudo pacman -S --noconfirm fastfetch"


echo "✅ Установка пакетов завершена!"


backup_configs
copy_new_configs


echo "ℹ️  Для полного применения новых конфигураций потребуется перезагрузка системы."

echo "✅ Установка завершена! Если потребуется восстановить старую конфигурацию, запустите:"
echo "   ~/dotfiles/Scripts/restore.sh"
