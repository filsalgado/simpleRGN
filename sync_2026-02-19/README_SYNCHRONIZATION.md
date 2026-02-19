# 📚 Documentação Completa de Sincronização - Índice

## 🎯 Resumo Executivo

Foram criados **5 documentos + 3 scripts** para facilitar a sincronização segura da aplicação SimpleRGN com produção, preservando todos os dados existentes.

---

## 📄 Documentos Criados

### 1. **QUICK_START_SYNC.md** ⭐ **COMECE AQUI!**
- **Tempo de leitura:** 5 minutos
- **Para:** Quem quer fazer tudo rápido
- **Contém:**
  - Links rápidos para scripts
  - Passo a passo em 3 linhas
  - Troubleshooting comum
  - ✅ **Use isto se não tiver tempo**

### 2. **SYNC_TO_PRODUCTION.md** 📖 **DOCUMENTAÇÃO PRINCIPAL**
- **Tempo de leitura:** 15-20 minutos
- **Para:** Compreender o processo completo
- **Contém:**
  - Explicação detalhada de cada alteração
  - Passo a passo em 4 fases
  - Validações após cada passo
  - Rollback procedures
  - ✅ **Leia isto antes de sincronizar**

### 3. **TECHNICAL_MIGRATIONS.md** 🔧 **PARA TÉCNICOS**
- **Tempo de leitura:** 20 minutos
- **Para:** Quem quer entender o SQL exato
- **Contém:**
  - SQL completo de cada migration
  - Detalhes de schema antes/depois
  - Verificações SQL de validação
  - Plano de rollback técnico
  - ✅ **Para quem entende de bases de dados**

### 4. **SYNCHRONIZATION_TIMELINE.md** 📅 **TIMELINE COMPLETA**
- **Tempo de leitura:** 15 minutos
- **Para:** Planear quando e como sincronizar
- **Contém:**
  - Timeline recomendada
  - Checklist pré e pós-sincronização
  - Estratégia de backups
  - Plano de comunicação aos utilizadores
  - Monitoramento pós-sincronização
  - ✅ **Para gestão do projeto**

### 5. **MIGRATION_RECOVERY.md** 🆘 **CONTINGÊNCIA**
- **Tempo de leitura:** 10 minutos
- **Para:** Apenas se algo correr mal
- **Contém:**
  - Diagnósti
cos de erro
  - Procedimentos de rollback passo a passo
  - Contactos e suporte
  - ✅ **Esperemos não precisar, mas está aqui**

---

## 🛠️ Scripts Criados

### 1. **sync_production.sh** 🚀 **PRINCIPAL**
```bash
./sync_production.sh
```
**O que faz:**
- ✅ Faz backup automático
- ✅ Atualiza código do GitHub
- ✅ Reinicia containers
- ✅ Aplica migrations
- ✅ Valida tudo automaticamente
- ✅ Mostra resultado final

**Tempo:** ~5-10 minutos  
**Recomendado:** SIM - Faz tudo automaticamente

---

### 2. **backup_db.sh** 💾 **BACKUP MANUAL**
```bash
./backup_db.sh
```
**O que faz:**
- ✅ Faz backup da base de dados
- ✅ Gera ficheiro SQL completo
- ✅ Guarda em ./backups/

**Tempo:** ~1-5 minutos (depende do tamanho)  
**Opcional:** Mas RECOMENDADO fazer antes de sync_production.sh

---

### 3. **validate_migration.sh** ✓ **VALIDAÇÃO**
```bash
./validate_migration.sh
```
**O que faz:**
- ✅ Verifica se tabelas existem
- ✅ Verifica se colunas foram criadas
- ✅ Conta registos no sistema
- ✅ Mostra dados de amostra

**Tempo:** ~1 minuto  
**Uso:** Após sync_production.sh para confirmar sucesso

---

## 🎯 Como Usar

### Opção 1: Automática (Recomendado)
**Quem:** Qualquer pessoa com acesso ao terminal  
**Tempo:** 15 minutos total

```bash
1. cd /home/filipe/projs/simpleRGN
2. ./backup_db.sh           # Backup segurança
3. ./sync_production.sh      # Sync automática
4. ./validate_migration.sh   # Validar resultado
```

### Opção 2: Manual (Para Técnicos)
**Quem:** Pessoas confortáveis com Docker + SQL  
**Tempo:** 30 minutos

```bash
1. Ler SYNC_TO_PRODUCTION.md
2. Ler TECHNICAL_MIGRATIONS.md
3. Fazer backup manual: ./backup_db.sh
4. Seguir instruções manuais passo a passo
5. Executar verificações SQL
```

### Opção 3: Gestão de Projeto
**Quem:** Project managers / coordinators  
**Tempo:** Planeamento + execução

```bash
1. Ler SYNCHRONIZATION_TIMELINE.md
2. Planear data/hora de sync
3. Comunicar aos utilizadores
4. Executar Opção 1 na hora marcada
5. Monitorar pós-sincronização
```

---

## 📊 Diagrama do Processo

