from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
# Removed unused timezone import
from django.contrib.auth import get_user_model
from django.db import transaction
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import StatusCadastro
from .models import AnaliseProcesso, StatusAnalise
from .services import devolver_para_analista_correcao_feita

User = get_user_model()


@receiver(post_save, sender=Cadastro)
def criar_processo_analise(sender, instance, created, **kwargs):
    """
    Signal que cria automaticamente um processo de análise
    quando um cadastro é salvo e está pronto para análise.

    NOVA VERSÃO: Usa transaction.on_commit() e service centralizado.
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

    # CORREÇÃO: Quando cadastro é reenviado após correção
    elif instance.status == StatusCadastro.RESUBMITTED:
        # Usar transaction.on_commit() para garantir visibilidade após commit
        transaction.on_commit(
            lambda: devolver_para_analista_correcao_feita(
                cadastro=instance,
                ator=instance.agente_responsavel
            )
        )

    # CORREÇÃO: Detecção automática de atualizações após rejeição
    elif not created:  # Somente para atualizações, não criações
        try:
            processo = AnaliseProcesso.objects.get(cadastro=instance)
            # Se o processo está enviado para correção e o cadastro foi atualizado
            if (processo.status == StatusAnalise.ENVIADO_PARA_CORRECAO and
                processo.data_conclusao and
                hasattr(instance, 'updated_at') and
                instance.updated_at > processo.data_conclusao):

                # Usar transaction.on_commit() para garantir visibilidade
                transaction.on_commit(
                    lambda: devolver_para_analista_correcao_feita(
                        cadastro=instance,
                        ator=instance.agente_responsavel
                    )
                )

        except AnaliseProcesso.DoesNotExist:
            pass  # Não há processo para este cadastro


@receiver(pre_save, sender=Cadastro)
def detectar_mudanca_status(sender, instance, **kwargs):
    """
    Signal para detectar mudanças de status do cadastro.
    Simplificado - a lógica principal está no post_save.
    """
    if instance.pk:  # Só para atualizações
        try:
            cadastro_anterior = Cadastro.objects.get(pk=instance.pk)
            # Marcar se o status mudou para RESUBMITTED para processamento no post_save
            if (cadastro_anterior.status != StatusCadastro.RESUBMITTED and
                instance.status == StatusCadastro.RESUBMITTED):
                instance._status_changed_to_resubmitted = True
        except Cadastro.DoesNotExist:
            pass