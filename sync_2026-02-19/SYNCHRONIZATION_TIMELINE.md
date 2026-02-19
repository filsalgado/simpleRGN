# 📅 Plano de Sincronização - Timeline e Best Practices

## 🎯 Objetivo

Sincronizar a aplicação SimpleRGN de desenvolvimento com a de produção (Portainer), aplicando 3 novas migrations à base de dados sem perder dados existentes.

---

## 📊 O Que Está a Mudar

### Novos Campos na BD
1. **Estado Civil** → Campo em Participation (opcional)
2. **Data de Nascimento** → 3 campos em Individual (ano, mês, dia - todos opcionais)
3. **Falecido à Data do Evento** → Campo em Participation (padrão: FALSE)

### Nova Funcionalidade de Aplicação
1. Botões "Novo Registo" e "Listar Registos" na navbar
2. Dois botões de gravação (Gravar / Gravar & Novo)
3. Toast notifications ao invés de alerts
4. Melhor UX geral

---

## ⏱️ Timeline Recomendada

### **Dia 1: Preparação (30 minutos)**

```
14:00 - Reunião de planeamento
14:15 - Comunicar aos utilizadores (aviso de downtime)
14:30 - Fazer backup em local seguro (Google Drive, Dropbox)
14:45 - Documentar estado atual (screenshots dos dados)
```

### **Dia 1: Sincronização (Noite/Madrugada - fora de horas de trabalho)**

```
22:00 - Notificar utilizadores que sisteama ficará offline
22:15 - Executar sync_production.sh
22:30 - Validar com validate_migration.sh
22:45 - Testes manuais (criar registo, preencheer novos campos)
23:00 - Comunicar volta ao normal
```

**Total: ~1 hora (incluindo testes)**

### **Dia 2: Validação em Produção (15 minutos)**

```
09:00 - Verificar logs do sistema
09:15 - Testar funcionalidades críticas
09:30 - Feedback dos utilizadores
```

---

## 🔐 Segurança - 4 Camadas de Proteção

### Camada 1: Backup Antecipado ✅
```bash
# 1-2 dias antes
./backup_db.sh
# Guarde em Google Drive, OneDrive, etc
```

### Camada 2: Backup Pré-Sincronização ✅
```bash
# Automático no sync_production.sh
# Ficheiro salvo em ./backups/
```

### Camada 3: Validação Pós-Sincronização ✅
```bash
# Automático no sync_production.sh
# Verifica todas as tabelas e colunas
```

### Camada 4: Testes Finais ✅
```bash
# Manual
1. Fazer login
2. Criar novo registo
3. Ver dados antigos (ainda existem?)
4. Editar registo existente
```

---

## 📋 Checklist Pré-Sincronização

**1-2 dias antes:**
- [ ] Comunicar aos utilizadores sobre downtime
- [ ] Fazer backup completo (./backup_db.sh)
- [ ] Guardar backup em cloud (Google Drive, etc)
- [ ] Testar sync_production.sh em ambiente de teste
- [ ] Ler SYNC_TO_PRODUCTION.md completamente
- [ ] Preparar plano de rollback (saber como restaurar)

**Dia da sincronização:**
- [ ] Avisar utilizadores (sísteema vai offline)
- [ ] Ninguém acedendo ao sistema
- [ ] Fazer backup final (segunda cópia)
- [ ] Verificar containers estão a correr
- [ ] Executar ./sync_production.sh
- [ ] Validar com ./validate_migration.sh
- [ ] Testar tudo manualmente
- [ ] Comunicar volta ao normal

---

## 🚀 Passo a Passo Recomendado

### Passo 1: Preparar em Desenvolvimento (Hoje)

```bash
# Verificar que as alterações existem em dev
npm run build
npm run dev

# Testar manualmente
# 1. Criar novo registo
# 2. Preencher todos os campos incluindo os novos
# 3. Ver que tudo funciona
```

### Passo 2: Fazer Commit e Push (Hoje)

```bash
git add .
git commit -m "v2.0: Add marital status, birth date, is_dead_at_event"
git push origin main
```

### Passo 3: Em Produção (Amanhã à noite)

```bash
# 2210 - Entrar em Portainer
cd /path/to/simplergn

# 2215 - Fazer backup extra
./backup_db.sh

# 2220 - Sincronizar (PASSO CRÍTICO)
./sync_production.sh

# 2230 - Validar
./validate_migration.sh

# 2240 - Testar manualmente
# Abrir http://localhost:3010
# Fazer teste completo

# 2300 - Comunicar volta ao normal
```

---

## 💾 Estratégia de Backups

### Antes da Sincronização
```
2025-02-19_backup_completa.sql ← Guarde isto! (Google Drive)
```

### Automático Durante Sync
```
./backups/backup_before_sync_20250219_220000.sql ← Criado automaticamente
```

### Retenção Recomendada
```
Manter últimos 7 backups
Manter 1 backup mensal em archive
Manter em 2 locais (servidor + cloud)
```

---

