# Sistema de notificações por e-mail DESABILITADO
# Usando apenas notificações internas do sistema

# from django.core.mail import send_mail
# from django.conf import settings
from .models import NotificacaoLog

def notify(to_emails, subject, body, context=None, user=None):
    """Sistema de notificação desabilitado - usando apenas notificações internas.
    
    Args:
        to_emails: Lista de e-mails ou e-mail único
        subject: Assunto da notificação
        body: Corpo da mensagem
        context: Contexto da notificação (opcional)
        user: Usuário que originou a notificação (opcional)
    """
    # Normalizar lista de emails
    if not isinstance(to_emails, (list, tuple)):
        to_emails = [to_emails]
    
    # Filtrar emails válidos
    emails_validos = [e for e in to_emails if e]
    destinatarios_str = ", ".join(emails_validos)
    
    # Registrar tentativa de notificação no log
    try:
        NotificacaoLog.objects.create(
            tipo='EMAIL',
            destinatarios=destinatarios_str,
            assunto=subject,
            corpo=body,
            status='DESABILITADO',
            contexto=context or 'sistema',
            usuario_origem=user,
            erro='Sistema de email desabilitado - usando apenas logs internos'
        )
    except Exception as e:
        # Se falhar ao criar o log, não deve quebrar o fluxo principal
        print(f"Erro ao registrar log de notificação: {e}")
    
    # Notificações por e-mail desabilitadas
    # O sistema usará apenas notificações internas
    pass
    
    # Código original comentado:
    # send_mail(
    #     subject=subject,
    #     message=body,
    #     from_email=getattr(settings, "DEFAULT_FROM_EMAIL", "no-reply@abase.local"),
    #     recipient_list=emails_validos,
    #     fail_silently=True,
    # )