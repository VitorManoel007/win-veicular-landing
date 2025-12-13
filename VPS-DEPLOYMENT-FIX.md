# Fix de Deployment - Win Veicular Landing na VPS

## Problema
A porta 3000 já está em uso por outro container (SingulAI).

## Solução Rápida (Execute na VPS)

### Opção 1: Liberar Porta e Reiniciar (RECOMENDADO)

```bash
# 1. Conectar à VPS
ssh root@72.60.147.56

# 2. Navegar para o diretório
cd /srv/win-veicular-landing

# 3. Parar todos os containers Win Veicular
docker-compose down

# 4. Remover redes órfãs
docker network prune -f

# 5. Aguardar 5 segundos
sleep 5

# 6. Verificar se porta está livre
lsof -i :3000

# 7. Reiniciar containers
docker-compose up -d --remove-orphans

# 8. Verificar status
docker-compose ps

# 9. Testar (aguarde 5-10 segundos)
curl http://localhost:3000
```

### Opção 2: Usar Porta Diferente

Se houver conflito persistente, você pode modificar a porta:

```bash
# Editar docker-compose.yml
nano /srv/win-veicular-landing/docker-compose.yml
```

Mudar:
```yaml
# DE:
ports:
  - "3000:3000"

# PARA:
ports:
  - "3001:3000"
```

Depois reiniciar:
```bash
docker-compose up -d --remove-orphans
docker-compose ps
```

---

## Próximo Passo: Configurar SSL com Let's Encrypt

Após containers estarem rodando:

```bash
# 1. Parar nginx temporariamente
docker-compose stop nginx

# 2. Gerar certificado SSL
certbot certonly --standalone \
    -d grupowin.site \
    -d www.grupowin.site \
    --non-interactive \
    --agree-tos \
    --email admin@grupowin.site

# 3. Copiar certificados
mkdir -p /srv/win-veicular-landing/certs
sudo cp /etc/letsencrypt/live/grupowin.site/fullchain.pem /srv/win-veicular-landing/certs/
sudo cp /etc/letsencrypt/live/grupowin.site/privkey.pem /srv/win-veicular-landing/certs/
sudo chown -R 1000:1000 /srv/win-veicular-landing/certs

# 4. Reiniciar nginx com SSL
docker-compose up -d nginx

# 5. Verificar status
docker-compose ps
curl -I https://grupowin.site
```

---

## Verificar Saúde do Serviço

```bash
# Ver logs em tempo real
docker-compose logs -f

# Verificar apenas container da app
docker-compose logs -f win-veicular

# Verificar apenas nginx
docker-compose logs -f nginx

# Status completo
docker-compose ps

# Testar acesso
curl http://localhost
curl http://localhost/index.html
```

---

## Troubleshooting

### Porta 3000 ainda em uso?
```bash
# Ver qual processo está usando a porta
lsof -i :3000

# Forçar parada (último recurso)
docker kill $(docker ps -q) || true
docker-compose up -d --remove-orphans
```

### Docker não encontrado?
```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
apt-get install -y docker-compose
```

### Sem espaço em disco?
```bash
# Limpar imagens não usadas
docker image prune -a -f

# Limpar volumes órfãos
docker volume prune -f

# Ver espaço disponível
df -h
```

---

## Comandos Úteis

```bash
# Entrar dentro do container (debug)
docker-compose exec win-veicular sh

# Rebuild sem cache
docker-compose build --no-cache

# Parar serviços
docker-compose stop

# Remover tudo (limpar)
docker-compose down -v

# Ver histórico de logs
docker-compose logs -f --tail=100
```

---

## Status Final Esperado

```
NAME                      COMMAND                     STATE               PORTS
win-veicular-landing      docker-entrypoint.sh ...    Up (healthy)        0.0.0.0:3000->3000/tcp
win-veicular-nginx        /docker-entrypoint.sh ...   Up                  0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp
```

---

## Dúvidas?

Se ainda houver problemas, colete informações:
```bash
docker-compose ps
docker-compose logs | head -50
docker ps -a
lsof -i :3000
lsof -i :80
lsof -i :443
```

E compartilhe comigo! 🚀
