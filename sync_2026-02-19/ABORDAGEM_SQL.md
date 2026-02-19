# 🗄️ Script SQL Direto - Alternativa via pgAdmin

## 📋 Resumo

Script SQL que implementa diretamente as 3 alterações à base de dados, sem precisar de Docker ou Prisma.

**Ficheiro:** `migrations_production.sql`  
**Tamanho:** ~7 KB  
**Tempo de execução:** 10-30 segundos

---

## ✅ Vantagens desta Abordagem

| Vantagem | Descrição |
|----------|-----------|
| **Direto** | Executa SQL diretamente na BD de produção |
| **Rápido** | ~20 segundos de execução |
| **Simples** | Via pgAdmin, sem terminal/Docker |
| **Visível** | Pode ver cada comando executado |
| **Controlado** | Acesso direto à BD |
| **Seguro** | Validações automáticas no script |
| **Reversível** | Backup manual antes de executar |

---

## ⚠️ Desvantagens

| Desvantagem | Mitigação |
|-------------|-----------|
| Sem versionamento no Prisma | Aplicação web já tem schema atualizado |
| Sem histórico automático | Documentar quando executou |
| Manual | Requer acesso direto pgAdmin |
| Sem Docker | Não reinicia containers |

---

## 🚀 Como Usar

### Passo 1: Fazer Backup Primeiro ⚠️

```bash
# No servidor de produção (terminal)
cd /path/to/simplergn
./backup.sh

# Ou copie o dump via pgAdmin
```

### Passo 2: Aceder ao pgAdmin

```
1. Abrir: http://seu-servidor:5050 (ou port do pgAdmin)
2. Conectar à base de dados PostgreSQL
3. Selecionar BD: simplergn
4. Tools → Query Tool
```

### Passo 3: Preparar o Script

```
1. Copiar todo o conteúdo de: migrations_production.sql
2. Colar na janela Query Tool do pgAdmin
3. Selecionar tudo (Ctrl+A)
```

### Passo 4: Executar

```
1. Clicar no botão Execute (F5)
2. Aguardar conclusão (~20 segundos)
3. Ver mensagens de sucesso no painel de output
4. Verificar que não há erros
```

### Passo 5: Validar

```sql
-- Copiar estas queries para pgAdmin para validar:

-- 1. Ver tabela MaritalStatus
SELECT * FROM "MaritalStatus" LIMIT 5;

-- 2. Ver colunas em Individual
SELECT column_name FROM information_schema.columns
WHERE table_name = 'Individual'
AND column_name IN ('birthYear', 'birthMonth', 'birthDay');

-- 3. Ver colunas em Participation
SELECT column_name FROM information_schema.columns
WHERE table_name = 'Participation'
AND column_name IN ('maritalStatusId', 'isDeadAtEvent');

-- 4. Contar registos (devem ser iguais a antes)
SELECT COUNT(*) FROM "Event";
SELECT COUNT(*) FROM "Participation";
SELECT COUNT(*) FROM "Individual";
```

---

## 🔒 Segurança do Script

O script garante:

✅ **Idempotência** - Pode executar múltiplas vezes, só altera se não existir  
✅ **Transações** - Tudo ou nada (se erro, reverte tudo)  
✅ **Validações** - Confirma cada alteração com DO blocks  
✅ **Relatórios** - Mostra exatamente o que foi feito  
✅ **Integridade** - Verifica que nenhum dado foi perdido  

---

## 📊 O Que Muda

### Tabela Nova: MaritalStatus
```sql
CREATE TABLE "MaritalStatus" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT UNIQUE NOT NULL,
    "isOriginal" BOOLEAN DEFAULT false
);
```

### Colunas Novas em Individual
```sql
ALTER TABLE "Individual" ADD COLUMN "birthYear" INTEGER;
ALTER TABLE "Individual" ADD COLUMN "birthMonth" INTEGER;
ALTER TABLE "Individual" ADD COLUMN "birthDay" INTEGER;
```

