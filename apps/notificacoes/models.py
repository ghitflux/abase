from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()

class NotificacaoLog(models.Model):
    """Log de notificações enviadas ou tentativas de envio."""
    
    TIPO_CHOICES = [
        ('EMAIL', 'Email'),
        ('SISTEMA', 'Sistema'),
        ('SMS', 'SMS'),
    ]
    
    STATUS_CHOICES = [
        ('ENVIADO', 'Enviado'),
        ('FALHA', 'Falha'),
        ('DESABILITADO', 'Desabilitado'),
    ]
    
    tipo = models.CharField(max_length=20, choices=TIPO_CHOICES, default='EMAIL')
    destinatarios = models.TextField(help_text="Lista de destinatários (emails separados por vírgula)")
    assunto = models.CharField(max_length=255)
    corpo = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='DESABILITADO')
    data_criacao = models.DateTimeField(default=timezone.now)
    erro = models.TextField(blank=True, null=True, help_text="Detalhes do erro, se houver")
    
    # Campos opcionais para rastreamento
    usuario_origem = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    contexto = models.CharField(max_length=100, blank=True, help_text="Contexto da notificação (ex: cadastro_status_change)")
    
    class Meta:
        ordering = ['-data_criacao']
        verbose_name = 'Log de Notificação'
        verbose_name_plural = 'Logs de Notificações'
    
    def __str__(self):
        return f"{self.tipo} - {self.assunto} ({self.status})"


class Notificacao(models.Model):
    """Notificações do sistema para usuários."""
    
    TIPO_CHOICES = [
        ('PROCESSO_ATRIBUIDO', 'Processo Atribuído'),
        ('PROCESSO_CORRIGIDO', 'Processo Corrigido'),
        ('PROCESSO_APROVADO', 'Processo Aprovado'),
        ('PROCESSO_REJEITADO', 'Processo Rejeitado'),
        ('CADASTRO_PENDENTE', 'Cadastro Pendente'),
        ('PAGAMENTO_LIBERADO', 'Pagamento Liberado'),
        ('SISTEMA', 'Sistema'),
    ]
    
    usuario = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notificacoes')
    tipo = models.CharField(max_length=30, choices=TIPO_CHOICES)
    titulo = models.CharField(max_length=255)
    mensagem = models.TextField()
    lida = models.BooleanField(default=False)
    data_criacao = models.DateTimeField(default=timezone.now)
    
    # Campos opcionais para links
    url_acao = models.URLField(blank=True, null=True, help_text="URL para ação relacionada")
    objeto_id = models.PositiveIntegerField(blank=True, null=True, help_text="ID do objeto relacionado")
    
    class Meta:
        ordering = ['-data_criacao']
        verbose_name = 'Notificação'
        verbose_name_plural = 'Notificações'
    
    def __str__(self):
        return f"{self.titulo} - {self.usuario.username}"
    
    def marcar_como_lida(self):
        """Marca a notificação como lida."""
        self.lida = True
        self.save(update_fields=['lida'])
