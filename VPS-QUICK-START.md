# ⚡ DEPLOY RÁPIDO NA VPS

## 1️⃣ Conectar na VPS
```bash
ssh root@72.60.147.56
```

## 2️⃣ Executar Script de Deploy
```bash
curl -fsSL https://raw.githubusercontent.com/VitorManoel007/win-veicular-landing/main/deploy-vps.sh -o deploy-vps.sh
sudo bash deploy-vps.sh grupowin.site
```

## 3️⃣ Aguardar Conclusão
O script vai:
- Instalar Docker
- Clonar repositório
- Gerar SSL Let's Encrypt
- Configurar firewall
- Deixar tudo online

## 4️⃣ Acessar Site
```
https://grupowin.site
https://www.grupowin.site
```

---

## 📋 Pré-requisitos Importantes

✅ **DNS já apontado?**
- Acesse seu registrador de domínio
- Crie registro A: grupowin.site → 72.60.147.56
- Crie registro CNAME: www → grupowin.site

✅ **Portas abertas?**
- Porta 80 (HTTP) deve estar acessível
- Porta 443 (HTTPS) deve estar acessível

---

## 🆘 Se o Script Falhar

Veja o arquivo `DEPLOY-VPS.md` para passo a passo manual.

## 📝 Próximas Atualizações

Para atualizar código em produção:
```bash
cd /srv/win-veicular-landing
git pull origin main
docker-compose build --no-cache
docker-compose up -d
```

## 🔍 Ver Status
```bash
docker-compose -f /srv/win-veicular-landing/docker-compose.yml ps
docker-compose -f /srv/win-veicular-landing/docker-compose.yml logs -f
```