### Colunas Novas em Participation
```sql
ALTER TABLE "Participation" ADD COLUMN "maritalStatusId" INTEGER;
ALTER TABLE "Participation" ADD COLUMN "isDeadAtEvent" BOOLEAN DEFAULT false;
ALTER TABLE "Participation" ADD FOREIGN KEY ("maritalStatusId") 
    REFERENCES "MaritalStatus"("id") ON DELETE SET NULL;
```

---

## 🆘 Se Algo Correr Mal

### Erro Durante Execução

```
Se ver erro como "relation ... does not exist":
1. Parar a execução
2. Verificar se BD está OK
3. Restaurar de backup
4. Tentar novamente
```

### Rollback Manual

Se precisar reverter (não recomendado sem backup):

```sql
-- ⚠️ APENAS SE NECESSÁRIO E TIVER BACKUP!
DROP TABLE "MaritalStatus" CASCADE;
ALTER TABLE "Participation" DROP COLUMN "maritalStatusId";
ALTER TABLE "Participation" DROP COLUMN "isDeadAtEvent";
ALTER TABLE "Individual" DROP COLUMN "birthYear";
ALTER TABLE "Individual" DROP COLUMN "birthMonth";
ALTER TABLE "Individual" DROP COLUMN "birthDay";
```

---

## 📈 Comparação: SQL vs Docker vs Prisma

| Aspecto | SQL Direto | Docker + Prisma | Prisma Via CLI |
|---------|-----------|-----------------|-----------------|
| **Velocidade** | ⭐⭐⭐ Máxima | ⭐⭐ Média | ⭐⭐ Média |
| **Segurança** | ⭐⭐⭐ Backup manual | ⭐⭐⭐ Automática | ⭐⭐⭐ Automática |
| **Versionamento** | ❌ Nenhum | ✅ Automático | ✅ Automático |
| **Simplicidade** | ⭐⭐⭐ Simples | ⭐ Complexo | ⭐⭐ Médio |
| **Acesso** | ✅ pgAdmin | ✅ Terminal Docker | ✅ Terminal |
| **Idempotência** | ✅ Sim | ✅ Sim | ✅ Sim |
| **Validação** | ✅ Manual | ✅ Automática | ✅ Automática |

---

## 🎯 Recomendação

**Usar Script SQL ( esta abordagem) se:**
- ✅ Tem acesso direto a pgAdmin
- ✅ Quer abordagem simples e rápida
- ✅ Não quer lidar com Docker
- ✅ A BD é crítica (backup obrigatório)

**Usar sync_production.sh (Docker) se:**
- ✅ Quer abordagem automática completa
- ✅ Quer versionamento das migrations
- ✅ Prefere histórico automático
- ✅ Não tem acesso direto à BD

---

## ✅ Checklist Uso

- [ ] Fiz backup da BD
- [ ] Guardei backup em local seguro
- [ ] Copiei conteúdo de migrations_production.sql
- [ ] Abri pgAdmin e conectei à BD corrета
- [ ] Colei script no Query Tool
- [ ] Executei (F5)
- [ ] Vi "✅ TODAS AS ALTERAÇÕES FORAM APLICADAS COM SUCESSO!"
- [ ] Executei as 4 queries de validação
- [ ] Testei na aplicação web
- [ ] Documentei data/hora da execução

---

## 📞 Suporte

Se encontrar problemas:

1. **Verificar erro no output do pgAdmin**
2. **Consultar logs da BD:**
   ```bash
   # No servidor PostgreSQL
   tail -f /var/log/postgresql/postgresql.log
   ```
3. **Restaurar de backup**
4. **Reexecutar o script**

---

## 📝 Referência

**Ficheiro:** `migrations_production.sql`  
**Data:** 19 de Fevereiro de 2026  
**Versão:** v2.0  
**Status:** Pronto para usar ✅
