#!/bin/bash
# Script de Deploy Automático - Win Veicular Landing
# Para executar na VPS Ubuntu 22.04

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
    exit 1
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Verificar se está rodando como root
if [[ $EUID -ne 0 ]]; then
   print_error "Este script deve ser rodado como root (use: sudo bash deploy-vps.sh)"
fi

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║   Win Veicular Landing - Deploy VPS Automático      ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Configurações
DOMAIN="${1:-grupowin.site}"
WWW_DOMAIN="www.${DOMAIN}"
PROJECT_DIR="/srv/win-veicular-landing"
EMAIL="admin@${DOMAIN}"

print_info "Domínio: $DOMAIN"
print_info "Diretório: $PROJECT_DIR"
print_info "Email para Let's Encrypt: $EMAIL"

# Confirmar antes de continuar
read -p "Deseja continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    print_warning "Operação cancelada"
    exit 1
fi

echo ""
print_info "=== PASSO 1: Atualizações do Sistema ==="
apt-get update
apt-get upgrade -y
print_status "Sistema atualizado"

echo ""
print_info "=== PASSO 2: Instalar Docker ==="
if command -v docker &> /dev/null; then
    print_status "Docker já instalado: $(docker --version)"
else
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    print_status "Docker instalado"
fi

# Verificar Docker Compose
if command -v docker-compose &> /dev/null; then
    print_status "Docker Compose já instalado: $(docker-compose --version)"
else
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    print_status "Docker Compose instalado"
fi

echo ""
print_info "=== PASSO 3: Criar Diretório do Projeto ==="
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
print_status "Diretório criado: $PROJECT_DIR"

echo ""
print_info "=== PASSO 4: Clonar Repositório ==="
if [ -d ".git" ]; then
    print_info "Repositório já existe, atualizando..."
    git pull origin main
else
    REPO_URL="https://github.com/VitorManoel007/win-veicular-landing.git"
    print_info "Clonando: $REPO_URL"
    git clone "$REPO_URL" .
fi
print_status "Repositório clonado"

echo ""
print_info "=== PASSO 5: Criar Diretórios Necessários ==="
mkdir -p certs logs
chmod 755 certs logs
print_status "Diretórios criados"

echo ""
print_info "=== PASSO 6: Build e Deploy Docker ==="
docker-compose down 2>/dev/null || true
docker-compose build --no-cache
docker-compose up -d
print_status "Containers iniciados"

sleep 5
docker-compose ps

echo ""
print_info "=== PASSO 7: Instalar Certbot para SSL ==="
if ! command -v certbot &> /dev/null; then
    apt-get install -y certbot
    print_status "Certbot instalado"
else
    print_status "Certbot já instalado"
fi

echo ""
print_info "=== PASSO 8: Parar Nginx Temporariamente para SSL ==="
docker-compose stop nginx
sleep 2
print_status "Nginx parado"

echo ""
print_info "=== PASSO 9: Obter Certificado SSL com Let's Encrypt ==="
print_warning "Certifique-se de que:"
echo "  • O domínio $DOMAIN aponta para este servidor (IP: $(hostname -I | awk '{print $1}'))"
echo "  • As portas 80 e 443 estão abertas"
echo ""
read -p "Pressione ENTER para continuar com a geração do certificado..."

# Gerar certificado
certbot certonly --standalone \
    -d "$DOMAIN" \
    -d "$WWW_DOMAIN" \
    --non-interactive \
    --agree-tos \
    --email "$EMAIL"

if [ $? -eq 0 ]; then
    print_status "Certificado obtido com sucesso"
    
    # Copiar certificados para o container
    echo ""
    print_info "=== PASSO 10: Copiar Certificados para Container ==="
    cp /etc/letsencrypt/live/"$DOMAIN"/fullchain.pem "$PROJECT_DIR"/certs/
    cp /etc/letsencrypt/live/"$DOMAIN"/privkey.pem "$PROJECT_DIR"/certs/
    chmod 644 "$PROJECT_DIR"/certs/*
    print_status "Certificados copiados"
else
    print_error "Falha ao obter certificado SSL"
fi

echo ""
print_info "=== PASSO 11: Reiniciar Nginx com SSL ==="
docker-compose up -d nginx
sleep 3
docker-compose ps
print_status "Nginx reiniciado com SSL"

echo ""
print_info "=== PASSO 12: Configurar Auto-Renewal de SSL ==="
# Criar script de renovação
cat > /usr/local/bin/renew-ssl.sh << 'EOF'
#!/bin/bash
DOMAIN="$1"
PROJECT_DIR="/srv/win-veicular-landing"

certbot renew --quiet
cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem $PROJECT_DIR/certs/
cp /etc/letsencrypt/live/$DOMAIN/privkey.pem $PROJECT_DIR/certs/
docker-compose -f $PROJECT_DIR/docker-compose.yml restart nginx
EOF

chmod +x /usr/local/bin/renew-ssl.sh

# Adicionar ao crontab
(crontab -l 2>/dev/null || echo "") | grep -q "renew-ssl.sh" || \
(crontab -l 2>/dev/null; echo "0 3 * * * /usr/local/bin/renew-ssl.sh $DOMAIN") | crontab -

print_status "Auto-renewal configurado"

echo ""
print_info "=== PASSO 13: Otimizações Finais ==="

# Habilitar UFW firewall
if ! ufw status | grep -q "inactive"; then
    print_warning "Firewall já configurado"
else
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 22/tcp    # SSH
    ufw allow 80/tcp    # HTTP
    ufw allow 443/tcp   # HTTPS
    ufw enable
    print_status "Firewall habilitado"
fi

# Criar healthcheck
cat > /usr/local/bin/healthcheck-win.sh << 'EOF'
#!/bin/bash
DOMAIN="${1:-grupowin.site}"

# Verificar se site está respondendo
STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN)

if [ "$STATUS" = "200" ] || [ "$STATUS" = "301" ]; then
    echo "✓ Win Veicular está online"
    exit 0
else
    echo "✗ Win Veicular retornou status $STATUS"
    exit 1
fi
EOF

chmod +x /usr/local/bin/healthcheck-win.sh
print_status "Healthcheck criado"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          DEPLOY CONCLUÍDO COM SUCESSO!              ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
print_info "Seu site está disponível em:"
echo -e "  ${BLUE}https://${DOMAIN}${NC}"
echo -e "  ${BLUE}https://${WWW_DOMAIN}${NC}"
echo ""
print_info "Comandos úteis:"
echo "  Verificar status: docker-compose -f $PROJECT_DIR/docker-compose.yml ps"
echo "  Ver logs: docker-compose -f $PROJECT_DIR/docker-compose.yml logs -f"
echo "  Atualizar: cd $PROJECT_DIR && git pull && docker-compose restart"
echo "  Saúde: healthcheck-win.sh $DOMAIN"
echo ""
print_info "Certificado SSL renovado automaticamente todo dia às 3:00 AM"
echo ""
