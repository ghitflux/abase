from django.db import models
from django.contrib.auth import get_user_model
from django.core.validators import MinValueValidator, MaxValueValidator
from decimal import Decimal
from .choices import (
    StatusCadastro, TipoPessoa, EstadoCivil, TipoConta,
    SituacaoServidor, StatusParcela
)

User = get_user_model()

class Cadastro(models.Model):
    """
    Cadastro do associado (sem campos de observação).
    Cálculos automáticos são atualizados ao salvar.
    """

    # ---- Dados cadastrais ----
    tipo_pessoa          = models.CharField(max_length=2, choices=TipoPessoa.choices, default=TipoPessoa.PF)
    cpf                  = models.CharField("CPF", max_length=11, blank=True, db_index=True)   # PF
    cnpj                 = models.CharField("CNPJ", max_length=14, blank=True, db_index=True)  # PJ
    rg                   = models.CharField("RG", max_length=20, blank=True)
    orgao_expedidor      = models.CharField("Órgão Expedidor", max_length=20, blank=True)

    nome_razao_social    = models.CharField("Nome/Razão Social", max_length=180)
    nome_completo        = models.CharField("Nome completo", max_length=180, blank=True)       # PF
    data_nascimento      = models.DateField("Data de nascimento", null=True, blank=True)
    profissao            = models.CharField("Profissão", max_length=120, blank=True)
    estado_civil         = models.CharField("Estado civil", max_length=20, choices=EstadoCivil.choices, blank=True)

    # ---- Endereço ----
    cep                  = models.CharField("CEP", max_length=8, blank=True)
    endereco             = models.CharField("Endereço", max_length=180, blank=True)
    numero               = models.CharField("Nº", max_length=10, blank=True)
    complemento          = models.CharField("Complemento", max_length=60, blank=True)
    bairro               = models.CharField("Bairro", max_length=80, blank=True)
    cidade               = models.CharField("Cidade", max_length=80, blank=True)
    uf                   = models.CharField("UF", max_length=2, blank=True)

    # ---- Dados bancários ----
    banco                = models.CharField("Banco", max_length=120, blank=True)
    agencia              = models.CharField("Agência", max_length=15, blank=True)
    conta                = models.CharField("Conta", max_length=20, blank=True)
    tipo_conta           = models.CharField("Tipo de Conta", max_length=2, choices=TipoConta.choices, blank=True)
    chave_pix            = models.CharField("Chave Pix", max_length=120, blank=True)

    # ---- Contato e vínculo público ----
    celular              = models.CharField("Celular", max_length=20, blank=True)
    email                = models.EmailField("E-mail", blank=True)
    orgao_publico        = models.CharField("Órgão Público", max_length=120, blank=True)
    situacao_servidor    = models.CharField("Situação do Servidor", max_length=20, choices=SituacaoServidor.choices, blank=True)
    matricula_servidor   = models.CharField("Matrícula do Servidor Público", max_length=30, db_index=True)

    # ---- Dados para cálculo de margem (pré-validação) ----
    valor_bruto_total    = models.DecimalField("Valor Bruto Total", max_digits=12, decimal_places=2, null=True, blank=True)
    valor_liquido        = models.DecimalField("Valor Líquido (contra-cheque)", max_digits=12, decimal_places=2, null=True, blank=True)
    prazo_antecipacao_meses = models.PositiveSmallIntegerField("Prazo de Antecipação (meses)", default=3, validators=[MinValueValidator(1), MaxValueValidator(12)])

    # calculados
    trinta_porcento_bruto       = models.DecimalField("30% do Bruto", max_digits=12, decimal_places=2, default=Decimal("0.00"))
    margem_liquido_menos_30_bruto = models.DecimalField("Margem (Líquido - 30% do Bruto)", max_digits=12, decimal_places=2, default=Decimal("0.00"))

    # ---- Detalhes do contrato ----
    mensalidade_associativa = models.DecimalField("Contribuição Associativa (R$)", max_digits=12, decimal_places=2, default=Decimal("0.00"))
    taxa_antecipacao_percent = models.DecimalField("Taxa de Antecipação (%)", max_digits=5, decimal_places=2, default=Decimal("30.00"))  # sempre 30%
    disponivel              = models.DecimalField("Repasse ao Associado (R$)", max_digits=12, decimal_places=2, default=Decimal("0.00"))
    valor_total_antecipacao = models.DecimalField("Total das 3 Cotas (R$)", max_digits=12, decimal_places=2, default=Decimal("0.00"))
    data_aprovacao          = models.DateField("Data da Aprovação", null=True, blank=True)
    data_primeira_mensalidade = models.DateField("Data da primeira contribuição", null=True, blank=True)
    mes_averbacao           = models.CharField("Mês de Averbação (AAAA-MM)", max_length=7, blank=True)
    doacao_associado        = models.DecimalField("Doação do Associado (R$)", max_digits=12, decimal_places=2, default=Decimal("0.00"))

    # ---- Agente ----
    agente_responsavel      = models.ForeignKey(User, on_delete=models.PROTECT, related_name="cadastros", verbose_name="Agente Responsável")
    agente_padrao           = models.BooleanField("Agente Padrão", default=False)
    auxilio_agente_taxa_percent = models.DecimalField("Auxílio do Agente (%)", max_digits=5, decimal_places=2, default=Decimal("10.00"))  # sempre 10%
    data_envio              = models.DateField("Data do Envio", null=True, blank=True)

    # ---- Fluxo ----
    status                 = models.CharField(max_length=32, choices=StatusCadastro.choices, db_index=True, default=StatusCadastro.DRAFT)
    cadastro_anterior      = models.ForeignKey("self", null=True, blank=True, on_delete=models.SET_NULL, related_name="renovacoes")

    # ---- Timestamps ----
    created_at             = models.DateTimeField(auto_now_add=True)
    updated_at             = models.DateTimeField(auto_now=True)
    approved_at            = models.DateTimeField(null=True, blank=True)
    paid_at                = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ["-created_at"]
        indexes = [
            models.Index(fields=["cpf"]),
            models.Index(fields=["cnpj"]),
            models.Index(fields=["matricula_servidor"]),
            models.Index(fields=["status"]),
            models.Index(fields=["created_at"]),
        ]

    # ---- Cálculos automáticos ----
    def recalc(self):
        bruto   = self.valor_bruto_total or Decimal("0")
        liquido = self.valor_liquido or Decimal("0")
        mensal  = self.mensalidade_associativa or Decimal("0")
        self.taxa_antecipacao_percent = Decimal("30.00")  # fixo
        self.trinta_porcento_bruto = (bruto * Decimal("0.30")).quantize(Decimal("0.01"))
        self.margem_liquido_menos_30_bruto = (liquido - self.trinta_porcento_bruto).quantize(Decimal("0.01"))
        self.valor_total_antecipacao = (mensal * Decimal("3")).quantize(Decimal("0.01"))
        self.doacao_associado = (self.valor_total_antecipacao * Decimal("0.30")).quantize(Decimal("0.01"))
        self.disponivel = (self.valor_total_antecipacao * Decimal("0.70")).quantize(Decimal("0.01"))

    def save(self, *args, **kwargs):
        self.recalc()
        super().save(*args, **kwargs)

    def __str__(self):
        doc = self.cpf or self.cnpj or "—"
        return f"{self.nome_razao_social} • {doc} • {self.get_status_display()}"

class ParcelaAntecipacao(models.Model):
    cadastro   = models.ForeignKey(Cadastro, on_delete=models.CASCADE, related_name="parcelas")
    numero     = models.PositiveSmallIntegerField("Nº Mensalidade", validators=[MinValueValidator(1), MaxValueValidator(3)])
    valor      = models.DecimalField("Valor (R$)", max_digits=12, decimal_places=2, default=Decimal("0.00"))
    vencimento = models.DateField("Vencimento", null=True, blank=True)
    status     = models.CharField("Status", max_length=12, choices=StatusParcela.choices, default=StatusParcela.PENDENTE)

    class Meta:
        unique_together = ("cadastro","numero")
        ordering = ["numero"]