from django.db import transaction
from django.utils import timezone
from django.contrib.auth import get_user_model

User = get_user_model()


def devolver_para_analista_correcao_feita(cadastro, ator=None):
    """
    Move o processo para 'CORRECAO_REALIZADA' e devolve ao último analista.
    Não exige clique do analista - totalmente automático.

    Args:
        cadastro: Instância do modelo Cadastro
        ator: Usuário que fez a correção (geralmente o agente)
    """
    from .models import AnaliseProcesso, StatusAnalise, HistoricoAnalise
    from apps.notificacoes.models import Notificacao

    try:
        # Buscar o processo de análise relacionado
        processo = AnaliseProcesso.objects.get(cadastro=cadastro)

        # Salvar status anterior para histórico
        status_anterior = processo.status

        # Atualizar processo para correção realizada
        processo.status = StatusAnalise.CORRECAO_REALIZADA

        # MANTER o analista_responsavel para evitar gargalo de reatribuição
        # processo.analista_responsavel = processo.analista_responsavel  # já mantido

        # Reset data de início para nova análise
        processo.data_inicio_analise = None

        # Adicionar campo de data da correção se existir
        if hasattr(processo, 'data_correcao'):
            processo.data_correcao = timezone.now()

        # Atualizar campos de controle se existirem
        update_fields = ['status']
        if hasattr(processo, 'atualizado_em'):
            processo.atualizado_em = timezone.now()
            update_fields.append('atualizado_em')
        if hasattr(processo, 'data_correcao'):
            update_fields.append('data_correcao')

        processo.save(update_fields=update_fields)

        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=ator or cadastro.agente_responsavel,
            acao=f'Correção realizada automaticamente pelo agente {cadastro.agente_responsavel.get_full_name()}',
            status_anterior=status_anterior,
            status_novo=StatusAnalise.CORRECAO_REALIZADA,
            observacoes=f'Cadastro editado e reenviado automaticamente. Agente: {cadastro.agente_responsavel.get_full_name()}. Data/Hora: {timezone.now().strftime("%d/%m/%Y %H:%M:%S")}'
        )

        # Criar notificação em tempo real para o analista
        if processo.analista_responsavel:
            try:
                Notificacao.objects.create(
                    usuario=processo.analista_responsavel,
                    tipo='PROCESSO_CORRIGIDO',
                    titulo=f'Correção Realizada - Processo #{cadastro.id}',
                    mensagem=f'O agente {cadastro.agente_responsavel.get_full_name()} realizou as correções solicitadas no processo #{cadastro.id}. O processo está pronto para nova análise.',
                    url_acao=f'/analise/processo/{processo.id}/',
                    objeto_id=processo.id
                )
            except Exception as e:
                # Log do erro sem quebrar o fluxo principal
                print(f"Erro ao criar notificação de correção realizada: {e}")

        return True, f'Processo #{processo.id} movido para correção realizada automaticamente'

    except AnaliseProcesso.DoesNotExist:
        # Se não existe processo, criar um novo com correção realizada
        try:
            processo = AnaliseProcesso.objects.create(
                cadastro=cadastro,
                status=StatusAnalise.CORRECAO_REALIZADA,
                prioridade=3,  # Alta prioridade para correções
            )

            # Adicionar campo de data da correção se existir
            if hasattr(processo, 'data_correcao'):
                processo.data_correcao = timezone.now()
                processo.save(update_fields=['data_correcao'])

            # Registrar criação no histórico
            HistoricoAnalise.objects.create(
                processo=processo,
                usuario=ator or cadastro.agente_responsavel,
                acao=f'Processo criado com correção realizada pelo agente {cadastro.agente_responsavel.get_full_name()}',
                status_anterior=None,
                status_novo=StatusAnalise.CORRECAO_REALIZADA,
                observacoes=f'Processo criado automaticamente após reenvio. Agente: {cadastro.agente_responsavel.get_full_name()}. Data/Hora: {timezone.now().strftime("%d/%m/%Y %H:%M:%S")}'
            )

            return True, f'Novo processo #{processo.id} criado com correção realizada'

        except Exception as e:
            return False, f'Erro ao criar processo: {str(e)}'

    except Exception as e:
        return False, f'Erro interno: {str(e)}'


def marcar_cadastro_como_corrigido(cadastro):
    """
    Atualiza status do cadastro para RESUBMITTED quando o agente salva correções.

    Args:
        cadastro: Instância do modelo Cadastro
    """
    from apps.cadastros.choices import StatusCadastro

    # Verificar se o cadastro está em status que permite correção
    if cadastro.status == StatusCadastro.PENDING_AGENT:
        cadastro.status = StatusCadastro.RESUBMITTED
        cadastro.save(update_fields=['status'])
        return True
    return False