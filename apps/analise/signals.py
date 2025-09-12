from django.db.models.signals import post_save
from django.dispatch import receiver
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import StatusCadastro
from .models import AnaliseProcesso, StatusAnalise


@receiver(post_save, sender=Cadastro)
def criar_processo_analise(sender, instance, created, **kwargs):
    """
    Signal que cria automaticamente um processo de análise
    quando um cadastro é salvo e está pronto para análise.
    """
    # Cria processo apenas quando o status muda para SENT_REVIEW
    if instance.status == StatusCadastro.SENT_REVIEW:
        # Verifica se já existe um processo para este cadastro
        if not hasattr(instance, 'analise_processo') or not AnaliseProcesso.objects.filter(cadastro=instance).exists():
            # Cria o processo de análise automaticamente
            AnaliseProcesso.objects.create(
                cadastro=instance,
                status=StatusAnalise.PENDENTE,
                prioridade=2  # Normal
            )