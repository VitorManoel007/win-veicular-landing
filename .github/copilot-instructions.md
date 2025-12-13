# Instruções para Agentes de IA - Win Veicular Landing

## Visão Geral do Projeto
Landing page de proteção veicular para o Grupo Win. Stack: **Vite + React + TypeScript + Tailwind CSS + shadcn-ui**. Aplicação estática sem backend, focada em conversão com CTAs para WhatsApp e telefone.

## Arquitetura

### Estrutura de Componentes
- **Componentes de seção** (`src/components/*.tsx`): Cada seção da landing page é um componente independente
  - `HeroSection`: Topo com pitch de valor, preço e CTAs principais
  - `BenefitsSection`, `ComparisonSection`, `PlansSection`, `UrgencySection`
  - `WhatsAppButton`: Botão flutuante fixo com link WhatsApp
  - `Footer`: Rodapé com informações e links
- **Componentes UI** (`src/components/ui/`): shadcn-ui components reutilizáveis
- **Página raiz** (`src/pages/Index.tsx`): Orquestra todas as seções

### Design System Centralizado
Tudo definido em `src/index.css` com **variáveis CSS em HSL** (`--brand-orange`, `--brand-dark`, gradientes, sombras):
```css
--brand-orange: 28 95% 54%;  /* Cor primária */
--brand-dark: 0 0% 15%;      /* Cor secundária */
--gradient-orange: linear-gradient(135deg, hsl(28 95% 54%) 0%, hsl(35 100% 60%) 100%);
```
- Tipografia: Poppins (corpo), Montserrat (títulos) - importadas via HTML
- Animações customizadas: `animate-fade-in`, `animate-scale-in` com delays

### Roteamento
React Router simples: rota `/` com fallback `*` → NotFound. Sem API routes ou backend.

## Fluxos de Desenvolvimento

### Build & Deploy
```bash
npm run dev      # Vite dev server (localhost:8080)
npm run build    # Vite build (output: dist/)
npm run lint     # ESLint + TypeScript
npm run preview  # Preview build localmente
```

### Deploy em VPS (Ubuntu 22.04)
1. **Clone e instale**: `git clone ... && cd win-veicular-landing && npm i`
2. **Build**: `npm run build`
3. **Serve**: Use Nginx/Caddy apontando para `dist/` ou Node (serve package)
4. **Domínio customizado**: Configurar via Nginx ou reverse proxy

## Padrões & Convenções

### Componentes React
- **Exports nomeados** (não default) para componentes reutilizáveis
- **Props TypeScript** implícitas via `React.FC` quando necessário
- **Sem state global**: tudo é estático, use dados hardcoded em arrays (ex: `plans`, `comparisons`)

### Estilização
- **Tailwind first**: Classes diretas, não CSS externo
- **Gradientes customizados**: Use `bg-gradient-orange` (definido em tailwind.config.ts)
- **Sombras**: `shadow-glow` (halo laranja), `shadow-strong` (sombra escura)
- **Responsividade**: Mobile-first: `grid-cols-1 md:grid-cols-3`

### CTAs & Links Internos
- **WhatsApp**: `href="https://wa.me/5511999999999"` (atualizar número conforme necessário)
- **Telefone**: `href="tel:+5511999999999"`
- **Links externos**: Sempre com `target="_blank" rel="noopener noreferrer"`

### Animações
- **Fade-in com delay**: `className="animate-fade-in" style={{ animationDelay: '0.1s' }}`
- **Scale-in**: `animate-scale-in`
- **Hover effects**: `hover:scale-105 transition-all duration-300`

## Pontos Críticos para IA

1. **Dados Hardcoded**: Planos, comparações e features estão em arrays nos componentes. Alterar dados = editar JSX, não config files.

2. **Imagens & Assets**: Importadas em `src/assets/` e referenciadas com `import logoHorizontal from "@/assets/logo-horizontal.png"`

3. **Números de Contato**: Atualize TODOS os `5511999999999` simultaneamente em:
   - `HeroSection`, `PlansSection`, `ComparisonSection`, `WhatsAppButton`

4. **Design System**: Alterar cores = `src/index.css`. Alterar spacing/radius = `tailwind.config.ts` (theme.extend)

5. **Tipografia**: Montserrat + Poppins importadas no HTML. Especificar com `font-['Montserrat']` no Tailwind.

## Comandos Úteis
- `npm run lint` para validar código antes de commit
- `npm run build:dev` para build com modo development
- Vite hot reload automático em dev - editar e salvar reflete na UI instantaneamente

## Referências
- [Vite docs](https://vite.dev)
- [Tailwind CSS](https://tailwindcss.com)
- [shadcn/ui](https://ui.shadcn.com)
- [React Router v6](https://reactrouter.com)
