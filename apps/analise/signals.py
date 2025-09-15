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
    
    # Atualiza processo existente quando cadastro é reenviado após correção
    elif instance.status == StatusCadastro.RESUBMITTED:
        try:
            processo = AnaliseProcesso.objects.get(cadastro=instance)
            # Atualiza o status para "Correção Feita" e remove o analista responsável
            processo.status = StatusAnalise.CORRECAO_FEITA
            processo.analista_responsavel = None
            processo.data_inicio_analise = None
            processo.save()
            
            # Registra no histórico
            from .models import HistoricoAnalise
            HistoricoAnalise.objects.create(
                processo=processo,
                usuario=None,  # Sistema
                acao='Cadastro corrigido e reenviado pelo agente',
                status_anterior=StatusAnalise.REJEITADO,
                status_novo=StatusAnalise.CORRECAO_FEITA
            )
        except AnaliseProcesso.DoesNotExist:
            # Se não existe processo, cria um novo
            AnaliseProcesso.objects.create(
                cadastro=instance,
                status=StatusAnalise.CORRECAO_FEITA,
                prioridade=3  # Alta prioridade para correções
            )
    
    # FALLBACK: Verificar se o cadastro foi atualizado após rejeição do processo
    # Isso captura casos onde o status não mudou mas o cadastro foi corrigido
    elif not created:  # Somente para atualizações, não criações
        try:
            processo = AnaliseProcesso.objects.get(cadastro=instance)
            # Se o processo está rejeitado mas o cadastro foi atualizado depois da rejeição
            if (processo.status == StatusAnalise.REJEITADO and 
                processo.data_conclusao and 
                instance.updated_at > processo.data_conclusao):
                
                # Marcar como correção feita
                processo.status = StatusAnalise.CORRECAO_FEITA
                processo.analista_responsavel = None
                processo.data_inicio_analise = None
                processo.save()
                
                # Registrar no histórico
                from .models import HistoricoAnalise
                HistoricoAnalise.objects.create(
                    processo=processo,
                    usuario=None,  # Sistema
                    acao='Cadastro atualizado após rejeição - detectado automaticamente',
                    status_anterior=StatusAnalise.REJEITADO,
                    status_novo=StatusAnalise.CORRECAO_FEITA
                )
        except AnaliseProcesso.DoesNotExist:
            pass  # Não há processo para este cadastro