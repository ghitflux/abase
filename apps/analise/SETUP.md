# Setup Rápido - Módulo de Análise

## 🚀 Configuração em 5 Minutos

Guia rápido para configurar o módulo de análise no sistema ABASE.

## ✅ Pré-requisitos

- Django 5.2+ instalado
- Sistema ABASE configurado
- Banco de dados migrado
- Servidor de desenvolvimento rodando

## 📋 Checklist de Configuração

### 1. Verificar Apps Instaladas

Certifique-se de que estas apps estão em `settings.py`:

```python
INSTALLED_APPS = [
    # Apps do sistema
    'apps.analise',      # ✅ Módulo de análise
    'apps.accounts',     # ✅ Sistema de usuários
    'apps.cadastro',     # ✅ Módulo de cadastros
    # Outras apps...
]
```

### 2. Configurar URLs

Verifique se as URLs estão incluídas em `core/urls.py`:

```python
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('analise/', include('apps.analise.urls')),  # ✅ URLs do módulo
    # Outras URLs...
]
```

### 3. Executar Migrações

```bash
# Criar migrações se necessário
python manage.py makemigrations analise

# Aplicar migrações
python manage.py migrate
```

### 4. Configurar Permissões

Execute no Django shell (`python manage.py shell`):

```python
# Importar modelos necessários
from django.contrib.auth.models import Group, User

# 1. Criar grupo de analistas
analistas_group, created = Group.objects.get_or_create(name='Analistas')
if created:
    print("✅ Grupo 'Analistas' criado com sucesso")
else:
    print("ℹ️ Grupo 'Analistas' já existe")

# 2. Adicionar usuário admin ao grupo (opcional)
admin_user = User.objects.filter(is_superuser=True).first()
if admin_user:
    admin_user.groups.add(analistas_group)
    print(f"✅ Usuário '{admin_user.username}' adicionado ao grupo Analistas")

# 3. Verificar configuração
print(f"👥 Usuários no grupo Analistas: {analistas_group.user_set.count()}")
```

### 5. Verificar Templates

Certifique-se de que estes arquivos existem:

```
apps/analise/templates/analise/
├── dashboard.html      ✅ Dashboard principal
├── esteira.html        ✅ Esteira de processos  
├── relatorio.html      ✅ Página de relatórios
└── detalhe_processo.html ✅ Detalhes do processo
```

### 6. Testar Acesso

1. **Iniciar servidor**:
   ```bash
   python manage.py runserver
   ```

2. **Acessar URLs**:
   - Dashboard: http://127.0.0.1:8000/analise/
   - Esteira: http://127.0.0.1:8000/analise/esteira/
   - Relatórios: http://127.0.0.1:8000/analise/relatorio/

## 🔧 Comandos Úteis

### Criar Usuário Analista

```python
# No Django shell
from django.contrib.auth.models import User, Group

# Criar usuário
user = User.objects.create_user(
    username='analista1',
    email='analista1@empresa.com',
    password='senha123',
    first_name='João',
    last_name='Silva'
)

# Adicionar ao grupo
analistas_group = Group.objects.get(name='Analistas')
user.groups.add(analistas_group)

print(f"✅ Usuário analista '{user.username}' criado e configurado")
```

### Verificar Dados de Teste

```python
# No Django shell
from apps.analise.models import AnaliseProcesso
from apps.cadastro.models import Cadastro

print(f"📊 Processos de análise: {AnaliseProcesso.objects.count()}")
print(f"👤 Cadastros: {Cadastro.objects.count()}")
print(f"👥 Usuários analistas: {Group.objects.get(name='Analistas').user_set.count()}")
```

### Criar Dados de Teste (se necessário)

```python
# No Django shell
from apps.analise.models import AnaliseProcesso, StatusAnalise, TipoAnalise
from apps.cadastro.models import Cadastro
from django.contrib.auth.models import User

# Verificar se existem cadastros
if Cadastro.objects.count() == 0:
    print("⚠️ Nenhum cadastro encontrado. Crie cadastros primeiro.")
else:
    # Criar processo de teste
    cadastro = Cadastro.objects.first()
    processo = AnaliseProcesso.objects.create(
        cadastro=cadastro,
        status=StatusAnalise.PENDENTE,
        tipo_analise=TipoAnalise.COMPLETA,
        prioridade='media',
        observacoes='Processo de teste criado automaticamente'
    )
    print(f"✅ Processo de teste criado: ID {processo.id}")
```

## 🚨 Troubleshooting

### Erro 403 Forbidden

**Problema**: Usuário não consegue acessar o módulo.

**Solução**:
```python
# Verificar se usuário está no grupo correto
user = User.objects.get(username='seu_usuario')
print(f"Grupos do usuário: {[g.name for g.groups.all()]}")

# Adicionar ao grupo se necessário
analistas_group = Group.objects.get(name='Analistas')
user.groups.add(analistas_group)
```

### Erro 404 Not Found

**Problema**: URLs não encontradas.

**Verificações**:
1. ✅ URLs incluídas no `core/urls.py`
2. ✅ App `analise` em `INSTALLED_APPS`
3. ✅ Servidor reiniciado após mudanças

### Template Not Found

**Problema**: Templates não encontrados.

**Verificações**:
1. ✅ Arquivos existem em `apps/analise/templates/analise/`
2. ✅ Nomes dos templates estão corretos nas views
3. ✅ `TEMPLATES` configurado corretamente no settings

### Processos não aparecem

**Problema**: Esteira vazia mesmo com dados.

**Verificações**:
```python
# Verificar dados
from apps.analise.models import AnaliseProcesso
processos = AnaliseProcesso.objects.all()
print(f"Total de processos: {processos.count()}")
for p in processos[:5]:
    print(f"- ID: {p.id}, Status: {p.status}, Cadastro: {p.cadastro}")
```

## 📚 Recursos Adicionais

- **README completo**: `apps/analise/README.md`
- **Documentação de correções**: `documentos/CORRECOES_MODULO_ANALISE.md`
- **Changelog**: `CHANGELOG_ANALISE.md`

## ✨ Funcionalidades Disponíveis

Após a configuração, você terá acesso a:

- 📊 **Dashboard** com estatísticas e visão geral
- 🔄 **Esteira** para gerenciar processos
- 📈 **Relatórios** com métricas de performance
- 🔍 **Detalhes** completos de cada processo
- 👤 **Sistema de permissões** baseado em grupos
- 📱 **Interface responsiva** para desktop e mobile

## 🎯 Próximos Passos

1. **Configurar usuários**: Criar contas para analistas
2. **Importar dados**: Adicionar cadastros e processos reais
3. **Personalizar**: Ajustar templates conforme necessário
4. **Treinar equipe**: Orientar analistas sobre o uso do sistema

---

**⏱️ Tempo estimado de configuração**: 5-10 minutos  
**🔧 Dificuldade**: Básica  
**📞 Suporte**: Consulte a documentação completa ou logs do Django

**Última atualização**: 11 de Setembro de 2025