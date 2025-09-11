import re

_ONLY_DIGITS = re.compile(r"\D+")

def digits(s: str) -> str:
    """Mantém apenas dígitos."""
    return "" if s is None else _ONLY_DIGITS.sub("", s)

def upper(s: str) -> str:
    return (s or "").upper().strip()

def cep_clean(s: str) -> str:
    """Retorna exatamente 8 dígitos, sem máscara."""
    return digits(s)[:8]

def cpf_clean(s: str) -> str:
    """Retorna exatamente 11 dígitos, sem máscara."""
    return digits(s)[:11]

def cnpj_clean(s: str) -> str:
    """Retorna exatamente 14 dígitos, sem máscara."""
    return digits(s)[:14]

def phone_clean(s: str) -> str:
    """
    Normaliza telefone para somente dígitos (até 15).
    (Ex.: para +55DDDNÚMERO, mantenha a origem; guardamos sem +, apenas dígitos).
    """
    return digits(s)[:15]