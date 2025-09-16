from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect, get_object_or_404
from django.core.paginator import Paginator
from django.db.models import Q
from django.contrib.auth import get_user_model
from django.contrib import messages
# JsonResponse import removed as it was unused
from django.utils import timezone
from django.views.decorators.http import require_http_methods
# csrf_exempt import removed as it was unused
from django.db import transaction
# json import removed as it was unused

from core.utils.model_paths import is_valid_text_path
from .models import AnaliseProcesso, HistoricoAnalise, StatusAnalise
from apps.cadastros.choices import StatusCadastro
from apps.tesouraria.models import ProcessoTesouraria
from apps.accounts.decorators import analista_required
from apps.notificacoes.models import Notificacao

User = get_user_model()

# Mapeamento de status (permite variações que você já usa)
STATUS_MAP = {
    "pendentes": [
        "PENDENTE", "ENVIADO_PARA_CORRECAO", "AGUARDANDO_CORRECAO"
    ],
    "em_analise": [
        "EM_ANALISE"
    ],
    "em_correcao": [
        "CORRECAO_REALIZADA", "CORRECAO_FEITA", "CORRECAO"
    ],
    "efetivados": [
        "APROVADO", "EFETIVADO"
    ],
    "cancelados": [
        "CANCELADO", "REPROVADO"
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
    s_upper = [s.upper() for s in status_list]
    # Tenta com enum (StatusAnalise.*). Se não existir, usa string direta.
    for s in s_upper:
        # suporte a enums no model
        if hasattr(StatusAnalise, s):
            q |= Q(status=getattr(StatusAnalise, s))
        else:
            q |= Q(status__iexact=s) | Q(status__icontains=s.replace("_", " "))
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

    qs = _apply_search(AnaliseProcesso, qs, search)
    qs = _apply_analista(qs, analista)
    qs = _apply_agente(qs, agente)
    
    # Aplicar filtro por status dos filtros rápidos
    if status:
        if status == "pendente":
            qs = qs.filter(_status_q(["PENDENTE", "ENVIADO_PARA_CORRECAO", "AGUARDANDO_CORRECAO"]))
        elif status == "em_analise":
            qs = qs.filter(_status_q(["EM_ANALISE"]))
        elif status == "em_correcao":
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
    Renderiza a Esteira com 5 blocos, cada um paginado em 10 (HTMX carrega fragmentos).
    """
    # Dados iniciais (primeira página de cada bloco) — render estático
    qs = _base_queryset(request)

    context = {
        "users": User.objects.all().order_by("first_name","last_name","username"),
        "count_total": qs.count(),
    }
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

    paginator = Paginator(qs.order_by("-id"), 10)
    page_obj = paginator.get_page(page)

    return render(request, "analise/partials/_esteira_block.html", {
        "block": block,
        "page_obj": page_obj,
        "paginator": paginator,
        "request": request,
    })

# Manter outras views existentes
@login_required
@analista_required
def dashboard(request):
    """Dashboard principal do módulo de análise."""
    
    # Estatísticas gerais
    total_processos = AnaliseProcesso.objects.count()
    processos_pendentes = AnaliseProcesso.objects.filter(status=StatusAnalise.PENDENTE).count()
    processos_em_analise = AnaliseProcesso.objects.filter(status=StatusAnalise.EM_ANALISE).count()
    processos_aprovados = AnaliseProcesso.objects.filter(status=StatusAnalise.APROVADO).count()
    processos_enviados_correcao = AnaliseProcesso.objects.filter(status=StatusAnalise.ENVIADO_PARA_CORRECAO).count()
    processos_correcao_realizada = AnaliseProcesso.objects.filter(status=StatusAnalise.CORRECAO_REALIZADA).count()
    
    # Processos em atraso
    processos_em_atraso = AnaliseProcesso.objects.filter(
        prazo_analise__lt=timezone.now(),
        data_conclusao__isnull=True
    ).count()
    
    # Últimos processos
    ultimos_processos = AnaliseProcesso.objects.select_related(
        'cadastro', 'analista_responsavel'
    ).order_by('-data_entrada')[:10]
    
    # Processos do analista logado
    meus_processos = AnaliseProcesso.objects.filter(
        analista_responsavel=request.user,
        status=StatusAnalise.EM_ANALISE
    ).count()
    
    context = {
        'total_processos': total_processos,
        'processos_pendentes': processos_pendentes,
        'processos_em_analise': processos_em_analise,
        'processos_aprovados': processos_aprovados,
        'processos_enviados_correcao': processos_enviados_correcao,
        'processos_correcao_realizada': processos_correcao_realizada,
        'processos_em_atraso': processos_em_atraso,
        'ultimos_processos': ultimos_processos,
        'meus_processos': meus_processos,
    }
    
    return render(request, 'analise/dashboard.html', context)

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
    
    # Buscar histórico
    historico = processo.historico.all().order_by('-data_acao')
    
    # Verificar se usuário pode assumir/analisar este processo
    pode_assumir = not processo.analista_responsavel or processo.analista_responsavel == request.user
    pode_analisar = processo.analista_responsavel == request.user
    
    context = {
        'processo': processo,
        'checklist_itens': checklist_itens,
        'historico': historico,
        'pode_assumir': pode_assumir,
        'pode_analisar': pode_analisar,
        'status_choices': StatusAnalise.choices,
    }
    
    return render(request, 'analise/detalhe_processo.html', context)

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
                'status': 'PENDENTE',
                'data_aprovacao': timezone.now()
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
        # Atualizar processo
        processo.status = StatusAnalise.ENVIADO_PARA_CORRECAO
        processo.data_conclusao = timezone.now()
        processo.feedback_agente = feedback
        processo.save()

        # Atualizar status do cadastro
        processo.cadastro.status = StatusCadastro.PENDING_AGENT
        processo.cadastro.save()

        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo enviado para correção',
            status_anterior=processo.status,
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
