#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$HOME/.config-backups/$DATE"

backup_configs() {
    echo "📦 Создание резервной копии текущих конфигураций..."
    echo "ℹ️  Копируются только те, которые затрагиваются этим репозиторием."

    mkdir -p "$BACKUP_DIR/.config"

    for dir in "$DOTFILES_DIR"/Configs/.config/*; do
        name=$(basename "$dir")
        if [[ -d "$HOME/.config/$name" ]]; then
            cp -r "$HOME/.config/$name" "$BACKUP_DIR/.config/"
        fi
    done

    for file in .zshrc .p10k.zsh .nanorc; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$BACKUP_DIR/"
        fi
    done

    echo "✅ Бэкап сохранён в $BACKUP_DIR"
}

backup_configs
