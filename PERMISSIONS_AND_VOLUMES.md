# SimpleRGN - Configuração de Permissões e Volumes

## 📁 Estrutura de Diretórios no Servidor

```
/data/
├── compose/
│   └── simplergn/          # Repositório Git (rw: debian)
│       ├── docker-compose.yml
│       ├── scripts/
│       │   ├── backup.sh
│       │   ├── restore.sh
│       │   └── update.sh
│       └── web/
├── backups/                # Backups SQL (rw: debian)
│   └── backup_simplergn_20260203_165609.sql.gz
├── postgresql/             # VOLUME: Dados PostgreSQL (rw: UID 999)
│   ├── 18/docker/
│   └── data/
└── pgadmin/                # VOLUME: Dados pgAdmin (rw: UID 999)
```

---

## 🔐 Permissões Recomendadas

### Para `/data/postgresql` (Bind Mount / Volume):

```bash
# Owner: UID 999 (postgres user no container)
# Group: GID 999
# Permissions: 0755 (rwxr-xr-x)

# Comandos para configurar:
sudo chown -R 999:999 /data/postgresql
sudo chmod -R 0755 /data/postgresql
```

**Explicação:**
- **0755** = `rwxr-xr-x`
- Owner (postgres/UID 999): pode ler, escrever, executar
- Group: pode ler, executar
- Others: pode ler, executar
- Suficiente para Docker escrever dados

### Para `/data/pgadmin`:

```bash
sudo chown -R 999:999 /data/pgadmin
sudo chmod -R 0755 /data/pgadmin
```

### Para `/data/backups` (Backups SQL):

```bash
sudo chown debian:debian /data/backups
sudo chmod 0755 /data/backups
```

---

## ✅ Verificar Permissões

```bash
# Ver permissões atuais
sudo ls -lah /data/postgresql /data/pgadmin

# Resultado esperado:
# drwxr-xr-x  999  systemd-journal  /data/postgresql
# drwxr-xr-x  999  systemd-journal  /data/pgadmin
```

---

## 🔄 Volumes vs Bind Mounts

### Volumes Nomeados (RECOMENDADO)
```yaml
volumes:
  postgres_data:  # Docker gere automaticamente
```

**Vantagens:**
- ✅ Docker gere permissões automaticamente
- ✅ Portainer consegue fazer "Pull & Redeploy" sem problemas
- ✅ Dados persistem entre redeploys
- ✅ Melhor compatibilidade cross-platform

**Localização:** `/var/lib/docker/volumes/postgres_data/_data`

### Bind Mounts
```yaml
volumes:
  - /data/postgresql:/var/lib/postgresql/data
```

**Vantagens:**
- ✅ Dados visíveis no filesystem do host
- ✅ Fácil fazer backups manuais
- ✅ Controlo total de permissões

**Requisitos:**
- ⚠️ Permissões corretas (0755, UID 999)
- ⚠️ Docker conseguir escrever
- ⚠️ Evitar "Pull & Redeploy" do Portainer (usa scripts)

---

## 🚨 Problemas Comuns e Soluções

### Problema: "Permission denied" ao modificar BD

```bash
# Solução: Corrigir permissões
sudo chown -R 999:999 /data/postgresql
sudo chmod -R 0755 /data/postgresql
docker restart simplergn-db-1
```

### Problema: Dados desaparecem após "Pull & Redeploy"

```bash
# Solução: NÃO usar "Pull & Redeploy" do Portainer
# Usar scripts:
bash /data/compose/simplergn/scripts/update.sh /data/compose/simplergn
```

### Problema: Volumes localizados em `_data`

```bash
# Verificar onde Docker armazena volumes:
docker inspect postgres_data

# Resultado mostra "Mountpoint": "/var/lib/docker/volumes/postgres_data/_data"
# Isto é normal com volumes nomeados
```

---

## 📋 Checklist de Configuração

- [ ] `/data/postgresql` tem owner UID 999, permissions 0755
- [ ] `/data/pgadmin` tem owner UID 999, permissions 0755
- [ ] `/data/compose/simplergn` tem owner debian, permissions 0755
- [ ] `/data/backups` tem owner debian, permissions 0755
- [ ] `docker-compose.yml` usa `postgres_data:` (volume nomeado)
- [ ] Scripts (`backup.sh`, `restore.sh`, `update.sh`) têm permissão exec (755)
- [ ] Cron configurado: `0 2 * * * bash /data/compose/simplergn/scripts/backup.sh`

---

## 🔍 Validação Final

Após configuração, testar:

```bash
# 1. Verificar volumes
docker volume ls | grep simplergn

# 2. Verificar dados
docker exec simplergn-db-1 psql -U user -d simplergn -c "SELECT COUNT(*) FROM \"User\";"

# 3. Fazer backup
bash /data/compose/simplergn/scripts/backup.sh

# 4. Verificar histórico backups
ls -lh /data/backups/

# 5. Testar update (não perder dados)
bash /data/compose/simplergn/scripts/update.sh /data/compose/simplergn

# 6. Confirmar dados ainda lá estão
docker exec simplergn-db-1 psql -U user -d simplergn -c "SELECT COUNT(*) FROM \"User\";"
```

Resultado esperado: **2 users em todas as verificações** ✅

