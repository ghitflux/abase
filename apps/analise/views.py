from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect, get_object_or_404
from django.core.paginator import Paginator
from django.db.models import Q
from django.contrib.auth import get_user_model
from django.contrib import messages
from django.http import JsonResponse
from django.utils import timezone
from django.views.decorators.http import require_http_methods
# csrf_exempt import removed as it was unused
from django.db import transaction
# json import removed as it was unused

from core.utils.model_paths import is_valid_text_path
from .models import AnaliseProcesso, HistoricoAnalise, StatusAnalise, ChecklistAnalise
from .services import KPIService
from apps.cadastros.choices import StatusCadastro
from apps.tesouraria.models import ProcessoTesouraria
from apps.accounts.decorators import analista_required
from apps.notificacoes.models import Notificacao

User = get_user_model()

# Mapeamento de status (permite variações que você já usa)
STATUS_MAP = {
    "pendentes": [
        # Não há processos pendentes no banco atualmente
        # Adicionando status que podem ser considerados pendentes
        "PENDENTE", "AGUARDANDO_ANALISE"
    ],
    "em_analise": [
        "em_analise"  # Status real no banco (minúsculo)
    ],
    "em_correcao": [
        "enviado_para_correcao"  # Status real no banco (minúsculo)
    ],
    "correcao_realizada": [
        "correcao_realizada"  # Status real no banco (minúsculo)
    ],
    "efetivados": [
        "aprovado"  # Status real no banco (minúsculo)
    ],
    "aprovado": [  # Adicionado mapeamento direto
        "aprovado"  # Status real no banco (minúsculo)
    ],
    "cancelados": [
        "cancelado"  # Status real no banco (minúsculo)
    ],
    "cancelado": [  # Adicionado mapeamento direto
        "cancelado"  # Status real no banco (minúsculo)
    ],
}

# Campos candidatos para busca textual (apenas os válidos serão aplicados)
SEARCH_FIELDS = [
    "id",
    "cadastro__nome_completo",
    "cadastro__cpf_cnpj",
    "observacoes_analista",
    "feedback_agente",
]

def _status_q(status_list):
    q = Q()
    # Trabalhar com os status como estão (sem conversão para maiúsculo)
    for s in status_list:
        # Primeiro tenta busca exata
        q |= Q(status__iexact=s)
        # Depois tenta com enum se existir
        s_upper = s.upper()
        if hasattr(StatusAnalise, s_upper):
            q |= Q(status=getattr(StatusAnalise, s_upper))
        # Por último, tenta busca por conteúdo
        q |= Q(status__icontains=s.replace("_", " "))
    return q

def _apply_search(model, qs, term):
    if not term:
        return qs
    q = Q()
    for path in SEARCH_FIELDS:
        # id não precisa ser textual
        if path == "id" and term.isdigit():
            q |= Q(id=int(term))
            continue
        if is_valid_text_path(model, path):
            q |= Q(**{f"{path}__icontains": term})
    return qs.filter(q)

def _apply_analista(qs, analista_id):
    if not analista_id:
        return qs
    return qs.filter(analista_responsavel_id=analista_id)

def _apply_agente(qs, agente_id):
    if not agente_id:
        return qs
    # tente agente_responsavel via cadastro
    return qs.filter(cadastro__agente_responsavel_id=agente_id)

def _apply_data_entrada(qs, data_entrada):
    if not data_entrada:
        return qs
    try:
        from datetime import datetime
        data = datetime.strptime(data_entrada, '%Y-%m-%d').date()
        return qs.filter(data_entrada__date=data)
    except (ValueError, TypeError):
        return qs

def _apply_data_periodo(qs, data_inicio, data_fim):
    """Aplica filtro por período de datas"""
    if data_inicio:
        try:
            from datetime import datetime
            data = datetime.strptime(data_inicio, "%Y-%m-%d").date()
            qs = qs.filter(data_entrada__date__gte=data)
        except ValueError:
            pass
    
    if data_fim:
        try:
            from datetime import datetime
            data = datetime.strptime(data_fim, "%Y-%m-%d").date()
            qs = qs.filter(data_entrada__date__lte=data)
        except ValueError:
            pass
    
    return qs

