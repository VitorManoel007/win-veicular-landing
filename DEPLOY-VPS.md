# Guia Rápido de Deploy na VPS

## Info da VPS
- **IP**: 72.60.147.56
- **Domínio**: grupowin.site
- **SO**: Ubuntu 22.04.5 LTS
- **Projeto**: Win Veicular Landing

## 🚀 Deploy Automático (1 Comando)

Conecte na VPS via SSH e execute:

```bash
ssh root@72.60.147.56

# Copiar script
curl -fsSL https://raw.githubusercontent.com/VitorManoel007/win-veicular-landing/main/deploy-vps.sh -o deploy-vps.sh

# Executar
sudo bash deploy-vps.sh grupowin.site
```

Isso vai:
1. ✅ Atualizar sistema
2. ✅ Instalar Docker + Docker Compose
3. ✅ Clonar seu repositório
4. ✅ Fazer build dos containers
5. ✅ Gerar certificado SSL automaticamente
6. ✅ Configurar firewall
7. ✅ Configurar auto-renewal SSL
8. ✅ Deixar o site online em https://grupowin.site

## 📋 Pré-requisitos

Antes de rodar o script:

1. **DNS Apontado**: Seu domínio `grupowin.site` deve apontar para o IP `72.60.147.56`
   - Abra seu painel DNS do registrador
   - Crie um registro A apontando para o IP
   - Crie um registro CNAME www → grupowin.site

2. **Portas Abertas**: Certifique-se que as portas 80 e 443 estão acessíveis
   - Firewall da VPS não bloqueia essas portas
   - Seu ISP não bloqueia as portas

## 📝 Passo a Passo Manual (Se Preferir)

Se o script automático não funcionar, siga estes passos:

### 1. SSH na VPS
```bash
ssh root@72.60.147.56
```

### 2. Clonar Projeto
```bash
mkdir -p /srv
cd /srv
git clone https://github.com/VitorManoel007/win-veicular-landing.git win-veicular-landing
cd win-veicular-landing
mkdir -p certs logs
```

### 3. Instalar Docker
```bash
curl -fsSL https://get.docker.com | sh
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### 4. Iniciar Containers
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### 5. Obter Certificado SSL
```bash
# Parar nginx temporariamente
docker-compose stop nginx

# Instalar certbot
apt-get update && apt-get install -y certbot

# Gerar certificado
certbot certonly --standalone \
  -d grupowin.site \
  -d www.grupowin.site \
  --non-interactive \
  --agree-tos \
  --email seu-email@grupowin.site
```

### 6. Copiar Certificados
```bash
cp /etc/letsencrypt/live/grupowin.site/fullchain.pem /srv/win-veicular-landing/certs/
cp /etc/letsencrypt/live/grupowin.site/privkey.pem /srv/win-veicular-landing/certs/
chmod 644 /srv/win-veicular-landing/certs/*
```

### 7. Reiniciar com SSL
```bash
docker-compose up -d nginx
docker-compose ps
```

### 8. Testar
```bash
curl https://grupowin.site
# Esperado: HTTP 200 com HTML da landing page
```

## 🔍 Após o Deploy

### Verificar Status
```bash
docker-compose ps
# Deve mostrar 2 containers rodando: win-veicular e nginx
```

### Ver Logs
```bash
docker-compose logs -f
# Veja erros em tempo real
```

### Atualizar Código
```bash
cd /srv/win-veicular-landing
git pull origin main
docker-compose build --no-cache
docker-compose up -d
```

### Verificar SSL
```bash
# Acesse: https://grupowin.site

# Ou teste via comando:
curl -vI https://grupowin.site 2>&1 | grep -i "ssl\|certificate\|issuer"
```

## 🛠️ Troubleshooting

### Certificado não funciona
```bash
# Verificar certificado
certbot certificates

# Renovar manualmente
certbot renew --force-renewal

# Copiar novamente
cp /etc/letsencrypt/live/grupowin.site/*.pem /srv/win-veicular-landing/certs/
docker-compose restart nginx
```

### Site não carrega
```bash
# Verificar se containers estão rodando
docker-compose ps

# Ver logs
docker-compose logs nginx
docker-compose logs win-veicular

# Reiniciar tudo
docker-compose restart
```

### 502 Bad Gateway
```bash
# Certificar que app está respondendo
docker-compose exec win-veicular wget http://localhost:3000

# Testar conexão do nginx
docker-compose exec nginx wget http://win-veicular:3000

# Logs
docker-compose logs nginx
```

## 🔄 Auto-Renewal SSL

O script configura auto-renewal automático. O certificado será renovado todo dia às 3:00 AM.

Para verificar:
```bash
crontab -l
# Deve mostrar uma linha com renew-ssl.sh
```

Para renovar manualmente:
```bash
/usr/local/bin/renew-ssl.sh grupowin.site
```

## 🚨 Firewall

O script configura UFW automaticamente:
- SSH (22): Permitido
- HTTP (80): Permitido
- HTTPS (443): Permitido
- Resto: Bloqueado

Para gerenciar manualmente:
```bash
# Ver status
ufw status

# Habilitar
ufw enable

# Desabilitar
ufw disable

# Adicionar regra
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
```

## 📞 Suporte

Se encontrar problemas:

1. Verificar logs: `docker-compose logs -f`
2. Testar DNS: `nslookup grupowin.site`
3. Testar conectividade: `curl -v https://grupowin.site`
4. Verificar firewall: `ufw status`

## ✅ Checklist Final

- [ ] DNS apontado para 72.60.147.56
- [ ] Script deploy-vps.sh executado com sucesso
- [ ] Site acessível em https://grupowin.site
- [ ] Certificado SSL válido
- [ ] Containers rodando (`docker-compose ps`)
- [ ] Logs limpos (sem erros)
- [ ] Auto-renewal configurado

Pronto! Seu site está no ar! 🎉
