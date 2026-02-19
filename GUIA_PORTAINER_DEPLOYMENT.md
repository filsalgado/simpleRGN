# Guia Completo: Deployment com Portainer

## 🔧 CONFIGURAÇÃO INICIAL (Uma vez apenas)

### 1️⃣ Servidor de Destino - Instalar Portainer
```bash
ssh user@seu-servidor.com

# Instalar Docker (se não tiver)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Instalar Portainer
docker run -d -p 8000:8000 -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

### 2️⃣ Local (WSL) - Configurar Git
```bash
cd /home/filipe/projs/simpleRGN

# Configurar utilizador Git
git config --global user.name "Seu Nome"
git config --global user.email "seu-email@github.com"

# Gerar SSH key
ssh-keygen -t ed25519 -C "seu-email@github.com"
# Pressione Enter 3x
```

### 3️⃣ GitHub - Adicionar SSH Key
1. Copie a chave pública:
```bash
cat ~/.ssh/id_ed25519.pub
```

2. GitHub → Settings → SSH Keys → Add new
3. Cole a chave e guarde

### 4️⃣ GitHub - Criar Personal Access Token (para Portainer)
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Marque: `repo` (full control of private repositories)
4. Copie o token: `ghp_xxxxxxxxxxxxxxxxxxxxxxxx`

### 5️⃣ GitHub - Criar Repositório
1. https://github.com/new
2. Nome: `simpleRGN`
3. Privado
4. Deixe vazio (sem README)
5. Create repository

---

## 📤 PRIMEIRO PUSH (Uma vez)

### Local (WSL)
```bash
cd /home/filipe/projs/simpleRGN

# Inicializar Git
git init
git add .
git commit -m "Deploy inicial - simpleRGN"
git branch -M main

# Adicionar remote
git remote add origin git@github.com:filsalgado/simpleRGN.git

# Push
git push -u origin main
```

---

## 🚀 PRIMEIRO DEPLOYMENT NO PORTAINER (Uma vez)

### 1. Aceder ao Portainer
- URL: `https://seu-servidor.com:9443`
- Configure conta de administrador

### 2. Criar Stack
1. **Stacks** → **Add Stack** → **Git repository**
2. Preencha:
   - **Repository URL**: 
     ```
     https://filsalgado:ghp_xxxxxxxxxxxxxxxxxxxxxxxx@github.com/filsalgado/simpleRGN.git
     ```
   - **Compose path**: `docker-compose.yml`
   - **Repository reference**: `main`
   - **Authentication**: Desactivada (token já está na URL)

3. **Variáveis de Ambiente**:
   ```
   POSTGRES_USER=dbuser
   POSTGRES_PASSWORD=senha-super-segura-aqui
   POSTGRES_DB=simplergn
   NEXTAUTH_SECRET=FLEWxuVvDOkV5lOmLzSZCtKfBS+IYOxGz9AL+hXj3/s=
   NEXTAUTH_URL=https://seu-dominio.com
   ```

4. **Deploy**

### 3. Verificar Deploy
- **Containers** → procure "web" e "db"
- Clique no container "web" → **Logs** para ver se iniciou corretamente
- Aceda a: `http://seu-servidor.com:3010`

---

## 🔄 ATUALIZAÇÕES (Recorrente - sempre que alterar código)

### Local (WSL) - Fazer alterações
```bash
cd /home/filipe/projs/simpleRGN

# Editar arquivos conforme necessário
# ... fazer as alterações ...

# Preparar para push
git add .
git commit -m "Descrição da alteração"
git push origin main
```

### Servidor (Portainer) - Atualizar
1. Aceda a **Stacks** → Seu stack → **"Pull & Redeploy"**
2. Aguarde o deployment terminar
3. Verifique os logs

---

## 📋 RESUMO RÁPIDO

| Ação | Onde | Frequência |
|------|------|-----------|
| `git config` | WSL | Uma vez |
| `ssh-keygen` | WSL | Uma vez |
| Adicionar SSH key | GitHub | Uma vez |
| Gerar token | GitHub | Uma vez |
| Criar repositório | GitHub | Uma vez |
| `git init` e `git push` | WSL | Uma vez |
| Instalar Portainer | Servidor | Uma vez |
| Criar Stack | Portainer | Uma vez |
| `git push` (alterações) | WSL | Sempre |
| "Pull & Redeploy" | Portainer | Sempre |

---

## 🔐 Variáveis Importantes

- **NEXTAUTH_SECRET**: Gerar com `openssl rand -base64 32`
- **POSTGRES_PASSWORD**: Use uma senha forte
- **NEXTAUTH_URL**: URL final onde a app vai estar acessível
- **Token GitHub**: Nunca compartilhe publicamente

---

## ✅ Checklist Final

- [ ] Portainer instalado no servidor
- [ ] Git configurado localmente
- [ ] SSH key gerada e adicionada ao GitHub
- [ ] Token GitHub criado
- [ ] Repositório criado no GitHub
- [ ] Código feito push inicial
- [ ] Stack criado no Portainer
- [ ] Aplicação acessível em `http://seu-servidor.com:3010`
- [ ] Banco de dados funcionando
- [ ] pgAdmin acessível em `http://seu-servidor.com:5060`

