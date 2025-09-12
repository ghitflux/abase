# Documentação Completa do Sistema ABASE

## Visão Geral

O Sistema ABASE é uma aplicação Django para gestão de associados e órgãos, com funcionalidades completas de cadastro, análise, auditoria, relatórios e administração.

## Estrutura do Projeto

### Apps Principais

#### 1. **accounts** - Gestão de Usuários
- **Funcionalidades:**
  - Sistema de autenticação personalizado
  - Dashboard de usuários
  - Decoradores de permissão
  - Signals para eventos de usuário
  - Template tags personalizadas

- **Arquivos Principais:**
  - `models.py`: Modelos de usuário customizados
  - `views.py`: Views de login, dashboard e perfil
  - `decorators.py`: Decoradores de permissão por grupo
  - `signals.py`: Sinais para eventos de usuário

#### 2. **cadastros** - Gestão de Associados e Órgãos
- **Funcionalidades:**
  - Cadastro de associados com validações completas
  - Cadastro de órgãos públicos
  - Sistema de filtros avançados
  - Formulários dinâmicos
  - Validações de CPF, CNPJ, telefone, email
  - Sistema de normalização de dados

- **Modelos Principais:**
  - `Associado`: Dados pessoais, endereço, contato, situação
  - `Orgao`: Dados institucionais, endereço, responsáveis
  - `Endereco`: Endereços com validação de CEP
  - `Situacao`: Status dos cadastros

- **Arquivos Principais:**
  - `models.py`: Modelos de dados com validações
  - `forms.py`: Formulários com validações customizadas
  - `filters.py`: Filtros para listagens
  - `choices.py`: Opções para campos de escolha
  - `signals.py`: Sinais para auditoria automática

#### 3. **analise** - Módulo de Análise (NOVO)
- **Funcionalidades:**
  - Esteira de processamento de cadastros
  - Dashboard de análise com estatísticas
  - Sistema de atribuição de analistas
  - Checklist de verificação
  - Histórico de análises
  - Ações de aprovação, rejeição e suspensão
  - Encaminhamento para tesouraria

- **Modelos:**
  - `StatusAnalise`: Status dos processos (Pendente, Em Análise, Aprovado, etc.)
  - `TipoAnalise`: Tipos de análise (Associado, Órgão)
  - `AnaliseProcesso`: Processo principal de análise
  - `ChecklistAnalise`: Itens de verificação
  - `HistoricoAnalise`: Histórico de mudanças

- **Templates:**
  - `dashboard.html`: Dashboard com estatísticas e gráficos
  - `esteira.html`: Lista de processos com filtros
  - Integração com sidebar do sistema

#### 4. **auditoria** - Sistema de Auditoria
- **Funcionalidades:**
  - Log automático de todas as operações
  - Rastreamento de mudanças
  - Relatórios de auditoria
  - Filtros por usuário, data, ação

- **Modelos:**
  - `LogAuditoria`: Registro de todas as operações
  - Campos: usuário, ação, modelo, objeto_id, dados_anteriores, dados_novos

#### 5. **relatorios** - Sistema de Relatórios
- **Funcionalidades:**
  - Dashboard de relatórios
  - Exportação XLSX (Excel)
  - Exportação PDF
  - Relatórios de associados, órgãos e dashboard
  - Gráficos e estatísticas

- **Tipos de Relatório:**
  - Associados (XLSX/PDF)
  - Órgãos (XLSX/PDF)
  - Dashboard (PDF)
  - Relatórios customizados

#### 6. **tesouraria** - Gestão Financeira
- **Funcionalidades:**
  - Controle de contribuições
  - Gestão de pagamentos
  - Relatórios financeiros
  - Integração com análise de cadastros

#### 7. **importador** - Importação de Dados
- **Funcionalidades:**
  - Importação de planilhas Excel
  - Validação de dados importados
  - Mapeamento de campos
  - Relatórios de importação
  - Tratamento de erros

#### 8. **documentos** - Gestão de Documentos
- **Funcionalidades:**
  - Upload de documentos
  - Armazenamento seguro
  - Versionamento
  - Associação com cadastros

#### 9. **notificacoes** - Sistema de Notificações
- **Funcionalidades:**
  - Notificações em tempo real
  - Email notifications
  - Notificações do sistema
  - Histórico de notificações

#### 10. **exportacao** - Sistema de Exportação
- **Funcionalidades:**
  - Exportação de dados em diversos formatos
  - Agendamento de exportações
  - Templates de exportação

#### 11. **common** - Utilitários Comuns
- **Funcionalidades:**
  - Validadores customizados
  - Normalizadores de dados
  - Utilitários compartilhados
  - Modelos base

## Interface do Usuário

### Sidebar Navigation
O sistema possui uma navegação lateral organizada com:

