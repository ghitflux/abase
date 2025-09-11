# Passo 6 — Cadastro do Agente, Anexos em Rascunho e Cálculos Automáticos

## O que foi entregue
- Campos do cadastro conforme especificado (sem observações; usando Órgão Público).
- Cálculos automáticos:
  - 30% do bruto e margem (líquido − 30%).
  - Valor total = 3 × mensalidade.
  - Doação = 30% do total; Disponível = 70%.
- Upload de documentos com **rascunho** (persistentes em caso de erro).
- Promoção automática de rascunhos → documentos no sucesso.
- Criação automática das **3 parcelas** do contrato.
- Máscaras (CPF/CNPJ/CEP) e **ViaCEP** para endereço.

## Onde editar
- Modelos: `apps/cadastros/models.py`
- Form: `apps/cadastros/forms.py`
- Views: `apps/cadastros/views.py` (agente_create) e `apps/documentos/views.py` (rascunho/serve)
- Templates: `apps/cadastros/templates/cadastros/agente_form.html` e `apps/documentos/templates/documentos/_draft_list.html`
- URLs: `apps/cadastros/urls.py` e `apps/documentos/urls.py`

## Próximos passos (Passo 7)
- Normalização/validação de CPF/CNPJ/CEP/PIX (server-side).
- Admin Django (busca, filtros, export).
- Entrega privada em produção com **Nginx X-Accel-Redirect**.