```
┌─────────────────────────────────────────────┐
│   SINCRONIZAÇÃO SimpleRGN (v1.0 → v2.0)    │
└─────────────────────────────────────────────┘

FASE 1: PREPARAÇÃO
┌────────────────────────────────────────────┐
│ ✓ Ler documentação (15 min)                 │
│ ✓ Fazer backup (backup_db.sh) (5 min)      │
│ ✓ Guardar backup em cloud (2 min)          │
│ ✓ Avisar utilizadores (2 min)              │
└────────────────────────────────────────────┘
         ↓
FASE 2: SINCRONIZAÇÃO
┌────────────────────────────────────────────┐
│ ✓ Executar sync_production.sh (10 min)     │
│   - Pulls do GitHub                        │
│   - Faz backup pré-sync                    │
│   - Reinicia containers                    │
│   - Aplica migrations                      │
│   - Valida resultado                       │
└────────────────────────────────────────────┘
         ↓
FASE 3: VALIDAÇÃO
┌────────────────────────────────────────────┐
│ ✓ Executar validate_migration.sh (2 min)   │
│ ✓ Testar manualmente (5 min)               │
│   - Fazer login                            │
│   - Criar registo novo                     │
│   - Ver campos novos                       │
│   - Editar registo antigo                  │
└────────────────────────────────────────────┘
         ↓
FASE 4: COMUNICAÇÃO
┌────────────────────────────────────────────┐
│ ✓ Comunicar volta ao normal                │
│ ✓ Recolher feedback                        │
│ ✓ Monitorar logs diários                   │
└────────────────────────────────────────────┘

TOTAL: ~30 minutos (incluindo testes)
```

---

## 🔍 O Que Muda a Nível Técnico

### 1. **Base de Dados**

#### Tabela Nova: MaritalStatus
```
ID | Name | IsOriginal
---|------|----------
1  | Solteiro | true
2  | Casado   | true
... (pode adicionar mais)
```

#### Individual (Novos Campos Opcionais)
```
... | birthYear | birthMonth | birthDay | ...
... |  NULL     |   NULL     |  NULL    | ...  ← Registos antigos
... |  1990     |      3     |    15    | ...  ← Novos registos
```

#### Participation (Novos Campos)
```
... | maritalStatusId | isDeadAtEvent | ...
... |      NULL       |     FALSE     | ...  ← Registos antigos
... |        2        |     FALSE     | ...  ← Novos registos
```

### 2. **Aplicação Web**

- Novos botões na navbar: "Novo Registo", "Listar Registos"
- Novos campos nos formulários (Estado Civil, Data de Nascimento)
- Novo checkbox: "Falecido à Data do Evento"
- Melhor UX com toast notifications
- Dois botões de gravação: "Gravar" / "Gravar & Novo"

---

## ✅ Checklist Final

- [ ] Li QUICK_START_SYNC.md (5 min)
- [ ] Fiz backup com backup_db.sh
- [ ] Guardei backup em local seguro (Google Drive, etc)
- [ ] Li SYNC_TO_PRODUCTION.md completamente
- [ ] Entendo os riscos e mitigações
- [ ] Tem plano de rollback preparado
- [ ] Avisei utilizadores da manutenção
- [ ] Executei sync_production.sh
- [ ] Validei com validate_migration.sh
- [ ] Testei manualmente
- [ ] Documentei data/hora de sincronização
- [ ] Comunicei volta ao normal
- [ ] Monitorei logs após sync

---

## 📞 Principais Contactos

| Documento Útil | Situação |
|---|---|
| QUICK_START_SYNC.md | "Quero fazer isto já!" |
| SYNC_TO_PRODUCTION.md | "Preciso entender tudo antes" |
| TECHNICAL_MIGRATIONS.md | "Como funciona o SQL?" |
| SYNCHRONIZATION_TIMELINE.md | "Quando devo fazer isto?" |
| MIGRATION_RECOVERY.md | "Algo correu mal!" |

---

## 🎓 Próximas Sincronizações

Futuras atualizações podem usar o mesmo processo:

```bash
./sync_production.sh  # Sempre funciona da mesma forma
```

---

## 📊 Estatísticas

| Item | Valor |
|------|-------|
| Documentos criados | 5 |
| Scripts criados | 3 |
| Tempo total de leitura | ~45 minutos |
| Tempo de sincronização | ~15-30 minutos |
| Risco de perda de dados | Mínimo (backup + migrations seguras) |
| Reversibilidade | 100% (backup disponível) |
| Recomendação | ✅ Pode fazer com confiança |

---

## 🎉 Conclusão

Tem tudo o que precisa para sincronizar com segurança:

✅ **Documentação completa** - 5 documentos diferentes para vários públicos  
✅ **Scripts automáticos** - Tudo fazer com um comando  
✅ **Backup seguro** - Pode restaurar se algo correr mal  
✅ **Validação** - Verifica se tudo correu bem  
✅ **Suporte** - Documentação de contingência incluída

**Recomendação final: Execute `./sync_production.sh` e pronto! 🚀**

---

**Data:** 19 de Fevereiro de 2026  
**Versão:** v2.0  
**Status:** Pronto para produção ✅
