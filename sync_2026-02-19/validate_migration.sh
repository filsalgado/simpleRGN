#!/bin/bash
# Script para validar a sincronização em Produção

echo "============================================"
echo "Validação de Sincronização - SimpleRGN"
echo "============================================"
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar coluna
check_column() {
    local table=$1
    local column=$2
    local expected_type=$3
    
    result=$(docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name='$table' AND column_name='$column');")
    
    if [[ $result == *"t"* ]]; then
        echo -e "${GREEN}✓${NC} $table.$column existe"
        return 0
    else
        echo -e "${RED}✗${NC} $table.$column NÃO ENCONTRADO"
        return 1
    fi
}

# Função para verificar tabela
check_table() {
    local table=$1
    
    result=$(docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name='$table');")
    
    if [[ $result == *"t"* ]]; then
        echo -e "${GREEN}✓${NC} Tabela $table existe"
        return 0
    else
        echo -e "${RED}✗${NC} Tabela $table NÃO ENCONTRADA"
        return 1
    fi
}

echo "1. Verificando Nova Tabela: MaritalStatus"
echo "-------------------------------------------"
check_table "MaritalStatus"

echo ""
echo "2. Verificando Novos Campos em 'Individual'"
echo "--------------------------------------------"
check_column "Individual" "birthYear" "integer"
check_column "Individual" "birthMonth" "integer"
check_column "Individual" "birthDay" "integer"

echo ""
echo "3. Verificando Novos Campos em 'Participation'"
echo "-----------------------------------------------"
check_column "Participation" "maritalStatusId" "integer"
check_column "Participation" "isDeadAtEvent" "boolean"

echo ""
echo "4. Verificando Integridade dos Dados"
echo "-------------------------------------"

# Contar registos
echo -n "Eventos no sistema: "
docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT COUNT(*) FROM Event;"

echo -n "Participantes no sistema: "
docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT COUNT(*) FROM Participation;"

echo -n "Indivíduos no sistema: "
docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT COUNT(*) FROM Individual;"

echo ""
echo "5. Verificando Valores De Padrão"
echo "--------------------------------"

# Verificar padrão de isDeadAtEvent
echo -n "Padrão de 'isDeadAtEvent' em novos registos: "
docker exec simplergn-db-1 psql -U postgres -d simplergn -tc "SELECT column_default FROM information_schema.columns WHERE table_name='Participation' AND column_name='isDeadAtEvent';"

echo ""
echo "6. Mostrando Estado Civil Carregados"
echo "------------------------------------"
docker exec simplergn-db-1 psql -U postgres -d simplergn -c "SELECT * FROM \"MaritalStatus\" LIMIT 5;"

echo ""
echo "7. Amostra de Registos com Novos Campos"
echo "--------------------------------------"
docker exec simplergn-db-1 psql -U postgres -d simplergn -c "SELECT id, \"isDeadAtEvent\", \"maritalStatusId\" FROM \"Participation\" LIMIT 3;"

echo ""
echo "============================================"
echo -e "${GREEN}Validação Completa${NC}"
echo "============================================"
echo ""
echo "Se todos os items acima estão com ✓, a migração foi bem-sucedida!"
echo ""
