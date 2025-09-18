# Removed unused import: django.db.transaction
# Count import removed as it is not used
from django.utils import timezone
from django.contrib.auth import get_user_model
from datetime import timedelta

User = get_user_model()


class KPIService:
    """Serviço para cálculo de KPIs da esteira de análise"""
    
    @staticmethod
    def get_date_range(data_inicio=None, data_fim=None):
        """Retorna range de datas padrão se não fornecido"""
        if not data_fim:
            data_fim = timezone.now()
        if not data_inicio:
            data_inicio = data_fim - timedelta(days=30)
        return data_inicio, data_fim
    
    @staticmethod
    def get_previous_period(data_inicio, data_fim):
        """Calcula período anterior para comparação"""
        periodo_atual = data_fim - data_inicio
        data_fim_anterior = data_inicio
        data_inicio_anterior = data_fim_anterior - periodo_atual
        return data_inicio_anterior, data_fim_anterior
    
    @classmethod
    def get_processos_pendentes(cls, data_inicio=None, data_fim=None):
        """KPI: Processos pendentes de análise"""
        from .models import AnaliseProcesso, StatusAnalise
        
        data_inicio, data_fim = cls.get_date_range(data_inicio, data_fim)
        
        # Período atual - incluindo processos pendentes e correção realizada
        atual = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio, data_fim],
            status__in=[StatusAnalise.PENDENTE, StatusAnalise.CORRECAO_REALIZADA]
        ).count()
        
        # Período anterior
        data_inicio_ant, data_fim_ant = cls.get_previous_period(data_inicio, data_fim)
        anterior = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio_ant, data_fim_ant],
            status__in=[StatusAnalise.PENDENTE, StatusAnalise.CORRECAO_REALIZADA]
        ).count()
        
        # Cálculo da variação
        variacao = cls._calcular_variacao(atual, anterior)
        
        return {
            'valor': atual,
            'valor_anterior': anterior,
            'variacao': variacao,
            'tipo_variacao': 'negativa' if variacao > 0 else 'positiva',  # Menos pendentes é melhor
            'label': 'Processos Pendentes',
            'icone': 'clock'
        }
    
    @classmethod
    def get_processos_em_analise(cls, data_inicio=None, data_fim=None):
        """KPI: Processos em análise"""
        from .models import AnaliseProcesso, StatusAnalise
        
        data_inicio, data_fim = cls.get_date_range(data_inicio, data_fim)
        
        # Período atual
        atual = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio, data_fim],
            status=StatusAnalise.EM_ANALISE
        ).count()
        
        # Período anterior
        data_inicio_ant, data_fim_ant = cls.get_previous_period(data_inicio, data_fim)
        anterior = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio_ant, data_fim_ant],
            status=StatusAnalise.EM_ANALISE
        ).count()
        
        variacao = cls._calcular_variacao(atual, anterior)
        
        return {
            'valor': atual,
            'valor_anterior': anterior,
            'variacao': variacao,
            'tipo_variacao': 'neutra',  # Em análise é neutro
            'label': 'Em Análise',
            'icone': 'search'
        }
    
    @classmethod
    def get_processos_aprovados(cls, data_inicio=None, data_fim=None):
        """KPI: Processos aprovados"""
        from .models import AnaliseProcesso, StatusAnalise
        
        data_inicio, data_fim = cls.get_date_range(data_inicio, data_fim)
        
        # Período atual
        atual = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio, data_fim],
            status=StatusAnalise.APROVADO
        ).count()
        
        # Período anterior
        data_inicio_ant, data_fim_ant = cls.get_previous_period(data_inicio, data_fim)
        anterior = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio_ant, data_fim_ant],
            status=StatusAnalise.APROVADO
        ).count()
        
        variacao = cls._calcular_variacao(atual, anterior)
        
        return {
            'valor': atual,
            'valor_anterior': anterior,
            'variacao': variacao,
            'tipo_variacao': 'positiva' if variacao > 0 else 'negativa',  # Mais aprovados é melhor
            'label': 'Aprovados',
            'icone': 'check'
        }
    
    @classmethod
    def get_tempo_medio_analise(cls, data_inicio=None, data_fim=None):
        """KPI: Tempo médio de análise em horas"""
        from .models import AnaliseProcesso
        
        data_inicio, data_fim = cls.get_date_range(data_inicio, data_fim)
        
        # Processos concluídos no período atual
        processos_atuais = AnaliseProcesso.objects.filter(
            data_conclusao__range=[data_inicio, data_fim],
            data_conclusao__isnull=False
        )
        
        # Calcular tempo médio atual
        tempo_total_atual = 0
        count_atual = 0
        for processo in processos_atuais:
            if processo.data_inicio_analise:
                tempo_analise = processo.data_conclusao - processo.data_inicio_analise
                tempo_total_atual += tempo_analise.total_seconds()
                count_atual += 1
        
        tempo_medio_atual = (tempo_total_atual / count_atual / 3600) if count_atual > 0 else 0
        
        # Período anterior
        data_inicio_ant, data_fim_ant = cls.get_previous_period(data_inicio, data_fim)
        processos_anteriores = AnaliseProcesso.objects.filter(
            data_conclusao__range=[data_inicio_ant, data_fim_ant],
            data_conclusao__isnull=False
        )
        
        # Calcular tempo médio anterior
        tempo_total_anterior = 0
        count_anterior = 0
        for processo in processos_anteriores:
            if processo.data_inicio_analise:
                tempo_analise = processo.data_conclusao - processo.data_inicio_analise
                tempo_total_anterior += tempo_analise.total_seconds()
                count_anterior += 1
        
        tempo_medio_anterior = (tempo_total_anterior / count_anterior / 3600) if count_anterior > 0 else 0
        
        variacao = cls._calcular_variacao(tempo_medio_atual, tempo_medio_anterior)
        
        return {
            'valor': round(tempo_medio_atual, 1),
            'valor_anterior': round(tempo_medio_anterior, 1),
            'variacao': variacao,
            'tipo_variacao': 'negativa' if variacao > 0 else 'positiva',  # Menos tempo é melhor
            'label': 'Tempo Médio (h)',
            'icone': 'clock',
            'sufixo': 'h'
        }
    
    @classmethod
    def get_taxa_aprovacao(cls, data_inicio=None, data_fim=None):
        """KPI: Taxa de aprovação em percentual"""
        from .models import AnaliseProcesso, StatusAnalise
        
        data_inicio, data_fim = cls.get_date_range(data_inicio, data_fim)
        
        # Período atual
        total_atual = AnaliseProcesso.objects.filter(
            data_conclusao__range=[data_inicio, data_fim],
            data_conclusao__isnull=False
        ).count()
        
        aprovados_atual = AnaliseProcesso.objects.filter(
            data_conclusao__range=[data_inicio, data_fim],
            status=StatusAnalise.APROVADO
        ).count()
        
        taxa_atual = (aprovados_atual / total_atual * 100) if total_atual > 0 else 0
        
        # Período anterior
        data_inicio_ant, data_fim_ant = cls.get_previous_period(data_inicio, data_fim)
        
        total_anterior = AnaliseProcesso.objects.filter(
            data_conclusao__range=[data_inicio_ant, data_fim_ant],
            data_conclusao__isnull=False
        ).count()
        
        aprovados_anterior = AnaliseProcesso.objects.filter(
            data_conclusao__range=[data_inicio_ant, data_fim_ant],
            status=StatusAnalise.APROVADO
        ).count()
        
        taxa_anterior = (aprovados_anterior / total_anterior * 100) if total_anterior > 0 else 0
        
        variacao = cls._calcular_variacao(taxa_atual, taxa_anterior)
        
        return {
            'valor': round(taxa_atual, 1),
            'valor_anterior': round(taxa_anterior, 1),
            'variacao': variacao,
            'tipo_variacao': 'positiva' if variacao > 0 else 'negativa',  # Maior taxa é melhor
            'label': 'Taxa de Aprovação',
            'icone': 'percent',
            'sufixo': '%'
        }
    
    @classmethod
    def get_processos_em_atraso(cls, data_inicio=None, data_fim=None):
        """KPI: Processos em atraso"""
        from .models import AnaliseProcesso, StatusAnalise
        from django.utils import timezone
        
        data_inicio, data_fim = cls.get_date_range(data_inicio, data_fim)
        
        # Período atual - processos que ainda não foram concluídos e estão em atraso
        atual = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio, data_fim],
            data_conclusao__isnull=True,
            status__in=[StatusAnalise.PENDENTE, StatusAnalise.EM_ANALISE, StatusAnalise.CORRECAO_REALIZADA]
        ).filter(
            data_entrada__lt=timezone.now() - timedelta(days=3)  # Considera em atraso após 3 dias
        ).count()
        
        # Período anterior
        data_inicio_ant, data_fim_ant = cls.get_previous_period(data_inicio, data_fim)
        anterior = AnaliseProcesso.objects.filter(
            data_entrada__range=[data_inicio_ant, data_fim_ant],
            data_conclusao__isnull=True,
            status__in=[StatusAnalise.PENDENTE, StatusAnalise.EM_ANALISE, StatusAnalise.CORRECAO_REALIZADA]
        ).filter(
            data_entrada__lt=data_fim_ant - timedelta(days=3)
        ).count()
        
        variacao = cls._calcular_variacao(atual, anterior)
        
        return {
            'valor': atual,
            'valor_anterior': anterior,
            'variacao': variacao,
            'tipo_variacao': 'negativa' if variacao > 0 else 'positiva',  # Menos atrasos é melhor
            'label': 'Em Atraso',
            'icone': 'alert'
        }
    
    @classmethod
    def get_all_kpis(cls, data_inicio=None, data_fim=None):
        """Retorna todos os KPIs de uma vez"""
        return {
            'pendentes': cls.get_processos_pendentes(data_inicio, data_fim),
            'em_analise': cls.get_processos_em_analise(data_inicio, data_fim),
            'aprovados': cls.get_processos_aprovados(data_inicio, data_fim),
            'tempo_medio': cls.get_tempo_medio_analise(data_inicio, data_fim),
            'taxa_aprovacao': cls.get_taxa_aprovacao(data_inicio, data_fim),
            'em_atraso': cls.get_processos_em_atraso(data_inicio, data_fim),
        }
    
    @classmethod
    def get_filtered_kpis(cls, analista_id=None, agente_id=None, data_inicio=None, data_fim=None, search=None):
        """Retorna KPIs filtrados com base nos parâmetros fornecidos"""
        from .models import AnaliseProcesso, StatusAnalise
        from django.db.models import Q
        
        # Construir queryset base com filtros
        qs = AnaliseProcesso.objects.all()
        
        # Aplicar filtros
        if analista_id:
            qs = qs.filter(analista_responsavel_id=analista_id)
        
        if agente_id:
            qs = qs.filter(cadastro__agente_responsavel_id=agente_id)
        
        if search:
            search_fields = [
                "id",
                "cadastro__nome_completo",
                "cadastro__cpf_cnpj",
                "observacoes_analista",
                "feedback_agente",
            ]
            search_q = Q()
            for field in search_fields:
                if field == "id":
                    try:
                        search_q |= Q(**{f"{field}__exact": int(search)})
                    except ValueError:
                        pass
                else:
                    search_q |= Q(**{f"{field}__icontains": search})
            qs = qs.filter(search_q)
        
        # Aplicar filtro de data
        if data_inicio or data_fim:
            if data_inicio:
                from datetime import datetime
                try:
                    data = datetime.strptime(data_inicio, "%Y-%m-%d").date()
                    qs = qs.filter(data_entrada__date__gte=data)
                except ValueError:
                    pass
            
            if data_fim:
                from datetime import datetime
                try:
                    data = datetime.strptime(data_fim, "%Y-%m-%d").date()
                    qs = qs.filter(data_entrada__date__lte=data)
                except ValueError:
                    pass
        
        # Calcular KPIs baseados no queryset filtrado
        pendentes = qs.filter(
            status__in=[StatusAnalise.PENDENTE, StatusAnalise.CORRECAO_FEITA]
        ).count()
        
        em_analise = qs.filter(status=StatusAnalise.EM_ANALISE).count()
        
        aprovados = qs.filter(status=StatusAnalise.APROVADO).count()
        
        # Para KPIs mais complexos, usar os métodos existentes com período de data
        if data_inicio or data_fim:
            tempo_medio = cls.get_tempo_medio_analise(data_inicio, data_fim)
            taxa_aprovacao = cls.get_taxa_aprovacao(data_inicio, data_fim)
            em_atraso = cls.get_processos_em_atraso(data_inicio, data_fim)
        else:
            tempo_medio = cls.get_tempo_medio_analise()
            taxa_aprovacao = cls.get_taxa_aprovacao()
            em_atraso = cls.get_processos_em_atraso()
        
        return {
            'pendentes': {
                'valor': pendentes,
                'valor_anterior': 0,  # Simplificado para filtros
                'variacao': 0,
                'tipo_variacao': 'neutra',
                'label': 'Pendentes',
                'icone': 'clock'
            },
            'em_analise': {
                'valor': em_analise,
                'valor_anterior': 0,
                'variacao': 0,
                'tipo_variacao': 'neutra',
                'label': 'Em Análise',
                'icone': 'eye'
            },
            'aprovados': {
                'valor': aprovados,
                'valor_anterior': 0,
                'variacao': 0,
                'tipo_variacao': 'neutra',
                'label': 'Aprovados',
                'icone': 'check'
            },
            'tempo_medio': tempo_medio,
            'taxa_aprovacao': taxa_aprovacao,
            'em_atraso': em_atraso,
        }
    
    @staticmethod
    def _calcular_variacao(valor_atual, valor_anterior):
        """Calcula variação percentual entre dois valores"""
        if valor_anterior == 0:
            return 100 if valor_atual > 0 else 0
        return round(((valor_atual - valor_anterior) / valor_anterior) * 100, 1)


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