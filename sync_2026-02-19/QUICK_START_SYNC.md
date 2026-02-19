# 🚀 Sincronização SimpleRGN v2.0 - Guia Rápido

## 🎯 Escolha uma Opção

### ⭐ OPÇÃO A: SQL Direto via pgAdmin (MAIS SIMPLES)

**Tempo:** ~30 segundos  
**Requer:** Acesso a pgAdmin  
**Risco:** Mínimo (com backup)  

**Como fazer:**
```
1. Fazer backup da BD (via terminal ou pgAdmin)
2. Abrir pgAdmin na porta 5050
3. Conectar à BD "simplergn"
4. Tools → Query Tool
5. Copiar todo o conteúdo de: migrations_production.sql
6. Colar no Query Tool
7. Executar (F5)
8. Ver "✅ TODAS AS ALTERAÇÕES FORAM APLICADAS COM SUCESSO!"
9. Pronto! 🎉
```

**Documentação:** `ABORDAGEM_SQL.md`

---

### OPÇÃO B: Docker Automático (COMPLETO)

**Tempo:** ~25 minutos  
**Requer:** Terminal + Docker  
**Risco:** Mínimo (backup automático)  

**Como fazer:**
```bash
# 1. Ler documentação
cat SYNC_TO_PRODUCTION.md

# 2. Fazer backup
./backup_db.sh

# 3. Sincronizar
./sync_production.sh

# 4. Validar
./validate_migration.sh

# Pronto! ✅
```

---

## 📊 Comparação

| Aspecto | SQL (A) | Docker (B) |
|---------|---------|-----------|
| **Tempo** | 30 seg | 25 min |
| **Simplicidade** | ⭐⭐⭐ Muito simples | ⭐⭐ Média |
| **Requer** | pgAdmin | Terminal Docker |
| **Backup** | Manual | Automático |
| **Validação** | Manual | Automática |
| **Versionamento** | Nenhum | Git automático |

---

## 🎓 Qual Escolher?

**Use Opção A (SQL) se:**
- ✅ Quer algo rápido (30 segundos)
- ✅ Tem acesso a pgAdmin
- ✅ Prefere simplicidade
- ✅ Não quer lidar com Docker

**Use Opção B (Docker) se:**
- ✅ Quer abordagem completamente automática
- ✅ Tem experiência com Docker
- ✅ Quer versionamento automático
- ✅ Prefere maior controlo

---

## 📋 Ficheiros disponíveis

### Opção A (SQL)
- `migrations_production.sql` - Script SQL pronto a usar
- `ABORDAGEM_SQL.md` - Documentação completa

### Opção B (Docker)
- `sync_production.sh` - Script automático
- `backup_db.sh` - Backup manual
- `validate_migration.sh` - Validação
- `SYNC_TO_PRODUCTION.md` - Documentação
- `TECHNICAL_MIGRATIONS.md` - Detalhes técnicos

---

## ⚠️ Antes de Começar

- [ ] Fiz backup da BD
- [ ] Guardei backup num local seguro
- [ ] Avisei utilizadores (se necessário)
- [ ] Li a documentação correspondente

---

## 🆘 Se Algo Correr Mal

**Opção A (SQL):**
1. Restaurar de backup
2. Contactar suporte

**Opção B (Docker):**
1. Script tem rollback automático
2. Restaurar de backup se necessário

---

## 📞 Documentação Completa

| Documento | Para Quem | Tempo |
|-----------|-----------|-------|
| `ABORDAGEM_SQL.md` | Opção A (SQL) | 10 min |
| `SYNC_TO_PRODUCTION.md` | Opção B (Docker) | 20 min |
| `TECHNICAL_MIGRATIONS.md` | Técnicos | 15 min |
| `SYNCHRONIZATION_TIMELINE.md` | Planeamento | 15 min |

---

## ✅ Próximos Passos

**Se escolheu Opção A:**
```bash
cat ABORDAGEM_SQL.md
# Depois seguir as instruções
```

**Se escolheu Opção B:**
```bash
cat SYNC_TO_PRODUCTION.md
# Depois executar: ./sync_production.sh
```

---

## 🎉 Conclusão

Ambas as opções são seguras e testadas. **Recomendação: Comece pela Opção A (SQL) se tem pgAdmin - é o mais rápido!**

**Data:** 19 de Fevereiro de 2026  
**Versão:** v2.0  
**Status:** Pronto para produção ✅
