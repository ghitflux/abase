# 📋 Guia de Boas Práticas - Sistema ABASE

## 🎯 Objetivo

Este documento estabelece as diretrizes e boas práticas para desenvolvimento, manutenção e evolução do sistema ABASE, garantindo qualidade, consistência e manutenibilidade do código.

## 🏗️ Estrutura de Código

### 1. Organização de Apps Django

```
apps/
├── nome_app/
│   ├── __init__.py
│   ├── admin.py           # Configuração do admin
│   ├── apps.py            # Configuração da app
│   ├── models.py          # Modelos de dados
│   ├── views.py           # Views (se poucas) ou views/
│   ├── urls.py            # URLs da app
│   ├── forms.py           # Formulários (se necessário)
│   ├── serializers.py     # Serializers DRF (se API)
│   ├── utils.py           # Funções auxiliares
│   ├── signals.py         # Signals Django (se necessário)
│   ├── managers.py        # Managers customizados (se necessário)
│   ├── migrations/        # Migrações automáticas
│   ├── templates/         # Templates específicos da app
│   │   └── nome_app/
│   └── tests/             # Testes da app
│       ├── __init__.py
│       ├── test_models.py
│       ├── test_views.py
│       └── test_utils.py
```

### 2. Nomenclatura de Arquivos e Diretórios

**✅ Boas Práticas:**
- Nomes em inglês para código
- snake_case para arquivos Python
- kebab-case para templates HTML
- PascalCase para classes
- UPPER_CASE para constantes

**❌ Evitar:**
- Caracteres especiais ou acentos
- Espaços em nomes de arquivos
- Nomes genéricos como `utils.py` sem contexto

## 💾 Banco de Dados

### 1. Modelos Django

```python
# ✅ Exemplo de modelo bem estruturado
class Pessoa(models.Model):
    # Campos obrigatórios primeiro
    nome = models.CharField(max_length=200, verbose_name="Nome Completo")
    email = models.EmailField(unique=True, verbose_name="E-mail")
    
    # Campos opcionais depois
    telefone = models.CharField(max_length=20, blank=True, null=True)
    data_nascimento = models.DateField(blank=True, null=True)
    
    # Campos de auditoria por último
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = "Pessoa"
        verbose_name_plural = "Pessoas"
        ordering = ['nome']
        
    def __str__(self):
        return self.nome
        
    def get_absolute_url(self):
        return reverse('pessoa_detail', kwargs={'pk': self.pk})
```

### 2. Migrações

**✅ Boas Práticas:**
- Sempre revisar migrações antes de aplicar
- Fazer backup antes de migrações em produção
- Nunca editar migrações já aplicadas
- Usar migrações de dados quando necessário

```bash
# Gerar migrações
python manage.py makemigrations

# Revisar SQL da migração
python manage.py sqlmigrate app_name 0001

# Aplicar migrações
python manage.py migrate
```

## 🎨 Frontend e Design System

### 1. Templates HTML

```html
<!-- ✅ Estrutura recomendada -->
{% extends "base.html" %}
{% load static %}

{% block title %}Título da Página • ABASE{% endblock %}

{% block content %}
<div class="container">
  <header class="mb-6">
    <h1 class="text-2xl font-bold">Título da Página</h1>
    <p class="text-muted-foreground">Descrição da página</p>
  </header>
  
  <main>
    <!-- Conteúdo principal -->
  </main>
</div>
{% endblock %}
```

### 2. Classes CSS (shadcn-like)

**✅ Usar componentes pré-definidos:**
```html
<!-- Botões -->
<button class="btn btn-primary">Primário</button>
<button class="btn btn-secondary">Secundário</button>
<button class="btn btn-outline">Outline</button>
<button class="btn btn-destructive">Deletar</button>

<!-- Cards -->
<div class="card">
  <div class="card-header">
    <h3 class="card-title">Título</h3>
  </div>
  <div class="card-body">
    Conteúdo
  </div>
</div>

<!-- Formulários -->
<div class="space-y-4">
  <div>
    <label class="label">Nome</label>
    <input class="input" type="text" placeholder="Digite o nome">
  </div>
  <div>
    <label class="label">Descrição</label>
    <textarea class="textarea" placeholder="Digite a descrição"></textarea>
  </div>
</div>
```

### 3. Ícones

**Usar Lucide Icons:**
```html
<i data-lucide="search"></i>       <!-- Buscar -->
<i data-lucide="plus"></i>         <!-- Adicionar -->
<i data-lucide="edit"></i>         <!-- Editar -->
<i data-lucide="trash-2"></i>      <!-- Deletar -->
<i data-lucide="download"></i>     <!-- Download -->
<i data-lucide="upload"></i>       <!-- Upload -->
```

## 🔒 Segurança

### 1. Validação de Dados

```python
# ✅ Sempre validar dados de entrada
def create_pessoa(request):
    if request.method == 'POST':
        form = PessoaForm(request.POST)
        if form.is_valid():
            pessoa = form.save(commit=False)
            pessoa.created_by = request.user
            pessoa.save()
            return redirect('pessoa_list')
    else:
        form = PessoaForm()
    
    return render(request, 'form.html', {'form': form})
```

### 2. Permissões e Autenticação

```python
from django.contrib.auth.decorators import login_required
from apps.accounts.decorators import admin_required

@login_required
def user_view(request):
    # View para usuários logados
    pass

@admin_required
def admin_view(request):
    # View apenas para administradores
    pass
```

