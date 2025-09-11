# Sistema de notificações por e-mail DESABILITADO
# Usando apenas notificações internas do sistema

# from django.core.mail import send_mail
# from django.conf import settings

def notify(to_emails, subject, body):
    """Sistema de notificação desabilitado - usando apenas notificações internas.
    
    Args:
        to_emails: Lista de e-mails ou e-mail único (ignorado)
        subject: Assunto da notificação (ignorado)
        body: Corpo da mensagem (ignorado)
    """
    # Notificações por e-mail desabilitadas
    # O sistema usará apenas notificações internas
    pass
    
    # Código original comentado:
    # if not isinstance(to_emails, (list, tuple)):
    #     to_emails = [to_emails]
    # 
    # send_mail(
    #     subject=subject,
    #     message=body,
    #     from_email=getattr(settings, "DEFAULT_FROM_EMAIL", "no-reply@abase.local"),
    #     recipient_list=[e for e in to_emails if e],
    #     fail_silently=True,
    # )