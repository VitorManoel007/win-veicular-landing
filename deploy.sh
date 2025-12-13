#!/bin/bash
# Script de deploy para Win Veicular Landing

set -e  # Parar em caso de erro

echo "=== Win Veicular Deploy Script ==="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configurações
PROJECT_DIR="/opt/win-veicular-landing"
DOMAIN=${1:-"seu-dominio.com"}

# Função para imprimir com cor
print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Verificar se está rodando como root
if [[ $EUID -ne 0 ]]; then
   print_error "Este script deve ser rodado como root (use sudo)"
   exit 1
fi

# Opção de comando
COMMAND=${1:-"deploy"}

case "$COMMAND" in
  deploy)
    print_info "Iniciando deploy..."
    
    # Ir para diretório do projeto
    cd "$PROJECT_DIR" || exit 1
    print_status "Diretório do projeto: $PROJECT_DIR"
    
    # Pull do repositório
    print_info "Atualizando código do repositório..."
    git pull origin main
    print_status "Código atualizado"
    
    # Instalar dependências
    print_info "Instalando dependências..."
    npm install --production
    print_status "Dependências instaladas"
    
    # Build
    print_info "Compilando aplicação..."
    npm run build
    print_status "Build realizado com sucesso"
    
    # Reiniciar Nginx
    print_info "Reiniciando Nginx..."
    systemctl restart nginx
    print_status "Nginx reiniciado"
    
    echo ""
    print_status "Deploy concluído com sucesso!"
    print_info "Seu site está disponível em: https://$DOMAIN"
    ;;
    
  install)
    print_info "Instalando Win Veicular Landing..."
    
    if [ -d "$PROJECT_DIR" ]; then
      print_error "Diretório $PROJECT_DIR já existe"
      exit 1
    fi
    
    # Criar diretório
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
    
    # Clone do repositório
    read -p "Digite a URL do repositório Git: " REPO_URL
    git clone "$REPO_URL" .
    print_status "Repositório clonado"
    
    # Instalar dependências
    npm install --production
    print_status "Dependências instaladas"
    
    # Build
    npm run build
    print_status "Build realizado"
    
    # Instruções para Nginx
    echo ""
    print_info "Próximos passos:"
    echo "1. Configure seu domínio em /etc/nginx/sites-available/win-veicular"
    echo "2. Execute: sudo systemctl restart nginx"
    echo "3. Configure SSL com: sudo certbot --nginx -d seu-dominio.com"
    ;;
    
  logs)
    print_info "Logs do Nginx:"
    tail -f /var/log/nginx/error.log
    ;;
    
  *)
    echo "Uso: $0 {deploy|install|logs}"
    echo ""
    echo "Comandos:"
    echo "  deploy    - Fazer deploy (git pull, npm install, npm run build)"
    echo "  install   - Instalar inicialmente em /opt/win-veicular-landing"
    echo "  logs      - Ver logs do Nginx em tempo real"
    exit 1
    ;;
esac
