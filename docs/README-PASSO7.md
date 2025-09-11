# Passo 7 — Normalização/Validações, Admin e Arquivos Privados (X-Accel)

## O que foi feito
- App `apps.common` com:
  - `normalize.py`: digits/upper/cep/cpf/cnpj/phone.
  - `validators.py`: CPF, CNPJ, CEP e PIX (e-mail, telefone, CPF/CNPJ, chave aleatória).
- `CadastroForm.clean()`:
  - Normaliza CPF/CNPJ/CEP/UF/telefone.
  - Regras PF/PJ (exige CPF válido para PF e CNPJ válido para PJ).
  - Validação de PIX e CEP.
- Admin de `Cadastro`:
  - Busca: CPF/CNPJ/Matrícula/Órgão Público.
  - Filtros: Status/Tipo/Situação/Órgão Público/Data.
  - Inlines de Parcelas e Documentos.
  - Ação "Exportar CSV".
- Menu condicional: "Novo Cadastro" só para AGENTE/ADMIN.
- Arquivos privados:
  - DEV: Django serve direto.
  - PROD: Nginx via `X-Accel-Redirect` (mais seguro).

## Onde editar
- Normalização/validadores: `apps/common/`
- Form: `apps/cadastros/forms.py`
- Admin: `apps/cadastros/admin.py`
- Entrega privada: `apps/documentos/views.py`
- Nginx: `configs/nginx/abase.conf`

## Funcionalidades implementadas

### Validações Server-side
- **CPF/CNPJ**: Validação completa com dígitos verificadores
- **CEP**: Deve ter exatamente 8 dígitos
- **PIX**: Aceita CPF, CNPJ, e-mail, telefone ou chave aleatória
- **Regras PF/PJ**: PF exige CPF válido, PJ exige CNPJ válido
- **Normalização**: Remove máscaras automaticamente

### Admin Avançado
- **Busca**: Nome, CPF, CNPJ, matrícula, órgão público
- **Filtros**: Por status, tipo pessoa, situação servidor, órgão, data
- **Inlines**: Parcelas e documentos vinculados
- **Export CSV**: Exportação completa dos dados
- **Campos calculados**: Readonly para valores automáticos

### Menu Baseado em Perfil
- **Novo Cadastro**: Apenas para AGENTE e ADMIN
- **Análise**: Apenas para ANALISTA (placeholder)
- **Superuser**: Acesso total
- **Template tag**: `has_group` para verificações RBAC

### Arquivos Privados
- **Desenvolvimento**: Django serve diretamente via FileResponse
- **Produção**: Nginx X-Accel-Redirect para performance e segurança
- **Controle de acesso**: Verificação de permissões antes da entrega