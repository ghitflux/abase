from django.db import models
from django.conf import settings

class ImportacaoContribuicao(models.Model):
    referencia = models.DateField(help_text="Primeiro dia do mês de referência (ex.: 2025-05-01)")
    data_geracao = models.DateField(null=True, blank=True)
    arquivo_nome = models.CharField(max_length=255)
    arquivo_sha256 = models.CharField(max_length=64, unique=True)
    criado_por = models.ForeignKey(settings.AUTH_USER_MODEL, null=True, blank=True, on_delete=models.SET_NULL)
    criado_em = models.DateTimeField(auto_now_add=True)

    total_linhas = models.PositiveIntegerField(default=0)
    total_processados = models.PositiveIntegerField(default=0)
    total_atualizados = models.PositiveIntegerField(default=0)
    total_ignorados = models.PositiveIntegerField(default=0)
    total_nao_encontrados = models.PositiveIntegerField(default=0)

    def __str__(self):
        return f"Importação {self.referencia:%Y-%m} • {self.arquivo_nome}"

class ImportacaoOcorrencia(models.Model):
    ACOES = [
        ("MARCADA_LIQUIDADA","Parcela marcada como liquidada"),
        ("IGNORADA_STATUS","Linha ignorada pelo status externo"),
        ("CADASTRO_NAO_EFETIVADO","Cadastro não está efetivado"),
        ("CPF_MATRICULA_NAO_ENCONTRADO","Cadastro não encontrado por CPF+Matrícula"),
        ("PARCELA_DO_MES_NAO_ENCONTRADA","Não há parcela do mês de referência"),
    ]
    importacao = models.ForeignKey(ImportacaoContribuicao, related_name="ocorrencias", on_delete=models.CASCADE)
    cpf = models.CharField(max_length=14)
    matricula = models.CharField(max_length=32)
    nome = models.CharField(max_length=200, blank=True)
    orgao_pagto = models.CharField(max_length=32, blank=True)
    valor = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    status_externo = models.CharField(max_length=2)
    status_legenda = models.CharField(max_length=200)
    acao = models.CharField(max_length=64, choices=ACOES)
    mensagem = models.TextField(blank=True)
    criado_em = models.DateTimeField(auto_now_add=True)

    cadastro_id = models.IntegerField(null=True, blank=True)
    parcela_id = models.IntegerField(null=True, blank=True)
