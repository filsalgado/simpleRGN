# 🐛 Debug: Login não funciona para não-admins em produção

## ❌ Problema
- ✅ Admins conseguem fazer login
- ❌ Não-admins ficam no spinner indefinidamente
- ✅ Localmente (dev) funciona tudo

## 🔍 Causa Provável
Um dos endpoints chamados logo após o login está a falhar **silenciosamente** para não-admins:
1. `/api/users/me/context/current` - Carrega contexto do utilizador
2. `/api/records` - Carrega registos disponíveis
3. Outro endpoint que depende da BD

## 🛠️ Solução: Regenerar Prisma Client

Se executou o SQL diretamente (sem passar por Prisma), o cliente Prisma pode não estar sincronizado com a BD.

```bash
# SSH no servidor ou terminal local
cd /home/filipe/projs/simpleRGN

# 1. Regenerar Prisma
docker compose exec web npx prisma generate

# 2. Verificar se há erros
docker compose restart web

# 3. Ver logs
docker compose logs -f web
```

## 📊 Logs para Procurar

Quando tentar fazer login com não-admin, procura por:

```
[DEBUG] Session: email@example.com Role: USER
[DEBUG] User ID from session: 123
[DEBUG] User found: parishId, eventType
```

**Se vir `[ERROR]` em vez de `[DEBUG]`**, o problema está ali!

---

## 🎯 Checklist

- [ ] Fez backup da BD
- [ ] Executou `npx prisma generate`
- [ ] Reiniciou container `web`
- [ ] Tentou login com não-admin
- [ ] Viu logs `[DEBUG]` corrigos (não `[ERROR]`)
- [ ] Login funcionou! ✅

---

## 📋 Se Persistir o Problema

Se ainda não funciona, envie os logs exatos:

```bash
# Copiar logs para ficheiro
docker compose logs web > logs.txt

# Ver últimas 50 linhas enquanto tenta login
docker compose logs -f web | tail -50
```

---

## 🔧 Outras Possibilidades (Menos Prováveis)

1. **NEXTAUTH_SECRET** - Já verificou em Portainer?
   - Variável de ambiente criada?
   - Formato correto?

2. **DATABASE_URL** - Conectividade
   ```sql
   -- Execute no pgAdmin:
   SELECT id, email, role FROM "User" LIMIT 5;
   ```

3. **Trusty Proxy** - Se atrás de proxy/load balancer
   - Verificar `NEXTAUTH_URL` em Portainer

---

## 📞 Próximos Passos

1. Execute `npx prisma generate`
2. Reinicie container
3. Envie os logs se problema persistir
