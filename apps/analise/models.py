from django.db import models
from django.contrib.auth.models import User
from apps.cadastros.models import Cadastro
# Remove unused import


class StatusAnalise(models.TextChoices):
    """Status possíveis para análise de cadastros"""
    PENDENTE = 'pendente', 'Pendente de Análise'
    EM_ANALISE = 'em_analise', 'Em Análise'
    APROVADO = 'aprovado', 'Aprovado - Encaminhado para Tesouraria'
    CORRECAO_FEITA = 'correcao_feita', 'Correção Feita - Aguardando Nova Análise'
    ENVIADO_PARA_CORRECAO = 'enviado_para_correcao', 'Enviado para Correção'
    CORRECAO_REALIZADA = 'correcao_realizada', 'Correção Realizada'
    CANCELADO = 'cancelado', 'Cancelado Definitivamente'


class TipoAnalise(models.TextChoices):
    """Tipos de análise realizadas"""
    DOCUMENTAL = 'documental', 'Análise Documental'
    DADOS = 'dados', 'Análise de Dados'
    COMPLETA = 'completa', 'Análise Completa'


class AnaliseProcesso(models.Model):
    """
    Modelo principal para controle da esteira de análise de cadastros.
    
    Cada cadastro criado por um agente entra automaticamente na esteira
    de análise para verificação de documentos e dados antes de ser
    encaminhado para a tesouraria.
    """
    
    # Relacionamentos
    cadastro = models.OneToOneField(
        Cadastro,
        on_delete=models.CASCADE,
        related_name='analise_processo',
        verbose_name='Cadastro'
    )
    
    analista_responsavel = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='analises_responsavel',
        verbose_name='Analista Responsável'
    )
    
    # Status e controle
    status = models.CharField(
        max_length=25,
        choices=StatusAnalise.choices,
        default=StatusAnalise.PENDENTE,
        verbose_name='Status da Análise'
    )
    
    tipo_analise = models.CharField(
        max_length=20,
        choices=TipoAnalise.choices,
        default=TipoAnalise.COMPLETA,
        verbose_name='Tipo de Análise'
    )
    
    prioridade = models.IntegerField(
        default=1,
        choices=[
            (1, 'Baixa'),
            (2, 'Normal'),
            (3, 'Alta'),
            (4, 'Urgente')
        ],
        verbose_name='Prioridade'
    )
    
    # Datas de controle
    data_entrada = models.DateTimeField(
        auto_now_add=True,
        verbose_name='Data de Entrada na Análise'
    )
    
    data_inicio_analise = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Data de Início da Análise'
    )
    
    data_conclusao = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Data de Conclusão'
    )
    
    # Observações e feedback
    observacoes_analista = models.TextField(
        blank=True,
        verbose_name='Observações do Analista',
        help_text='Observações internas do analista durante a análise'
    )
    
    feedback_agente = models.TextField(
        blank=True,
        verbose_name='Feedback para o Agente',
        help_text='Feedback que será enviado ao agente em caso de rejeição'
    )
    
    # Controle de SLA
    prazo_analise = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Prazo para Análise',
        help_text='Prazo limite para conclusão da análise'
    )
    
    class Meta:
        verbose_name = 'Processo de Análise'
        verbose_name_plural = 'Processos de Análise'
        ordering = ['-prioridade', 'data_entrada']
        
    def __str__(self):
        return f'Análise #{self.id} - {self.cadastro.nome_completo}'
    
    @property
    def tempo_na_esteira(self):
        """Calcula o tempo que o processo está na esteira"""
        from django.utils import timezone
        if self.data_conclusao:
            return self.data_conclusao - self.data_entrada
        return timezone.now() - self.data_entrada
    
    @property
    def em_atraso(self):
        """Verifica se o processo está em atraso"""
        if not self.prazo_analise:
            return False
        from django.utils import timezone
        return timezone.now() > self.prazo_analise and not self.data_conclusao


class ChecklistAnalise(models.Model):
    """
    Checklist de itens a serem verificados durante a análise.
    
    Permite controlar quais documentos e informações foram
    verificados durante o processo de análise.
    """
    
    processo = models.ForeignKey(
        AnaliseProcesso,
        on_delete=models.CASCADE,
        related_name='checklist_itens',
        verbose_name='Processo de Análise'
    )
    
    item = models.CharField(
        max_length=200,
        verbose_name='Item do Checklist'
    )
    
    verificado = models.BooleanField(
        default=False,
        verbose_name='Verificado'
    )
    
    obrigatorio = models.BooleanField(
        default=True,
        verbose_name='Obrigatório'
    )
    
    observacoes = models.TextField(
        blank=True,
        verbose_name='Observações',
        help_text='Observações sobre este item específico'
    )
    
    verificado_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name='Verificado por'
    )
    
    data_verificacao = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Data da Verificação'
    )
    
    class Meta:
        verbose_name = 'Item do Checklist'
        verbose_name_plural = 'Itens do Checklist'
        unique_together = ['processo', 'item']
        
    def __str__(self):
        status = '✓' if self.verificado else '✗'
        return f'{status} {self.item}'


class HistoricoAnalise(models.Model):
    """
    Histórico de mudanças de status e ações realizadas
    durante o processo de análise.
    """
    
    processo = models.ForeignKey(
        AnaliseProcesso,
        on_delete=models.CASCADE,
        related_name='historico',
        verbose_name='Processo de Análise'
    )
    
    usuario = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        verbose_name='Usuário'
    )
    
    acao = models.CharField(
        max_length=100,
        verbose_name='Ação Realizada'
    )
    
    status_anterior = models.CharField(
        max_length=25,
        choices=StatusAnalise.choices,
        null=True,
        blank=True,
        verbose_name='Status Anterior'
    )
    
    status_novo = models.CharField(
        max_length=25,
        choices=StatusAnalise.choices,
        null=True,
        blank=True,
        verbose_name='Novo Status'
    )
    
    observacoes = models.TextField(
        blank=True,
        verbose_name='Observações'
    )
    
    data_acao = models.DateTimeField(
        auto_now_add=True,
        verbose_name='Data da Ação'
    )
    
    class Meta:
        verbose_name = 'Histórico de Análise'
        verbose_name_plural = 'Histórico de Análises'
        ordering = ['-data_acao']
        
    def __str__(self):
        return f'{self.acao} - {self.data_acao.strftime("%d/%m/%Y %H:%M")}'
