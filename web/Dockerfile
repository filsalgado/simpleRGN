FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma

RUN apk add --no-cache openssl libc6-compat
RUN npm install

# Copiar apenas arquivos que git permite (exclui .next por gitignore)
COPY . .

# Build cria .next dentro do Docker
RUN npm run build

# Verificar que .next foi criado
RUN test -d /app/.next || (echo "ERROR: .next not created after build!" && exit 1)

# Remove build artifacts not needed in production
RUN npm prune --omit=dev

EXPOSE 3000

CMD ["npm", "run", "start"]
