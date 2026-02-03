# Builder stage
FROM node:22-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
COPY prisma ./prisma

RUN apk add --no-cache openssl libc6-compat
RUN npm install

# Copy source and build
COPY . .

# Build para produção
RUN npm run build

# Final stage
FROM node:22-alpine

WORKDIR /app

# Install runtime dependencies only
RUN apk add --no-cache openssl libc6-compat

# Copy from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma

EXPOSE 3000

CMD ["npm", "run", "start"]
