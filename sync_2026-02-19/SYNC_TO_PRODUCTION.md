# Sincronização para Produção - Guia Seguro

## 📋 Resumo das Alterações

### Código da Aplicação (Next.js)
- Layout e UI melhorado
- Dois botões para gravação (Gravar / Gravar & Novo)
- Toast notifications ao invés de alerts
- Navbar com botões de acesso rápido

### Base de Dados (3 migrations novas)

#### 1. `20260218213437_add_marital_status`
- Cria tabela `MaritalStatus` (Estado Civil)
- Adiciona coluna `maritalStatusId` na tabela `Participation`
- Estado civil é opcional - dados existentes não são afetados

#### 2. `20260218232814_update_birth_date_fields`
- Adiciona 3 colunas na tabela `Individual`:
  - `birthYear` (Integer, NULL)
  - `birthMonth` (Integer, NULL)
  - `birthDay` (Integer, NULL)
- Campos são opcionais - dados existentes mantêm-se intactos

#### 3. `20260218233546_add_is_dead_at_event`
- Adiciona coluna `isDeadAtEvent` na tabela `Participation`
- Padrão: FALSE (comportamento atual mantém-se)
- Dados existentes não são afetados

---

## 🔧 Passo a Passo de Sincronização

### Fase 1: Atualizar o Código (Fácil)

#### 1.1 No Portainer, aceda ao stack do SimpleRGN
```bash
# No terminal do Portainer
cd /path/to/simplergn  # Ajuste para o caminho correto
```

#### 1.2 Puxar as últimas alterações do GitHub
```bash
git pull origin main
```

#### 1.3 Verificar as mudanças
```bash
git log --oneline -5  # Ver últimos commits
git status            # Verificar se tudo está limpo
```

---

### Fase 2: Fazer Backup da Base de Dados (OBRIGATÓRIO)

**Sempre faça backup antes de alterar o schema!**

```bash
# Fazer backup via docker
docker exec simplergn-db-1 pg_dump -U postgres -d simplergn > backup_before_migration_$(date +%Y%m%d_%H%M%S).sql

# Ou manualmente no Portainer:
# 1. Abrir PostgreSQL
# 2. Tools > pg_dump
# 3. Gravar ficheiro de backup
```

**Guarde este ficheiro num local seguro!**

---

### Fase 3: Aplicar as Migrations (Schema)

**Opção A: Automática (Recomendado)**

```bash
# No container do web, as migrations executam automáticamente no build
docker compose down
docker compose up -d

# O Docker vai:
# 1. Pull da imagem
# 2. npm install
# 3. npx prisma generate
# 4. npx prisma migrate deploy ← Aplica migrations automaticamente
# 5. npm run build
```

**Opção B: Manual (Se precisar controlo total)**

```bash
# Entrar no container
docker exec -it simplergn-web-1 bash

# Ver migrations pendentes
npx prisma migrate status

# Aplicar migrations
npx prisma migrate deploy

# Sair
exit
```

---

### Fase 4: Verificar se Tudo Está OK

```bash
# 1. Verificar logs do container
docker compose logs -f web

# 2. Testar a aplicação
# - Abrir em browser: http://localhost:3010
# - Fazer login
# - Criar novo registo
# - Verificar se todos os campos novos aparecem

# 3. Verificar schema na DB
docker exec simplergn-db-1 psql -U postgres -d simplergn -c "\d Participation"
docker exec simplergn-db-1 psql -U postgres -d simplergn -c "\d Individual"

# 4. Verificar dados existentes
docker exec simplergn-db-1 psql -U postgres -d simplergn -c "SELECT COUNT(*) FROM Event;"
docker exec simplergn-db-1 psql -U postgres -d simplergn -c "SELECT COUNT(*) FROM Participation;"
```

---

## 🔙 Se Algo Correr Mal (Rollback)

### Se a migração falhar:

```bash
# 1. Parar os containers
docker compose down

# 2. Restaurar backup
docker exec simplergn-db-1 psql -U postgres -d simplergn < backup_before_migration_YYYYMMDD_HHMMSS.sql

# 3. Reverter código
git revert <commit-hash>  # ou git reset --hard HEAD~1

# 4. Recomeçar
docker compose up -d
```

### Se precisar reverter uma migration específica:

```bash
# Entrar no container
docker exec -it simplergn-web-1 bash

# Ver histórico
npx prisma migrate status

# Reverter até à migration anterior (cuidado - perde dados!)
# NOTA: Prisma não tem "rollback" automático
# Precisará restaurar do backup ou fazer manualmente

# Alternativa: Restaurar de backup
docker compose down
docker exec simplergn-db-1 psql -U postgres -d simplergn < backup_file.sql
git reset --hard <commit-anterior>
docker compose up -d
```

---

## ✅ Checklist de Sincronização

- [ ] Fiz backup da DB de produção
- [ ] Guardei o backup num local seguro
- [ ] Puxei o código mais recente do GitHub
- [ ] Verifiquei que não há conflitos (`git status` limpo)
- [ ] Executei `docker compose down && docker compose up -d`
- [ ] As migrations executaram com sucesso
- [ ] Testei a aplicação (login, novo registo, etc)
- [ ] Verifiquei os campos novos nos formulários
- [ ] Os dados antigos continuam intactos
- [ ] Documentei a data/hora da sincronização

---

## 📊 Dados após Migração

### Comportamento dos Novos Campos

1. **Estado Civil** (`maritalStatusId` em Participation)
   - Opcional
   - Registos antigos: NULL (pode ser preenchido quando editar)
   - Novos registos: pode ser selecionado (padrão NULL)

2. **Data de Nascimento** (`birthYear`, `birthMonth`, `birthDay`)
   - Opcional (separado para facilitar gerenciamento de datas parciais)
   - Dados antigos: NULL (pode ser adicionado depois)
   - Novos registos: pode ser preenchido

3. **Falecido à Data do Evento** (`isDeadAtEvent`)
   - Padrão: FALSE
   - Registos antigos: FALSE (comportamento histórico mantém-se)
   - Pode ser editado quando necessário

---

## 📞 Suporte

Se encontrar problemas:

1. **Verificar logs:**
   ```bash
   docker compose logs web
   docker compose logs db
   ```

2. **Testar conexão DB:**
   ```bash
   docker exec simplergn-db-1 pg_isready -U postgres
   ```

3. **Restaurar do backup:** Seguir passo "Se Algo Correr Mal"

---

## 🔐 Notas Importantes

- ✅ **Seguro**: Todas as migrations adicionam colunas opcionais - nenhum dato é perdido
- ✅ **Reversível**: Tem backup da DB antes de qualquer alteração
- ✅ **Testado**: As migrations foram testadas em desenvolvimento
- ⚠️ **Produção**: Sempre faça backup antes de alterar a DB
