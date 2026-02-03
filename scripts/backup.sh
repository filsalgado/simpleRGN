#!/bin/bash
# Script de backup automático do SimpleRGN
# Executa: 0 2 * * * /data/simplergn/scripts/backup.sh (cron diário às 2:00 UTC)

BACKUP_DIR="/data/backups"
DB_CONTAINER="simplergn-db-1"
DB_USER="user"
DB_NAME="simplergn"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_simplergn_$TIMESTAMP.sql"
RETENTION_DAYS=7

# Criar diretório se não existir
mkdir -p "$BACKUP_DIR"

# Fazer dump
echo "[$(date)] Iniciando backup..."
docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" --no-owner > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "[$(date)] ✓ Backup concluído: $BACKUP_FILE ($SIZE)"
    
    # Comprimir
    gzip "$BACKUP_FILE"
    echo "[$(date)] ✓ Compressão concluída: $BACKUP_FILE.gz"
    
    # Remover backups antigos (mais de 7 dias)
    find "$BACKUP_DIR" -name "backup_simplergn_*.sql.gz" -mtime +$RETENTION_DAYS -delete
    echo "[$(date)] ✓ Backups antigos removidos (>${RETENTION_DAYS} dias)"
else
    echo "[$(date)] ✗ Erro ao fazer backup!"
    exit 1
fi
