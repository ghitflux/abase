# PASSO 5 - Design System shadcn-like + Funcionalidades Avançadas

## 📋 Objetivo do Passo 5

Incorporar a padronização do Design System no estilo shadcn/ui (tema dark com destaque #682D44) e "componentes shadcn-like" prontos para Django + Tailwind (sem React).

**Nota:** O shadcn/ui oficial é para React. Replicamos a anatomia, tokens e classes do shadcn/ui em CSS utilitário + partials HTML, mantendo comportamento com HTMX/Alpine. Visual e usabilidade ficam equivalentes, sem mudar a arquitetura Django.

## 🎨 5.0 Preparar Design System (tokens + componentes)

### 5.0.1 Configuração do Tailwind com tokens shadcn

**Arquivo:** `tailwind.config.js`

```javascript
module.exports = {
  content: ["./templates/**/*.html", "./apps/**/*.html", "./apps/**/*.py"],
  darkMode: ["class"], // força .dark
  theme: {
    container: { center: true, padding: "1rem" },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: { DEFAULT: "hsl(var(--primary))", foreground: "hsl(var(--primary-foreground))" },
        secondary:{ DEFAULT: "hsl(var(--secondary))",foreground:"hsl(var(--secondary-foreground))"},
        destructive:{ DEFAULT: "hsl(var(--destructive))",foreground:"hsl(var(--destructive-foreground))"},
        muted: { DEFAULT:"hsl(var(--muted))", foreground:"hsl(var(--muted-foreground))" },
        accent:{ DEFAULT:"hsl(var(--accent))", foreground:"hsl(var(--accent-foreground))" },
        popover:{ DEFAULT:"hsl(var(--popover))", foreground:"hsl(var(--popover-foreground))" },
        card:{ DEFAULT:"hsl(var(--card))", foreground:"hsl(var(--card-foreground))" },
      },
      borderRadius: { lg: "0.5rem", md: "0.375rem", sm: "0.25rem" },
      keyframes: {
        "accordion-down": { from: { height: 0 }, to: { height: "var(--radix-accordion-content-height)" } },
        "accordion-up": { from: { height: "var(--radix-accordion-content-height)" }, to: { height: 0 } },
      },
      animation: { "accordion-down": "accordion-down 0.2s ease-out", "accordion-up":"accordion-up 0.2s ease-out" },
    },
  },
  plugins: [],
};
```

### 5.0.2 Tokens de Cor shadcn (tema dark)

**Arquivo:** `static/css/shadcn.css`

```css
/* Tokens no padrão shadcn/ui - tema dark com primária #682D44 */
:root {
  --radius: 0.5rem;
  /* base (para light, caso necessário no futuro) */
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  --muted: 210 40% 96.1%;
  --muted-foreground: 215.4 16.3% 46.9%;
  --popover: 0 0% 100%;
  --popover-foreground: 222.2 84% 4.9%;
  --card: 0 0% 100%;
  --card-foreground: 222.2 84% 4.9%;
  --border: 214.3 31.8% 91.4%;
  --input: 214.3 31.8% 91.4%;
  --primary: 338 41% 29%; /* #682D44 em HSL aproximado */
  --primary-foreground: 355 100% 97%;
  --secondary: 210 40% 96.1%;
  --secondary-foreground: 222.2 47.4% 11.2%;
  --accent: 210 40% 96.1%;
  --accent-foreground: 222.2 47.4% 11.2%;
  --destructive: 0 84% 60%;
  --destructive-foreground: 0 0% 98%;
  --ring: 338 41% 29%;
}

.dark {
  --background: 240 10% 4%;
  --foreground: 0 0% 95%;
  --muted: 240 3.7% 15.9%;
  --muted-foreground: 240 5% 64.9%;
  --popover: 240 10% 4%;
  --popover-foreground: 0 0% 95%;
  --card: 240 10% 7%;
  --card-foreground: 0 0% 95%;
  --border: 240 3.7% 15.9%;
  --input: 240 3.7% 15.9%;
  --primary: 338 41% 29%;           /* ABASE vinho (#682D44) */
  --primary-foreground: 0 0% 98%;
  --secondary: 240 3.7% 15.9%;
  --secondary-foreground: 0 0% 98%;
  --accent: 240 3.7% 15.9%;
  --accent-foreground: 0 0% 98%;
  --destructive: 0 62.8% 30.6%;
  --destructive-foreground: 0 0% 98%;
  --ring: 338 41% 29%;
}

/* Componentes shadcn-like (HTML server-rendered) */
.btn{ @apply inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-50 disabled:pointer-events-none h-10 px-4 py-2; }
.btn-primary{ @apply bg-primary text-primary-foreground hover:opacity-90; }
.btn-secondary{ @apply bg-secondary text-secondary-foreground hover:bg-secondary/80; }
.btn-outline{ @apply border border-input bg-transparent hover:bg-accent hover:text-accent-foreground; }
.btn-ghost{ @apply hover:bg-accent hover:text-accent-foreground; }
.btn-destructive{ @apply bg-destructive text-destructive-foreground hover:bg-destructive/90; }

.input{ @apply flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring; }
.textarea{ @apply w-full min-h-[80px] rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring; }
.select{ @apply h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground; }
.label{ @apply text-sm text-muted-foreground mb-1; }
.badge{ @apply inline-flex items-center rounded-md border px-2 py-0.5 text-xs font-semibold transition-colors; }

.card{ @apply rounded-lg border border-border bg-card text-card-foreground shadow-sm; }
.card-body{ @apply p-4; }
.card-header{ @apply p-4 border-b border-border; }
.card-title{ @apply text-lg font-semibold; }
.card-desc{ @apply text-sm text-muted-foreground; }

.table{ @apply w-full text-sm; }
.table th{ @apply text-left text-muted-foreground border-b border-border py-2; }
.table td{ @apply border-b border-border/50 py-2; }

.tabs{ @apply flex items-center gap-2; }
.tab{ @apply inline-flex items-center rounded-md border border-transparent px-3 py-2 text-sm hover:bg-accent hover:text-accent-foreground; }
.tab-active{ @apply bg-primary text-primary-foreground; }

.alert{ @apply rounded-md border border-border p-4; }
.alert-title{ @apply font-medium mb-1; }
.alert-desc{ @apply text-sm text-muted-foreground; }

.dialog-backdrop{ @apply fixed inset-0 bg-black/50 z-40 hidden; }
.dialog{ @apply fixed z-50 inset-0 flex items-center justify-center p-4; }
.dialog-panel{ @apply w-full max-w-lg rounded-lg border border-border bg-popover text-popover-foreground shadow-lg; }
.dialog-actions{ @apply p-4 border-t border-border flex justify-end gap-2; }
```

### 5.0.3 Importar CSS no bundle Tailwind

**Arquivo:** `assets/tailwind.css`

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@import "../static/css/shadcn.css"; /* importa tokens + componentes */
```

### 5.0.4 Base HTML em modo dark + Lucide (ícones)

**Arquivo:** `templates/base.html`

```html
<!doctype html>
<html lang="pt-BR" class="dark h-full"> <!-- força dark -->
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>{% block title %}ABASE{% endblock %}</title>
  <link rel="stylesheet" href="/static/css/app.css">
  <script src="https://unpkg.com/htmx.org@1.9.12"></script>
  <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
  <script defer src="https://unpkg.com/lucide@latest"></script>
</head>
<body class="min-h-full bg-background text-foreground">
  <div class="flex">
    {% include "partials/sidebar.html" %}
    <main class="flex-1">
      {% include "partials/header.html" %}
      <div class="p-6 max-w-[1400px] mx-auto">{% block content %}{% endblock %}</div>
    </main>
  </div>

  <!-- Dialog container padrão shadcn-like -->
  <div id="modal-backdrop" class="dialog-backdrop"></div>
  <div id="modal" class="dialog hidden">
    <div class="dialog-panel">
      <div id="modal-body" class="card-body"></div>
      <div class="dialog-actions">
        <button class="btn-secondary" onclick="closeDialog()">Fechar</button>
      </div>
    </div>
  </div>

  <script>
    // Lucide Icons
    document.addEventListener('DOMContentLoaded', ()=>{ 
      if(window.lucide){ lucide.createIcons(); }
    });

    // Dialog helpers (shadcn-like)
    const backdrop = document.getElementById('modal-backdrop');
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    
    function openDialog(html){ 
      modalBody.innerHTML = html; 
      backdrop.classList.remove('hidden'); 
      modal.classList.remove('hidden'); 
    }
    
    function closeDialog(){ 
      modalBody.innerHTML = ""; 
      backdrop.classList.add('hidden'); 
      modal.classList.add('hidden'); 
    }

    // Abrir automaticamente quando partial cair no alvo #modal-body via HTMX
    document.body.addEventListener('htmx:afterOnLoad', function(evt){
      if(evt.detail.target.id === 'modal-body'){ 
        backdrop.classList.remove('hidden'); 
        modal.classList.remove('hidden'); 
      }
    });
  </script>
</body>
</html>
```

## 🔧 Funcionalidades Implementadas

### 5.1 Uploads Privados
- Storage seguro com validação
- Interface de modal para upload
- Sistema de rascunhos
- Controle de acesso por usuário

### 5.2 Mini Dashboards (KPIs)
- Cards com métricas em tempo real
- Layout responsivo
- Cores consistentes com design system

### 5.3 Importador TXT
- Interface para upload de arquivos
- Processamento idempotente
- Feedback visual do processo
- Histórico de importações

### 5.4 Modais Interativos
- Sistema de dialogs shadcn-like
- Integração com HTMX
- Animações suaves
- Controle por JavaScript

### 5.5 Componentes UI
- Tabelas responsivas
- Sistema de tabs
- Filtros avançados
- Paginação integrada

## 🚀 Como Executar

1. **Compile o CSS:**
```bash
npx tailwindcss -i ./assets/tailwind.css -o ./static/css/app.css --watch
```

2. **Inicie o Django:**
```bash
python manage.py runserver
```

3. **Acesse as funcionalidades:**
- Sistema principal: http://localhost:8000
- Interface de admin: http://localhost:8000/admin

## ✅ Checklist de Implementação

- [x] Configuração Tailwind com tokens shadcn
- [x] CSS com componentes shadcn-like
- [x] Base HTML com tema dark
- [x] Integração Lucide Icons
- [x] Sistema de modais
- [x] Uploads privados
- [ ] Mini dashboards
- [ ] Importador TXT
- [ ] Tabelas e filtros
- [ ] Testes de integração

## 🔄 Próximos Passos

Após completar o Passo 5, seguir para o **Passo 6**:
- Sistema de testes automatizados
- CI/CD pipeline
- Documentação de API
- Deploy em ambiente de produção

---

**Status:** Em Implementação  
**Data de Início:** 11/09/2025  
**Responsável:** Equipe ABASE