def _base_queryset(request):
    qs = AnaliseProcesso.objects.all().select_related(
        "analista_responsavel",
        "cadastro__agente_responsavel",
    )
    # filtros
    search = request.GET.get("search") or request.GET.get("q") or ""
    analista = request.GET.get("analista") or ""
    agente = request.GET.get("agente") or ""
    status = request.GET.get("status") or ""
    data_entrada = request.GET.get("data_entrada") or ""
    data_inicio = request.GET.get("data_inicio") or ""
    data_fim = request.GET.get("data_fim") or ""

    qs = _apply_search(AnaliseProcesso, qs, search)
    qs = _apply_analista(qs, analista)
    qs = _apply_agente(qs, agente)
    
    # Aplicar filtro de data - priorizar período se fornecido
    if data_inicio or data_fim:
        qs = _apply_data_periodo(qs, data_inicio, data_fim)
    elif data_entrada:
        qs = _apply_data_entrada(qs, data_entrada)
    
    # Aplicar filtro por status dos filtros rápidos
    if status:
        if status == "pendente":
            qs = qs.filter(_status_q(["PENDENTE", "CORRECAO_FEITA"]))
        elif status == "em_analise":
            qs = qs.filter(_status_q(["EM_ANALISE"]))
        elif status == "em_correcao":
            qs = qs.filter(_status_q(["ENVIADO_PARA_CORRECAO"]))  # Processos enviados para correção
        elif status == "correcao_realizada":
            qs = qs.filter(_status_q(["CORRECAO_REALIZADA", "CORRECAO_FEITA", "CORRECAO"]))
        elif status == "aprovado":
            qs = qs.filter(_status_q(["APROVADO", "EFETIVADO"]))
        elif status == "cancelado":
            qs = qs.filter(_status_q(["CANCELADO", "REPROVADO"]))
    
    return qs

@login_required
@analista_required
def analise_redirect(request):
    # /analise/ → /analise/esteira/
    return redirect("analise:esteira")

@login_required
@analista_required
def esteira(request):
    """
    Renderiza a Esteira com blocos paginados.
    Se for requisição HTMX, retorna apenas os blocos filtrados.
    """
    # Dados iniciais
    qs = _base_queryset(request)

    # Adicionar KPIs à esteira - calcular com base nos filtros aplicados
    kpi_service = KPIService()
    
    # Extrair parâmetros de filtro para passar ao KPIService
    analista = request.GET.get("analista") or ""
    agente = request.GET.get("agente") or ""
    data_inicio = request.GET.get("data_inicio") or ""
    data_fim = request.GET.get("data_fim") or ""
    search = request.GET.get("search") or request.GET.get("q") or ""
    
    # Calcular KPIs com filtros aplicados
    kpis = kpi_service.get_filtered_kpis(
        analista_id=analista,
        agente_id=agente,
        data_inicio=data_inicio,
        data_fim=data_fim,
        search=search
    )

    context = {
        "users": User.objects.all().order_by("first_name","last_name","username"),
        "count_total": qs.count(),
        "kpis": kpis,
    }

    # Se for requisição HTMX do formulário de filtros, renderizar apenas os blocos
    is_htmx = request.headers.get('HX-Request') == 'true'
    has_filters = request.GET.get('analista') or request.GET.get('agente') or request.GET.get('search') or request.GET.get('data_inicio') or request.GET.get('data_fim')

    if is_htmx and has_filters:
        return render(request, "analise/partials/_blocks_container.html", context)

    return render(request, "analise/esteira.html", context)

@login_required
@analista_required
def esteira_block(request):
    """
    Fragmento HTMX para um bloco específico com paginação.
    Parâmetros:
      - block: pendentes|em_analise|em_correcao|efetivados|cancelados
      - page: número (default 1)
    """
    block = request.GET.get("block", "pendentes")
    page = int(request.GET.get("page", "1") or "1")

    if block not in STATUS_MAP:
      block = "pendentes"

    qs = _base_queryset(request).filter(_status_q(STATUS_MAP[block]))

    paginator = Paginator(qs.order_by("-id"), 5)
    page_obj = paginator.get_page(page)

    # Mapear o block para o status correto para o badge
    block_to_status = {
        "pendentes": "pendente",
        "em_analise": "em_analise", 
        "em_correcao": "em_correcao",
        "correcao_realizada": "correcao_realizada",
        "efetivados": "aprovado",
        "aprovado": "aprovado",  # Adicionado mapeamento direto
        "cancelados": "cancelado",
        "cancelado": "cancelado"  # Adicionado mapeamento direto
    }

    return render(request, "analise/partials/_esteira_block.html", {
        "block": block,
        "status": block_to_status.get(block, "pendente"),
        "page_obj": page_obj,
        "paginator": paginator,
        "request": request,
    })

