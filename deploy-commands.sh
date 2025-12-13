#!/bin/bash

##############################################################################
# Deploy Script - Win Veicular Landing
# 
# Uso: ./deploy-commands.sh [comando]
# Comandos: setup | deploy | update | rollback | status | ssl | logs
#
# Data: 13 de Dezembro de 2025
##############################################################################

set -e

REPO_URL="https://github.com/VitorManoel007/win-veicular-landing.git"
DEPLOY_PATH="/srv/win-veicular-landing"
DOMAIN="grupowin.site"
VPS_IP="72.60.147.56"
APP_PORT="5003"
EMAIL="admin@grupowin.site"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

##############################################################################
# Funções Utilitárias
##############################################################################

print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Este script deve ser executado como root"
        exit 1
    fi
}

##############################################################################
# Comandos de Deploy
##############################################################################

cmd_setup() {
    print_header "SETUP INICIAL - Win Veicular Landing"
    
    check_root
    
    print_info "Verificando pré-requisitos..."
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado"
        echo "Instale com: curl -fsSL https://get.docker.com | sh"
        exit 1
    fi
    print_success "Docker instalado"
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose não está instalado"
        exit 1
    fi
    print_success "Docker Compose instalado"
    
    # Verificar Git
    if ! command -v git &> /dev/null; then
        print_error "Git não está instalado"
        exit 1
    fi
    print_success "Git instalado"
    
    print_info "Criando diretório de deploy..."
    mkdir -p "$DEPLOY_PATH"
    cd "$DEPLOY_PATH"
    
    print_info "Clonando repositório..."
    if [ -d .git ]; then
        print_info "Repositório já existe, atualizando..."
        git pull origin main
    else
        git clone "$REPO_URL" .
    fi
    
    print_success "Setup inicial concluído!"
    print_info "Próximo passo: ./deploy-commands.sh deploy"
}

cmd_deploy() {
    print_header "DEPLOY - Win Veicular Landing"
    
    check_root
    
    if [ ! -d "$DEPLOY_PATH" ]; then
        print_error "Diretório de deploy não existe. Execute setup primeiro."
        exit 1
    fi
    
    cd "$DEPLOY_PATH"
    
    print_info "Parando containers antigos..."
    docker-compose down --remove-orphans 2>/dev/null || true
    docker network prune -f 2>/dev/null || true
    sleep 2
    
    print_info "Fazendo build Docker..."
    docker-compose build --no-cache
    
    print_info "Iniciando containers..."
    docker-compose up -d
    sleep 5
    
    print_info "Testando acesso..."
    if curl -s -I http://localhost:$APP_PORT | grep -q "200"; then
        print_success "Container respondendo na porta $APP_PORT"
    else
        print_error "Container não respondendo!"
        docker-compose logs
        exit 1
    fi
    
    print_success "Deploy concluído com sucesso!"
    print_info "Aplicação disponível em: http://$VPS_IP:$APP_PORT"
    print_info "Próximo passo: ./deploy-commands.sh ssl"
}

cmd_update() {
    print_header "UPDATE - Win Veicular Landing"
    
    check_root
    
    cd "$DEPLOY_PATH" || exit 1
    
    print_info "Atualizando código..."
    git pull origin main
    
    print_info "Verificando se há mudanças no Dockerfile..."
    if git diff HEAD~1 Dockerfile | grep -q "^[+-]"; then
        print_info "Dockerfile foi alterado, fazendo rebuild..."
        docker-compose build --no-cache
    else
        print_info "Nenhuma mudança no Dockerfile"
    fi
    
    print_info "Reiniciando containers..."
    docker-compose up -d --no-build
    
    sleep 3
    docker-compose ps
    
    print_success "Update concluído!"
}

cmd_status() {
    print_header "STATUS - Win Veicular Landing"
    
    echo -e "\n${BLUE}Docker Containers:${NC}"
    docker-compose ps 2>/dev/null || echo "Docker não ativo"
    
    echo -e "\n${BLUE}Porta $APP_PORT:${NC}"
    if lsof -i :$APP_PORT &>/dev/null; then
        print_success "Porta $APP_PORT está em uso"
        lsof -i :$APP_PORT
    else
        print_error "Porta $APP_PORT não está em uso"
    fi
    
    echo -e "\n${BLUE}Nginx Status:${NC}"
    systemctl is-active nginx &>/dev/null && print_success "Nginx ativo" || print_error "Nginx inativo"
    
    echo -e "\n${BLUE}Teste HTTP:${NC}"
    if curl -s -I http://localhost:$APP_PORT | grep -q "200"; then
        print_success "HTTP respondendo"
    else
        print_error "HTTP não respondendo"
    fi
    
    echo -e "\n${BLUE}Teste HTTPS:${NC}"
    if curl -s -I https://$DOMAIN 2>/dev/null | grep -q "200"; then
        print_success "HTTPS respondendo"
    else
        print_error "HTTPS não respondendo (pode ser DNS/SSL)"
    fi
}

