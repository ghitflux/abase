"""
Modelos da app Tesouraria

Esta app gerencia movimentações de recursos de organizações sem fins lucrativos,
focando em gestão transparente de entradas e saídas de tesouraria.
"""

from django.db import models
from django.contrib.auth.models import User
import uuid


class MovimentacaoTesouraria(models.Model):
    """
    Modelo para registrar movimentações da tesouraria
    
    Registra entradas e saídas de recursos, permitindo controle
    transparente das movimentações financeiras da organização.
    """
    
    TIPO_CHOICES = [
        ('entrada', 'Entrada de Recurso'),
        ('saida', 'Saída de Recurso'),
    ]
    
    # Campos principais
    descricao = models.CharField(
        max_length=200, 
        verbose_name="Descrição",
        help_text="Descrição detalhada da movimentação"
    )
    valor = models.DecimalField(
        max_digits=10, 
        decimal_places=2,
        verbose_name="Valor",
        help_text="Valor da movimentação em reais"
    )
    tipo = models.CharField(
        max_length=10, 
        choices=TIPO_CHOICES,
        verbose_name="Tipo de Movimentação"
    )
    data = models.DateField(
        verbose_name="Data da Movimentação"
    )
    
    # Relacionamentos
    usuario = models.ForeignKey(
        User, 
        on_delete=models.CASCADE,
        verbose_name="Usuário Responsável",
        help_text="Usuário que registrou a movimentação"
    )
    
    # Campos opcionais
    observacoes = models.TextField(
        blank=True, 
        null=True,
        verbose_name="Observações",
        help_text="Informações adicionais sobre a movimentação"
    )
    
    # Auditoria
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name="Criado em"
    )
    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name="Atualizado em"
    )
    
    class Meta:
        verbose_name = 'Movimentação de Tesouraria'
        verbose_name_plural = 'Movimentações de Tesouraria'
        ordering = ['-data', '-created_at']
        db_table = 'tesouraria_movimentacao'
    
    def __str__(self):
        """Representação textual da movimentação"""
        return f'{self.descricao} - {self.get_tipo_display()} - R$ {self.valor}'
    
    def get_valor_formatado(self):
        """Retorna valor formatado em moeda brasileira"""
        return f"R$ {self.valor:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")


class StatusMensalidade(models.TextChoices):
    PENDENTE = 'PENDENTE', 'Pendente'
    LIQUIDADA = 'LIQUIDADA', 'Liquidada'
    CANCELADA = 'CANCELADA', 'Cancelada'


