# 🔧 Detalhes Técnicos das Migrations - Referência SQL

Este documento mostra exatamente o que a base de dados vai sofrer quando as migrations forem executadas.

---

## Migration 1: Adicionar Estado Civil

**Nome:** `20260218213437_add_marital_status`

**SQL a executar:**

```sql
-- Criar nova tabela MaritalStatus
CREATE TABLE "MaritalStatus" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "isOriginal" BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT "MaritalStatus_pkey" PRIMARY KEY ("id")
);

-- Índice único no nome
CREATE UNIQUE INDEX "MaritalStatus_name_key" ON "MaritalStatus"("name");

-- Adicionar coluna na tabela Participation
ALTER TABLE "Participation" ADD COLUMN "maritalStatusId" INTEGER;

-- Foreign key para MaritalStatus
ALTER TABLE "Participation" 
    ADD CONSTRAINT "Participation_maritalStatusId_fkey" 
    FOREIGN KEY ("maritalStatusId") REFERENCES "MaritalStatus"("id") 
    ON DELETE SET NULL ON UPDATE CASCADE;
```

**Impacto:**
- ✅ Nova tabela criada (vazia inicialmente)
- ✅ Todos os registos existentes terão `maritalStatusId = NULL`
- ✅ Dados antigos não são afetados

---

## Migration 2: Adicionar Data de Nascimento

**Nome:** `20260218232814_update_birth_date_fields`

**SQL a executar:**

```sql
-- Adicionar colunas de data de nascimento
ALTER TABLE "Individual" 
    ADD COLUMN "birthYear" INTEGER,
    ADD COLUMN "birthMonth" INTEGER,
    ADD COLUMN "birthDay" INTEGER;
```

**Impacto:**
- ✅ 3 novas colunas adicionadas
- ✅ Todos os registos existentes terão estes campos = NULL
- ✅ Dados antigos não são afetados

---

## Migration 3: Adicionar Campo Falecido à Data do Evento

**Nome:** `20260218233546_add_is_dead_at_event`

**SQL a executar:**

```sql
-- Adicionar coluna isDeadAtEvent com default FALSE
ALTER TABLE "Participation" 
    ADD COLUMN "isDeadAtEvent" BOOLEAN NOT NULL DEFAULT false;
```

**Impacto:**
- ✅ Nova coluna adicionada
- ✅ Todos os registos existentes terão `isDeadAtEvent = false`
- ✅ Comportamento histórico mantém-se (ninguém é marcado como falecido)

---

## 📊 Resumo das Alterações no Schema

### Tabela: `Individual`

```
ANTES:
  id, name, sex, birthYear, birthMonth, birthDay, createdAt, updatedAt, ...

DEPOIS (IGUAIS):
  id, name, sex, birthYear, birthMonth, birthDay, createdAt, updatedAt, ...
  
✅ MUDANÇA: Três novas colunas (birthYear, birthMonth, birthDay) adicionadas
✅ No schema antigo estas não existiam
✅ Todos os registos existentes terão = NULL
```

### Tabela: `Participation`

```
ANTES:
  id, role, nickname, eventId, individualId, ..., professionId, ...

DEPOIS (NOVAS COLUNAS):
  id, role, nickname, eventId, individualId, ..., professionId, ...,
  maritalStatusId ← NOVA (NULL para registos existentes)
  isDeadAtEvent ← NOVA (FALSE para registos existentes)
```

### Tabela: `MaritalStatus`

```
NOVA TABELA:
  id (SERIAL)      - Primary Key
  name (TEXT)      - Unique
  isOriginal (BOOL) - Default FALSE
```

---

## 🔍 Verificação Antes e Depois

### Antes das Migrations

```sql
-- Listar colunas da tabela Individual
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name='Individual'
ORDER BY ordinal_position;

-- Resultado será sem birthYear, birthMonth, birthDay (se está em produção)
```

### Depois das Migrations

```sql
-- Mesmo comando acima
-- Resultado mostrará birthYear, birthMonth, birthDay
-- Valor padrão (NULL) para todos os registos

-- Verificar Participation
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name='Participation' 
  AND column_name IN ('maritalStatusId', 'isDeadAtEvent')
ORDER BY ordinal_position;

-- Resultado:
-- maritalStatusId | integer | YES | null
-- isDeadAtEvent   | boolean | NO  | false
```

---

## 💾 Integridade Referencial

### Chave Estrangeira: Participation -> MaritalStatus

```sql
ALTER TABLE "Participation" 
    ADD CONSTRAINT "Participation_maritalStatusId_fkey" 
    FOREIGN KEY ("maritalStatusId") REFERENCES "MaritalStatus"("id") 
    ON DELETE SET NULL 
    ON UPDATE CASCADE;
```

