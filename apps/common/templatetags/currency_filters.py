from django import template
from decimal import Decimal, InvalidOperation
from datetime import date, datetime

register = template.Library()

def _to_decimal(value) -> Decimal:
    """Converte vários formatos (incluindo 'R$ 1.234,56') para Decimal com segurança."""
    if value is None or value == "":
        return Decimal("0")

    if isinstance(value, Decimal):
        return value

    if isinstance(value, (int, float)):
        return Decimal(str(value))

    if isinstance(value, str):
        s = value.strip()
        # remove "R$", espaços e NBSP
        s = s.replace("R$", "").replace("\xa0", "").replace(" ", "")
        # remove separador de milhar brasileiro e troca vírgula por ponto nos decimais
        s = s.replace(".", "").replace(",", ".")
        try:
            return Decimal(s)
        except InvalidOperation:
            return Decimal("0")

    return Decimal("0")


def _format_brl(dec: Decimal) -> str:
    # formata 1.234,56
    q = f"{dec:,.2f}"  # -> '1,234.56'
    inteiro, decimal = q.split(".")
    inteiro = inteiro.replace(",", ".")
    return f"{inteiro},{decimal}"


@register.filter
def currency_brl(value):
    """
    Formata para '1.234,56' (sem R$).
    Aceita Decimal, int, float e str (incluindo 'R$ 1.234,56').
    """
    dec = _to_decimal(value)
    return _format_brl(dec)


@register.filter
def currency_brl_full(value):
    """
    Formata para 'R$ 1.234,56'.
    """
    return f"R$ {currency_brl(value)}"


@register.filter
def days_until(date_value):
    """
    Quantos dias faltam até uma data (YYYY-MM-DD ou date).
    """
    if not date_value:
        return "Data não informada"

    today = date.today()

    if isinstance(date_value, str):
        try:
            date_value = datetime.strptime(date_value, "%Y-%m-%d").date()
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
