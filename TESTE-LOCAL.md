# Teste Local com Docker

Guia para testar a aplicação em um ambiente local antes de fazer deploy na VPS.

## Pré-requisitos

- Docker Desktop instalado ([Download](https://www.docker.com/products/docker-desktop))
- Git
- Terminal/CMD

## Passos para Testar Localmente

### 1. Clonar e Entrar no Projeto

```bash
git clone <seu-repositorio> win-veicular-landing
cd win-veicular-landing
```

### 2. Construir a Imagem Docker

```bash
# Build da imagem
docker build -t win-veicular:latest .

# Verificar se foi criada
docker images | grep win-veicular
```

Saída esperada:
```
REPOSITORY           TAG       IMAGE ID      CREATED              SIZE
win-veicular        latest    abc123def456   About a minute ago   150MB
```

### 3. Testar Rodando com Docker Run (Simples)

Para testar rapidamente sem docker-compose:

```bash
# Rodar container
docker run -d --name win-veicular-test -p 3000:3000 win-veicular:latest

# Verificar se está rodando
docker ps

# Ver logs
docker logs -f win-veicular-test

# Abrir no navegador
# Windows/Mac: http://localhost:3000
# Linux: curl http://localhost:3000
```

Saída esperada dos logs:
```
   ┌─────────────────────────────────────┐
   │   Accepting connections at http://localhost:3000   │
   └─────────────────────────────────────┘
```

### 4. Parar e Limpar (Docker Run)

```bash
# Parar container
docker stop win-veicular-test

# Remover container
docker rm win-veicular-test
```

### 5. Testar Completo com Docker Compose (Recomendado)

Para testar a configuração final como estará na VPS:

#### 5a. Preparar Ambiente

```bash
# Criar diretórios necessários
mkdir -p certs logs

# Criar certificados auto-assinados para teste (opcional)
# Você pode usar certificados reais ou deixar comentado no nginx.conf
```

#### 5b. Modificar nginx.conf para Teste Local

Se estiver testando com HTTP (sem SSL):

```bash
# Editar nginx.conf - comentar as linhas SSL
# Ou criar um arquivo nginx-dev.conf
```

Alternativa: Editar `docker-compose.yml` para teste:

```bash
# Opção 1: Usar porta HTTP diretamente (modificar docker-compose.yml)
# Mudar:  "80:80" e "443:443"
# Para:   "80:80" (remover 443)
```

#### 5c. Iniciar com Docker Compose

```bash
# Build e iniciar
docker-compose up -d

# Ver status
docker-compose ps

# Ver logs
docker-compose logs -f
```

Saída esperada:
```
NAME                 COMMAND                  SERVICE    STATUS
win-veicular-nginx   "/docker-entrypoint.…"   nginx      Up 2 seconds
win-veicular-land… "serve -s dist -l 300…"   win-veicular   Up 2 seconds
```

#### 5d. Acessar a Aplicação

```bash
# Abrir em seu navegador
http://localhost

# Ou via curl
curl -v http://localhost
```

#### 5e. Ver Logs em Tempo Real

```bash
# Logs da aplicação
docker-compose logs -f win-veicular

# Logs do Nginx
docker-compose logs -f nginx

# Logs de tudo
docker-compose logs -f
```

#### 5f. Parar Tudo

```bash
# Parar containers
docker-compose stop

# Remover containers e networks
docker-compose down

# Remover também volumes
docker-compose down -v
```

## Testes Funcionais

### Verificar se Aplicação Está Respondendo

```bash
# Health check manual
curl -v http://localhost:3000

# Esperado: HTTP/1.1 200 OK
```

### Testar Cache de Assets

```bash
# Primeiro request
curl -I http://localhost:3000/index.html

# Ver header Cache-Control
# Esperado: Cache-Control: no-cache, no-store, must-revalidate
```

### Testar React Router

```bash
# Acessar rota inexistente
curl http://localhost/rota-inexistente/teste

# Esperado: Retorna index.html (fallback para SPA)
```

## Troubleshooting Local

### Erro: Port already in use

Se a porta 3000 ou 80 já está em uso:

```bash
# Mudar porta no docker-compose.yml
# De: "80:80" para "8080:80"
# De: "3000:3000" para "3001:3000"

# Ou matar processo usando a porta
# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Mac/Linux:
lsof -i :3000
kill -9 <PID>
```

### Erro: Cannot find module

```bash
# Rebuildar sem cache
docker-compose build --no-cache

# Ou deletar tudo e recomeçar
docker-compose down -v
rm -rf node_modules
docker-compose build --no-cache
docker-compose up -d
```

### Aplicação não carrega

```bash
# Ver logs detalhados
docker-compose logs win-veicular
docker-compose logs nginx

# Verificar se container está rodando
docker-compose ps

# Entrar no container para debugar
docker-compose exec win-veicular sh
```

### 502 Bad Gateway no Nginx

```bash
# Verificar se serviço win-veicular está respondendo
docker-compose exec nginx wget http://win-veicular:3000

# Ver logs do nginx
docker-compose logs nginx
```

## Validação Pré-Deploy

Checklist antes de fazer deploy na VPS:

- [ ] `docker build -t win-veicular:latest .` funciona sem erros
- [ ] `docker-compose up -d` inicia sem erros
- [ ] `docker-compose ps` mostra 2 containers rodando (nginx + app)
- [ ] `curl http://localhost` retorna HTML com status 200
- [ ] Acessar `http://localhost` no navegador mostra a landing page
- [ ] Cliques no WhatsApp abrem link correto
- [ ] Assets (JS, CSS, imagens) carregam corretamente
- [ ] Não há erros no console do navegador (F12)
- [ ] `docker-compose logs` mostra logs limpos (sem erros)
- [ ] `docker-compose down` remove tudo corretamente

## Diferenças Local vs VPS

| Aspecto | Local | VPS |
|---------|-------|-----|
| SSL/TLS | Opcional (HTTP) | Obrigatório |
| Domínio | localhost | seu-dominio.com |
| Certificados | Não precisa | Certbot Let's Encrypt |
| Portas | 80, 3000, 443 livres | 80, 443 podem ter conflitos |
| Volumes | ./certs, ./logs | /srv/win-veicular/certs, logs |
| Firewall | Não | Configurar ufw/iptables |

## Debug Avançado

### Entrar no Container

```bash
# Na aplicação
docker-compose exec win-veicular sh

# Dentro do container:
ls -la       # Ver arquivos
cat dist/index.html  # Ver HTML gerado
```

### No Nginx

```bash
# Entrar no nginx
docker-compose exec nginx sh

# Dentro do container:
cat /etc/nginx/nginx.conf
curl http://win-veicular:3000  # Testar conexão com app
```

### Ver Recursos Usados

```bash
# CPU, memória, I/O
docker stats

# Espaço em disco
docker system df
```

## Próximos Passos

Se tudo funcionar localmente:

1. Commit e push do código
2. Seguir instruções em [DEPLOY.md](./DEPLOY.md) para VPS
3. Testar em staging antes de produção

Dúvidas? Veja o arquivo DEPLOY.md para deploy em produção.
