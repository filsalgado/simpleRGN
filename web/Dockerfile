FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma

RUN apk add --no-cache openssl libc6-compat
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
