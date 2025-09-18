from django import template
register = template.Library()

STATUS = {
  # genéricos do DS
  "APROVADO":"badge--aprovado","EFETIVADO":"badge--efetivado",
  "EM_ANALISE":"badge--analise","EM ANÁLISE":"badge--analise","ANDAMENTO":"badge--andamento",
  "PENDENTE":"badge--pendente","AGUARDANDO":"badge--aguardando",
  "ENVIADO_PARA_CORRECAO":"badge--enviado-correcao",
  "EM_CORRECAO":"badge--em_correcao","EM CORREÇÃO":"badge--em_correcao","CORRECAO":"badge--correcao",
  "CORRECAO_REALIZADA":"badge--correcao-feita","CORREÇÃO REALIZADA":"badge--correcao-feita",
  "CANCELADO":"badge--cancelado","REPROVADO":"badge--reprovado",
  "PAGO":"badge--pago","EM ATRASO":"badge--atraso","EM_ABERTO":"badge--aberto","ABERTO":"badge--aberto",
  # códigos desta tela (Minha Esteira)
  "DRAFT":"badge--default",
  "SENT_REVIEW":"badge--analise",
  "PENDING_AGENT":"badge--pendente",
  "APPROVED_REVIEW":"badge--aprovado",
  "CANCELLED":"badge--cancelado",
  "LIQUIDADA": "badge--pago",
    "LIQUIDADO": "badge--pago",
    "PAGA": "badge--pago",
    "QUITADA": "badge--pago",
    "ATRASADA": "badge--atraso",
}

ROLES = {
  "AGENTE":"chip--agente","ANALISTA":"chip--analista",
  "TESOURARIA":"chip--tesouraria","TESOUREIRO":"chip--tesouraria","ADMIN":"chip--tesouraria"
}

@register.filter
def status_class(v):
    key = str(v or "").upper().strip().replace("-","_")
    return STATUS.get(key,"badge--default")

@register.filter
def role_class(v):
    key = str(v or "").upper().strip()
    return ROLES.get(key,"chip--analista")
