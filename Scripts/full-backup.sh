#!/bin/bash

set -euo pipefail

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$HOME/.config-backups/$DATE"

backup_configs() {
    echo "📦 Создание полной резервной копии: $HOME/.config → $BACKUP_DIR"

    mkdir -p "$BACKUP_DIR"

    if command -v rsync >/dev/null 2>&1; then
        rsync -a --delete "$HOME/.config/" "$BACKUP_DIR/.config/"
    else
        cp -a "$HOME/.config" "$BACKUP_DIR"/
    fi

    for file in .zshrc .p10k.zsh .nanorc; do
        [ -f "$HOME/$file" ] && cp "$HOME/$file" "$BACKUP_DIR/"
    done

    echo "✅ Бэкап сохранён в $BACKUP_DIR"
}

backup_configs
