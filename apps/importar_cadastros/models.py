from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
import json


class TipoImportacao(models.TextChoices):
    """Tipos de importação disponíveis"""
    CADASTROS = 'cadastros', 'Cadastros'
    EFETIVADOS = 'efetivados', 'Efetivados'


class StatusImportacao(models.TextChoices):
    """Status do lote de importação"""
    DRAFT = 'draft', 'Rascunho'
    DRY_RUN = 'dry_run', 'Simulação'
    PROCESSING = 'processing', 'Processando'
    COMPLETED = 'completed', 'Concluído'
    ERROR = 'error', 'Erro'


class ImportBatch(models.Model):
    """
    Lote de importação que identifica cada processo de importação.
    Armazena informações sobre o arquivo, mapeamento e estatísticas.
    """
    
    # Identificação
    tipo = models.CharField(
        max_length=20,
        choices=TipoImportacao.choices,
        verbose_name="Tipo de Importação"
    )
    
    # Arquivos
    planilha = models.FileField(
        upload_to="import_batches/%Y/%m/",
        verbose_name="Planilha",
        help_text="Arquivo CSV ou XLSX com os dados para importação"
    )
    
    anexos_zip = models.FileField(
        upload_to="import_batches/%Y/%m/",
        null=True,
        blank=True,
        verbose_name="Anexos ZIP",
        help_text="Arquivo ZIP com documentos organizados por CPF"
    )
    
    # Configuração
    mapping_json = models.JSONField(
        default=dict,
        verbose_name="Mapeamento JSON",
        help_text="Mapeamento das colunas da planilha para campos do modelo"
    )
    
    # Controle
    usuario = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="import_batches",
        verbose_name="Usuário"
    )
    
    status = models.CharField(
        max_length=20,
        choices=StatusImportacao.choices,
        default=StatusImportacao.DRAFT,
        verbose_name="Status"
    )
    
    # Estatísticas
    total_linhas = models.PositiveIntegerField(default=0, verbose_name="Total de Linhas")
    linhas_processadas = models.PositiveIntegerField(default=0, verbose_name="Linhas Processadas")
    linhas_sucesso = models.PositiveIntegerField(default=0, verbose_name="Linhas com Sucesso")
    linhas_erro = models.PositiveIntegerField(default=0, verbose_name="Linhas com Erro")
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Atualizado em")
    started_at = models.DateTimeField(null=True, blank=True, verbose_name="Iniciado em")
    completed_at = models.DateTimeField(null=True, blank=True, verbose_name="Concluído em")
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = "Lote de Importação"
        verbose_name_plural = "Lotes de Importação"
    
    def __str__(self):
        return f"Lote {self.id} - {self.get_tipo_display()} ({self.get_status_display()})"
    
    def get_mapping_display(self):
        """Retorna o mapeamento formatado para exibição"""
        if not self.mapping_json:
            return "Nenhum mapeamento definido"
        return json.dumps(self.mapping_json, indent=2, ensure_ascii=False)
    
    def get_progress_percentage(self):
        """Calcula a porcentagem de progresso"""
        if self.total_linhas == 0:
            return 0
        return round((self.linhas_processadas / self.total_linhas) * 100, 1)
    
    def get_success_percentage(self):
        """Calcula a porcentagem de sucesso"""
        if self.linhas_processadas == 0:
            return 0
        return round((self.linhas_sucesso / self.linhas_processadas) * 100, 1)


class ImportRow(models.Model):
    """
    Linha individual de importação.
    Armazena os dados brutos e o resultado do processamento.
    """
    
    batch = models.ForeignKey(
        ImportBatch,
        on_delete=models.CASCADE,
        related_name="rows",
        verbose_name="Lote"
    )
    
    linha_numero = models.PositiveIntegerField(verbose_name="Número da Linha")
    
    dados_brutos = models.JSONField(
        verbose_name="Dados Brutos",
        help_text="Dados originais da linha da planilha"
    )
    
    sucesso = models.BooleanField(default=False, verbose_name="Sucesso")
    
    mensagem_erro = models.TextField(
        blank=True,
        verbose_name="Mensagem de Erro",
        help_text="Detalhes do erro caso o processamento falhe"
    )
    
    # Relacionamento com o cadastro criado/atualizado (se houver)
    cadastro = models.ForeignKey(
        'cadastros.Cadastro',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="import_rows",
        verbose_name="Cadastro"
    )
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    
    class Meta:
        ordering = ['linha_numero']
        unique_together = ['batch', 'linha_numero']
        verbose_name = "Linha de Importação"
        verbose_name_plural = "Linhas de Importação"
    
    def __str__(self):
        status = "✓" if self.sucesso else "✗"
        return f"Linha {self.linha_numero} {status}"
    
    def get_dados_display(self):
        """Retorna os dados formatados para exibição"""
        return json.dumps(self.dados_brutos, indent=2, ensure_ascii=False)


class ImportDocument(models.Model):
    """
    Documento importado de um arquivo ZIP.
    Vinculado a um cadastro específico.
    """
    
    batch = models.ForeignKey(
        ImportBatch,
        on_delete=models.CASCADE,
        related_name="documents",
        verbose_name="Lote"
    )
    
    cadastro = models.ForeignKey(
        'cadastros.Cadastro',
        on_delete=models.CASCADE,
        related_name="import_documents",
        verbose_name="Cadastro"
    )
    
    tipo = models.CharField(
        max_length=50,
        verbose_name="Tipo do Documento",
        help_text="Tipo identificado pelo nome do arquivo"
    )
    
    arquivo = models.FileField(
        upload_to="import_cadastros_docs/%Y/%m/",
        verbose_name="Arquivo"
    )
    
    nome_original = models.CharField(
        max_length=255,
        verbose_name="Nome Original",
        help_text="Nome original do arquivo no ZIP"
    )
    
    cpf_pasta = models.CharField(
        max_length=11,
        verbose_name="CPF da Pasta",
        help_text="CPF da pasta onde o arquivo estava no ZIP"
    )
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    
    class Meta:
        ordering = ['cadastro', 'tipo', 'nome_original']
        verbose_name = "Documento Importado"
        verbose_name_plural = "Documentos Importados"
    
    def __str__(self):
        return f"{self.cadastro} - {self.tipo} - {self.nome_original}"