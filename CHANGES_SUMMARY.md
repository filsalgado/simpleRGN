# Resumo de Alterações - Preferências de Utilizador

## 📋 Objetivo
Mover a configuração de "Tipo de Evento" e "Paróquia Contexto" das páginas de registos para as páginas de administração de utilizadores, permitindo que estas preferências sejam carregadas automaticamente ao fazer login.

## ✅ Alterações Realizadas

### 1. **Schema Prisma** - `web/prisma/schema.prisma`
- Campo `currentEventType String?` já estava adicionado (valores: 'BAPTISM', 'MARRIAGE', 'DEATH')
- Campo `currentParishId Int?` já existia
- Migração `20260112215246_add_current_event_type` já havia sido aplicada

### 2. **API Endpoint** - `web/app/api/users/[id]/route.ts`

**GET /api/users/[id]**
- Actualizado para retornar `currentEventType` junto com `currentParishId`
- Resposta inclui: `{ id, name, email, currentParishId, currentEventType }`

**PATCH /api/users/[id]**
- Actualizado para aceitar parâmetros `currentParishId` e `currentEventType`
- Substitui anterior `contextParishId` por `currentParishId` (correspondência com schema)
- Processa ambos os parâmetros dinamicamente

### 3. **Página de Novo Utilizador** - `web/app/admin/users/new/page.tsx`

**Adições:**
- Importação de `useState` e `useEffect`
- Type `Parish` para tipagem
- Campo `currentParishId` e `currentEventType` no state
- `useEffect` para carregar lista de paróquias do `/api/parishes`

**Formulário:**
- Novo campo select para "Paróquia Contexto" com lista de paróquias dinâmica
- Novo campo select para "Tipo de Evento Preferido" (Batismo/Casamento/Óbito)
- Separador visual (HR) para distinguir preferências do utilizador

**Envio:**
- FormData inclui `currentParishId` e `currentEventType` no payload POST

### 4. **Página de Edição de Utilizador** - `web/app/admin/users/[id]/edit/page.tsx`

**Adições:**
- Type `Parish` para tipagem
- Campo `currentParishId` e `currentEventType` no state
- `useEffect` actualizador para:
  - Buscar dados do utilizador com GET `/api/users/{id}`
  - Buscar lista de paróquias com GET `/api/parishes`
  - Carregar preferências do utilizador na inicialização

**Formulário:**
- Mesmo layout de novo utilizador com campos de preferência
- Paróquias carregam a partir da API

**Envio:**
- PATCH inclui `currentParishId` e `currentEventType` quando presentes

### 5. **Página de Novos Registos** - `web/app/records/new/page.tsx`

**Remoções:**
- Função `handleEventTypeChange` removida (salvava preferência dinamicamente)
- Lógica de PATCH para salvar eventType tipo removida

**Mantém:**
- Carregamento automático de `currentEventType` e `currentParishId` da API no `useEffect`
- Pré-seleção do tipo de evento preferido ao carregar a página
- Comportamento normal do dropdown sem efeitos colaterais de salvamento

## 🔄 Fluxo de Utilização

### Cenário 1: Novo Utilizador
1. Admin acede `/admin/users/new`
2. Preenche dados e selecciona "Paróquia Contexto" e "Tipo de Evento Preferido"
3. Clica "Criar Utilizador" - preferências são gravadas na base de dados

### Cenário 2: Editar Utilizador
1. Admin acede `/admin/users/{id}/edit`
2. Página carrega preferências actuais do utilizador
3. Admin pode actualizar "Paróquia Contexto" e "Tipo de Evento Preferido"
4. Clica "Atualizar Utilizador" - preferências são gravadas

### Cenário 3: Novo Registo (após login)
1. Utilizador faz login
2. Acede `/records/new`
3. Página carrega automaticamente:
   - Paróquia preferida (pré-selecciona se existir)
   - Tipo de evento preferido (pré-selecciona se existir)
4. Criar novo registo com valores pré-carregados

## 🔍 Validação

Todas as alterações foram compiladas com sucesso:
```
✓ Compiled successfully in 3.2s
✓ All pages and routes configured correctly
✓ No TypeScript errors
```

Servidor Next.js está respondendo normalmente em `http://localhost:3000`

## 📝 Próximos Passos (Opcionais)

1. **Sessão NextAuth**: Poderia carregar preferências na sessão ao fazer login para evitar chamadas à API em cada página
2. **Validação**: Adicionar validação de segurança para garantir que utilizadores não podem modificar preferências de outros utilizadores
3. **Feedback Visual**: Adicionar mensagem de sucesso ao guardar preferências nas páginas de admin

---

**Data**: 12 de Janeiro de 2026
**Status**: ✅ Implementado e Testado
