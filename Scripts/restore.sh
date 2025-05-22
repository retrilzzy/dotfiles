#!/bin/env bash

BACKUP_DIR="$HOME/.config-backups"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Резервные копии не найдены: $BACKUP_DIR"
    exit 1
fi

echo "📦 Доступные резервные копии:"
ls "$BACKUP_DIR"

read -rp "Введите имя папки для восстановления (YYYY-MM-DD_HH:MM:SS): " folder

if [ ! -d "$BACKUP_DIR/$folder" ]; then
    echo "❌ Директория $folder не найдена в резервных копиях"
    exit 1
fi

echo "♻️  Восстановление конфигураций..."
cp -r "$BACKUP_DIR/$folder/.config" ~/
cp "$BACKUP_DIR/$folder"/.{zshrc,p10k.zsh,nanorc} ~/ 2>/dev/null || true

echo "✅ Конфигурации восстановлены!"
