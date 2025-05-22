#!/bin/env bash

backup_configs() {
    echo "📦 Создание резервной копии текущих конфигураций..."
    echo "ℹ️  Копируются только те, которые затрагиваются этим репозиторием."

    DATE=$(date +%Y-%m-%d_%H:%M:%S)
    BACKUP_DIR=~/.config-backups/"$DATE"
    mkdir -p "$BACKUP_DIR"

    for dir in ~/dotfiles/Configs/.config/*; do
        name=$(basename "$dir")
        if [ -d ~/.config/"$name" ]; then
            cp -r ~/.config/"$name" "$BACKUP_DIR/.config/"
        fi
    done

    cp ~/{.zshrc,.p10k.zsh,.nanorc} "$BACKUP_DIR/" 2>/dev/null || true

    echo "✅ Бэкап сохранён в $BACKUP_DIR"
}

backup_configs
