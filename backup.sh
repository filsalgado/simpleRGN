#!/bin/bash

# Define backup filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="simpleRGN_backup_$TIMESTAMP.zip"

echo "Iniciando backup para: $BACKUP_NAME"
echo "Excluindo node_modules, .next, .git e builds..."

# Create zip file excluding heavy/generated folders
# -r: recursive
# -x: exclude pattern
zip -r "$BACKUP_NAME" . \
    -x "*/node_modules/*" \
    -x "*/.next/*" \
    -x "*/.git/*" \
    -x "*.zip" \
    -x "*/dist/*" \
    -x "*/build/*" \
    -x ".env" 

echo "Backup criado com sucesso: $BACKUP_NAME"