1. **Dashboard** - Visão geral do sistema
2. **Minha Esteira** - Processos do usuário logado
3. **Novo Cadastro** - Formulários de cadastro (AGENTE)
4. **Análise** - Módulo de análise (ANALISTA)
5. **Secretaria** - Funcionalidades administrativas
6. **Contribuições** - Gestão financeira (ADMIN)
7. **Importações** - Importação de dados (ADMIN)
8. **Relatórios** - Submenu com:
   - Dashboard de Relatórios
   - Exportar Associados (XLSX)
   - Exportar Órgãos (XLSX)
   - Relatório Associados (PDF)
   - Relatório Órgãos (PDF)
   - Relatório Dashboard (PDF)
9. **Auditoria** - Logs do sistema
10. **Administração** - Configurações (SUPERUSER)

### Grupos de Usuários
- **SUPERUSER**: Acesso total
- **ADMIN**: Administração geral
- **DIRETORIA**: Relatórios e visão executiva
- **ANALISTA**: Análise de cadastros
- **AGENTE**: Cadastro de dados
- **TESOURARIA**: Gestão financeira

## Tecnologias Utilizadas

### Backend
- **Django 4.x**: Framework web principal
- **Python 3.x**: Linguagem de programação
- **SQLite/PostgreSQL**: Banco de dados
- **Django REST Framework**: APIs (se aplicável)

### Frontend
- **HTML5/CSS3**: Estrutura e estilo
- **Tailwind CSS**: Framework CSS utilitário
- **Alpine.js**: JavaScript reativo
- **Chart.js**: Gráficos e visualizações

### Funcionalidades Especiais
- **Sistema de Temas**: Dark/Light mode
- **Responsivo**: Adaptável a diferentes dispositivos
- **Acessibilidade**: Seguindo padrões WCAG
- **Performance**: Otimizado para carregamento rápido

## Configurações

### Settings Principais
- **INSTALLED_APPS**: Todos os apps listados
- **MIDDLEWARE**: Segurança, sessões, autenticação
- **DATABASES**: Configuração do banco de dados
- **STATIC_FILES**: Arquivos estáticos
- **MEDIA_FILES**: Upload de arquivos

### URLs Principais
- `/`: Dashboard principal
- `/accounts/`: Autenticação
- `/cadastros/`: Gestão de cadastros
- `/analise/`: Módulo de análise
- `/relatorios/`: Sistema de relatórios
- `/auditoria/`: Logs de auditoria
- `/admin/`: Administração Django

## Funcionalidades de Segurança

1. **Autenticação**: Sistema robusto de login
2. **Autorização**: Controle por grupos de usuário
3. **Auditoria**: Log de todas as operações
4. **Validações**: Validação rigorosa de dados
5. **CSRF Protection**: Proteção contra ataques CSRF
6. **SQL Injection**: Proteção através do ORM Django

## Fluxo de Trabalho

### Cadastro de Associados/Órgãos
1. **Agente** cadastra novos associados/órgãos
2. Sistema valida dados automaticamente
3. Cadastro entra na **esteira de análise**
4. **Analista** assume o processo
5. Verificação através de **checklist**
6. Aprovação/Rejeição/Suspensão
7. Se aprovado, encaminha para **tesouraria**
8. Todas as ações são **auditadas**

### Relatórios e Exportações
1. Usuários autorizados acessam **Relatórios**
2. Escolhem formato (XLSX/PDF)
3. Sistema gera relatório em tempo real
4. Download automático
5. Log da operação na auditoria

## Manutenção e Monitoramento

### Scripts Disponíveis
- `clean_rascunhos.bat`: Limpeza de rascunhos
- `git_manager.py`: Gestão do Git
- `test_runner.py`: Execução de testes

### Testes
- Testes unitários para todos os apps
- Cobertura de código com coverage
- Relatórios de teste automatizados

### Documentação
- Documentação técnica completa
- Manuais de usuário
- Guias de manutenção
- Instruções de deploy

## Próximos Passos

1. **Finalizar Módulo de Análise**:
   - Templates de detalhes do processo
   - Sistema de encaminhamento
   - Integração completa

2. **Melhorias de Performance**:
   - Cache de consultas
   - Otimização de queries
   - CDN para assets

3. **Funcionalidades Avançadas**:
   - Notificações em tempo real
   - Dashboard executivo
   - Relatórios customizáveis

4. **Mobile App**:
   - App mobile para consultas
   - Notificações push
   - Funcionalidades offline

## Conclusão

O Sistema ABASE é uma solução completa e robusta para gestão de associados e órgãos, com funcionalidades avançadas de análise, auditoria e relatórios. O sistema foi desenvolvido seguindo as melhores práticas de desenvolvimento Django, com foco em segurança, performance e usabilidade.

A arquitetura modular permite fácil manutenção e extensão, enquanto o sistema de permissões garante que cada usuário tenha acesso apenas às funcionalidades necessárias para seu papel no sistema.