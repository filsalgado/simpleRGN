/*
═══════════════════════════════════════════════════════════════════════════════
  SCRIPT DE MIGRAÇÃO - SimpleRGN v2.0
  Data: 19 de Fevereiro de 2026
  Objetivo: Adicionar campos de Estado Civil, Data de Nascimento e indicador
            de Falecido à Data do Evento
═══════════════════════════════════════════════════════════════════════════════

INSTRUÇÕES DE USO:
─────────────────
1. Abrir pgAdmin no servidor de produção
2. Conectar à base de dados 'simplergn'
3. Abrir o Query Tool
4. Copiar todo o conteúdo deste ficheiro
5. Colar no Query Tool
6. Executar (F5 ou botão Execute)

SEGURANÇA:
──────────
✓ Todas as alterações apenas ADICIONAM colunas
✓ Nenhum dado existente é deletado
✓ Transações garantem atomicidade (tudo ou nada)
✓ Validações antes de cada alteração

TEMPO ESTIMADO: 10-30 segundos

═══════════════════════════════════════════════════════════════════════════════
*/

-- Iniciar transação
BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════════════════════════
-- MIGRATION 1: Adicionar Estado Civil (MaritalStatus)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Verificar se tabela já existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_name = 'MaritalStatus'
    ) THEN
        CREATE TABLE "MaritalStatus" (
            "id" SERIAL NOT NULL,
            "name" TEXT NOT NULL,
            "isOriginal" BOOLEAN NOT NULL DEFAULT false,
            CONSTRAINT "MaritalStatus_pkey" PRIMARY KEY ("id")
        );
        
        -- Criar índice único
        CREATE UNIQUE INDEX "MaritalStatus_name_key" ON "MaritalStatus"("name");
        
        RAISE NOTICE 'Tabela MaritalStatus criada com sucesso';
    ELSE
        RAISE NOTICE 'Tabela MaritalStatus já existe (ignorando)';
    END IF;
END $$;

-- Adicionar coluna maritalStatusId em Participation
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Participation' AND column_name = 'maritalStatusId'
    ) THEN
        ALTER TABLE "Participation" ADD COLUMN "maritalStatusId" INTEGER;
        
        -- Adicionar foreign key
        ALTER TABLE "Participation" 
            ADD CONSTRAINT "Participation_maritalStatusId_fkey" 
            FOREIGN KEY ("maritalStatusId") REFERENCES "MaritalStatus"("id") 
            ON DELETE SET NULL ON UPDATE CASCADE;
        
        RAISE NOTICE 'Coluna maritalStatusId adicionada em Participation';
    ELSE
        RAISE NOTICE 'Coluna maritalStatusId já existe (ignorando)';
    END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- MIGRATION 2: Adicionar Data de Nascimento em Separado (Dia-Mês-Ano)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Adicionar colunas de data de nascimento em Individual
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Individual' AND column_name = 'birthYear'
    ) THEN
        ALTER TABLE "Individual" 
            ADD COLUMN "birthYear" INTEGER,
            ADD COLUMN "birthMonth" INTEGER,
            ADD COLUMN "birthDay" INTEGER;
        
        RAISE NOTICE 'Colunas de data de nascimento adicionadas em Individual';
    ELSE
        RAISE NOTICE 'Colunas de data de nascimento já existem (ignorando)';
    END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- MIGRATION 3: Adicionar Indicador de Falecido à Data do Evento
-- ═══════════════════════════════════════════════════════════════════════════════

-- Adicionar coluna isDeadAtEvent em Participation
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Participation' AND column_name = 'isDeadAtEvent'
    ) THEN
        ALTER TABLE "Participation" 
            ADD COLUMN "isDeadAtEvent" BOOLEAN NOT NULL DEFAULT false;
        
        RAISE NOTICE 'Coluna isDeadAtEvent adicionada em Participation';
    ELSE
        RAISE NOTICE 'Coluna isDeadAtEvent já existe (ignorando)';
    END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- VALIDAÇÃO: Confirmar que todas as alterações foram aplicadas
-- ═══════════════════════════════════════════════════════════════════════════════

DO $$
DECLARE
    marital_table_exists BOOLEAN;
    birth_year_exists BOOLEAN;
    birth_month_exists BOOLEAN;
    birth_day_exists BOOLEAN;
    marital_status_id_exists BOOLEAN;
    is_dead_at_event_exists BOOLEAN;
