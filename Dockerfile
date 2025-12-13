# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar package files
COPY package*.json ./
COPY bun.lockb* ./

# Instalar dependências
RUN npm install --production=false

# Copiar código fonte
COPY . .

# Build da aplicação
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Instalar serve para servir arquivos estáticos
RUN npm install -g serve

# Copiar apenas os arquivos necessários do builder
COPY --from=builder /app/dist ./dist

# Criar usuário não-root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

USER nextjs

# Expose porta
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Start server
CMD ["serve", "-s", "dist", "-l", "3000"]
