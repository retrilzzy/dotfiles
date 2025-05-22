#!/bin/env bash

backup_configs() {
    echo "📦 Создание полной резервной копии ~/.config..."

    DATE=$(date +%Y-%m-%d_%H:%M:%S)
    BACKUP_DIR=~/.config-backups/"$DATE"
    mkdir -p "$BACKUP_DIR"

    if command -v rsync >/dev/null 2>&1; then
        rsync -a ~/.config/ "$BACKUP_DIR/.config/"
    else
        cp -a ~/.config "$BACKUP_DIR/"
    fi

    cp ~/{.zshrc,.p10k.zsh,.nanorc} "$BACKUP_DIR/" 2>/dev/null || true

    echo "✅ Бэкап сохранён в $BACKUP_DIR"
}


backup_configs
