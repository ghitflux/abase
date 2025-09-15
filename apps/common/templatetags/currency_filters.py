from django import template
from decimal import Decimal
import locale

register = template.Library()

@register.filter
def currency_brl(value):
    """
    Formata um valor decimal para o formato monetário brasileiro (BRL).
    Exemplo: 5200.00 -> "5.200,00"
    """
    if value is None or value == "":
        return "0,00"
    
    try:
        # Converte para Decimal se necessário
        if isinstance(value, str):
            value = Decimal(value)
        elif not isinstance(value, Decimal):
            value = Decimal(str(value))
        
        # Converte para float para formatação
        float_value = float(value)
        
        # Formata com separador de milhares (ponto) e decimais (vírgula)
        formatted = f"{float_value:,.2f}"
        
        # Troca ponto por vírgula para decimais e vírgula por ponto para milhares
        # Primeiro, substitui temporariamente a vírgula decimal
        parts = formatted.split('.')
        if len(parts) == 2:
            integer_part = parts[0].replace(',', '.')
            decimal_part = parts[1]
            return f"{integer_part},{decimal_part}"
        else:
            return formatted.replace(',', '.')
            
    except (ValueError, TypeError, AttributeError):
        return "0,00"

@register.filter
def currency_brl_full(value):
    """
    Formata um valor decimal para o formato monetário brasileiro completo com R$.
    Exemplo: 5200.00 -> "R$ 5.200,00"
    """
    formatted_value = currency_brl(value)
    return f"R$ {formatted_value}"

@register.filter
def days_until(date_value):
    """
    Calcula quantos dias restam até uma data específica.
    Retorna o número de dias ou uma mensagem se a data já passou.
    """
    if not date_value:
        return "Data não informada"
    
    from datetime import date
    today = date.today()
    
    if isinstance(date_value, str):
        from datetime import datetime
        try:
            date_value = datetime.strptime(date_value, '%Y-%m-%d').date()
        except ValueError:
            return "Data inválida"
    
    days_diff = (date_value - today).days
    
    if days_diff < 0:
        return f"Vencido há {abs(days_diff)} dias"
    elif days_diff == 0:
        return "Vence hoje"
    elif days_diff == 1:
        return "Vence amanhã"
    else:
        return f"Vence em {days_diff} dias"