class Mensalidade(models.Model):
    """
    Modelo para mensalidades importadas de arquivos CSV/TXT
    
    Registra mensalidades que serão conciliadas com parcelas dos cadastros.
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    competencia = models.CharField(max_length=7, help_text="Formato YYYY-MM")
    cpf = models.CharField(max_length=14)
    matricula = models.CharField(max_length=50)
    status = models.CharField(max_length=10, choices=StatusMensalidade.choices, default=StatusMensalidade.PENDENTE)
    valor = models.DecimalField(max_digits=10, decimal_places=2)
    data_importacao = models.DateTimeField(auto_now_add=True)
    data_liquidacao = models.DateTimeField(null=True, blank=True)
    observacoes = models.TextField(blank=True)
    
    class Meta:
        unique_together = ['competencia', 'cpf', 'matricula']
        ordering = ['-competencia', 'cpf']
        verbose_name = 'Mensalidade'
        verbose_name_plural = 'Mensalidades'
    
    def __str__(self):
        return f"{self.competencia} - {self.cpf} - {self.matricula}"


class ReconciliacaoLog(models.Model):
    """
    Log das execuções do processo de reconciliação automática
    """
    data_execucao = models.DateTimeField(auto_now_add=True)
    total_processados = models.IntegerField(default=0)
    total_conciliados = models.IntegerField(default=0)
    detalhes = models.TextField(blank=True)
    executado_por = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    
    class Meta:
        ordering = ['-data_execucao']
        verbose_name = 'Log de Reconciliação'
        verbose_name_plural = 'Logs de Reconciliação'
    
    def __str__(self):
        return f"Reconciliação {self.data_execucao.strftime('%d/%m/%Y %H:%M')}"


class StatusProcessoTesouraria(models.TextChoices):
    """Status possíveis para processos na tesouraria"""
    PENDENTE = 'pendente', 'Pendente de Processamento'
    EM_PROCESSAMENTO = 'em_processamento', 'Em Processamento'
    EM_VALIDACAO_VIDEO = 'em_validacao_video', 'Em Validação Vídeo'
    EM_AVERBACAO = 'em_averbacao', 'Em Averbação'
    PROCESSADO = 'processado', 'Processado com Sucesso'
    REJEITADO = 'rejeitado', 'Rejeitado'
    

class ProcessoTesouraria(models.Model):
    """
    Modelo para processos que chegam da análise para a tesouraria.
    
    Representa cadastros aprovados na análise que precisam ser
    processados pela tesouraria.
    """
    
    # Relacionamentos
    cadastro = models.OneToOneField(
        'cadastros.Cadastro',
        on_delete=models.CASCADE,
        related_name='processo_tesouraria',
        verbose_name='Cadastro'
    )
    
    origem_analise = models.ForeignKey(
        'analise.AnaliseProcesso',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='processos_tesouraria',
        verbose_name='Origem da Análise'
    )
    
    # Status e controle
    status = models.CharField(
        max_length=20,
        choices=StatusProcessoTesouraria.choices,
        default=StatusProcessoTesouraria.PENDENTE,
        verbose_name='Status do Processo'
    )
    
    # Informações da análise
    observacoes_analise = models.TextField(
        blank=True,
        verbose_name='Observações da Análise',
        help_text='Observações vindas do processo de análise'
    )
    
    # Agente responsável pelo cadastro
    agente_responsavel = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='processos_tesouraria_agente',
        verbose_name='Agente Responsável',
        help_text='Agente que fez o cadastro original'
    )
    
    # Datas de controle
    data_entrada = models.DateTimeField(
        auto_now_add=True,
        verbose_name='Data de Entrada na Tesouraria'
    )
    
    data_processamento = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Data do Processamento'
    )
    
    # Responsável pelo processamento
    processado_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='processos_tesouraria_processados',
        verbose_name='Processado por'
    )

    # Analista que originou a aprovação (para retorno de pendências)
    analista_origem = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='processos_tesouraria_origem',
        verbose_name='Analista de Origem',
        help_text='Analista que primeiro assumiu e aprovou este processo'
    )

    # Data em que a análise foi aprovada
    data_aprovacao = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Data da Aprovação',
        help_text='Data e hora em que o processo foi aprovado na análise'
    )
    
    # Observações da tesouraria
    observacoes_tesouraria = models.TextField(
        blank=True,
        verbose_name='Observações da Tesouraria',
        help_text='Observações internas da tesouraria'
    )
    
    # Comprovantes de pagamento
    comprovante_associado = models.FileField(
        upload_to='tesouraria/comprovantes/associados/',
        blank=True,
        null=True,
        verbose_name='Comprovante de Pagamento do Associado',
        help_text='Comprovante do pagamento liberado para o associado'
    )
    
    comprovante_agente = models.FileField(
        upload_to='tesouraria/comprovantes/agentes/',
        blank=True,
        null=True,
        verbose_name='Comprovante de Pagamento do Agente',
        help_text='Comprovante do auxílio pago ao agente'
    )
    
    class Meta:
        verbose_name = 'Processo da Tesouraria'
        verbose_name_plural = 'Processos da Tesouraria'
        ordering = ['-data_entrada']
        
    def __str__(self):
        return f'Processo #{self.id} - {self.cadastro.nome_completo}'