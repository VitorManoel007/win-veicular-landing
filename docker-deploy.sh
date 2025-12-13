#!/bin/bash
# Docker deployment script for Win Veicular Landing

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker não está instalado. Instale Docker e tente novamente."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose não está instalado. Instale Docker Compose e tente novamente."
    exit 1
fi

print_status "Docker e Docker Compose detectados"

COMMAND=${1:-"help"}

case "$COMMAND" in
    setup)
        print_info "Configurando Win Veicular Landing com Docker..."
        
        # Create necessary directories
        mkdir -p certs logs
        print_status "Diretórios criados"
        
        # Build images
        print_info "Construindo imagens Docker..."
        docker-compose build
        print_status "Imagens construídas"
        
        # Start services
        print_info "Iniciando serviços..."
        docker-compose up -d
        print_status "Serviços iniciados"
        
        # Wait for services to be ready
        sleep 10
        
        # Check if services are running
        if docker-compose ps | grep -q "win-veicular.*Up"; then
            print_status "Serviço Win Veicular está rodando"
        else
            print_error "Falha ao iniciar serviços"
            exit 1
        fi
        
        echo ""
        print_info "Próximos passos:"
        echo "1. Configure seus certificados SSL:"
        echo "   sudo cp /etc/letsencrypt/live/seu-dominio.com/fullchain.pem certs/"
        echo "   sudo cp /etc/letsencrypt/live/seu-dominio.com/privkey.pem certs/"
        echo "2. Atualize a configuração Nginx com seu domínio"
        echo "3. Reinicie os serviços: docker-compose restart"
        ;;
        
    build)
        print_info "Construindo imagens Docker..."
        docker-compose build --no-cache
        print_status "Build concluído"
        ;;
        
    start)
        print_info "Iniciando serviços..."
        docker-compose up -d
        print_status "Serviços iniciados"
        docker-compose ps
        ;;
        
    stop)
        print_info "Parando serviços..."
        docker-compose down
        print_status "Serviços parados"
        ;;
        
    restart)
        print_info "Reiniciando serviços..."
        docker-compose restart
        print_status "Serviços reiniciados"
        docker-compose ps
        ;;
        
    logs)
        print_info "Logs da aplicação:"
        docker-compose logs -f win-veicular
        ;;
        
    deploy)
        print_info "Fazendo deploy..."
        
        # Pull latest code
        git pull origin main
        print_status "Código atualizado"
        
        # Rebuild and restart
        docker-compose down
        docker-compose build --no-cache
        docker-compose up -d
        
        sleep 5
        docker-compose ps
        print_status "Deploy concluído!"
        ;;
        
    clean)
        print_info "Limpando containers e volumes..."
        docker-compose down -v
        docker system prune -f
        print_status "Limpeza concluída"
        ;;
        
    ps)
        docker-compose ps
        ;;
        
    *)
        echo "Win Veicular Docker Deploy Tool"
        echo ""
        echo "Uso: $0 {setup|build|start|stop|restart|deploy|logs|clean|ps|help}"
        echo ""
        echo "Comandos:"
        echo "  setup       - Setup inicial (build + start)"
        echo "  build       - Construir imagens Docker"
        echo "  start       - Iniciar containers"
        echo "  stop        - Parar containers"
        echo "  restart     - Reiniciar containers"
        echo "  deploy      - Deploy completo (git pull + build + restart)"
        echo "  logs        - Ver logs em tempo real"
        echo "  clean       - Remover containers e volumes"
        echo "  ps          - Ver status dos containers"
        echo "  help        - Mostrar esta mensagem"
        ;;
esac
