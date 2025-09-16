from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from django.utils import timezone
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import StatusCadastro
from .models import AnaliseProcesso, StatusAnalise, HistoricoAnalise


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
    
    # CORREÇÃO: Atualiza processo existente quando cadastro é reenviado após correção
    elif instance.status == StatusCadastro.RESUBMITTED:
        try:
            processo = AnaliseProcesso.objects.get(cadastro=instance)
            status_anterior = processo.status
            
            # CORREÇÃO: Atualizar para CORRECAO_REALIZADA mantendo o analista responsável
            processo.status = StatusAnalise.CORRECAO_REALIZADA
            # MANTÉM o analista_responsavel para evitar gargalo de reatribuição
            processo.data_inicio_analise = None   # Reset data de início
            processo.data_correcao = timezone.now()  # Registrar data da correção
            processo.save()
            
            # CORREÇÃO: Registrar no histórico com identificação do agente responsável
            HistoricoAnalise.objects.create(
                processo=processo,
                usuario=instance.agente_responsavel,  # CORREÇÃO: Identificar o agente
                acao=f'Correção realizada pelo agente {instance.agente_responsavel.get_full_name()} - Processo retornado para fila de análise',
                status_anterior=status_anterior,
                status_novo=StatusAnalise.CORRECAO_REALIZADA,
                observacoes=f'Cadastro reenviado automaticamente. Agente: {instance.agente_responsavel.get_full_name()}. Data/Hora: {timezone.now().strftime("%d/%m/%Y %H:%M:%S")}'
            )
            
        except AnaliseProcesso.DoesNotExist:
            # Se não existe processo, cria um novo com correção realizada
            processo = AnaliseProcesso.objects.create(
                cadastro=instance,
                status=StatusAnalise.CORRECAO_REALIZADA,
                prioridade=3,  # Alta prioridade para correções
                data_correcao=timezone.now()
            )
            
            # Registrar criação no histórico
            HistoricoAnalise.objects.create(
                processo=processo,
                usuario=instance.agente_responsavel,
                acao=f'Processo criado com correção realizada pelo agente {instance.agente_responsavel.get_full_name()}',
                status_anterior=None,
                status_novo=StatusAnalise.CORRECAO_REALIZADA,
                observacoes=f'Processo criado automaticamente após reenvio. Agente: {instance.agente_responsavel.get_full_name()}. Data/Hora: {timezone.now().strftime("%d/%m/%Y %H:%M:%S")}'
            )
    
    # CORREÇÃO: Melhorar detecção de atualizações após rejeição
    elif not created:  # Somente para atualizações, não criações
        try:
            processo = AnaliseProcesso.objects.get(cadastro=instance)
            # Se o processo está enviado para correção e o cadastro foi atualizado
            if (processo.status == StatusAnalise.ENVIADO_PARA_CORRECAO and 
                processo.data_conclusao and 
                instance.updated_at > processo.data_conclusao):
                
                status_anterior = processo.status
                
                # CORREÇÃO: Marcar como correção realizada mantendo analista
                processo.status = StatusAnalise.CORRECAO_REALIZADA
                # MANTÉM o analista_responsavel para evitar gargalo de reatribuição
                processo.data_inicio_analise = None
                processo.data_correcao = timezone.now()
                processo.save()
                
                # CORREÇÃO: Registrar no histórico com identificação do agente
                HistoricoAnalise.objects.create(
                    processo=processo,
                    usuario=instance.agente_responsavel,
                    acao=f'Correção realizada automaticamente pelo agente {instance.agente_responsavel.get_full_name()}',
                    status_anterior=status_anterior,
                    status_novo=StatusAnalise.CORRECAO_REALIZADA,
                    observacoes=f'Cadastro atualizado após rejeição - detectado automaticamente. Agente: {instance.agente_responsavel.get_full_name()}. Data/Hora: {timezone.now().strftime("%d/%m/%Y %H:%M:%S")}'
                )
                
        except AnaliseProcesso.DoesNotExist:
            pass  # Não há processo para este cadastro


@receiver(pre_save, sender=Cadastro)
def detectar_mudanca_status(sender, instance, **kwargs):
    """
    Signal para detectar mudanças de status em tempo real
    e garantir sincronização imediata entre esteiras.
    """
    if instance.pk:  # Só para atualizações
        try:
            cadastro_anterior = Cadastro.objects.get(pk=instance.pk)
            # Se o status mudou para RESUBMITTED
            if (cadastro_anterior.status != StatusCadastro.RESUBMITTED and 
                instance.status == StatusCadastro.RESUBMITTED):
                
                # Marcar para processamento no post_save
                instance._status_changed_to_resubmitted = True
                
        except Cadastro.DoesNotExist:
            pass