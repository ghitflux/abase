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
