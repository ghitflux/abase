# Documentação do Módulo de Análise

## Visão Geral

O Módulo de Análise é um sistema completo para processamento e validação de cadastros de associados e órgãos. Ele implementa uma esteira de trabalho (workflow) que permite aos analistas revisar, validar e aprovar/rejeitar cadastros de forma organizada e auditável.

## Estrutura do Módulo

### Localização
```
apps/analise/
├── __init__.py
├── admin.py
├── apps.py
├── models.py          # Modelos de dados
├── views.py           # Views e lógica de negócio
├── urls.py            # Configuração de URLs
├── templates/analise/ # Templates HTML
│   ├── dashboard.html # Dashboard principal
│   └── esteira.html   # Lista de processos
├── migrations/        # Migrações do banco
└── tests.py          # Testes unitários
```

## Modelos de Dados

### 1. StatusAnalise
Define os possíveis status de um processo de análise.

```python
class StatusAnalise(models.Model):
    nome = models.CharField(max_length=50, unique=True)
    descricao = models.TextField(blank=True)
    cor = models.CharField(max_length=7, default='#6B7280')  # Hex color
    ativo = models.BooleanField(default=True)
```

**Status Padrão:**
- Pendente (amarelo)
- Em Análise (azul)
- Aprovado (verde)
- Rejeitado (vermelho)
- Suspenso (cinza)

### 2. TipoAnalise
Define os tipos de análise disponíveis.

```python
class TipoAnalise(models.Model):
    nome = models.CharField(max_length=50, unique=True)
    descricao = models.TextField(blank=True)
    checklist_padrao = models.JSONField(default=list)
    ativo = models.BooleanField(default=True)
```

**Tipos Padrão:**
- Associado
- Órgão

### 3. AnaliseProcesso
Processo principal de análise de um cadastro.

```python
class AnaliseProcesso(models.Model):
    # Relacionamentos
    cadastro = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    objeto_id = models.PositiveIntegerField()
    cadastro_objeto = GenericForeignKey('cadastro', 'objeto_id')
    
    tipo_analise = models.ForeignKey(TipoAnalise, on_delete=models.CASCADE)
    status = models.ForeignKey(StatusAnalise, on_delete=models.CASCADE)
    analista = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    
    # Dados do processo
    data_criacao = models.DateTimeField(auto_now_add=True)
    data_atribuicao = models.DateTimeField(null=True, blank=True)
    data_conclusao = models.DateTimeField(null=True, blank=True)
    prazo_analise = models.DateTimeField(null=True, blank=True)
    
    # Observações
    observacoes = models.TextField(blank=True)
    motivo_rejeicao = models.TextField(blank=True)
    
    # Controle
    prioridade = models.CharField(max_length=10, choices=PRIORIDADE_CHOICES, default='normal')
    ativo = models.BooleanField(default=True)
```

### 4. ChecklistAnalise
Itens de verificação para cada processo.

```python
class ChecklistAnalise(models.Model):
    processo = models.ForeignKey(AnaliseProcesso, on_delete=models.CASCADE)
    item = models.CharField(max_length=200)
    verificado = models.BooleanField(default=False)
    obrigatorio = models.BooleanField(default=True)
    observacoes = models.TextField(blank=True)
    data_verificacao = models.DateTimeField(null=True, blank=True)
    verificado_por = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
```

### 5. HistoricoAnalise
Histórico de todas as mudanças no processo.

```python
class HistoricoAnalise(models.Model):
    processo = models.ForeignKey(AnaliseProcesso, on_delete=models.CASCADE)
    usuario = models.ForeignKey(User, on_delete=models.CASCADE)
    acao = models.CharField(max_length=50)
    status_anterior = models.ForeignKey(StatusAnalise, on_delete=models.CASCADE, related_name='historico_anterior')
    status_novo = models.ForeignKey(StatusAnalise, on_delete=models.CASCADE, related_name='historico_novo')
    observacoes = models.TextField(blank=True)
    data_acao = models.DateTimeField(auto_now_add=True)
```

## Views e Funcionalidades

### 1. Dashboard de Análise
**URL:** `/analise/dashboard/`
**Permissão:** Grupo ANALISTA ou SUPERUSER

**Funcionalidades:**
- Estatísticas gerais (total de processos, pendentes, em análise, atrasados)
- Gráficos de status dos processos
- Lista de processos recentes
- Ações rápidas (assumir processo, ver esteira)

### 2. Esteira de Análise
**URL:** `/analise/esteira/`
**Permissão:** Grupo ANALISTA ou SUPERUSER

**Funcionalidades:**
- Lista paginada de todos os processos
- Filtros por status, tipo, analista
- Busca por nome/documento
- Ações em lote
- Assumir processos não atribuídos

### 3. Detalhes do Processo
**URL:** `/analise/processo/<id>/`
**Permissão:** Analista responsável ou SUPERUSER

**Funcionalidades:**
- Visualização completa do cadastro
- Checklist de verificação
- Histórico de ações
- Documentos anexos
- Ações de aprovação/rejeição/suspensão

### 4. Ações do Processo

#### Assumir Processo
**URL:** `/analise/processo/<id>/assumir/`
**Método:** POST (AJAX)
- Atribui o processo ao analista logado
- Muda status para "Em Análise"
- Registra no histórico

#### Aprovar Processo
**URL:** `/analise/processo/<id>/aprovar/`
**Método:** POST
- Valida checklist obrigatório
- Muda status para "Aprovado"
- Encaminha para tesouraria (se aplicável)
- Registra no histórico

