# Guia de Manutenção e Evolução — Sistema ABASE (Django + Postgres)

Este guia documenta **como corrigir bugs**, **adicionar módulos** e **evoluir** o sistema com segurança.

## 1) Branch/Commit/PR
- Branches: `main` (prod), `develop` (homolog), `feature/<slug>`, `fix/<slug>`.
- Commits: Conventional Commits (ex.: `feat: filtros por órgão público`, `fix: máscara de CPF`).
- PR: descrição clara, screenshots (UI), evidências (logs/testes), migrações revisadas.

## 2) Estrutura

```
apps/
accounts/ # auth, RBAC e helpers
cadastros/ # cadastro do associado (esteira Agente/Analista/Tesouraria)
documentos/ # uploads privados, rascunhos e entrega protegida
tesouraria/ # mensalidades, conciliação (importador usa aqui)
importador/ # importação TXT manual (competência/CPF/matrícula)
relatorios/ # painéis e KPIs da diretoria
auditoria/ # logs de segurança (login/logout/failed)
common/ # normalização/validadores/utilidades
configs/ # nginx/gunicorn/scripts
docs/ # este arquivo, ADRs, especificações
templates/ # base, parciais e páginas
static/ # assets finais (css/js)
assets/ # origem do Tailwind
```

## 3) Fluxo para correções
1. Abrir **issue** com passos para reproduzir.  
2. Branch `fix/<slug>`.  
3. Escrever teste (quando possível) + corrigir.  
4. `python manage.py check` + rodar local.  
5. Abrir PR → review → merge.

## 4) Fluxo para novas features
1. **Especificação curta** (`docs/adr-YYYYMMDD-<slug>.md`).  
2. Modelagem (índices, choices, migrações evolutivas, evitar quebra).  
3. Camada de serviço (`services.py`) com transações quando necessário.  
4. Views/Templates (HTMX quando melhora UX).  
5. Auditoria para ações críticas.  
6. Testes mínimos (unitário/integração).  
7. PR e revisão.

## 5) Banco e migrações
- Sempre rodar local:  

```bash
(.venv) > python manage.py makemigrations
(.venv) > python manage.py migrate
```

- **Backward-compatible**: evitar remoções bruscas de campos; prefira `null=True`/defaults temporários.

## 6) Uploads e privacidade
- Uploads **privados por padrão** em `_private/`.  
- Anexos de formulário primeiro vão para **rascunho** por `draft_token`.  
- No **sucesso** (cadastro salvo), rascunhos são **promovidos** para documentos definitivos.  
- Em produção, entrega com **Nginx X-Accel-Redirect** (Passo 7).

## 7) Cálculos automáticos (contrato)
- `taxa_antecipacao_percent` = **30%**.  
- `valor_total_antecipacao` = **3 × mensalidade_associativa**.  
- `doacao_associado` = **30%** de `valor_total_antecipacao`.  
- `disponivel` = **70%** de `valor_total_antecipacao`.  
- `trinta_porcento_bruto` = **30%** de `valor_bruto_total`.  
- `margem_liquido_menos_30_bruto` = `valor_liquido - trinta_porcento_bruto`.

## 8) Performance
- Índices em campos de busca/filtro.  
- `select_related`/`prefetch_related` nas listas.  
- Paginação obrigatória.

## 9) Segurança
- CSRF, validação no servidor, limites de tamanho/tipo de arquivo, RBAC em views, logs de segurança (Passo 8).