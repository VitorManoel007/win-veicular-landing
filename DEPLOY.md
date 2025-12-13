# Guia de Deploy - Win Veicular Landing Page

Este documento descreve como fazer o deploy da landing page em uma VPS Ubuntu 22.04 com isolamento via Docker.

## Pré-requisitos

- Docker 20.10+
- Docker Compose 2.0+
- Git
- Acesso SSH à VPS como root ou com privilégios sudo

## Instalação Rápida com Docker (Recomendado)

### 1. Instalar Docker e Docker Compose

```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalação
docker --version
docker-compose --version
```

### 2. Clonar e Configurar Projeto

```bash
# Criar diretório para o projeto
sudo mkdir -p /srv/win-veicular-landing
cd /srv/win-veicular-landing

# Clonar repositório
sudo git clone <seu-repositorio> .

# Criar diretórios necessários
sudo mkdir -p certs logs
```

### 3. Setup Inicial

```bash
# Tornar script executável
sudo chmod +x docker-deploy.sh

# Setup inicial (build + start)
sudo ./docker-deploy.sh setup
```

### 4. Configurar SSL/TLS

```bash
# Opção 1: Usar certbot do host
sudo apt install certbot
sudo certbot certonly --standalone -d seu-dominio.com

# Copiar certificados para dentro do container
sudo cp /etc/letsencrypt/live/seu-dominio.com/fullchain.pem ./certs/
sudo cp /etc/letsencrypt/live/seu-dominio.com/privkey.pem ./certs/
sudo chmod 644 certs/*

# Reiniciar containers
sudo ./docker-deploy.sh restart
```

### 5. Verificar Status

```bash
sudo ./docker-deploy.sh ps

# Ver logs
sudo ./docker-deploy.sh logs
```

## Gerenciamento com Docker

### Comandos Úteis

```bash
# Ver status dos containers
sudo ./docker-deploy.sh ps

# Ver logs em tempo real
sudo ./docker-deploy.sh logs

# Reiniciar serviços
sudo ./docker-deploy.sh restart

# Parar serviços
sudo ./docker-deploy.sh stop

# Iniciar serviços
sudo ./docker-deploy.sh start

# Fazer deploy com novo código
sudo ./docker-deploy.sh deploy

# Limpar tudo (containers + volumes)
sudo ./docker-deploy.sh clean
```

### Estrutura de Diretórios

```
/srv/win-veicular-landing/
├── Dockerfile
├── docker-compose.yml
├── docker-deploy.sh
├── nginx.conf
├── .dockerignore
├── certs/                 # Certificados SSL
│   ├── fullchain.pem
│   └── privkey.pem
├── logs/                  # Logs do Nginx
│   ├── access.log
│   └── error.log
├── src/
├── dist/
├── package.json
└── ... (outros arquivos do projeto)
```

## Monitoramento

### Ver logs dos containers

```bash
# Logs da aplicação
docker-compose logs -f win-veicular

# Logs do Nginx
docker-compose logs -f nginx

# Logs de sistema
docker stats

# Verificar saúde
docker-compose ps
```

### Auto-restart

Os containers estão configurados com `restart: unless-stopped`, o que significa que eles vão reiniciar automaticamente se a VPS reiniciar ou se os containers caírem.


```bash
sudo ./docker-deploy.sh deploy
```

## Alternativa: Setup Manual (Sem Docker)

Se preferir não usar Docker, siga os passos abaixo.

### 1. Clonar e Instalar

```bash
cd /opt
git clone <seu-repositorio> win-veicular-landing
cd win-veicular-landing
npm install
npm run build
```

### 2. Configurar Nginx

Copie o arquivo `nginx.conf.template` para a configuração do nginx:

```bash
sudo cp nginx.conf.template /etc/nginx/sites-available/win-veicular
sudo nano /etc/nginx/sites-available/win-veicular
# Atualize: seu-dominio.com e caminhos de certificados
```

### 3. Ativar Site

```bash
sudo ln -s /etc/nginx/sites-available/win-veicular /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 4. SSL com Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d seu-dominio.com
```

## Troubleshooting

### Container não inicia
```bash
# Ver logs de erro
docker-compose logs win-veicular

# Reconstruir imagem
docker-compose build --no-cache

# Iniciar novamente
docker-compose up -d
```

### Certificados SSL expirados
```bash
sudo certbot renew
sudo cp /etc/letsencrypt/live/seu-dominio.com/fullchain.pem ./certs/
sudo cp /etc/letsencrypt/live/seu-dominio.com/privkey.pem ./certs/
sudo ./docker-deploy.sh restart
```

### 502 Bad Gateway
- Verificar se o container da aplicação está rodando: `docker-compose ps`
- Verificar logs: `docker-compose logs win-veicular`
- Reiniciar: `docker-compose restart`

## Variáveis de Ambiente

Para adicionar variáveis de ambiente no Docker:

1. Edite o arquivo `.env.example` (ou crie um novo `.env`)
2. Use prefixo `VITE_` para variáveis de build
3. Adicione ao `docker-compose.yml` se necessário:

```yaml
services:
  win-veicular:
    environment:
      - VITE_WHATSAPP_NUMBER=5511999999999
```

## Renew SSL Automático

Configure um cron job para renovar certificados automaticamente:

```bash
# Editar crontab
sudo crontab -e

# Adicione a linha:
0 3 * * * certbot renew --quiet && cp /etc/letsencrypt/live/seu-dominio.com/fullchain.pem /srv/win-veicular-landing/certs/ && cp /etc/letsencrypt/live/seu-dominio.com/privkey.pem /srv/win-veicular-landing/certs/ && docker-compose -f /srv/win-veicular-landing/docker-compose.yml restart nginx
```

## Backup

Para fazer backup do seu projeto:

```bash
# Backup completo
sudo tar -czf /backup/win-veicular-$(date +%Y%m%d).tar.gz /srv/win-veicular-landing/

# Backup apenas do código
sudo tar -czf /backup/win-veicular-code-$(date +%Y%m%d).tar.gz \
  --exclude='dist' \
  --exclude='node_modules' \
  --exclude='.git' \
  /srv/win-veicular-landing/
```
