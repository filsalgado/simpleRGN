# SimpleRGN - Configuração de Volumes

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
└── backups/                # Backups SQL (rw: debian)
    └── backup_simplergn_20260203_165609.sql.gz

# Dados do Docker (gerenciados automaticamente)
/var/lib/docker/volumes/
├── simplergn_postgres_data/
│   └── _data/             # PostgreSQL data
└── simplergn_pgadmin_data/
    └── _data/             # pgAdmin data
```

---

## 📦 Volumes Nomeados (Implementação Atual)

SimpleRGN usa **named volumes** para ambos PostgreSQL e pgAdmin:

```yaml
services:
  db:
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  pgadmin:
    volumes:
      - pgadmin_data:/var/lib/pgadmin

volumes:
  postgres_data:
  pgadmin_data:
```

**Vantagens:**
- ✅ Docker gere permissões automaticamente
- ✅ Portainer consegue fazer "Pull & Redeploy" sem perder dados
- ✅ Dados persistem entre redeploys
- ✅ Compatível cross-platform
- ✅ Maior segurança (não expostos no filesystem do host)

---

## � Verificar Dados

```bash
# 1. Listar volumes Docker
docker volume ls | grep simplergn

# 2. Inspecionar volume PostgreSQL
docker volume inspect simplergn_postgres_data
# Resultado: "Mountpoint": "/var/lib/docker/volumes/simplergn_postgres_data/_data"

# 3. Verificar dados dentro de um volume
docker exec simplergn-db-1 ls -la /var/lib/postgresql/data/

# 4. Contar registros
docker exec simplergn-db-1 psql -U user -d simplergn -c "SELECT COUNT(*) FROM \"User\";"
```

---

## 📋 Procedimentos de Operação

