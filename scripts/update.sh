#!/bin/bash
# Script de update seguro do SimpleRGN
# Atualiza imagens e containers sem remover volumes

STACK_DIR="${1:-.}"
STACK_NAME="simplergn"

echo "[$(date)] Iniciando update seguro do $STACK_NAME..."

# 1. Fazer backup antes de update
echo "[$(date)] Fazendo backup da BD como precaução..."
if [ -f "$STACK_DIR/scripts/backup.sh" ]; then
    bash "$STACK_DIR/scripts/backup.sh"
else
    echo "⚠️  Script de backup não encontrado"
fi

# 2. Pull do repositório
echo "[$(date)] Atualizando código do GitHub..."
cd "$STACK_DIR"
git pull

# 3. Pull de imagens
echo "[$(date)] Atualizando imagens Docker..."
docker-compose pull

# 4. Restart dos containers
echo "[$(date)] Reiniciando containers..."
docker-compose up -d

# 5. Verificar status
echo "[$(date)] Verificando status..."
sleep 5
docker-compose ps

# 6. Verificar dados
echo "[$(date)] Verificando BD..."
docker exec "$STACK_NAME-db-1" psql -U user -d simplergn -c "SELECT COUNT(*) as users FROM \"User\";" 2>/dev/null

echo "[$(date)] ✓ Update completo!"
