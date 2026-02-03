# SimpleRGN - Status de Deployment (Feb 3, 2026)

## ✅ PRODUCTION LIVE

A aplicação SimpleRGN está **🟢 OPERACIONAL** em produção.

**URL:** http://vps-082dc5ca.vps.ovh.net:3010
**Environment:** OVH VPS - Debian Linux

---

## 📊 Dashboard Status

```
✅ Web App (Next.js)     → UP (dev mode, port 3010)
✅ PostgreSQL            → UP (port 5432)  
✅ pgAdmin               → UP (port 8060)
✅ Data Persistence      → GUARANTEED (named volumes)
✅ Automatic Backups     → ENABLED (02:00 UTC daily)
✅ User Database         → 2 active users
✅ Parish Database       → 4596 records
```

---

## 🔑 Credenciais de Acesso

| Recurso | Tipo | URL |
|---------|------|-----|
| **SimpleRGN App** | Next.js | http://vps-082dc5ca.vps.ovh.net:3010 |
| **Login Default** | Email | admin@simplergn.com |
| **Password** | Login | admin |
| **pgAdmin** | Web UI | http://vps-082dc5ca.vps.ovh.net:8060 |
| **Database** | PostgreSQL | localhost:5432 |

---

## 🔧 Infraestrutura

### Volumes (Docker)
- `simplergn_postgres_data` → BD PostgreSQL
- `simplergn_pgadmin_data` → Config pgAdmin

### Backups
- **Location:** `/data/backups/`
- **Schedule:** 02:00 UTC (diário)
- **Retenção:** 7 dias
- **Último:** backup_simplergn_20260203_165609.sql.gz (163K)

### Scripts Disponíveis (`/data/compose/simplergn/scripts/`)
```bash
backup.sh      # Manual backup
restore.sh     # Restore from backup
update.sh      # Safe update (preserva volumes)
```

---

## 📋 Operações Comuns

### Fazer Backup Manual
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
bash /data/compose/simplergn/scripts/backup.sh
```

### Restaurar do Backup
```bash
bash /data/compose/simplergn/scripts/restore.sh /data/backups/backup_*.sql.gz
```

### Fazer Update Seguro (NÃO usar Portainer!)
```bash
bash /data/compose/simplergn/scripts/update.sh /data/compose/simplergn
```

### Ver Logs
```bash
ssh debian@vps-082dc5ca.vps.ovh.net
cd /data/compose/simplergn
docker compose logs -f web
docker compose logs -f db
```

### Contar Registos na BD
```bash
docker exec simplergn-db-1 psql -U user -d simplergn -tc "SELECT COUNT(*) FROM \"Parish\";"
```

---

## ⚠️ Notas Importantes

1. **NÃO usar** Portainer "Pull & Redeploy" → PERDE dados
   - **USE:** `/data/compose/simplergn/scripts/update.sh`

2. **Dev Mode vs Production**
   - Atualmente em **desenvolvimento** (hot-reload enabled)
   - Para produção: mudar `npm run dev` → `npm run start` no Dockerfile
   - Resolvido problema de build cache com Next.js 16.1.1

3. **Cron Automático**
   - Backups: `0 2 * * * bash /data/compose/simplergn/scripts/backup.sh`
   - Configure via: `sudo crontab -e`

4. **Variáveis de Environment**
   - Localizado em: `/data/compose/simplergn/.env`
   - NEXTAUTH_SECRET sincronizado
   - DATABASE_URL com credenciais correctas

---

## 🚀 Próximos Passos (Opcionais)

- [ ] SSL/HTTPS com Let's Encrypt
- [ ] Nginx reverse proxy
- [ ] Monitoring (Prometheus/Grafana)
- [ ] Performance optimization
- [ ] Production build de Next.js (resolver BUILD_ID cache)

---

## 📞 Suporte

**Deployment Date:** February 3, 2026  
**Last Updated:** 18:10 UTC  
**Status:** 🟢 OPERATIONAL

Para issues, contacte o desenvolvedor.
