# 🚀 COMANDO DE DEPLOY EM UMA LINHA

## Deploy Automático Completo (VPS)

```bash
# Para primeira instalação e deploy
curl -fsSL https://raw.githubusercontent.com/VitorManoel007/win-veicular-landing/main/deploy-vps-v2.sh | bash
```

## Deploy com SSL (Após primeira instalação)

```bash
# Executar na VPS após deploy inicial
ssh root@72.60.147.56 'bash /srv/win-veicular-landing/deploy-commands.sh ssl'
```

## Deploy Rápido (Atualizações)

```bash
# Na VPS
cd /srv/win-veicular-landing && git pull origin main && docker-compose up -d --build
```

---

## Estrutura de Comandos (Mais Controle)

### 1️⃣ Setup (Primeira Vez)
```bash
ssh root@72.60.147.56
curl -fsSL https://raw.githubusercontent.com/VitorManoel007/win-veicular-landing/main/deploy-vps-v2.sh | bash
```

### 2️⃣ Deploy
```bash
ssh root@72.60.147.56 'cd /srv/win-veicular-landing && ./deploy-commands.sh deploy'
```

### 3️⃣ SSL/HTTPS
```bash
ssh root@72.60.147.56 'cd /srv/win-veicular-landing && ./deploy-commands.sh ssl'
```

### 4️⃣ Verificar Status
```bash
ssh root@72.60.147.56 'cd /srv/win-veicular-landing && ./deploy-commands.sh status'
```

---

## Variáveis de Configuração

Editar antes de executar:

```bash
# Em deploy-commands.sh (linhas 17-23)
DOMAIN="grupowin.site"              # Seu domínio
VPS_IP="72.60.147.56"               # IP da VPS
EMAIL="admin@grupowin.site"         # Email para SSL
APP_PORT="5003"                     # Porta da aplicação
```

---

## Aliases Úteis (Adicione ao ~/.bashrc)

```bash
# Deploy rápido
alias deploy-win='cd /srv/win-veicular-landing && git pull && docker-compose up -d --build'

# Ver logs
alias logs-win='cd /srv/win-veicular-landing && docker-compose logs -f'

# Status
alias status-win='cd /srv/win-veicular-landing && ./deploy-commands.sh status'
```

---

## Troubleshooting Rápido

```bash
# Se não conseguir conectar à VPS
ssh -i ~/.ssh/id_rsa root@72.60.147.56

# Ver erros do Docker
cd /srv/win-veicular-landing && docker-compose logs | tail -50

# Reiniciar tudo
cd /srv/win-veicular-landing && docker-compose restart

# Limpar e fazer rebuild
cd /srv/win-veicular-landing && docker-compose down -v && docker-compose build --no-cache && docker-compose up -d
```

---

## Ambiente Pré-configurado

**Configurações já prontas:**
- ✅ Porta: 5003 (sem conflitos)
- ✅ Domínio: grupowin.site
- ✅ Email SSL: admin@grupowin.site
- ✅ VPS IP: 72.60.147.56
- ✅ Docker Network: Bridge (padrão)
- ✅ Node Version: 18-Alpine
- ✅ Nginx: Reverse proxy no host

---

## Documentação Completa

📚 Veja **DEPLOYMENT.md** para guia completo com:
- Setup e instalação passo a passo
- Configuração SSL/HTTPS detalhada
- Troubleshooting completo
- Rollback e backup
- Segurança e firewall
- Performance e monitoramento

---

**Última atualização**: 13 de Dezembro de 2025  
**Versão**: 1.0-production-ready  
**Repositório**: https://github.com/VitorManoel007/win-veicular-landing