@login_required
@analista_required
def detalhe_processo(request, processo_id):
    """Visualização detalhada de um processo de análise"""
    processo = get_object_or_404(
        AnaliseProcesso.objects.select_related('cadastro', 'analista_responsavel'),
        id=processo_id
    )

    # Buscar checklist associado
    checklist_itens = processo.checklist_itens.all().order_by('id')

    # Buscar histórico completo - combinando histórico de análise e cadastro
    historico_analise = processo.historico.all().order_by('-data_acao')

    # Criar lista unificada de eventos para o histórico completo
    historico_completo = []

    # Adicionar eventos de análise
    for evento in historico_analise:
        historico_completo.append({
            'tipo': 'analise',
            'acao': evento.acao,
            'usuario': evento.usuario,
            'data_acao': evento.data_acao,
            'data': evento.data_acao,  # Para compatibilidade com template
            'status_anterior': evento.status_anterior,
            'status_novo': evento.status_novo,
            'observacoes': evento.observacoes,
        })

    # Adicionar eventos do cadastro se houver
    cadastro = processo.cadastro
    if hasattr(cadastro, 'historico_eventos'):
        for evento in cadastro.historico_eventos.all().order_by('-data_criacao'):
            historico_completo.append({
                'tipo': 'cadastro',
                'acao': evento.acao if hasattr(evento, 'acao') else 'Atualização do cadastro',
                'usuario': evento.usuario if hasattr(evento, 'usuario') else None,
                'data_acao': evento.data_criacao if hasattr(evento, 'data_criacao') else cadastro.updated_at,
                'data': evento.data_criacao if hasattr(evento, 'data_criacao') else cadastro.updated_at,
                'observacoes': evento.descricao if hasattr(evento, 'descricao') else '',
            })

    # Ordenar por data (mais recente primeiro)
    historico_completo.sort(key=lambda x: x['data_acao'], reverse=True)

    # Buscar mensalidades do cadastro
    parcelas = processo.cadastro.parcelas.all().order_by('numero')

    # Verificar se usuário pode assumir/analisar este processo
    pode_assumir = not processo.analista_responsavel or processo.analista_responsavel == request.user
    pode_analisar = processo.analista_responsavel == request.user

    context = {
        'processo': processo,
        'checklist_itens': checklist_itens,
        'historico': historico_analise,  # Histórico original para compatibilidade
        'historico_completo': historico_completo,  # Histórico unificado
        'parcelas': parcelas,  # Mensalidades do associado
        'pode_assumir': pode_assumir,
        'pode_analisar': pode_analisar,
        'status_choices': StatusAnalise.choices,
    }

    return render(request, 'analise/detalhe_processo.html', context)

@login_required
@analista_required
@require_http_methods(["POST"])
def toggle_checklist_item(request, item_id):
    """Toggle do estado verificado de um item do checklist"""
    item = get_object_or_404(ChecklistAnalise, id=item_id)

    # Verificar se o usuário tem permissão (deve ser o analista responsável)
    if item.processo.analista_responsavel != request.user:
        return JsonResponse({'error': 'Sem permissão'}, status=403)

    # Toggle do estado
    verificado = request.POST.get('verificado', 'false').lower() == 'true'
    item.verificado = verificado
    item.verificado_por = request.user if verificado else None
    item.data_verificacao = timezone.now() if verificado else None
    item.save()

    return JsonResponse({'success': True, 'verificado': item.verificado})

@login_required
@analista_required
@require_http_methods(["POST"])
def assumir_processo(request, processo_id):
    """Permite ao analista assumir um processo pendente"""
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)

    if processo.analista_responsavel and processo.analista_responsavel != request.user:
        messages.error(request, 'Este processo já está sendo analisado por outro analista.')
        return redirect('analise:esteira')

    with transaction.atomic():
        processo.analista_responsavel = request.user
        processo.status = StatusAnalise.EM_ANALISE
        processo.data_inicio_analise = timezone.now()
        processo.save()

        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo assumido pelo analista',
            status_anterior=processo.status,
            status_novo=StatusAnalise.EM_ANALISE
        )

    messages.success(request, f'Processo #{processo_id} assumido com sucesso!')
    return redirect('analise:detalhe_processo', processo_id=processo_id)

