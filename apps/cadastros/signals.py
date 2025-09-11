from django.db.models.signals import pre_save
from django.dispatch import receiver
from django.contrib.auth import get_user_model
from .models import Cadastro
from .choices import StatusCadastro
from apps.notificacoes.service import notify

User = get_user_model()

def _emails_grupo(nome_grupo):
    """Retorna lista de e-mails dos usuários de um grupo específico."""
    return list(User.objects.filter(groups__name=nome_grupo).values_list("email", flat=True))

@receiver(pre_save, sender=Cadastro)
def on_cadastro_status_change(sender, instance: Cadastro, **kwargs):
    """Signal disparado quando o status de um cadastro muda."""
    if not instance.pk:
        return  # novo cadastro, deixa criar
    
    try:
        old = Cadastro.objects.get(pk=instance.pk)
    except Cadastro.DoesNotExist:
        return
    
    if old.status == instance.status:
        return  # status não mudou

    # Agente responsável:
    agente_email = getattr(instance.agente_responsavel, "email", None)

    # Dispara mensagens neutras baseadas no novo status
    if instance.status == StatusCadastro.SENT_REVIEW:
        notify(
            to_emails=[agente_email] + _emails_grupo("ANALISTA"),
            subject="ABASE • Cadastro enviado para avaliação",
            body=f"O cadastro #{instance.id} foi enviado para avaliação."
        )
    elif instance.status == StatusCadastro.PENDING_AGENT:
        notify(
            to_emails=[agente_email],
            subject="ABASE • Cadastro com pendências",
            body=f"O cadastro #{instance.id} possui pendências. Gentileza corrigir para prosseguir."
        )
    elif instance.status == StatusCadastro.APPROVED_REVIEW:
        notify(
            to_emails=[agente_email] + _emails_grupo("TESOURARIA"),
            subject="ABASE • Cadastro aprovado para efetivação",
            body=f"O cadastro #{instance.id} foi aprovado. Prosseguir com a efetivação na associação."
        )
    elif instance.status == StatusCadastro.EFFECTIVATED:
        notify(
            to_emails=[agente_email],
            subject="ABASE • Cadastro efetivado",
            body=f"O cadastro #{instance.id} foi efetivado no sistema da associação."
        )