# Sistema ABASE - Documentação Completa

## 📋 Índice
- [Visão Geral do Projeto](#visão-geral-do-projeto)
- [Arquitetura](#arquitetura)
- [Estado Atual](#estado-atual)
- [Roadmap de Desenvolvimento](#roadmap-de-desenvolvimento)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Como Executar](#como-executar)

## 🎯 Visão Geral do Projeto

**Nome:** ABASE  
**Tipo:** Sistema de gestão empresarial  
**Framework:** Django 4.2  
**Database:** PostgreSQL  
**Frontend:** Django Templates + Tailwind CSS + HTMX + Alpine.js  
**Design System:** shadcn-like (dark theme com cor primária #682D44)

### Objetivo
Sistema completo de gestão empresarial com módulos de:
- Autenticação e controle de acesso
- Cadastros de pessoas e entidades
- Gestão financeira
- Sistema de auditoria
- Geração de relatórios
- Upload e gestão de documentos privados

## 🏗️ Arquitetura

### Estrutura de Apps Django
```
apps/
├── accounts/          # Autenticação, usuários e permissões
├── auditoria/         # Logs e trilha de auditoria
├── cadastros/         # Gestão de pessoas e entidades
├── financeiro/        # Transações e gestão financeira
└── relatorios/        # Relatórios e dashboards
```

### Stack Tecnológica
- **Backend:** Django 4.2, Python 3.12
- **Frontend:** HTML Templates, Tailwind CSS, HTMX, Alpine.js
- **Database:** PostgreSQL
- **Styling:** Design System baseado em shadcn/ui (adaptado para Django)
- **Icons:** Lucide Icons
- **Containerização:** Docker (planejado)

## 📊 Estado Atual

### ✅ Implementado (Passos 1-4)
1. **Estrutura Base Django**
   - Apps principais criadas
   - Modelos básicos definidos
   - Sistema de autenticação
   - Configurações de desenvolvimento

2. **Banco de Dados**
   - Modelos principais implementados
   - Migrações aplicadas
   - Relacionamentos estabelecidos

3. **Interface Administrativa**
   - Admin Django configurado
   - Modelos registrados
   - Filtros e buscas básicas

4. **Templates Base**
   - Layout responsivo
   - Navegação básica
   - Sistema de mensagens

### 🚧 Em Implementação (Passo 5)
**Design System shadcn-like + Funcionalidades Avançadas**
- Tokens de cor e tema dark (#682D44)
- Componentes shadcn-like para Django
- Uploads privados
- Mini dashboards com KPIs
- Importador de arquivos TXT
- Modais e diálogos interativos

### 📋 Roadmap (Passo 6+)
- Testes automatizados
- Sistema de deployment
- Documentação completa
- CI/CD pipeline
- Monitoramento e logs

## 🛠️ Configuração do Ambiente

### Pré-requisitos
- Python 3.12+
- Node.js 18+ (para Tailwind CSS)
- PostgreSQL 14+
- Git

### Instalação Local

1. **Clone o repositório:**
```bash
git clone <repository-url>
cd abasenew
```

2. **Configure o ambiente Python:**
```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# Linux/Mac
source .venv/bin/activate

pip install -r requirements.txt
```

3. **Configure o banco de dados:**
```bash
# Configure as variáveis no arquivo .env
cp .env.example .env
# Edite as configurações do banco de dados
```

4. **Configure o frontend:**
```bash
npm install
npx tailwindcss -i ./assets/tailwind.css -o ./static/css/app.css --watch
```

5. **Execute as migrações:**
```bash
python manage.py migrate
python manage.py createsuperuser
```

## 🚀 Como Executar

### Desenvolvimento
```bash
# Terminal 1 - Django
python manage.py runserver

# Terminal 2 - Tailwind CSS (watch mode)
npx tailwindcss -i ./assets/tailwind.css -o ./static/css/app.css --watch
```

### Script de Inicialização
```bash
python start_abase.py
```

Este script automaticamente:
- Verifica dependências
- Configura banco de dados
- Executa migrações
- Cria superusuário padrão (admin/admin123)
- Inicia o servidor

### Acessos
- **Sistema:** http://localhost:8000
- **Admin:** http://localhost:8000/admin
- **API:** http://localhost:8000/api/ (futuro)

## 📝 Estrutura de Arquivos

```
abasenew/
├── apps/                    # Apps Django
├── core/                    # Configurações Django
├── static/                  # Arquivos estáticos
├── templates/               # Templates HTML
├── media/                   # Uploads de usuários
├── documentos/             # Documentação do projeto
├── assets/                 # Source files (Tailwind, etc)
├── .env                    # Variáveis de ambiente
├── manage.py               # CLI Django
├── start_abase.py          # Script de inicialização
├── requirements.txt        # Dependências Python
├── package.json           # Dependências Node.js
└── tailwind.config.js     # Configuração Tailwind
```

## 🔐 Configurações de Segurança

- Chaves secretas em variáveis de ambiente
- CORS configurado
- Validação de permissões por nível de usuário
- Logs de auditoria implementados
- Uploads seguros com validação

## 📈 Próximos Passos

1. **Passo 6:** Testes automatizados e CI/CD
2. **Passo 7:** Sistema de notificações
3. **Passo 8:** API REST completa
4. **Passo 9:** Dashboard analytics
5. **Passo 10:** Deploy em produção

---

**Última atualização:** 11/09/2025  
**Versão:** 1.0.0-dev  
**Responsável:** Equipe ABASE