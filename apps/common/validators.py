import re
from django.core.exceptions import ValidationError
from .normalize import digits

# ---------------- CPF ----------------
def cpf_is_valid(cpf: str) -> bool:
    cpf = digits(cpf)
    if len(cpf) != 11 or cpf == cpf[0]*11:
        return False
    def dv(c, m):
        s = sum(int(c[i])*(m-i) for i in range(m-1))
        r = (s*10) % 11
        return 0 if r == 10 else r
    return int(cpf[9]) == dv(cpf, 10) and int(cpf[10]) == dv(cpf, 11)

def validate_cpf(value: str):
    if value and not cpf_is_valid(value):
        raise ValidationError("CPF inválido.")

# ---------------- CNPJ ----------------
def cnpj_is_valid(cnpj: str) -> bool:
    cnpj = digits(cnpj)
    if len(cnpj) != 14 or cnpj == cnpj[0]*14:
        return False
    pesos1 = [5,4,3,2,9,8,7,6,5,4,3,2]
    pesos2 = [6]+pesos1
    def dv(nums, pesos):
        s = sum(int(n)*p for n,p in zip(nums, pesos))
        r = s % 11
        return 0 if r < 2 else 11 - r
    d1 = dv(cnpj[:12], pesos1)
    d2 = dv(cnpj[:12]+str(d1), pesos2)
    return cnpj[-2:] == f"{d1}{d2}"

def validate_cnpj(value: str):
    if value and not cnpj_is_valid(value):
        raise ValidationError("CNPJ inválido.")

# ---------------- CEP ----------------
def validate_cep(value: str):
    v = digits(value)
    if v and len(v) != 8:
        raise ValidationError("CEP deve ter 8 dígitos.")

# ---------------- PIX ----------------
EMAIL_RE = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
PHONE_RE = re.compile(r"^\+?\d{10,15}$")
UUID_RE  = re.compile(r"^[0-9a-f]{32}$|^[0-9a-f\-]{36}$", re.I)

def validate_pix(value: str):
    v = (value or "").strip()
    if not v:
        return
    if EMAIL_RE.match(v):
        return  # e-mail ok
    dv = digits(v)
    # telefone (com ou sem +), cpf, cnpj, ou chave aleatória uuid-like
    if PHONE_RE.match(v) or cpf_is_valid(dv) or cnpj_is_valid(dv) or UUID_RE.match(v):
        return
    raise ValidationError("Chave PIX inválida (CPF/CNPJ, e-mail, celular ou chave aleatória).")