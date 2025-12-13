# Win Veicular Landing Page

🚗 Landing page de proteção veicular do Grupo Win. Desenvolvida com Vite, React, TypeScript e Tailwind CSS.

**Status**: ✅ **ONLINE EM PRODUÇÃO** 
- 🌐 **URL**: https://grupowin.site
- 📍 **IP**: 72.60.147.56:5003
- 🔒 **SSL**: Let's Encrypt (HTTPS)

---

## 🚀 Quick Start - Deploy na VPS

```bash
# Deploy automático com um único comando:
curl -fsSL https://raw.githubusercontent.com/VitorManoel007/win-veicular-landing/main/DEPLOY-VPS.sh | bash
```

Veja [DEPLOYMENT.md](./DEPLOYMENT.md) para instruções detalhadas.

---

## 💻 Desenvolvimento Local

### Pré-requisitos
- Node.js 18+ & npm
- Docker & Docker Compose (opcional, para testar com containers)

### Setup

```bash
# 1. Clone o repositório
git clone https://github.com/VitorManoel007/win-veicular-landing.git
cd win-veicular-landing

# 2. Instale dependências
npm install

# 3. Inicie dev server
npm run dev

# Acesso: http://localhost:5173
```

### Desenvolvimento com Docker

```bash
# Build e inicie containers locais
docker-compose -f docker-compose.dev.yml up -d

# Acesso: http://localhost:80
```

---

## 📦 Build para Produção

```bash
# Build otimizado
npm run build

# Preview do build
npm run preview
```

---

## 🏗️ Stack Tecnológico

| Tecnologia | Versão | Propósito |
|-----------|--------|----------|
| Vite | 5.4.19 | Build tool ultra-rápido |
| React | 18.3.1 | UI framework |
| TypeScript | 5.8.3 | Type safety |
| Tailwind CSS | 3.4.17 | Utility-first styling |
| shadcn-ui | latest | Componentes headless |
| React Router | 6.30.1 | Routing SPA |
| React Hook Form | 7.61.1 | Form management |
| TanStack Query | 5.83.0 | Server state |

---

## 📁 Estrutura do Projeto

```
src/
├── components/          # Componentes React
│   ├── HeroSection.tsx
│   ├── BenefitsSection.tsx
│   ├── ComparisonSection.tsx
│   ├── PlansSection.tsx
│   ├── UrgencySection.tsx
│   ├── Footer.tsx
│   ├── WhatsAppButton.tsx
│   └── ui/             # shadcn-ui components
├── pages/              # Páginas (Index, NotFound)
├── assets/             # Imagens e arquivos estáticos
├── lib/                # Utilitários
├── hooks/              # React hooks customizados
└── index.css           # Design system CSS variables

Dockerfile             # Multi-stage production build
docker-compose.yml     # Produção (sem nginx)
docker-compose.dev.yml # Desenvolvimento (com nginx)
```

---

## 🎨 Design System

**Cores Primárias** (definidas em `src/index.css`):
- `--brand-orange: 28 95% 54%` - Laranja principal
- `--brand-dark: 0 0% 15%` - Cinza escuro
- Gradientes customizados
- Sombras específicas para o projeto

**Tipografia**:
- Headers: Montserrat (700, 800, 900)
- Body: Poppins (400, 500, 600)

---

## 🚀 Deployment

### Local (Docker Compose)
```bash
docker-compose -f docker-compose.dev.yml up -d
# Acesso: http://localhost
```

### Produção (VPS)
```bash
# Opção 1: Deploy automático
curl -fsSL https://raw.githubusercontent.com/VitorManoel007/win-veicular-landing/main/DEPLOY-VPS.sh | bash

# Opção 2: Manual
cd /srv/win-veicular-landing
git pull origin main
docker-compose build --no-cache
docker-compose up -d
```

**Configuração Nginx**: Reverse proxy na porta 5003
**SSL**: Let's Encrypt (auto-renovação diária)

Veja [DEPLOYMENT.md](./DEPLOYMENT.md) para guia completo.

---

## 🔧 Comandos Disponíveis

```bash
npm run dev        # Iniciar servidor de desenvolvimento
npm run build      # Build para produção
npm run preview    # Preview do build
npm run lint       # Validar código (ESLint + TypeScript)
npm run type-check # Verificar tipos TypeScript
```

---

## 📝 Commits Importantes

| Commit | Descrição |
|--------|-----------|
| `b24fa24` | Add development environment + local test results |
| `371d54e` | Remove nginx from production docker-compose |
| `abbfaa9` | Change port to 5003 (avoid conflicts) |
| `f227faf` | Improve Dockerfile with build verification |
| `a47a0d3` | Add final VPS deployment script |

---

## 🐛 Troubleshooting

### Porta 5003 em uso?
```bash
lsof -i :5003
docker-compose down
```

### Certificado SSL expirado?
```bash
certbot renew --force-renewal
systemctl reload nginx
```

### Limpar tudo e recomeçar?
```bash
docker-compose down -v
rm -rf certs logs
git pull origin main
docker-compose build --no-cache
docker-compose up -d
```

---

## 📚 Documentação Adicional

- [DEPLOYMENT.md](./DEPLOYMENT.md) - Guia completo de deployment
- [.github/copilot-instructions.md](./.github/copilot-instructions.md) - Instruções para IA/agentes
- [VPS-DEPLOYMENT-FIX.md](./VPS-DEPLOYMENT-FIX.md) - Troubleshooting VPS

---

## 📞 Contatos Integrados

- **WhatsApp**: Botão flutuante com link para conversa
- **Telefone**: CTA com número de suporte
- **Email**: Configurável em `.env` (futuro)

---

## 🔐 Segurança

- ✅ HTTPS/SSL obrigatório em produção
- ✅ Headers de segurança (HSTS, X-Frame-Options, etc)
- ✅ CORS configurado adequadamente
- ✅ Dados estáticos (sem API sensível)

---

## 📄 Licença

Propriedade do Grupo Win. Todos os direitos reservados.

---

**Última atualização**: 13 de Dezembro de 2025
**Status**: ✅ Em Produção
**Porta**: 5003 (Docker) → 80/443 (Nginx)

## Deploy em VPS

Veja [DEPLOY.md](./DEPLOY.md) para instruções completas de deploy em uma VPS Ubuntu 22.04.
