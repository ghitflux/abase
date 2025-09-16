# currency_filters.py
from django import template
from decimal import Decimal, InvalidOperation
import re

register = template.Library()

def _parse_brl_to_decimal(value):
    """
    Aceita:
      - Decimal, int, float
      - '5200.00', '5.200,00', 'R$ 5.200,00', '520000' (centavos)
    Retorna Decimal('5200.00') ou None.
    """
    if value is None or value == "":
        return None
    if isinstance(value, (int, float, Decimal)):
        return Decimal(str(value))
    s = str(value).strip()
    # só dígitos -> tratar como centavos (ex.: '520000' -> 5200.00)
    if re.fullmatch(r"\d+", s):
        return (Decimal(s) / Decimal("100")).quantize(Decimal("0.01"))
    # limpa 'R$' e milhares
    s = s.replace("R$", "").strip()
    s = re.sub(r"\.(?=\d{3}(?:\D|$))", "", s)  # remove ponto de milhar
    s = s.replace(",", ".")                    # vírgula -> ponto
    s = re.sub(r"[^0-9.]", "", s)              # remove extras
    try:
        return Decimal(s)
    except (InvalidOperation, ValueError):
        return None

@register.filter
def currency_brl(value):
    """
    Exibe '5.200,00' (sem 'R$'). PARA TELA DE LEITURA, não para value="" de <input>.
    """
    d = _parse_brl_to_decimal(value)
    if d is None:
        return "0,00"
    # formata com separador de milhar e 2 casas SEM converter para float
    s = f"{d:,.2f}"                 # 5,200.00
    s = s.replace(",", "§").replace(".", ",").replace("§", ".")
    return s

@register.filter
def currency_brl_full(value):
    """
    Exibe 'R$ 5.200,00'.
    """
    return f"R$ {currency_brl(value)}"

@register.filter
def days_until(date_value):
    # (inalterado)
    from datetime import date, datetime
    if not date_value:
        return "Data não informada"
    today = date.today()
    if isinstance(date_value, str):
        try:
            date_value = datetime.strptime(date_value, '%Y-%m-%d').date()
        except ValueError:
            return "Data inválida"
    days_diff = (date_value - today).days
    if days_diff < 0:
        return f"Vencido há {abs(days_diff)} dias"
    if days_diff == 0:
        return "Vence hoje"
    if days_diff == 1:
        return "Vence amanhã"
    return f"Vence em {days_diff} dias"
