FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma

RUN apk add --no-cache openssl libc6-compat
RUN npm install

# Copiar arquivos da aplicação
COPY . .

EXPOSE 3000

# Usar dev mode (funciona melhor que production build)
CMD ["npm", "run", "dev"]