cmd_ssl() {
    print_header "CONFIGURAR SSL - Win Veicular Landing"
    
    check_root
    
    print_info "Parando nginx..."
    systemctl stop nginx 2>/dev/null || true
    sleep 2
    
    print_info "Gerando certificado SSL..."
    certbot certonly --standalone \
        -d "$DOMAIN" \
        -d "www.$DOMAIN" \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --force-renewal 2>/dev/null || true
    
    print_info "Configurando Nginx com SSL..."
    cat > /etc/nginx/sites-available/"$DOMAIN" << EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN www.$DOMAIN _;
    
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    
    location / {
        return 301 https://\$server_name\$request_uri;
    }
}

server {
    listen 443 ssl http2 default_server;
    listen [::]:443 ssl http2 default_server;
    server_name $DOMAIN www.$DOMAIN _;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location / {
        proxy_pass http://127.0.0.1:$APP_PORT;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

    # Remover site padrão se existir
    rm -f /etc/nginx/sites-enabled/default
    
    ln -sf /etc/nginx/sites-available/"$DOMAIN" /etc/nginx/sites-enabled/"$DOMAIN"
    
    print_info "Testando configuração nginx..."
    if nginx -t; then
        print_success "Configuração OK"
    else
        print_error "Erro na configuração nginx"
        exit 1
    fi
    
    print_info "Iniciando nginx..."
    systemctl start nginx
    systemctl enable nginx
    
    print_info "Configurando auto-renovação SSL..."
    (crontab -l 2>/dev/null | grep -v "certbot renew"; echo "0 3 * * * certbot renew --quiet && systemctl reload nginx") | crontab - 2>/dev/null || true
    
    print_success "SSL configurado com sucesso!"
    sleep 3
    
    echo -e "\n${BLUE}Certificados instalados:${NC}"
    certbot certificates 2>/dev/null || echo "Nenhum certificado"
}

cmd_logs() {
    print_header "LOGS - Win Veicular Landing"
    
    echo -e "\n${BLUE}Logs dos Containers (últimas 50 linhas):${NC}"
    docker-compose logs --tail=50
    
    echo -e "\n${BLUE}Pressione CTRL+C para parar. Modo follow (em tempo real):${NC}"
    read -p "Deseja ativar modo follow? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        docker-compose logs -f
    fi
}

cmd_rollback() {
    print_header "ROLLBACK - Win Veicular Landing"
    
    check_root
    
    cd "$DEPLOY_PATH" || exit 1
    
    print_info "Histórico de commits:"
    git log --oneline | head -10
    
    read -p "Digite o hash do commit para voltar (ou deixe em branco para cancelar): " COMMIT_HASH
    
    if [ -z "$COMMIT_HASH" ]; then
        print_error "Rollback cancelado"
        return
    fi
    
    print_info "Voltando para $COMMIT_HASH..."
    git reset --hard "$COMMIT_HASH"
    
    print_info "Rebuild e restart..."
    docker-compose build --no-cache
    docker-compose up -d
    
    sleep 3
    docker-compose ps
    
    print_success "Rollback concluído!"
}

cmd_help() {
    cat << 'EOF'
╔════════════════════════════════════════════════════════════╗
║   Deploy Script - Win Veicular Landing                    ║
║   Data: 13 de Dezembro de 2025                             ║
╚════════════════════════════════════════════════════════════╝

USO:
  ./deploy-commands.sh [comando]

COMANDOS:

  setup              Configuração inicial (clone + build)
  deploy             Deploy completo do projeto
  update             Atualizar código e reiniciar
  status             Ver status da aplicação
  ssl                Configurar SSL/HTTPS com Let's Encrypt
  logs               Ver logs dos containers
  rollback           Voltar para versão anterior
  help               Mostrar esta mensagem

EXEMPLOS:

  # Setup inicial
  ./deploy-commands.sh setup

  # Deploy após setup
  ./deploy-commands.sh deploy

  # Configurar SSL
  ./deploy-commands.sh ssl

  # Ver status
  ./deploy-commands.sh status

  # Atualizar código
  ./deploy-commands.sh update

VARIÁVEIS (edite no script):

  REPO_URL:    $REPO_URL
  DEPLOY_PATH: $DEPLOY_PATH
  DOMAIN:      $DOMAIN
  VPS_IP:      $VPS_IP
  APP_PORT:    $APP_PORT

═══════════════════════════════════════════════════════════════════

Documentação completa: DEPLOYMENT.md
Repositório: https://github.com/VitorManoel007/win-veicular-landing

EOF
}

##############################################################################
# Main
##############################################################################

COMMAND="${1:-help}"

case "$COMMAND" in
    setup)
        cmd_setup
        ;;
    deploy)
        cmd_deploy
        ;;
    update)
        cmd_update
        ;;
    status)
        cmd_status
        ;;
    ssl)
        cmd_ssl
        ;;
    logs)
        cmd_logs
        ;;
    rollback)
        cmd_rollback
        ;;
    help|--help|-h)
        cmd_help
        ;;
    *)
        print_error "Comando desconhecido: $COMMAND"
        echo ""
        cmd_help
        exit 1
        ;;
esac
