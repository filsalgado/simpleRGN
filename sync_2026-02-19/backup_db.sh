#!/bin/bash
# Script para fazer backup seguro da base de dados

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_simplergn_$TIMESTAMP.sql"

# Criar diretório se não existir
mkdir -p "$BACKUP_DIR"

echo "============================================"
echo "Backup da Base de Dados - SimpleRGN"
echo "============================================"
echo ""
echo "Timestamp: $TIMESTAMP"
echo "Ficheiro: $BACKUP_FILE"
echo ""

# Verificar se o container está a correr
if ! docker ps | grep -q simplergn-db-1; then
    echo "❌ Container simplergn-db-1 não está a correr!"
    echo "Inicie com: docker compose up -d"
    exit 1
fi

echo "📊 Iniciando backup..."
echo ""

# Fazer o backup
docker exec simplergn-db-1 pg_dump -U postgres -d simplergn > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✅ Backup concluído com sucesso!"
    echo "   Arquivo: $BACKUP_FILE"
    echo "   Tamanho: $SIZE"
    echo ""
    echo "📋 Informação adicional:"
    
    # Contar tabelas
    TABLES=$(docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';")
    echo "   Tabelas: $TABLES"
    
    # Mostrar tamanho da DB
    DB_SIZE=$(docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT pg_size_pretty(pg_database.datsize) FROM pg_database WHERE datname='simplergn';")
    echo "   Tamanho da DB: $DB_SIZE"
    
    echo ""
    echo "⚠️  IMPORTANTE:"
    echo "   1. Guarde este ficheiro num local seguro"
    echo "   2. Faça upload para cloud storage (Google Drive, Dropbox, OneDrive)"
    echo "   3. Mantenha backups anteriores"
    echo ""
    echo "   Para restaurar este backup (se necessário):"
    echo "   docker exec simplergn-db-1 psql -U postgres -d simplergn < $BACKUP_FILE"
    echo ""
else
    echo "❌ Erro ao fazer backup!"
    rm -f "$BACKUP_FILE"
    exit 1
fi
