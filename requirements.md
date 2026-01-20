# Especificação de Requisitos - Sistema de Registos Paroquiais (SimpleRGN)

## 1. Visão Geral
Aplicação web containerizada (Docker) com base de dados PostgreSQL para recolha, gestão e estruturação genealógica de registos paroquiais (Batismo, Casamento, Óbito).

## 2. Stack Tecnológico
- **Infraestrutura:** Docker & Docker Compose (focado em deploy no Portainer).
- **Base de Dados:** PostgreSQL.
- **Backend/Frontend:** (A definir na implementação, ex: Python/FastAPI, Django, ou Node.js).

## 3. Estrutura de Dados

### 3.1. Entidades Nucleares
- **Indivíduo:**
  - ID Único (UUID/Auto-inc).
  - *Família de Origem* (FK para a família composta pelos seus pais).
- **Família:**
  - ID Único.
  - Representa a união de dois indivíduos (ex: Pais, Casal).

### 3.2. Contexto Geográfico e Social
- **Paróquias:** Lista fixa/sistema de referência (Lookup table), não editável.
- **Lugares:** Lista editável pelo utilizador. Cada lugar pertence a uma Paróquia.
- **Profissões:** Lista pré-estabelecida de profissões.

### 3.3. Eventos (Registos)
Todos os eventos partilham:
- Data (Ano, Mês, Dia).
- Fonte (URL/Link para documento).
- Notas (Obs. livres).
- *Paróquia de Contexto* (Onde o ato ocorreu).
- **Auditoria:** `user_created`, `created_at`, `user_updated`, `updated_at`.

Tipos de Eventos e Participantes específicos:
1.  **Batismo / Óbito:**
    - Sujeito (Batizando/Defunto).
    - Pais (Pai, Mãe).
    - Avós (Paternos, Maternos).
    - Outros: Padrinhos, Testemunhas, Padre.
2.  **Casamento:**
    - Noivos (Noivo, Noiva) -> Cria uma nova *Família*.
    - Pais dos Noivos.
    - Avós dos Noivos.
    - Outros: Padrinhos, Testemunhas, Padre.

### 3.4. Atributos da Participação
Quando um indivíduo participa num evento (em qualquer papel), deve ser possível registar:
- Alcunha (neste ato).
- Profissão (neste ato).
- Naturalidade (Lugar).
- Residência (Lugar).
- Local de Óbito (se aplicável ao ato).

## 4. Requisitos Funcionais

### 4.1. Autenticação e Segurança
- Login e Registo de utilizadores.
- Mecanismo de recuperação de password.
- Todas as escritas na BD devem registar o utilizador responsável.

### 4.2. Interface de Utilizador (UI/UX)
- **Formulários:** Design minimalista e limpo.
- **Progressive Disclosure:** Campos para avós/ascendentes devem estar ocultos por defeito e aparecer via ação do utilizador ("Adicionar Avós").
- **Layout:** Disposição visual em "Árvore Genealógica Horizontal" para facilitar a compreensão das relações parentais durante a inserção.

### 4.3. Gestão
- Listagem de registos levantados.
- Capacidade de editar dados de registos já fechados.
- Edição da lista de Lugares disponíveis.

---

# Exemplo de Prompt para Gerar a Solução
*Use este prompt se quiser pedir a uma IA para gerar o código inicial.*

```text
Atua como um Arquiteto de Software Sénior e Full Stack Developer.
Cria uma estrutura de projeto para uma aplicação web com Docker e PostgreSQL.

O objetivo é gerir registos paroquiais (Batismo, Casamento, Óbito) e extrair relações genealógicas.

Requisitos de Dados:
1. Tabelas para Indivíduos e Famílias (auto-relacionamentos para ascendência).
2. Tabelas para Eventos com auditoria (quem criou/editou).
3. Tabelas auxiliares para Paróquias (fixas), Lugares (editáveis) e Profissões.
4. O modelo deve suportar papéis complexos (Pai, Mãe, Avós, Padrinhos) e atributos contextuais por evento (Alcunha, Profissão, Residência no momento do ato).

Requisitos Técnicos:
- Docker Compose configurado (App + DB).
- Backend com autenticação segura e recuperação de password.
- Frontend com formulário em "árvore genealógica horizontal", permitindo adicionar campos de ascendentes dinamicamente.

Por favor, gera:
1. O diagrama ER (Mermaid ou descrição SQL).
2. O docker-compose.yml.
3. A estrutura de ficheiros do projeto.
4. O código essencial para os modelos da base de dados e o formulário principal.
```
