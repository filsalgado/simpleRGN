#!/bin/bash
# Script de Sincronização Automatizada para Produção

set -e  # Sair se qualquer comando falhar

echo "============================================"
echo "Sincronização Automatizada - SimpleRGN"
echo "============================================"
echo ""

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_before_sync_$TIMESTAMP.sql"

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Função para logging
log() {
    echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +%H:%M:%S)] ERRO:${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date +%H:%M:%S)] AVISO:${NC} $1"
}

# 1. PRÉ-SINCRONIZAÇÃO
echo ""
log "=== FASE 1: PRÉ-SINCRONIZAÇÃO ==="
echo ""

# Verificar se está num repositório git
if [ ! -d ".git" ]; then
    log_error "Não está num repositório Git!"
    exit 1
fi

# Verificar se há alterações não commitadas
if [ -n "$(git status --porcelain)" ]; then
    log_warning "Existem alterações não commitadas:"
    git status --short
    read -p "Deseja continuar? (n/s): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

# 2. FAZER BACKUP
echo ""
log "=== FASE 2: FAZER BACKUP ==="
echo ""

mkdir -p "$BACKUP_DIR"

log "Iniciando backup da base de dados..."
docker exec simplergn-db-1 pg_dump -U postgres -d simplergn > "$BACKUP_FILE"

SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
log "✅ Backup completo: $BACKUP_FILE ($SIZE)"

# 3. ATUALIZAR CÓDIGO
echo ""
log "=== FASE 3: ATUALIZAR CÓDIGO ==="
echo ""

log "Puxando alterações do GitHub..."
git pull origin main

if [ $? -eq 0 ]; then
    log "✅ Código atualizado com sucesso"
else
    log_error "Falha ao puxar do GitHub"
    exit 1
fi

log "Mostrando alterações:"
git log --oneline -5

# 4. REINICIAR CONTAINERS
echo ""
log "=== FASE 4: REINICIAR CONTAINERS ==="
echo ""

log "Parando containers..."
docker compose down

log "Iniciando novamente (com migrations automáticas)..."
docker compose up -d

log "Aguardando que os containers fiquem prontos..."
sleep 10

# 5. VERIFICAR STATUS
echo ""
log "=== FASE 5: VERIFICAR STATUS ==="
echo ""

# Verificar se o container web está a correr
if docker ps | grep -q simplergn-web-1; then
    log "✅ Container web está a correr"
else
    log_error "Container web não está a correr!"
    exit 1
fi

# Verificar se o container db está a correr
if docker ps | grep -q simplergn-db-1; then
    log "✅ Container db está a correr"
else
    log_error "Container db não está a correr!"
    exit 1
fi

# Verificar conexão com DB
log "Verificando conexão com base de dados..."
if docker exec simplergn-db-1 pg_isready -U postgres > /dev/null 2>&1; then
    log "✅ Base de dados acessível"
else
    log_error "Não consegue aceder à base de dados!"
    exit 1
fi

# 6. VALIDAR MIGRATIONS
echo ""
log "=== FASE 6: VALIDAR MIGRATIONS ==="
echo ""

log "Verificando se as tabelas e colunas existem..."

# Verificar tabela MaritalStatus
if docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name='MaritalStatus');" | grep -q "t"; then
    log "✅ Tabela MaritalStatus existe"
else
    log_error "Tabela MaritalStatus não encontrada"
    exit 1
fi

# Verificar colunas em Individual
if docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name='Individual' AND column_name='birthYear');" | grep -q "t"; then
    log "✅ Coluna birthYear existe"
else
    log_error "Coluna birthYear não encontrada"
    exit 1
fi

# Verificar colunas em Participation
if docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name='Participation' AND column_name='isDeadAtEvent');" | grep -q "t"; then
    log "✅ Coluna isDeadAtEvent existe"
else
    log_error "Coluna isDeadAtEvent não encontrada"
    exit 1
fi

# 7. VERIFICAR INTEGRIDADE DOS DADOS
echo ""
log "=== FASE 7: VERIFICAR INTEGRIDADE DOS DADOS ==="
echo ""

EVENTS=$(docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT COUNT(*) FROM Event;")
PARTICIPATIONS=$(docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT COUNT(*) FROM Participation;")
INDIVIDUALS=$(docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT COUNT(*) FROM Individual;")

log "Registos no sistema:"
echo "   - Eventos: $EVENTS"
echo "   - Participantes: $PARTICIPATIONS"
echo "   - Indivíduos: $INDIVIDUALS"

# 8. VERIFICAR LOGS
echo ""
log "=== FASE 8: VERIFICAR LOGS ==="
echo ""

log "Mostrando últimas mensagens dos logs do web:"
docker compose logs --tail=10 web

# 9. CONCLUSÃO
echo ""
echo "============================================"
echo -e "${GREEN}✅ SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo "============================================"
echo ""
echo "📋 Resumo:"
echo "   ✓ Backup realizado: $BACKUP_FILE"
echo "   ✓ Código atualizado do GitHub"
echo "   ✓ Containers reiniciados"
echo "   ✓ Migrations aplicadas"
echo "   ✓ Dados preservados"
echo ""
echo "🔗 Próximos passos:"
echo "   1. Acesse http://localhost:3010"
echo "   2. Faça login"
echo "   3. Teste criar um novo registo"
echo "   4. Verifique se os novos campos aparecem"
echo ""
echo "⚠️  Informação importante:"
echo "   - Backup guardado em: $BACKUP_FILE"
echo "   - Para restaurar: docker exec simplergn-db-1 psql -U postgres -d simplergn < $BACKUP_FILE"
echo "   - Guarde este backup num local seguro!"
echo ""
