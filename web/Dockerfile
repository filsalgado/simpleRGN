FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma

RUN apk add --no-cache openssl libc6-compat
RUN npm install

# Copiar arquivos da aplicação
COPY . .

# Gerar Prisma Client e fazer build de produção
RUN npx prisma generate
RUN npm run build

# Desabilitar telemetria
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

EXPOSE 3000

# Usar production mode
CMD ["npm", "run", "start"]
