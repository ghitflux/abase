from django.db import models
from django.contrib.auth.models import User
import uuid

class StatusImportacao(models.TextChoices):
    PENDENTE = 'PENDENTE', 'Pendente'
    PROCESSANDO = 'PROCESSANDO', 'Processando'
    CONCLUIDO = 'CONCLUIDO', 'Concluído'
    ERRO = 'ERRO', 'Erro'

class ArquivoImportacao(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    nome_arquivo = models.CharField(max_length=255)
    arquivo = models.FileField(upload_to='importacoes/')
    tipo_arquivo = models.CharField(max_length=10, choices=[('CSV', 'CSV'), ('TXT', 'TXT')])
    competencia = models.CharField(max_length=7, help_text="Formato YYYY-MM")
    status = models.CharField(max_length=12, choices=StatusImportacao.choices, default=StatusImportacao.PENDENTE)
    usuario = models.ForeignKey(User, on_delete=models.CASCADE)
    data_upload = models.DateTimeField(auto_now_add=True)
    data_processamento = models.DateTimeField(null=True, blank=True)
    total_linhas = models.IntegerField(default=0)
    linhas_processadas = models.IntegerField(default=0)
    linhas_com_erro = models.IntegerField(default=0)
    log_erros = models.TextField(blank=True)
    
    class Meta:
        ordering = ['-data_upload']
    
    def __str__(self):
        return f"{self.nome_arquivo} - {self.competencia} ({self.status})"
