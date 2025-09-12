# Módulo de Análise - ABASE

## Visão Geral

O módulo de análise é responsável por gerenciar o fluxo de análise de processos no sistema ABASE. Permite que analistas visualizem, assumam e processem análises de cadastros de forma organizada e eficiente.

## Funcionalidades Principais

### 📊 Dashboard
- Visão geral dos processos
- Estatísticas por status
- Processos em atraso
- Últimos processos criados
- Processos do analista logado

### 🔄 Esteira de Processos
- Listagem paginada de todos os processos
- Filtros por status, prioridade e analista
- Busca por nome, CPF ou CNPJ
- Ação de assumir processos pendentes
- Navegação para detalhes do processo

### 📈 Relatórios
- Estatísticas de processos por período
- Métricas de performance
- Tempo médio de análise
- Ações rápidas para navegação

### 🔍 Detalhes do Processo
- Informações completas do cadastro
- Histórico de análises
- Checklist de verificação
- Ações de aprovação, rejeição ou suspensão

## Estrutura de Arquivos

```
apps/analise/
├── models.py              # Modelos de dados
├── views.py               # Views do módulo
├── urls.py                # Configuração de URLs
├── forms.py               # Formulários
├── admin.py               # Configuração do admin
├── apps.py                # Configuração da app
├── migrations/            # Migrações do banco
└── templates/analise/     # Templates HTML
    ├── dashboard.html     # Dashboard principal
    ├── esteira.html       # Esteira de processos
    ├── relatorio.html     # Página de relatórios
    └── detalhe_processo.html # Detalhes do processo
```

## Modelos de Dados

### AnaliseProcesso
Modelo principal que representa um processo de análise.

**Campos principais:**
- `cadastro`: Relacionamento com o cadastro a ser analisado
- `analista_responsavel`: Analista responsável pelo processo
- `status`: Status atual (Pendente, Em Análise, Aprovado, etc.)
- `tipo_analise`: Tipo de análise (Completa, Documental, etc.)
- `prioridade`: Prioridade do processo
- `data_entrada`: Data de entrada do processo
- `data_conclusao`: Data de conclusão da análise
- `observacoes`: Observações gerais

### StatusAnalise
Enum com os possíveis status de um processo:
- `PENDENTE`: Aguardando análise
- `EM_ANALISE`: Em processo de análise
- `APROVADO`: Processo aprovado
- `REJEITADO`: Processo rejeitado
- `SUSPENSO`: Processo suspenso

### TipoAnalise
Enum com os tipos de análise:
- `COMPLETA`: Análise completa
- `DOCUMENTAL`: Análise documental
- `SIMPLIFICADA`: Análise simplificada

## URLs Disponíveis

| URL | View | Descrição |
|-----|------|----------|
| `/analise/` | `dashboard_analise` | Dashboard principal |
| `/analise/esteira/` | `esteira_analise` | Esteira de processos |
| `/analise/relatorio/` | `relatorio_analise` | Página de relatórios |
| `/analise/processo/<int:pk>/` | `detalhe_processo` | Detalhes do processo |
| `/analise/assumir/<int:pk>/` | `assumir_processo` | Assumir processo |

## Permissões

### Decorator @analista_required
Todas as views do módulo utilizam o decorator `@analista_required` que verifica se o usuário:
- É superusuário, OU
- Pertence ao grupo "Analistas"

### Configuração de Permissões

1. **Criar grupo de analistas:**
```python
from django.contrib.auth.models import Group
analistas_group, created = Group.objects.get_or_create(name='Analistas')
```

2. **Adicionar usuário ao grupo:**
```python
from django.contrib.auth.models import User
user = User.objects.get(username='nome_usuario')
user.groups.add(analistas_group)
```

## Como Usar

### 1. Acesso ao Sistema
1. Faça login com credenciais de analista
2. Acesse: `http://localhost:8000/analise/`

### 2. Fluxo de Trabalho

#### Dashboard
1. Visualize estatísticas gerais
2. Identifique processos em atraso
3. Acesse seus processos atribuídos

#### Esteira de Processos
1. Acesse a esteira via menu ou dashboard
2. Use filtros para encontrar processos específicos
3. Assuma processos pendentes clicando em "Assumir"
4. Acesse detalhes clicando em "Visualizar"

#### Análise de Processo
1. No detalhe do processo, revise todas as informações
2. Preencha o checklist de verificação
3. Adicione observações se necessário
4. Tome uma decisão: Aprovar, Rejeitar ou Suspender

### 3. Filtros Disponíveis

**Na Esteira:**
- **Status**: Filtra por status do processo
- **Prioridade**: Filtra por prioridade (Alta, Média, Baixa)
- **Analista**: Filtra por analista responsável
- **Busca**: Busca por nome, CPF ou CNPJ do cadastro

## Configuração de Desenvolvimento

### 1. Dependências
Certifique-se de que as seguintes apps estão em `INSTALLED_APPS`:
```python
INSTALLED_APPS = [
    # ...
    'apps.analise',
    'apps.accounts',
    'apps.cadastro',
    # ...
]
```

### 2. URLs
Inclua as URLs do módulo no `core/urls.py`:
```python
urlpatterns = [
    # ...
    path('analise/', include('apps.analise.urls')),
    # ...
]
```

### 3. Migrações
```bash
python manage.py makemigrations analise
python manage.py migrate
```

### 4. Dados de Teste
```python
# Via Django shell
python manage.py shell

# Criar grupo de analistas
from django.contrib.auth.models import Group, User
analistas_group, created = Group.objects.get_or_create(name='Analistas')

# Adicionar usuário admin ao grupo
admin_user = User.objects.filter(is_superuser=True).first()
if admin_user:
    admin_user.groups.add(analistas_group)
```

## Tecnologias Utilizadas

- **Backend**: Django 5.2
- **Frontend**: HTML5, Tailwind CSS, JavaScript
- **Banco de Dados**: SQLite (dev) / PostgreSQL (prod)
- **Autenticação**: Django Auth com grupos

## Troubleshooting

### Erro 403 Forbidden
**Problema**: Usuário recebe erro 403 ao acessar páginas do módulo.

**Solução**: Verificar se o usuário pertence ao grupo "Analistas":
```python
user = User.objects.get(username='seu_usuario')
print(user.groups.all())  # Deve mostrar o grupo 'Analistas'
```

### Processos não aparecem na esteira
**Problema**: A esteira aparece vazia mesmo com processos no banco.

**Possíveis causas**:
1. Problemas no template (variáveis incorretas)
2. Filtros muito restritivos
3. Paginação mal configurada

**Solução**: Verificar se existem processos:
```python
from apps.analise.models import AnaliseProcesso
print(AnaliseProcesso.objects.count())
```

### Template não encontrado
**Problema**: Erro "TemplateDoesNotExist".

**Solução**: Verificar se todos os templates existem em `apps/analise/templates/analise/`:
- `dashboard.html`
- `esteira.html`
- `relatorio.html`
- `detalhe_processo.html`

## Contribuição

Para contribuir com o módulo:

1. Siga os padrões de código do projeto
2. Mantenha a documentação atualizada
3. Adicione testes para novas funcionalidades
4. Use o sistema de migrations para mudanças no banco

## Suporte

Para dúvidas ou problemas:
1. Consulte este README
2. Verifique os logs do Django
3. Consulte a documentação do projeto principal

---

**Última atualização**: 11 de Setembro de 2025  
**Versão**: 1.0