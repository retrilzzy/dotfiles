#!/bin/bash

set -euo pipefail

BACKUP_DIR="$HOME/.config-backups"

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "❌ Резервные копии не найдены: $BACKUP_DIR"
    exit 1
fi

echo "📦 Доступные резервные копии:"
ls -1 "$BACKUP_DIR" | sort

read -rp "Введите имя папки для восстановления (YYYY-MM-DD_HH-MM-SS): " folder

TARGET="$BACKUP_DIR/$folder"

if [[ ! -d "$TARGET" ]]; then
    echo "❌ Директория '$folder' не найдена в резервных копиях"
    exit 1
fi

echo "♻️  Восстановление конфигураций..."

mkdir -p "$HOME/.config"

cp -r "$TARGET/.config/." "$HOME/.config/" 2>/dev/null || true
cp "$TARGET"/.{zshrc,p10k.zsh,nanorc} "$HOME"/ 2>/dev/null || true

echo "✅ Конфигурации успешно восстановлены из $TARGET"