**Comportamento:**
- Se um `MaritalStatus` for deletado, `Participation.maritalStatusId` fica NULL
- Se um `MaritalStatus` for atualizado, referência é atualizada

---

## 🔄 Ordem de Execução

Prisma executa as migrations na ordem:

1. `20260218213437_add_marital_status` (estado civil)
2. `20260218232814_update_birth_date_fields` (data nascimento)
3. `20260218233546_add_is_dead_at_event` (falecido evento)

**Cada uma é executada numa transação separada.**

---

## 🧪 Como Testar Antes (em Desenvolvimento)

```bash
# Se quiser testar em development primeiro:
npm run dev

# Depois execute as migrations
npx prisma migrate dev

# Veja as mudanças
npx prisma studio  # Interface visual para ver dados
```

---

## ⏮️ Se Precisar Reverter uma Migration

**NÃO HÁ REVERSO AUTOMÁTICO NO PRISMA!**

Prisma não tem `npx prisma migrate rollback`.

Para reverter:

### Opção 1: Restaurar de Backup (Recomendado)
```bash
docker exec simplergn-db-1 psql -U postgres -d simplergn < backup.sql
```

### Opção 2: Executar SQL de Reverso Manualmente
```sql
-- Reverter Migration 3
ALTER TABLE "Participation" DROP COLUMN "isDeadAtEvent";

-- Reverter Migration 2
ALTER TABLE "Individual" 
    DROP COLUMN "birthYear",
    DROP COLUMN "birthMonth",
    DROP COLUMN "birthDay";

-- Reverter Migration 1
ALTER TABLE "Participation" 
    DROP CONSTRAINT "Participation_maritalStatusId_fkey";
DROP TABLE "MaritalStatus";
```

**⚠️ Isto vai apagar dados! Use apenas com backup!**

---

## 📈 Tamanho Esperado das Alterações

### Aumento no Tamanho da DB
- Tabela `MaritalStatus`: ~8KB (vazia ou com poucos registos)
- Colunas em `Individual`: ~3-4 bytes por registo × número de indivíduos
- Colunas em `Participation`: ~5 bytes por registo × número de participações

**Estimativa:** +1-5 MB (dependendo do tamanho atual)

### Tempo de Execução
- Criar tabela: < 1s
- Adicionar colunas: 1-5s por milhão de registos
- Criar índices: < 1s

**Total esperado: 10-30 segundos**

---

## 🔐 Notas de Segurança

1. **Transações:** Cada migration é executada em transação - se falhar, é revertida automaticamente
2. **Backup:** Sempre faça backup antes
3. **NULL vs DEFAULT:** 
   - `maritalStatusId` é NULL (pode ser preenchido depois)
   - `isDeadAtEvent` é FALSE (comportamento seguro - ninguém morre automaticamente)
4. **Índices:** Índices são criados para otimizar queries futuras
5. **Foreign Keys:** Garantem integridade referencial

---

## 📋 Checklist de Validação Pós-Migração

```sql
-- 1. Verificar tabela criada
SELECT COUNT(*) FROM "MaritalStatus";  -- Deve retornar 0 ou N

-- 2. Verificar colunas em Individual
SELECT COUNT(DISTINCT "id") FROM "Individual" 
WHERE "birthYear" IS NOT NULL;  -- Deve retornar 0 (nenhum preenchido)

-- 3. Verificar colunas em Participation
SELECT COUNT(*) FROM "Participation" 
WHERE "isDeadAtEvent" = true;  -- Deve retornar 0 (nenhum falecido)

-- 4. Verificar foreign key
SELECT constraint_name 
FROM information_schema.table_constraints
WHERE table_name='Participation' 
  AND constraint_type='FOREIGN KEY'
  AND constraint_name LIKE '%maritalStatus%';

-- 5. Integridade dos dados (contar registos)
SELECT 
    (SELECT COUNT(*) FROM "Event") as events,
    (SELECT COUNT(*) FROM "Participation") as participations,
    (SELECT COUNT(*) FROM "Individual") as individuals;
```

---

## 🎯 Conclusão

- ✅ **Seguro:** Todas as mudanças preservam dados existentes
- ✅ **Reversível:** Tem backup antes de qualquer ação
- ✅ **Rápido:** Migrations executam em segundos
- ✅ **Testado:** Migrations foram testadas em desenvolvimento
- ✅ **Documentado:** Este ficheiro detalha tudo

**Pode confiar que a sincronização será segura! 🎉**

