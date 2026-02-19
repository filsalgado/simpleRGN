# 🚀 Sincronização SimpleRGN - 19 de Fevereiro de 2026

Pasta com toda a documentação e scripts necessários para sincronizar a aplicação SimpleRGN com produção.

---

## 📂 Estrutura da Pasta

```
sync_2026-02-19/
├── 📖 Documentação
│   ├── README.md                        ← Está aqui
│   ├── QUICK_START_SYNC.md              ← ⭐ Comece aqui (5 min)
│   ├── SYNC_TO_PRODUCTION.md            ← Documentação completa (20 min)
│   ├── TECHNICAL_MIGRATIONS.md          ← Detalhes técnicos (15 min)
│   ├── SYNCHRONIZATION_TIMELINE.md      ← Planeamento (15 min)
│   ├── README_SYNCHRONIZATION.md        ← Índice geral
│   └── SYNC_FILES_INDEX.txt             ← Índice completo em texto
│
├── 🛠️ Scripts Executáveis
│   ├── sync_production.sh              ← PRINCIPAL (automático)
│   ├── backup_db.sh                    ← Backup manual
│   └── validate_migration.sh           ← Validação
│
└── 📋 Esta Pasta
    └── Criada: 19 de Fevereiro de 2026
```

---

## 🚀 Quick Start - Escolha uma Opção

### Opção A: Script SQL via pgAdmin (RECOMENDADO - Mais Simples) ⭐

**Ler:** [`ABORDAGEM_SQL.md`](ABORDAGEM_SQL.md)

```
1. Fazer backup da BD
2. Copiar migrations_production.sql
3. Abrir pgAdmin
4. Colar no Query Tool e executar
5. Pronto! (~30 segundos)
```

### Opção B: Docker Automático (Completo)

**Ler:** [`QUICK_START_SYNC.md`](QUICK_START_SYNC.md)

```
1. Ler guia rápido
2. ./backup_db.sh
3. ./sync_production.sh
4. ./validate_migration.sh
5. Pronto! (~25 minutos)
```

---

## 📊 Comparação Rápida

| Aspecto | SQL (Opção A) | Docker (Opção B) |
|---------|---------------|------------------|
| **Tempo** | 30 seg | 25 min |
| **Simplicidade** | ⭐⭐⭐ | ⭐⭐ |
| **Requer** | pgAdmin | Terminal Docker |
| **Risco** | Backup manual | Automático |
| **Validação** | Manual | Automática |

**Recomendação:** Comece pela Opção A (SQL) se tem pgAdmin

---

## 📚 Qual Documento Ler?

| Situação | Documento |
|----------|-----------|
| "Quero fazer isto já!" | QUICK_START_SYNC.md |
| "Preciso entender tudo" | SYNC_TO_PRODUCTION.md |
| "Sou técnico/tenho SQL" | TECHNICAL_MIGRATIONS.md |
| "Preciso planear a data" | SYNCHRONIZATION_TIMELINE.md |
| "Quero um índice completo" | README_SYNCHRONIZATION.md |
| "Quero texto simples" | SYNC_FILES_INDEX.txt |

---

## ⚠️ Checkpoints Importantes

### Antes de Sincronizar
- [ ] Fiz backup: `./backup_db.sh`
- [ ] Guardei backup em local seguro (Google Drive)
- [ ] Avisei utilizadores
- [ ] Leia pelo menos QUICK_START_SYNC.md

### Depois de Sincronizar
- [ ] Executei: `./validate_migration.sh`
- [ ] Testei manualmente (login, novo registo)
- [ ] Verificou novos campos (Estado Civil, Data Nasc.)
- [ ] Comunicou volta ao normal

---

## 📞 Se Algo Correr Mal

Restaurar do backup em ~10 minutos:

```bash
# Encontre o backup criado por backup_db.sh
ls -lah ../backups/

# Restaurar (exemplo):
docker compose down
docker exec simplergn-db-1 psql -U postgres -d simplergn < ../backups/backup_simplergn_20260219_HHMMSS.sql
docker compose up -d
```

---

## 📊 O Que Muda

**Base de Dados:**
- ✅ Nova tabela: MaritalStatus
- ✅ Novos campos: birthYear, birthMonth, birthDay
- ✅ Novos campos: maritalStatusId, isDeadAtEvent
- ✅ Todos os dados antigos preservados

**Aplicação:**
- ✅ Botões "Novo Registo" e "Listar Registos"
- ✅ Dois botões de gravação
- ✅ Toast notifications
- ✅ Novos campos nos formulários

---

## 🎯 Recomendação

**Comece por:** [`QUICK_START_SYNC.md`](QUICK_START_SYNC.md)

Depois execute: `./sync_production.sh`

Pronto! 🎉

---

**Criado:** 19 de Fevereiro de 2026  
**Versão:** v2.0  
**Status:** Pronto para produção ✅