## 🎯 Validações Críticas

### Antes de Considerar Sucesso

```sql
-- 1. Tabela MaritalStatus existe
SELECT COUNT(*) FROM "MaritalStatus";  -- OK se ≥ 0

-- 2. Colunas em Individual
SELECT COUNT(*) FROM information_schema.columns 
WHERE table_name='Individual' 
AND column_name IN ('birthYear', 'birthMonth', 'birthDay');
-- OK se = 3

-- 3. Colunas em Participation
SELECT COUNT(*) FROM information_schema.columns 
WHERE table_name='Participation' 
AND column_name IN ('maritalStatusId', 'isDeadAtEvent');
-- OK se = 2

-- 4. Dados antigos preservados
SELECT COUNT(*) FROM "Event";  -- Deve ser > 0

-- 5. Foreign keys OK
SELECT constraint_name 
FROM information_schema.table_constraints
WHERE table_name='Participation' 
AND constraint_type='FOREIGN KEY';
-- Deve incluir maritalStatus
```

---

## ⚠️ Riscos Mitigados

| Risco | Mitigação |
|-------|-----------|
| Perder dados antigos | Backup + Migrations apenas adicionam |
| Schema desincronizado | Prisma gerencia versionamento |
| Downtime prolongado | ~1 hora máximo |
| Erro de execução | Rollback automático + backup manual |
| Conflitos de código | Git pull primeiro |
| DB corrompida | Backup permite restaurar |

---

## 📞 Plano de Comunicação

### Para Utilizadores

**24h antes:**
```
📢 AVISO: SimpleRGN sofrerá manutenção amanhã à noite
   Horário: 22:00 - 23:00
   Duração: ~1 hora
   Razão: Atualização de bade de dados + novas funcionalidades
   Ação: Nenhuma necessária por sua parte
```

**No início da manutenção:**
```
🔧 MANUTENÇÃO: Sistema em atualização
   Esperamos volta às 23:00
   Obrigado pela paciência
```

**Quando terminar:**
```
✅ Sistema ONLINE
   Agora com: Estado Civil, Data de Nascimento, Novo Layout
   Aproveite as melhorias!
```

---

## 🔃 Rollback (Se Necessário)

Se algo correr mal:

```bash
# Passo 1: Parar (2 minutos)
docker compose down

# Passo 2: Restaurar (5 minutos, dependendo do tamanho)
docker exec simplergn-db-1 psql -U postgres -d simplergn < ./backups/backup_before_sync_20250219_220000.sql

# Passo 3: Reverter código (1 minuto)
git reset --hard HEAD~1

# Passo 4: Reiniciar (2 minutos)
docker compose up -d

# Total: ~10 minutos back to normal
```

---

## 📈 Pós-Sincronização

### Semana 1: Monitoramento Intenso
- [ ] Verificar logs diariamente
- [ ] Feedback dos utilizadores
- [ ] Nenhum registo criado sem os novos campos

### Semana 2-4: Normal
- [ ] Continuar uso normal
- [ ] Recolher feedback
- [ ] Documentar issues se existirem

### Mês 1: Documentação
- [ ] Criar guia para utilizadores sobre novos campos
- [ ] Documentar processo de sincronização
- [ ] Atualizar manual da aplicação

---

## 🏆 Boas Práticas

### ✅ Fazer
- [x] Fazer backup antes de qualquer ação
- [x] Testare em dev primeiro
- [x] Executarfora de horas de pico
- [x] Ter plano de rollback pronto
- [x] Comunicar aos utilizadores
- [x] Documentar tudo
- [x] Validar após sync
- [x] Monitorar logs

### ❌ NÃO Fazer
- [ ] Sincronizar em horários de trabalho
- [ ] Sem backup
- [ ] Sem testes prévios
- [ ] Sem comunicação aos utilizadores
- [ ] Mudar 2 coisas ao mesmo tempo
- [ ] Confiar que "vai funcionar"

---

## 📞 Contactos de Suporte

| Situação | Ação |
|----------|------|
| Dúvida antes de sync | Ler SYNC_TO_PRODUCTION.md + TECHNICAL_MIGRATIONS.md |
| Erro durante sync | Ver logs: `docker compose logs web` |
| DB não responde | Verificar: `docker exec simplergn-db-1 pg_isready` |
| Restaurar backup | Executar comando no "Rollback" acima |
| Aplicação não abre | Verificar containers: `docker ps` |

---

## ✨ Conclusão

Esta é uma **sincronização de baixo risco** porque:

1. **Nenhum dado é deletado** - Apenas colunas NULL são adicionadas
2. **Reversível** - Tem backup para restaurar
3. **Rápida** - Executa em ~1 hora
4. **Automática** - Script faz tudo
5. **Verificada** - Validação pós-sincronização

**Pode fazer com confiança! 🎉**

---

**Documento criado:** 19 de Fevereiro de 2026  
**Versão:** 2.0  
**Próximas versões:** Podem ser sincronizadas do mesmo modo
