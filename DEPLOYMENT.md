# 🚀 Guia Completo de Deployment - Win Veicular Landing

**Data**: 13 de Dezembro de 2025  
**Status**: ✅ Produção (https://grupowin.site)  
**Versão**: 1.0.0

---

## 📋 Índice

1. [Deployment Automático (Recomendado)](#deployment-automático)
2. [Deployment Manual](#deployment-manual)
3. [Configuração SSL/HTTPS](#configuração-sslhttps)
4. [Troubleshooting](#troubleshooting)
5. [Rollback](#rollback)

---

## 🤖 Deployment Automático (Recomendado)

### Pré-requisitos
- VPS com Ubuntu 22.04+ 
- Acesso SSH como root
- Domínio apontado para IP da VPS

### Executar Deploy

```bash
# Conectar à VPS
ssh root@72.60.147.56

# Executar script de deployment
curl -fsSL https://raw.githubusercontent.com/VitorManoel007/win-veicular-landing/main/deploy-vps-v2.sh | bash
```

**O que o script faz:**
1. ✅ Verifica permissões (root)
2. ✅ Cria diretório `/srv/win-veicular-landing`
3. ✅ Clona repositório público
4. ✅ Para containers antigos
5. ✅ Faz build Docker
6. ✅ Inicia containers (porta 5003)
7. ✅ Testa conexão
8. ✅ Guia para próximos passos

---

## 🔧 Deployment Manual

Se preferir controlar cada passo:

### 1. Conectar à VPS
```bash
ssh root@72.60.147.56
cd /srv/win-veicular-landing
```

### 2. Atualizar código
```bash
git pull origin main
```

### 3. Parar containers antigos
```bash
docker-compose down --remove-orphans
docker network prune -f
sleep 3
```

### 4. Build Docker
```bash
docker-compose build --no-cache
```

### 5. Iniciar containers
```bash
docker-compose up -d
sleep 5
docker-compose ps
```

### 6. Testar acesso
```bash
curl -I http://localhost:5003
curl -I http://72.60.147.56
```

---

## 🔒 Configuração SSL/HTTPS

### Automaticamente (Recomendado)

```bash
cd /srv/win-veicular-landing

# 1. Parar nginx
systemctl stop nginx
sleep 2

# 2. Gerar certificado
certbot certonly --standalone \
  -d grupowin.site \
  -d www.grupowin.site \
  --non-interactive \
  --agree-tos \
  --email admin@grupowin.site

# 3. Configurar nginx com SSL
cat > /etc/nginx/sites-available/grupowin.site << 'EOF'
# HTTP → HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name grupowin.site www.grupowin.site _;
    
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    
    location / {
        return 301 https://$server_name$request_uri;
    }
}

# HTTPS com SSL
server {
    listen 443 ssl http2 default_server;
    listen [::]:443 ssl http2 default_server;
    server_name grupowin.site www.grupowin.site _;

    ssl_certificate /etc/letsencrypt/live/grupowin.site/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/grupowin.site/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location / {
        proxy_pass http://127.0.0.1:5003;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# 4. Testar nginx
nginx -t

# 5. Iniciar nginx
systemctl start nginx
systemctl enable nginx

# 6. Auto-renovação SSL
(crontab -l 2>/dev/null | grep -v "certbot renew"; echo "0 3 * * * certbot renew --quiet && systemctl reload nginx") | crontab -

echo "✅ SSL configurado com sucesso!"
```

### Testar HTTPS
```bash
curl -I https://grupowin.site
curl -I https://72.60.147.56
```

---

## 📊 Monitoramento

### Verificar Status

```bash
# Status dos containers
docker-compose ps

# Logs em tempo real
docker-compose logs -f

# Verificar porta 5003
lsof -i :5003

# Verificar nginx
systemctl status nginx
tail -50 /var/log/nginx/error.log
```

### Health Checks

```bash
# Container health
docker-compose ps | grep healthy

# HTTP response
curl -I http://72.60.147.56:5003

# HTTPS response
curl -I https://grupowin.site
```

---

## 🔄 Atualizações

### Atualizar código + restart

```bash
cd /srv/win-veicular-landing

# Pull das mudanças
git pull origin main

# Rebuild (se houver mudanças no Dockerfile)
docker-compose build --no-cache

# Restart
docker-compose restart

# Ou: restart com rebuild
docker-compose up -d --build
```

### Rollback para versão anterior

```bash
cd /srv/win-veicular-landing

# Ver histórico
git log --oneline | head -10

# Voltar para commit anterior
git reset --hard HEAD~1

# Ou para commit específico
git reset --hard a47a0d3

# Rebuild e restart
docker-compose build --no-cache
docker-compose up -d
```

---

## 🐛 Troubleshooting

### Container não inicia

```bash
# Ver erro completo
docker-compose logs

# Limpar e recomeçar
docker-compose down -v
docker system prune -a -f
docker-compose build --no-cache
docker-compose up -d
```

### Porta 5003 em uso

```bash
# Ver o que está usando
lsof -i :5003

# Matar processo (se necessário)
kill -9 <PID>

# Ou parar containers
docker-compose down
```

### Nginx não faz proxy

```bash
# Testar config
nginx -t

# Reload
systemctl reload nginx

# Ver logs
tail -100 /var/log/nginx/error.log
```

### SSL com erro "certificate not found"

```bash
# Verificar certificados
ls -la /etc/letsencrypt/live/grupowin.site/

# Regenerar se necessário
certbot delete --cert-name grupowin.site
certbot certonly --standalone -d grupowin.site -d www.grupowin.site
```

### Certificado expirado

```bash
# Renovar manualmente
certbot renew --force-renewal

# Reload nginx
systemctl reload nginx

# Verificar validade
certbot certificates
```

---

## 🔐 Segurança

### Firewall (UFW)

```bash
# Habilitar
ufw enable

# Abrir portas necessárias
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS

# Ver status
ufw status
```

### Backup

```bash
# Backup do projeto
tar -czf win-veicular-backup-$(date +%Y%m%d).tar.gz /srv/win-veicular-landing

# Backup de certificados
tar -czf ssl-backup-$(date +%Y%m%d).tar.gz /etc/letsencrypt
```

---

## 📈 Performance

### Otimizações em Produção

```bash
# Verificar tamanho das imagens
docker images | grep win-veicular

# Limpar imagens não utilizadas
docker image prune -a -f

# Verificar espaço em disco
df -h

# Verificar uso de memória
docker stats win-veicular-landing
```

### Escalar se necessário

```bash
# Aumentar workers nginx (em /etc/nginx/nginx.conf)
worker_processes auto;

# Aumentar conexões
worker_connections 2048;

# Reload
systemctl reload nginx
```

---

## ✅ Checklist Pós-Deploy

- [ ] Container está UP e healthy
- [ ] HTTP responde na porta 5003
- [ ] Nginx faz reverse proxy para porta 5003
- [ ] HTTPS funciona sem avisos
- [ ] Certificado SSL válido
- [ ] DNS configurado para domínio
- [ ] Auto-renovação SSL configurada
- [ ] Backups agendados
- [ ] Monitoramento ativo

---

## 📞 Contatos & Suporte

**Projeto**: Win Veicular Landing  
**Repositório**: https://github.com/VitorManoel007/win-veicular-landing  
**VPS**: 72.60.147.56  
**Domínio**: grupowin.site

---

**Última atualização**: 13 de Dezembro de 2025
