# SimpleRGN - Guia de Deployment com Portainer

## 📋 Configuração Inicial

### 1. Preparar pasta no servidor
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
sudo mkdir -p /data/{compose/simplergn,backups}
sudo chown $USER:$USER /data/compose /data/backups
cd /data/compose/simplergn
```

### 2. Clonar repositório
```bash
git clone https://github.com/filsalgado/simpleRGN.git .
```

### 3. Configurar no Portainer

**Stack: simplergn**

Variáveis de ambiente (adicionar em Environment):
```
POSTGRES_USER=user
POSTGRES_PASSWORD=senha-superforte-aqui-para-Postgr3s
POSTGRES_DB=simplergn
NEXTAUTH_SECRET=FLEWxuVvDOkV5lOmLzSZCtKfBS+IYOxGz9AL+hXj3/s=
NEXTAUTH_URL=http://vps-082dc5ca.vps.ovh.net:3010
```

### 4. Deploy inicial
No Portainer, fazer first deploy normal.

---

## 🔄 Operações Regulares

### ✅ Fazer Backup (Manual)
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
bash /data/compose/simplergn/scripts/backup.sh
```

### ✅ Fazer Backup (Automático - Cron)
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
crontab -e
# Adicionar:
0 2 * * * bash /data/compose/simplergn/scripts/backup.sh >> /var/log/simplergn-backup.log 2>&1
```

### ✅ Listar Backups
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
ls -lh /data/backups/
```

### ✅ Update Seguro (NÃO usar Pull & Redeploy do Portainer!)
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
bash /data/compose/simplergn/scripts/update.sh /data/compose/simplergn
```

Isto:
- ✓ Faz backup automático
- ✓ Pull do GitHub
- ✓ Atualiza imagens
- ✓ Reinicia containers
- ✓ **Preserva volumes** (dados não são apagados!)

### ⚠️ Restaurar de Backup (em caso de desastre)
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
bash /data/compose/simplergn/scripts/restore.sh /data/backups/backup_simplergn_20260203_020000.sql.gz
```

---

## 📊 Monitoramento

### Ver status dos containers
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
docker ps | grep simplergn
```

### Ver logs
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
docker logs simplergn-web-1 --tail=50 -f
```

### Verificar dados na BD
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
docker exec simplergn-db-1 psql -U user -d simplergn -c "SELECT COUNT(*) FROM \"User\";"
```

### Tamanho da BD
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
docker exec simplergn-db-1 psql -U user -d simplergn -c "SELECT pg_size_pretty(pg_database_size('simplergn'));"
```

---

## 🎯 Fluxo Recomendado

Para adicionar código novo:
1. Fazer commit e push no GitHub
2. No servidor: `bash /data/compose/simplergn/scripts/update.sh /data/compose/simplergn`
3. Verificar se tudo funciona
4. Pronto! ✅

---

## ⚙️ Configurações Importantes

### docker-compose.yml
- **postgres_data**: Volume gerido por Docker (preservado em redeploys)
- **/data/pgadmin**: Bind mount para dados do pgAdmin (não crítico)
- Variáveis de ambiente: Configuradas no Portainer Stack Environment

### Volumes
```bash
docker volume ls | grep simplergn
# Resultado esperado:
# simplergn_postgres_data (volume para dados)
```

### Backup Strategy
- **Automático**: Cron a 02:00 UTC diariamente
- **Retenção**: 7 dias de backups anteriores
- **Local**: `/data/backups/*.sql.gz`
- **Tamanho**: ~600KB por backup (comprimido)

---

## 🛠️ Troubleshooting

### "Credenciais inválidas" no login
1. Verificar BD tem dados: `docker exec simplergn-db-1 psql -U user -d simplergn -c "SELECT COUNT(*) FROM \"User\";"`
2. Se vazio, fazer restore de backup: `bash restore.sh /data/backups/latest_backup.sql.gz`

### "Database does not exist"
1. Verificar container: `docker ps | grep simplergn-db`
2. Ver logs: `docker logs simplergn-db-1`
3. Se tabelas ausentes, fazer: `docker exec simplergn-web-1 npx prisma migrate deploy`

### Volumes foram apagados após Pull & Redeploy
1. **NUNCA** usar "Pull & Redeploy" no Portainer!
2. **SEMPRE** usar o script: `bash /data/compose/simplergn/scripts/update.sh`
3. Se perdeu dados, restaurar de backup: `bash restore.sh /data/backups/backup_data_antes_do_problema.sql.gz`

---

## 📝 Variáveis de Ambiente (Referência)

| Variável | Local Dev | Servidor | Notas |
|----------|-----------|----------|-------|
| `POSTGRES_USER` | user | user | Utilizador da BD |
| `POSTGRES_PASSWORD` | password | senha-superforte-aqui-para-Postgr3s | Senha forte |
| `POSTGRES_DB` | simplergn | simplergn | Nome da BD |
| `NEXTAUTH_SECRET` | FLEWxuVvDOkV5lOmLzSZCtKfBS+IYOxGz9AL+hXj3/s= | Igual | Token JWT |
| `NEXTAUTH_URL` | http://localhost:3010 | http://vps-082dc5ca.vps.ovh.net:3010 | URL da app |

---

## 📞 Contactos / Suporte

- **Aplicação**: http://vps-082dc5ca.vps.ovh.net:3010
- **pgAdmin**: http://vps-082dc5ca.vps.ovh.net:8060 (admin@admin.com / root)
- **GitHub**: https://github.com/filsalgado/simpleRGN