### 3. Variáveis de Ambiente

```python
# ✅ Nunca hardcode credenciais
from decouple import config

SECRET_KEY = config('SECRET_KEY')
DATABASE_URL = config('DATABASE_URL')
DEBUG = config('DEBUG', default=False, cast=bool)
```

## 🧪 Testes

### 1. Estrutura de Testes

```python
# tests/test_models.py
from django.test import TestCase
from django.contrib.auth.models import User
from apps.cadastros.models import Pessoa

class PessoaModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='test', password='test123'
        )
    
    def test_create_pessoa(self):
        pessoa = Pessoa.objects.create(
            nome="João Silva",
            email="joao@teste.com"
        )
        self.assertEqual(pessoa.nome, "João Silva")
        self.assertIsNotNone(pessoa.created_at)
    
    def test_str_method(self):
        pessoa = Pessoa(nome="Maria Santos")
        self.assertEqual(str(pessoa), "Maria Santos")
```

### 2. Comandos de Teste

```bash
# Executar todos os testes
python manage.py test

# Executar testes de uma app específica
python manage.py test apps.cadastros

# Executar com coverage
coverage run --source='.' manage.py test
coverage report
coverage html
```

## 📝 Documentação

### 1. Docstrings

```python
def calcular_idade(data_nascimento):
    """
    Calcula a idade baseada na data de nascimento.
    
    Args:
        data_nascimento (date): Data de nascimento da pessoa
        
    Returns:
        int: Idade em anos
        
    Raises:
        ValueError: Se a data for no futuro
    """
    from datetime import date
    
    if data_nascimento > date.today():
        raise ValueError("Data de nascimento não pode ser no futuro")
    
    hoje = date.today()
    return hoje.year - data_nascimento.year
```

### 2. Comentários no Código

```python
# ✅ Comentários úteis
# Aplicar desconto especial para clientes premium
if cliente.is_premium:
    valor_final = valor * 0.9

# ❌ Comentários óbvios
# Incrementar contador
contador += 1
```

## 🚀 Deploy e Versionamento

### 1. Git Workflow

```bash
# Branch principal: master/main
# Branches de feature: feature/nome-da-funcionalidade
# Branches de hotfix: hotfix/nome-do-fix

# Criar nova feature
git checkout -b feature/login-social
git add .
git commit -m "feat: implementar login com Google"
git push origin feature/login-social

# Merge para master
git checkout master
git merge feature/login-social
git push origin master
```

### 2. Mensagens de Commit

**Padrão Conventional Commits:**
```bash
feat: adicionar nova funcionalidade
fix: corrigir bug específico
docs: atualizar documentação
style: mudanças de formatação
refactor: refatoração sem mudança de comportamento
test: adicionar ou corrigir testes
chore: tarefas de manutenção
```

### 3. Variáveis de Ambiente por Ambiente

```bash
# .env.development
DEBUG=True
DATABASE_URL=postgresql://user:pass@localhost/abase_dev

# .env.production
DEBUG=False
DATABASE_URL=postgresql://user:pass@prod-server/abase_prod
SECRET_KEY=super-secret-production-key
```

## 🔍 Monitoramento e Logs

### 1. Logging

```python
import logging

logger = logging.getLogger(__name__)

def processar_importacao(arquivo):
    logger.info(f"Iniciando processamento de {arquivo.name}")
    
    try:
        # Processar arquivo
        resultado = processa_dados(arquivo)
        logger.info(f"Processamento concluído: {resultado}")
        return resultado
    except Exception as e:
        logger.error(f"Erro no processamento: {str(e)}")
        raise
```

### 2. Auditoria

```python
# Usar o sistema de auditoria para ações importantes
from apps.auditoria.utils import log_action

def delete_pessoa(request, pk):
    pessoa = get_object_or_404(Pessoa, pk=pk)
    
    # Log da ação antes de deletar
    log_action(
        user=request.user,
        action='DELETE',
        model='Pessoa',
        object_id=pk,
        data_anterior=model_to_dict(pessoa)
    )
    
    pessoa.delete()
    return redirect('pessoa_list')
```

## 📊 Performance

### 1. Queries Otimizadas

```python
# ✅ Usar select_related para ForeignKey
pessoas = Pessoa.objects.select_related('endereco')

# ✅ Usar prefetch_related para ManyToMany
pessoas = Pessoa.objects.prefetch_related('tags')

# ✅ Evitar N+1 queries
for pessoa in pessoas.select_related('endereco'):
    print(f"{pessoa.nome} - {pessoa.endereco.cidade}")
```

### 2. Cache

```python
from django.core.cache import cache

def get_dashboard_data():
    data = cache.get('dashboard_data')
    if data is None:
        data = expensive_calculation()
        cache.set('dashboard_data', data, timeout=300)  # 5 minutos
    return data
```

## ✅ Checklist de Revisão de Code

Antes de fazer commit, sempre verificar:

- [ ] Código segue padrões de nomenclatura
- [ ] Não há credenciais hardcoded
- [ ] Testes foram escritos e passam
- [ ] Documentação foi atualizada
- [ ] Migrations foram revisadas
- [ ] Performance foi considerada
- [ ] Logs apropriados foram adicionados
- [ ] Tratamento de erro implementado
- [ ] UI está consistente com design system
- [ ] Funcionalidade foi testada manualmente

---

**Última atualização:** 11/09/2025  
**Versão:** 1.0  
**Responsável:** Equipe ABASE