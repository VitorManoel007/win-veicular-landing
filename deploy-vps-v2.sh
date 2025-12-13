#!/bin/bash
# Deploy Win Veicular Landing - VPS
# Execute na VPS como root

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Win Veicular Landing - Deploy VPS (Porta 3003)          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se é root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Este script deve ser rodado como root"
   exit 1
fi

PROJECT_DIR="/srv/win-veicular-landing"
DOMAIN="${1:-grupowin.site}"
EMAIL="admin@${DOMAIN}"

echo "📍 Domínio: $DOMAIN"
echo "📁 Diretório: $PROJECT_DIR"
echo "🔌 Porta: 3003"
echo "📧 Email: $EMAIL"
echo ""

# Confirmar
read -p "Continuar com deploy? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "❌ Operação cancelada"
    exit 1
fi

# 1. Criar diretório
echo ""
echo "📂 [1/8] Criando diretório do projeto..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
echo "✅ Diretório pronto"

# 2. Clonar repositório
echo ""
echo "🔽 [2/8] Clonando repositório..."
if [ -d ".git" ]; then
    echo "📦 Repositório já existe, fazendo pull..."
    git pull origin main
else
    git clone https://github.com/VitorManoel007/win-veicular-landing.git .
fi
echo "✅ Repositório atualizado"

# 3. Criar diretórios necessários
echo ""
echo "📁 [3/8] Criando diretórios de suporte..."
mkdir -p certs logs
chmod 755 certs logs
echo "✅ Diretórios criados"

# 4. Parar containers antigos
echo ""
echo "🛑 [4/8] Parando containers antigos..."
docker-compose down 2>/dev/null || true
docker network prune -f 2>/dev/null || true
sleep 3
echo "✅ Containers parados"

# 5. Build Docker
echo ""
echo "🔨 [5/8] Fazendo build da imagem Docker..."
docker-compose build --no-cache
echo "✅ Build concluído"

# 6. Iniciar containers
echo ""
echo "🚀 [6/8] Iniciando containers..."
docker-compose up -d --remove-orphans
sleep 5
docker-compose ps
echo "✅ Containers online"

# 7. Testar conexão
echo ""
echo "🧪 [7/8] Testando conexão..."
if curl -s http://localhost:3003 | grep -q "Grupo Win"; then
    echo "✅ Site respondendo corretamente!"
else
    echo "⚠️  Aguardando app iniciar... (espere 10s)"
    sleep 10
fi

# 8. Próximos passos
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                   DEPLOY CONCLUÍDO! ✅                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📍 Acesso:"
echo "   HTTP: http://72.60.147.56:3003"
echo "   Nginx Proxy: http://72.60.147.56:80"
echo ""
echo "📝 Próximos passos (IMPORTANTE):"
echo ""
echo "1️⃣  Configurar DNS (adicione A record em seu registrador):"
echo "   grupowin.site  → 72.60.147.56"
echo "   www.grupowin.site → 72.60.147.56"
echo ""
echo "2️⃣  Gerar certificado SSL Let's Encrypt:"
echo "   docker-compose stop nginx"
echo "   sleep 2"
echo "   certbot certonly --standalone \\"
echo "       -d $DOMAIN \\"
echo "       -d www.$DOMAIN \\"
echo "       --non-interactive \\"
echo "       --agree-tos \\"
echo "       --email $EMAIL"
echo ""
echo "3️⃣  Copiar certificados:"
echo "   mkdir -p $PROJECT_DIR/certs"
echo "   cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem $PROJECT_DIR/certs/"
echo "   cp /etc/letsencrypt/live/$DOMAIN/privkey.pem $PROJECT_DIR/certs/"
echo "   chmod 644 $PROJECT_DIR/certs/*"
echo ""
echo "4️⃣  Reiniciar nginx com SSL:"
echo "   docker-compose up -d nginx"
echo ""
echo "5️⃣  Testar HTTPS:"
echo "   curl -I https://$DOMAIN"
echo ""
echo "📊 Comandos úteis:"
echo "   Status: docker-compose ps"
echo "   Logs: docker-compose logs -f"
echo "   Restart: docker-compose restart"
echo "   Down: docker-compose down"
echo ""
echo "✨ Parabéns! Win Veicular Landing está no ar! 🎉"
