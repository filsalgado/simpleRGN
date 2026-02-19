# 🔧 Fix: Login com Spinner Infinito - Solução

## ❌ Problema
- ✅ Login funciona (credenciais validadas, sessão criada)
- ✅ Utilizador vê nome na navbar (session ativa)  
- ❌ Página `/records/new` fica com spinner infinito
- ✅ Mas funciona se clicar em outros botões (navega manualmente)

## 🎯 Causa
O `Promise.all()` em `/records/new/page.tsx` e `/records/[id]/edit/page.tsx` aguarda 8 fetches simultâneos. Se **um deles tiver timeout ou responder muito lentamente**, fica preso indefinidamente.

## ✅ Solução Implementada

Adicionei uma função `fetchWithTimeout()` que:
1. Cancela requisições que demoram > 10 segundos
2. Permite que o erro seja capturado e tratado
3. O `finally` sempre executa e remove o spinner

### Alterações Feitas:

**1. web/app/records/new/page.tsx**
- Adicionado `fetchWithTimeout()` helper
- Atualizado `Promise.all()` para usar timeout
- Adicionado error handling apropriado

**2. web/app/records/[id]/edit/page.tsx**
- Mesmas alterações
- Agora também tem timeout

**3. web/app/api/users/me/context/current/route.ts**
- Adicionado logging `[DEBUG]` e `[ERROR]` para diagnosticar problemas
  
**4. web/app/api/records/route.ts**
- Adicionado logging no POST para rastrear erros

## 🚀 Deploy em Produção

```bash
cd /home/filipe/projs/simpleRGN

# 1. Compilar nova imagem
docker compose down
docker compose up --build -d

# 2. Acompanhar logs
docker compose logs -f web

# 3. Testar login
# Tenta login com não-admin
# Agora deve completar em < 10 segundos ou mostrar alerta
```

## 📊 O que Muda

Antes:
```
Login ✓ → spinner infinito → página travada
```

Depois:
```
Login ✓ → dados carregam (max 10s) → página abre ou alerta
```

## 🐛 Debug se Ainda Falhar

Se problema persistir, ver logs:
```bash
docker compose logs web | grep -E "\[DEBUG\]|\[ERROR\]|\[TIMEOUT\]"
```

Procurar por:
- `[TIMEOUT]` - Fetch expirou
- `[ERROR]` - Erro em query
- `[DEBUG]` - Info de debug

---

**Status:** ✅ Pronto para produção  
**Data:** 19 de Fevereiro de 2026  
**Versão:** v2.1 com timeout handling
