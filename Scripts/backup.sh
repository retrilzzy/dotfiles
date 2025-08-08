#!/bin/env bash

DOTFILES_DIR="$HOME/dotfiles"

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR=~/.config-backups/"$DATE"

backup_configs() {
    echo "📦 Создание резервной копии текущих конфигураций..."
    echo "ℹ️  Копируются только те, которые затрагиваются этим репозиторием."

    mkdir -p "$BACKUP_DIR/.config"

    for dir in "$DOTFILES_DIR"/Configs/.config/*; do
        name=$(basename "$dir")
        if [ -d ~/.config/"$name" ]; then
            cp -r "$HOME"/.config/"$name" "$BACKUP_DIR/.config/"
        fi
    done

    cp ~/{.zshrc,.p10k.zsh,.nanorc} "$BACKUP_DIR/" 2>/dev/null || true

    echo "✅ Бэкап сохранён в $BACKUP_DIR"
}

backup_configs
