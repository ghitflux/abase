"""
Template tags para status unificado e regras de negócio dos botões.
"""

from django import template
from django.utils.safestring import mark_safe
from ..status_mapping import get_unified_status_display, get_status_css_class

register = template.Library()

@register.simple_tag
def unified_status(cadastro):
    """
    Retorna o status unificado do cadastro.
    Usage: {% unified_status cadastro %}
    """
    return get_unified_status_display(cadastro)

@register.simple_tag
def unified_status_display(cadastro):
    """
    Retorna apenas o display do status unificado.
    Usage: {% unified_status_display cadastro %}
    """
    status_info = get_unified_status_display(cadastro)
    return status_info['display']

@register.simple_tag
def unified_status_badge(cadastro):
    """
    Retorna o HTML completo de uma badge com status unificado.
    Usage: {% unified_status_badge cadastro %}
    """
    status_info = get_unified_status_display(cadastro)

    html = f'''
    <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full {status_info['css_class']}">
        {status_info['display']}
    </span>
    '''

    return mark_safe(html)

@register.simple_tag
def can_cancel_process(cadastro):
    """
    Verifica se o processo pode ser cancelado.
    Usage: {% can_cancel_process cadastro %}
    """
    return cadastro.can_cancel()

@register.simple_tag
def can_validacao_video(cadastro):
    """
    Verifica se pode fazer validação de vídeo.
    Usage: {% can_validacao_video cadastro %}
    """
    return cadastro.can_validacao_video()

@register.simple_tag
def can_averbacao(cadastro):
    """
    Verifica se pode fazer averbação.
    Usage: {% can_averbacao cadastro %}
    """
    return cadastro.can_averbacao()

@register.simple_tag
def can_efetivar(cadastro):
    """
    Verifica se pode efetivar contrato.
    Usage: {% can_efetivar cadastro %}
    """
    return cadastro.can_efetivar()

@register.inclusion_tag('cadastros/partials/process_actions.html')
def process_actions(cadastro, module='agente'):
    """
    Renderiza botões de ação baseados nas regras de negócio.
    Usage: {% process_actions cadastro 'agente' %}
    """
    context = {
        'cadastro': cadastro,
        'module': module,
        'status_info': get_unified_status_display(cadastro),
        'can_cancel': cadastro.can_cancel(),
        'can_validacao_video': cadastro.can_validacao_video(),
        'can_averbacao': cadastro.can_averbacao(),
        'can_efetivar': cadastro.can_efetivar(),
    }

    return context

@register.filter
def status_css_class(status_value):
    """
    Retorna a classe CSS para um status.
    Usage: {{ status_value|status_css_class }}
    """
    return get_status_css_class(status_value)

@register.simple_tag
def show_button_if(condition, button_html):
    """
    Exibe botão apenas se a condição for verdadeira.
    Usage: {% show_button_if can_cancel '<button>Cancelar</button>' %}
    """
    if condition:
        return mark_safe(button_html)
    return ''

@register.simple_tag
def status_source_info(cadastro):
    """
    Retorna informações sobre a fonte do status.
    Usage: {% status_source_info cadastro %}
    """
    status_info = get_unified_status_display(cadastro)
    source_names = {
        'tesouraria': 'Tesouraria',
        'analise': 'Análise',
        'cadastro': 'Cadastro'
    }

    return {
        'source': status_info['source'],
        'source_name': source_names.get(status_info['source'], 'Desconhecido'),
        'date': status_info['date']
    }