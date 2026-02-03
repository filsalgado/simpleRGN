#!/bin/bash
# Script de restore do SimpleRGN
# Uso: ./restore.sh /data/backups/backup_simplergn_20260203_020000.sql.gz

if [ -z "$1" ]; then
    echo "Uso: $0 <caminho_do_backup>"
    echo "Exemplo: $0 /data/backups/backup_simplergn_20260203_020000.sql.gz"
    exit 1
fi

BACKUP_FILE="$1"
DB_CONTAINER="simplergn-db-1"
DB_USER="user"
DB_NAME="simplergn"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "✗ Arquivo não encontrado: $BACKUP_FILE"
    exit 1
fi

# Se o arquivo é .gz, decomprimir temporariamente
if [[ "$BACKUP_FILE" == *.gz ]]; then
    TEMP_FILE=$(mktemp)
    echo "[$(date)] Descomprimindo arquivo..."
    gunzip -c "$BACKUP_FILE" > "$TEMP_FILE"
    BACKUP_FILE="$TEMP_FILE"
fi

echo "[$(date)] Iniciando restore do database..."
echo "⚠️  AVISO: Isto vai SOBRESCREVER a BD existente!"
echo "Pressiona Ctrl+C para cancelar, ou enter para continuar..."
read

# Apagar tabelas existentes
echo "[$(date)] Limpando BD existente..."
docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" 2>/dev/null

# Restaurar
echo "[$(date)] Restaurando dados..."
docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "[$(date)] ✓ Restore concluído com sucesso!"
    
    # Verificar dados
    COUNT=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT COUNT(*) FROM \"User\";" 2>/dev/null | tail -1 | tr -d ' ')
    echo "[$(date)] Verificação: $COUNT utilizadores na BD"
else
    echo "[$(date)] ✗ Erro durante o restore!"
    exit 1
fi

# Limpar arquivo temporário
if [ ! -z "$TEMP_FILE" ] && [ -f "$TEMP_FILE" ]; then
    rm "$TEMP_FILE"
fi