#### Rejeitar Processo
**URL:** `/analise/processo/<id>/rejeitar/`
**Método:** POST
- Exige motivo da rejeição
- Muda status para "Rejeitado"
- Notifica o agente responsável
- Registra no histórico

#### Suspender Processo
**URL:** `/analise/processo/<id>/suspender/`
**Método:** POST
- Exige motivo da suspensão
- Muda status para "Suspenso"
- Define prazo para retomada
- Registra no histórico

### 5. Endpoints AJAX

#### Atualizar Checklist
**URL:** `/analise/processo/<id>/checklist/`
**Método:** POST
- Atualiza itens do checklist
- Calcula progresso automaticamente
- Retorna JSON com status

#### Buscar Processos
**URL:** `/analise/buscar/`
**Método:** GET
- Busca processos por filtros
- Retorna JSON paginado
- Usado para atualizações dinâmicas

## Templates

### 1. Dashboard (`dashboard.html`)
**Funcionalidades:**
- Cards com estatísticas principais
- Gráficos de barras para status
- Gráficos de progresso para analistas
- Lista de processos recentes
- Botões de ação rápida

**Tecnologias:**
- Tailwind CSS para estilização
- Chart.js para gráficos
- Alpine.js para interatividade

### 2. Esteira (`esteira.html`)
**Funcionalidades:**
- Tabela responsiva com processos
- Filtros dinâmicos
- Paginação
- Ações em linha
- Busca em tempo real

**Recursos:**
- Cores dinâmicas por status
- Tooltips informativos
- Confirmações de ação
- Loading states

## Integração com o Sistema

### 1. Sidebar Navigation
O módulo foi integrado ao menu lateral principal:
- Item "Análise" visível para grupos ANALISTA e SUPERUSER
- Link direto para o dashboard
- Ícone e estilização consistentes

### 2. Reorganização de Relatórios
Os itens de exportação foram reorganizados:
- Criado submenu "Relatórios" expansível
- Todos os exports movidos para o submenu
- Melhor organização visual
- Uso de Alpine.js para animações

### 3. Signals de Integração
O módulo se integra automaticamente:
- Novos cadastros geram processos de análise
- Mudanças são auditadas automaticamente
- Notificações são enviadas conforme necessário

## Permissões e Segurança

### Grupos de Usuário
- **ANALISTA**: Acesso completo ao módulo
- **SUPERUSER**: Acesso administrativo total
- **ADMIN**: Visualização de relatórios
- **Outros**: Sem acesso ao módulo

### Validações de Segurança
- Analistas só podem assumir processos não atribuídos
- Apenas o analista responsável pode alterar o processo
- Todas as ações são logadas na auditoria
- Validação de CSRF em todas as requisições

## Fluxo de Trabalho

### 1. Criação do Processo
1. Agente cadastra associado/órgão
2. Signal cria processo de análise automaticamente
3. Status inicial: "Pendente"
4. Checklist padrão é criado

### 2. Atribuição
1. Analista acessa esteira
2. Visualiza processos pendentes
3. Assume processo desejado
4. Status muda para "Em Análise"

### 3. Análise
1. Analista acessa detalhes do processo
2. Verifica dados do cadastro
3. Preenche checklist de verificação
4. Adiciona observações se necessário

### 4. Conclusão
1. Analista decide: aprovar, rejeitar ou suspender
2. Sistema valida pré-requisitos
3. Status é atualizado
4. Ações subsequentes são executadas
5. Histórico é registrado

## Métricas e Relatórios

### Dashboard Metrics
- Total de processos
- Processos pendentes
- Processos em análise
- Processos atrasados
- Taxa de aprovação
- Tempo médio de análise

### Relatórios Disponíveis
- Relatório de produtividade por analista
- Relatório de processos por período
- Relatório de rejeições com motivos
- Relatório de tempo de análise

## Configurações

### Settings Necessárias
```python
# Em settings.py
INSTALLED_APPS = [
    # ... outros apps
    'apps.analise',
]

# Configurações específicas do módulo
ANALISE_PRAZO_PADRAO = 5  # dias
ANALISE_NOTIFICAR_ATRASO = True
ANALISE_AUTO_ATRIBUIR = False
```

### URLs Configuration
```python
# Em core/urls.py
urlpatterns = [
    # ... outras URLs
    path('analise/', include('apps.analise.urls')),
]
```

## Próximos Desenvolvimentos

### Funcionalidades Planejadas
1. **Sistema de Notificações**
   - Notificações em tempo real
   - Alertas de prazo
   - Emails automáticos

2. **Relatórios Avançados**
   - Dashboard executivo
   - Métricas de performance
   - Exportação de dados

3. **Automação**
   - Regras de auto-aprovação
   - Distribuição automática
   - Validações inteligentes

4. **Mobile Support**
   - Interface responsiva aprimorada
   - App mobile dedicado
   - Notificações push

### Melhorias Técnicas
1. **Performance**
   - Cache de consultas
   - Otimização de queries
   - Lazy loading

2. **Testes**
   - Cobertura completa de testes
   - Testes de integração
   - Testes de performance

3. **Documentação**
   - Manual do usuário
   - Guia de administração
   - API documentation

## Conclusão

O Módulo de Análise representa uma solução completa e robusta para o processamento de cadastros no Sistema ABASE. Ele implementa as melhores práticas de desenvolvimento Django, com foco em usabilidade, segurança e performance.

A arquitetura modular e extensível permite fácil manutenção e adição de novas funcionalidades, enquanto a integração transparente com o sistema existente garante uma experiência de usuário consistente e eficiente.