@login_required
@analista_required
@require_http_methods(["POST"])
def aprovar_processo(request, processo_id):
    """Aprova um processo e envia para tesouraria"""
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)

    if processo.analista_responsavel != request.user:
        messages.error(request, 'Você não tem permissão para aprovar este processo.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)

    with transaction.atomic():
        # Atualizar processo
        processo.status = StatusAnalise.APROVADO
        processo.data_conclusao = timezone.now()
        processo.save()

        # Atualizar status do cadastro
        processo.cadastro.status = StatusCadastro.APPROVED_REVIEW
        processo.cadastro.save()

        # Criar processo na tesouraria
        ProcessoTesouraria.objects.get_or_create(
            cadastro=processo.cadastro,
            defaults={
                'analista_origem': request.user,
                'status': 'pendente',
                'data_aprovacao': timezone.now(),
                'origem_analise': processo,
                'agente_responsavel': processo.cadastro.agente_responsavel
            }
        )

        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo aprovado e enviado para tesouraria',
            status_anterior=processo.status,
            status_novo=StatusAnalise.APROVADO
        )

    messages.success(request, f'Processo #{processo_id} aprovado e enviado para tesouraria!')
    return redirect('analise:esteira')

@login_required
@analista_required
@require_http_methods(["POST"])
def enviar_para_correcao(request, processo_id):
    """Envia processo para correção pelo agente"""
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)

    if processo.analista_responsavel != request.user:
        messages.error(request, 'Você não tem permissão para enviar este processo para correção.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)

    feedback = request.POST.get('feedback_agente', '').strip()
    if not feedback:
        messages.error(request, 'É obrigatório informar o feedback para o agente.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)

    with transaction.atomic():
        # Salvar status anterior para histórico
        status_anterior = processo.status

        # Atualizar processo
        processo.status = StatusAnalise.ENVIADO_PARA_CORRECAO
        processo.data_conclusao = timezone.now()
        processo.feedback_agente = feedback
        # NÃO remover o analista_responsavel - ele deve continuar responsável
        processo.save()

        # Atualizar status do cadastro
        processo.cadastro.status = StatusCadastro.PENDING_AGENT
        processo.cadastro.save()

        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo enviado para correção',
            status_anterior=status_anterior,
            status_novo=StatusAnalise.ENVIADO_PARA_CORRECAO,
            observacoes=f'Feedback: {feedback}'
        )

        # Criar notificação para o agente
        try:
            Notificacao.objects.create(
                usuario=processo.cadastro.agente_responsavel,
                tipo='PROCESSO_REJEITADO',
                titulo=f'Correções Necessárias - Processo #{processo.id}',
                mensagem=f'O processo #{processo.id} foi rejeitado e precisa de correções. Feedback: {feedback}',
                url_acao=f'/cadastros/{processo.cadastro.id}/?edit=1',
                objeto_id=processo.id
            )
        except Exception:
            pass

    messages.success(request, f'Processo #{processo_id} enviado para correção!')
    return redirect('analise:esteira')

@login_required
@analista_required
@require_http_methods(["POST"])
def cancelar_processo(request, processo_id):
    """Cancela definitivamente um processo de análise"""
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)

    if processo.analista_responsavel != request.user:
        messages.error(request, 'Você não tem permissão para cancelar este processo.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)

    motivo_cancelamento = request.POST.get('motivo_cancelamento', '').strip()
    if not motivo_cancelamento:
        messages.error(request, 'É obrigatório informar o motivo do cancelamento.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)

    with transaction.atomic():
        # Atualizar processo
        processo.status = StatusAnalise.CANCELADO
        processo.data_conclusao = timezone.now()
        processo.feedback_agente = f'CADASTRO CANCELADO: {motivo_cancelamento}'
        processo.observacoes_analista = f'Processo cancelado pelo analista: {motivo_cancelamento}'
        processo.save()

        # Atualizar status do cadastro
        processo.cadastro.status = StatusCadastro.CANCELLED
        processo.cadastro.save()

        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo cancelado definitivamente',
            status_anterior=processo.status,
            status_novo=StatusAnalise.CANCELADO,
            observacoes=f'Motivo: {motivo_cancelamento}'
        )

    messages.success(request, f'Processo #{processo_id} cancelado definitivamente!')
    return redirect('analise:esteira')
