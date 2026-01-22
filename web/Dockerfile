FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma

RUN apk add --no-cache openssl libc6-compat
RUN npm install

COPY . .

# Build para produção
RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start"]
