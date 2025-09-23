"""
Sistema de mapeamento e sincronização de status entre módulos.

Este arquivo centraliza a lógica de conversão de status entre:
- Cadastro (cadastros.StatusCadastro)
- Análise (analise.StatusAnalise)
- Tesouraria (tesouraria.StatusProcessoTesouraria)
"""

from .choices import StatusCadastro

# Mapeamento: Status da Tesouraria -> Status do Cadastro
TESOURARIA_TO_CADASTRO = {
    'pendente': StatusCadastro.APPROVED_REVIEW,
    'em_processamento': StatusCadastro.APPROVED_REVIEW,
    'em_validacao_video': StatusCadastro.APPROVED_REVIEW,
    'em_averbacao': StatusCadastro.APPROVED_REVIEW,
    'processado': StatusCadastro.EFFECTIVATED,
    'rejeitado': StatusCadastro.CANCELLED,
}

# Mapeamento: Status da Análise -> Status do Cadastro
ANALISE_TO_CADASTRO = {
    'pendente': StatusCadastro.SENT_REVIEW,
    'em_analise': StatusCadastro.SENT_REVIEW,
    'aprovado': StatusCadastro.APPROVED_REVIEW,
    'correcao_feita': StatusCadastro.RESUBMITTED,
    'enviado_para_correcao': StatusCadastro.PENDING_AGENT,
    'correcao_realizada': StatusCadastro.RESUBMITTED,
    'cancelado': StatusCadastro.CANCELLED,
}

# Classes CSS para cada status (unificado)
STATUS_CSS_CLASSES = {
    # Status da Tesouraria
    'pendente': 'status-pendente',
    'em_processamento': 'status-em_validacao_video',
    'em_validacao_video': 'status-em_validacao_video',
    'em_averbacao': 'status-em_averbacao',
    'processado': 'status-processado',
    'rejeitado': 'status-rejeitado',

    # Status da Análise
    'em_analise': 'status-em_validacao_video',
    'aprovado': 'status-processado',
    'correcao_feita': 'status-pendente',
    'enviado_para_correcao': 'status-rejeitado',
    'correcao_realizada': 'status-pendente',
    'cancelado': 'status-rejeitado',

    # Status do Cadastro
    'DRAFT': 'status-default',
    'SENT_REVIEW': 'status-pendente',
    'PENDING_AGENT': 'status-rejeitado',
    'RESUBMITTED': 'status-pendente',
    'APPROVED_REVIEW': 'status-processado',
    'PAYMENT_PENDING': 'status-pendente',
    'EFFECTIVATED': 'status-processado',
    'CANCELLED': 'status-rejeitado',
}

def sync_cadastro_status(cadastro):
    """
    Sincroniza o status do cadastro baseado no status da tesouraria ou análise.
    """
    current_status = cadastro.get_current_status()

    if current_status['source'] == 'tesouraria':
        # Prioridade para status da tesouraria
        new_status = TESOURARIA_TO_CADASTRO.get(current_status['status'])
        if new_status and cadastro.status != new_status:
            cadastro.status = new_status
            cadastro.save(update_fields=['status'])

    elif current_status['source'] == 'analise':
        # Status da análise
        new_status = ANALISE_TO_CADASTRO.get(current_status['status'])
        if new_status and cadastro.status != new_status:
            cadastro.status = new_status
            cadastro.save(update_fields=['status'])

def get_status_css_class(status_value):
    """
    Retorna a classe CSS apropriada para um status.
    """
    return STATUS_CSS_CLASSES.get(status_value, 'status-default')

def get_unified_status_display(cadastro):
    """
    Retorna informações completas do status unificado.
    """
    current_status = cadastro.get_current_status()
    css_class = get_status_css_class(current_status['status'])

    return {
        'status': current_status['status'],
        'display': current_status['display'],
        'source': current_status['source'],
        'date': current_status['date'],
        'css_class': css_class,
    }