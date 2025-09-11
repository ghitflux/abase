# 📘 Guia de Utilização dos Scripts - Sistema ABASE

## 🎯 Visão Geral

O sistema ABASE inclui scripts automatizados para facilitar o desenvolvimento, testes e versionamento. Este documento explica como usar cada script disponível.

## 📂 Scripts Disponíveis

### 1. `start_abase.py` - Inicializador do Sistema

**Localização:** Raiz do projeto
**Função:** Inicializa o sistema completo com verificações automáticas

```bash
python start_abase.py
```

**O que faz:**
- ✅ Verifica dependências Python
- ✅ Testa conexão com banco de dados
- ✅ Executa migrações se necessário
- ✅ Cria superusuário padrão (admin/admin123)
- ✅ Inicia servidor Django
- ✅ Abre navegador automaticamente

**Quando usar:**
- Primeira execução do projeto
- Após clonar o repositório
- Para iniciar rapidamente o ambiente de desenvolvimento

### 2. `scripts/test_runner.py` - Testes Automatizados

**Localização:** `scripts/test_runner.py`
**Função:** Executa bateria completa de testes

```bash
# Executar todos os testes
python scripts/test_runner.py

# Ou com mais verbosidade
python scripts/test_runner.py --verbose
```

**Testes Executados:**
1. **Verificação de Ambiente**
   - Dependências instaladas
   - Configuração do banco
   - Estrutura de arquivos

2. **Qualidade de Código**
   - PEP8 compliance (flake8)
   - Imports não utilizados (autoflake)
   - Análise estática

3. **Segurança**
   - Django security checks
   - Verificação de credenciais hardcoded
   - Configurações de produção

4. **Testes Django**
   - Unit tests de todas as apps
   - Testes de integração
   - Validação de modelos

5. **Frontend**
   - Compilação CSS/Tailwind
   - Validação de assets
   - Verificação de templates

6. **Cobertura de Código**
   - Análise de coverage
   - Relatório HTML gerado
   - Métricas de qualidade

**Saída do Script:**
- Relatório detalhado no terminal
- Arquivo de relatório em `documentos/test_reports/`
- Relatório HTML de coverage em `htmlcov/`

### 3. `scripts/git_manager.py` - Gerenciamento de Versionamento

**Localização:** `scripts/git_manager.py`
**Função:** Automatiza commits e push para GitHub

#### Modo Interativo (Recomendado)
```bash
python scripts/git_manager.py
```

**Processo interativo:**
1. Verifica arquivos modificados
2. Detecta arquivos protegidos (credenciais)
3. Solicita mensagem de commit
4. Opção de executar testes antes do commit
5. Executa commit com mensagem padronizada
6. Opção de push para GitHub

#### Modo Rápido
```bash
# Commit e push rápidos
python scripts/git_manager.py quick "feat: adicionar nova funcionalidade"

# Sem executar testes
python scripts/git_manager.py quick "fix: correção rápida" --skip-tests
```

#### Verificar Status
```bash
python scripts/git_manager.py status
```

**Recursos de Segurança:**
- 🛡️ Detecta credenciais hardcoded
- 🛡️ Verifica arquivos sensíveis (.env, .key, etc.)
- 🛡️ Atualiza .gitignore automaticamente
- 🛡️ Executa testes antes do commit
- 🛡️ Mensagens padronizadas com assinatura

## 🔧 Scripts de Build e Deploy

### Compilação de CSS
```bash
# Compilar uma vez
npm run build-css

# Watch mode (desenvolvimento)
npm run watch-css

# Build para produção (minificado)
npm run build-css-prod
```

### Comandos Django Úteis
```bash
# Verificar projeto
python manage.py check

# Executar migrações
python manage.py migrate

# Criar superusuário
python manage.py createsuperuser

# Coletar arquivos estáticos
python manage.py collectstatic

# Shell Django
python manage.py shell
```

## 📊 Exemplos de Uso Prático

### Fluxo de Desenvolvimento Diário

1. **Iniciar o dia:**
```bash
# Atualizar repositório
git pull origin master

# Iniciar ambiente
python start_abase.py
```

2. **Durante desenvolvimento:**
```bash
# Em terminal separado - CSS watch
npm run watch-css

# Fazer alterações no código...
```

3. **Antes de commit:**
```bash
# Executar testes
python scripts/test_runner.py

# Commit interativo
python scripts/git_manager.py
```

### Fluxo para Nova Feature

1. **Criar branch:**
```bash
git checkout -b feature/nova-funcionalidade
```

2. **Desenvolver feature:**
```bash
# Trabalhar no código...
# Testar localmente
python manage.py runserver
```

3. **Testar e commitar:**
```bash
# Testes completos
python scripts/test_runner.py

# Commit da feature
python scripts/git_manager.py quick "feat: implementar nova funcionalidade"
```

4. **Merge para master:**
```bash
git checkout master
git merge feature/nova-funcionalidade
python scripts/git_manager.py quick "merge: nova funcionalidade"
```

### Preparação para Deploy

1. **Testes finais:**
```bash
# Bateria completa de testes
python scripts/test_runner.py

# Build de produção
npm run build-css-prod
python manage.py collectstatic
```

2. **Commit de release:**
```bash
python scripts/git_manager.py quick "release: versão 1.0.0"
```

## ⚙️ Configuração dos Scripts

### Dependências Opcionais (Recomendadas)

Para funcionalidades avançadas de qualidade de código:

```bash
pip install flake8 autoflake coverage bandit
```

**Benefícios:**
- `flake8`: Verificação PEP8 e qualidade de código
- `autoflake`: Remove imports não utilizados
- `coverage`: Análise de cobertura de testes
- `bandit`: Análise de segurança

### Configuração do Editor

Para melhor integração com IDEs:

**VS Code (`.vscode/settings.json`):**
```json
{
  "python.defaultInterpreterPath": "./.venv/Scripts/python",
  "python.formatting.provider": "black",
  "python.linting.enabled": true,
  "python.linting.flake8Enabled": true,
  "files.associations": {
    "*.html": "django-html"
  }
}
```

## 📋 Troubleshooting

### Problemas Comuns

1. **Erro: "manage.py not found"**
   ```bash
   # Certifique-se de estar no diretório raiz
   cd D:\apps\trae\Abase\abasenew
   python scripts/test_runner.py
   ```

2. **CSS não compila:**
   ```bash
   # Reinstalar dependências
   npm install
   npm run build-css
   ```

3. **Testes falhando:**
   ```bash
   # Verificar configuração do banco
   python manage.py check --database default
   
   # Executar migrações
   python manage.py migrate
   ```

4. **Git manager não funciona:**
   ```bash
   # Verificar se está em repositório git
   git status
   
   # Inicializar se necessário
   git init
   ```

### Logs e Debug

**Verificar logs detalhados:**
```bash
# Django com debug
python manage.py runserver --verbosity=2

# Testes com verbosidade
python scripts/test_runner.py --verbose

# CSS com debug
npx tailwindcss -i ./assets/tailwind.css -o ./static/css/app.css --watch --verbose
```

## 🚀 Integrações Futuras

### CI/CD Pipeline

Os scripts estão preparados para integração com:
- GitHub Actions
- GitLab CI
- Jenkins
- Docker containers

### Monitoramento

Planejado para próximas versões:
- Notificações Slack/Discord
- Métricas de performance
- Alertas de segurança
- Dashboard de qualidade

---

**💡 Dica:** Execute `python scripts/test_runner.py` sempre antes de fazer commits para garantir a qualidade do código!

**Última atualização:** 11/09/2025  
**Versão:** 1.0  
**Responsável:** Equipe ABASE