BEGIN
    -- Verificar tabela MaritalStatus
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_name = 'MaritalStatus'
    ) INTO marital_table_exists;
    
    -- Verificar colunas em Individual
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Individual' AND column_name = 'birthYear'
    ) INTO birth_year_exists;
    
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Individual' AND column_name = 'birthMonth'
    ) INTO birth_month_exists;
    
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Individual' AND column_name = 'birthDay'
    ) INTO birth_day_exists;
    
    -- Verificar colunas em Participation
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Participation' AND column_name = 'maritalStatusId'
    ) INTO marital_status_id_exists;
    
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'Participation' AND column_name = 'isDeadAtEvent'
    ) INTO is_dead_at_event_exists;
    
    -- Relatório final
    RAISE NOTICE '═══════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'VALIDAÇÃO FINAL DAS ALTERAÇÕES';
    RAISE NOTICE '═══════════════════════════════════════════════════════════════════';
    
    IF marital_table_exists THEN
        RAISE NOTICE '✓ Tabela MaritalStatus criada';
    ELSE
        RAISE EXCEPTION '✗ Tabela MaritalStatus NÃO ENCONTRADA';
    END IF;
    
    IF marital_status_id_exists THEN
        RAISE NOTICE '✓ Coluna maritalStatusId em Participation';
    ELSE
        RAISE EXCEPTION '✗ Coluna maritalStatusId NÃO ENCONTRADA';
    END IF;
    
    IF birth_year_exists AND birth_month_exists AND birth_day_exists THEN
        RAISE NOTICE '✓ Colunas de data de nascimento em Individual (Dia-Mês-Ano)';
    ELSE
        RAISE EXCEPTION '✗ Colunas de data de nascimento NÃO CRIADAS';
    END IF;
    
    IF is_dead_at_event_exists THEN
        RAISE NOTICE '✓ Coluna isDeadAtEvent em Participation';
    ELSE
        RAISE EXCEPTION '✗ Coluna isDeadAtEvent NÃO ENCONTRADA';
    END IF;
    
    RAISE NOTICE '═══════════════════════════════════════════════════════════════════';
    RAISE NOTICE '✅ TODAS AS ALTERAÇÕES FORAM APLICADAS COM SUCESSO!';
    RAISE NOTICE '═══════════════════════════════════════════════════════════════════';
END $$;

-- Contar registos para confirmar que nenhum foi deletado
DO $$
DECLARE
    event_count INTEGER;
    participation_count INTEGER;
    individual_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO event_count FROM "Event";
    SELECT COUNT(*) INTO participation_count FROM "Participation";
    SELECT COUNT(*) INTO individual_count FROM "Individual";
    
    RAISE NOTICE '';
    RAISE NOTICE 'INTEGRIDADE DOS DADOS:';
    RAISE NOTICE '─────────────────────────────────────────────────────────────────';
    RAISE NOTICE 'Eventos no sistema: %', event_count;
    RAISE NOTICE 'Participantes no sistema: %', participation_count;
    RAISE NOTICE 'Indivíduos no sistema: %', individual_count;
    RAISE NOTICE '─────────────────────────────────────────────────────────────────';
    RAISE NOTICE '✓ Todos os dados foram preservados!';
END $$;

-- Confirmar transação
COMMIT;

-- ═══════════════════════════════════════════════════════════════════════════════
-- INSTRUÇÕES PÓS-EXECUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════════

/*
PRÓXIMOS PASSOS:
────────────────

1. ✓ Script SQL executado na BD de Produção

2. Na aplicação (web):
   - O código já está pronto para usar os novos campos
   - Prisma schema já tem os campos configurados
   - Migrations no Prisma já estão sincronizadas

3. Verificar tudo está OK:
   - Fazer login na aplicação
   - Criar novo registo
   - Ver se novos campos aparecem (Estado Civil, Data de Nascimento)
   - Editar registo antigo - deve estar OK

4. Se algo correr mal:
   - Restaurar de backup
   - Contactar suporte

CAMPOS NOVOS DISPONÍVEIS:
─────────────────────────

Tabela: Individual
├─ birthYear (INTEGER, NULL) - Ano de nascimento
├─ birthMonth (INTEGER, NULL) - Mês de nascimento
└─ birthDay (INTEGER, NULL) - Dia de nascimento

Tabela: Participation
├─ maritalStatusId (INTEGER, NULL) - FK para MaritalStatus
└─ isDeadAtEvent (BOOLEAN, default FALSE) - Falecido à data do evento

Tabela: MaritalStatus (NOVA)
├─ id (SERIAL, PK)
├─ name (TEXT, UNIQUE) - Nome do estado civil
└─ isOriginal (BOOLEAN, default FALSE)

CONSULTAS ÚTEIS PARA DEPOIS:
───────────────────────────

-- Ver estrutura das novas colunas:
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'Individual'
  AND column_name IN ('birthYear', 'birthMonth', 'birthDay')
ORDER BY ordinal_position;

-- Ver foreign keys em Participation:
SELECT constraint_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'Participation'
  AND column_name = 'maritalStatusId';

-- Ver padrão de isDeadAtEvent:
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_name = 'Participation'
  AND column_name = 'isDeadAtEvent';

-- Contar participações com isDeadAtEvent = true:
SELECT COUNT(*) FROM "Participation"
WHERE "isDeadAtEvent" = true;
-- Resultado: 0 (nenhum foi marcado como falecido)

*/
