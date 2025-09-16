from django.db import models

class StatusCadastro(models.TextChoices):
    DRAFT = "DRAFT", "Rascunho"
    SENT_REVIEW = "SENT_REVIEW", "Enviado para análise"
    PENDING_AGENT = "PENDING_AGENT", "Pendência com agente"
    RESUBMITTED = "RESUBMITTED", "Reenviado pelo agente"
    APPROVED_REVIEW = "APPROVED_REVIEW", "Aprovado em análise"
    PAYMENT_PENDING = "PAYMENT_PENDING", "Pendente de pagamento"
    EFFECTIVATED = "EFFECTIVATED", "Efetivado"
    CANCELLED = "CANCELLED", "Cancelado"

class TipoPessoa(models.TextChoices):
    PF = "PF", "Pessoa Física"
    PJ = "PJ", "Pessoa Jurídica"

class EstadoCivil(models.TextChoices):
    SOLTEIRO = "SOLTEIRO", "Solteiro(a)"
    CASADO = "CASADO", "Casado(a)"
    DIVORCIADO = "DIVORCIADO", "Divorciado(a)"
    VIUVO = "VIUVO", "Viúvo(a)"
    UNIAO_ESTAVEL = "UNIAO_ESTAVEL", "União Estável"

class TipoConta(models.TextChoices):
    CC = "CC", "Conta Corrente"
    PP = "PP", "Poupança"

class TipoChavePix(models.TextChoices):
    CPF = "CPF", "CPF"
    CNPJ = "CNPJ", "CNPJ"
    EMAIL = "EMAIL", "E-mail"
    TELEFONE = "TELEFONE", "Telefone"
    ALEATORIA = "ALEATORIA", "Chave Aleatória"

class SituacaoServidor(models.TextChoices):
    ATIVO = "ATIVO", "Ativo"
    EFETIVO = "EFETIVO", "Efetivo"
    COMISSIONADO = "COMISSIONADO", "Comissionado"
    APOSENTADO = "APOSENTADO", "Aposentado"
    PENSIONISTA = "PENSIONISTA", "Pensionista"
    LICENCIADO = "LICENCIADO", "Licenciado"
    OUTRO = "OUTRO", "Outro"

class StatusParcela(models.TextChoices):
    PENDENTE = "PENDENTE", "Pendente"
    LIQUIDADA = "LIQUIDADA", "Liquidada"

ESTADO_CHOICES = [
    ('AC', 'Acre'),
    ('AL', 'Alagoas'),
    ('AP', 'Amapá'),
    ('AM', 'Amazonas'),
    ('BA', 'Bahia'),
    ('CE', 'Ceará'),
    ('DF', 'Distrito Federal'),
    ('ES', 'Espírito Santo'),
    ('GO', 'Goiás'),
    ('MA', 'Maranhão'),
    ('MT', 'Mato Grosso'),
    ('MS', 'Mato Grosso do Sul'),
    ('MG', 'Minas Gerais'),
    ('PA', 'Pará'),
    ('PB', 'Paraíba'),
    ('PR', 'Paraná'),
    ('PE', 'Pernambuco'),
    ('PI', 'Piauí'),
    ('RJ', 'Rio de Janeiro'),
    ('RN', 'Rio Grande do Norte'),
    ('RS', 'Rio Grande do Sul'),
    ('RO', 'Rondônia'),
    ('RR', 'Roraima'),
    ('SC', 'Santa Catarina'),
    ('SP', 'São Paulo'),
    ('SE', 'Sergipe'),
    ('TO', 'Tocantins'),
]