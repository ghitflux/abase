from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.http import JsonResponse
from django.db.models import Count, Q
from django.utils import timezone
from django.core.paginator import Paginator
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.db import transaction

from .models import AnaliseProcesso, ChecklistAnalise, HistoricoAnalise, StatusAnalise, TipoAnalise
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import StatusCadastro
from apps.tesouraria.models import ProcessoTesouraria
from apps.accounts.decorators import analista_required


@login_required
@analista_required
def dashboard(request):
    """
    Dashboard principal do módulo de análise.
    
    Exibe estatísticas da esteira de análise e processos pendentes.
    """
    
    # Estatísticas gerais
    total_processos = AnaliseProcesso.objects.count()
    processos_pendentes = AnaliseProcesso.objects.filter(status=StatusAnalise.PENDENTE).count()
    processos_em_analise = AnaliseProcesso.objects.filter(status=StatusAnalise.EM_ANALISE).count()
    processos_aprovados = AnaliseProcesso.objects.filter(status=StatusAnalise.APROVADO).count()
    processos_rejeitados = AnaliseProcesso.objects.filter(status=StatusAnalise.REJEITADO).count()
    processos_suspensos = AnaliseProcesso.objects.filter(status=StatusAnalise.SUSPENSO).count()
    
    # Processos em atraso
    processos_em_atraso = AnaliseProcesso.objects.filter(
        prazo_analise__lt=timezone.now(),
        data_conclusao__isnull=True
    ).count()
    
    # Removido: Processos por prioridade (não mais necessário)
    
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
        'processos_rejeitados': processos_rejeitados,
        'processos_suspensos': processos_suspensos,
        'processos_em_atraso': processos_em_atraso,
        'ultimos_processos': ultimos_processos,
        'meus_processos': meus_processos,
    }
    
    return render(request, 'analise/dashboard.html', context)


@login_required
@analista_required
def esteira_analise(request):
    """
    Lista todos os processos na esteira de análise com filtros.
    """
    
    # Filtros
    status_filter = request.GET.get('status', '')
    prioridade_filter = request.GET.get('prioridade', '')
    analista_filter = request.GET.get('analista', '')
    search = request.GET.get('search', '')
    
    # Query base
    processos = AnaliseProcesso.objects.select_related(
        'cadastro', 'analista_responsavel'
    ).prefetch_related('checklist_itens')
    
    # Aplicar filtros
    if status_filter:
        processos = processos.filter(status=status_filter)
    
    if prioridade_filter:
        processos = processos.filter(prioridade=prioridade_filter)
    
    if analista_filter:
        processos = processos.filter(analista_responsavel_id=analista_filter)
    
    if search:
        processos = processos.filter(
            Q(cadastro__nome_completo__icontains=search) |
            Q(cadastro__cpf_cnpj__icontains=search) |
            Q(observacoes_analista__icontains=search)
        )
    
    # Ordenação
    processos = processos.order_by('-prioridade', 'data_entrada')
    
    # Paginação
    paginator = Paginator(processos, 20)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'status_choices': StatusAnalise.choices,
        'prioridade_choices': [(1, 'Baixa'), (2, 'Normal'), (3, 'Alta'), (4, 'Urgente')],
        'current_filters': {
            'status': status_filter,
            'prioridade': prioridade_filter,
            'analista': analista_filter,
            'search': search,
        }
    }
    
    return render(request, 'analise/esteira.html', context)


@login_required
@analista_required
def detalhe_processo(request, processo_id):
    """
    Exibe detalhes de um processo de análise específico.
    """
    
    processo = get_object_or_404(
        AnaliseProcesso.objects.select_related('cadastro', 'analista_responsavel'),
        id=processo_id
    )
    
    # Checklist do processo
    checklist_itens = processo.checklist_itens.all().order_by('obrigatorio', 'item')
    
    # Histórico do processo
    historico = processo.historico.select_related('usuario').order_by('-data_acao')
    
    # Documentos do cadastro
    documentos = processo.cadastro.documentos.all() if hasattr(processo.cadastro, 'documentos') else []
    
    context = {
        'processo': processo,
        'checklist_itens': checklist_itens,
        'historico': historico,
        'documentos': documentos,
        'status_choices': StatusAnalise.choices,
        'tipo_analise_choices': TipoAnalise.choices,
    }
    
    return render(request, 'analise/detalhe_processo.html', context)


@login_required
@analista_required
@require_http_methods(["POST"])
def assumir_processo(request, processo_id):
    """
    Permite que um analista assuma um processo para análise.
    """
    
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)
    
    if processo.analista_responsavel and processo.analista_responsavel != request.user:
        messages.error(request, 'Este processo já está sendo analisado por outro analista.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    with transaction.atomic():
        # Atualizar processo
        processo.analista_responsavel = request.user
        processo.status = StatusAnalise.EM_ANALISE
        processo.data_inicio_analise = timezone.now()
        processo.save()
        
        # Se o cadastro foi resubmitido, atualizar seu status para enviado para análise
        if processo.cadastro.status == StatusCadastro.RESUBMITTED:
            processo.cadastro.status = StatusCadastro.SENT_REVIEW
            processo.cadastro.save()
        
        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo assumido para análise',
            status_anterior=StatusAnalise.PENDENTE,
            status_novo=StatusAnalise.EM_ANALISE
        )
    
    messages.success(request, f'Processo #{processo_id} assumido com sucesso!')
    return redirect('analise:detalhe_processo', processo_id=processo_id)


@login_required
@analista_required
@require_http_methods(["POST"])
def aprovar_processo(request, processo_id):
    """
    Aprova um processo e o encaminha para a tesouraria.
    """
    
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)
    
    if processo.analista_responsavel != request.user:
        messages.error(request, 'Você não tem permissão para aprovar este processo.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    observacoes = request.POST.get('observacoes', '')
    
    with transaction.atomic():
        # Atualizar processo
        processo.status = StatusAnalise.APROVADO
        processo.data_conclusao = timezone.now()
        processo.observacoes_analista = observacoes
        processo.save()
        
        # Atualizar status do cadastro
        processo.cadastro.status = StatusCadastro.APPROVED_REVIEW
        processo.cadastro.approved_at = timezone.now()
        processo.cadastro.save()
        
        # Criar processo na tesouraria com os dados bancários e PIX
        try:
            ProcessoTesouraria.objects.create(
                cadastro=processo.cadastro,
                origem_analise=processo,
                status='pendente',
                observacoes_analise=observacoes,
                agente_responsavel=processo.cadastro.agente_responsavel
            )
        except Exception as e:
            # Se não existir o modelo ProcessoTesouraria, criar uma movimentação básica
            from apps.tesouraria.models import MovimentacaoTesouraria
            MovimentacaoTesouraria.objects.create(
                descricao=f'Processo aprovado - {processo.cadastro.nome_completo}',
                valor=processo.cadastro.valor_total_antecipacao or 0,
                tipo='entrada',
                data=timezone.now().date(),
                usuario=request.user,
                observacoes=f'Cadastro aprovado. Agente: {processo.cadastro.agente_responsavel}. Obs: {observacoes}'
            )
        
        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo aprovado e encaminhado para tesouraria',
            status_anterior=StatusAnalise.EM_ANALISE,
            status_novo=StatusAnalise.APROVADO,
            observacoes=observacoes
        )
    
    messages.success(request, f'Processo #{processo_id} aprovado e encaminhado para a tesouraria!')
    return redirect('analise:esteira_analise')


@login_required
@analista_required
@require_http_methods(["POST"])
def rejeitar_processo(request, processo_id):
    """
    Rejeita um processo e o devolve ao agente com pendências.
    """
    
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)
    
    if processo.analista_responsavel != request.user:
        messages.error(request, 'Você não tem permissão para rejeitar este processo.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    feedback_agente = request.POST.get('feedback_agente', '')
    observacoes = request.POST.get('observacoes', '')
    
    if not feedback_agente:
        messages.error(request, 'É obrigatório informar o feedback para o agente.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    with transaction.atomic():
        # Atualizar processo
        processo.status = StatusAnalise.REJEITADO
        processo.data_conclusao = timezone.now()
        processo.feedback_agente = feedback_agente
        processo.observacoes_analista = observacoes
        processo.save()
        
        # Atualizar status do cadastro para pendência com agente
        processo.cadastro.status = StatusCadastro.PENDING_AGENT
        processo.cadastro.save()
        
        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo rejeitado e devolvido ao agente',
            status_anterior=StatusAnalise.EM_ANALISE,
            status_novo=StatusAnalise.REJEITADO,
            observacoes=f'Feedback: {feedback_agente}'
        )
    
    messages.success(request, f'Processo #{processo_id} devolvido ao agente para correção!')
    return redirect('analise:esteira_analise')


@login_required
@analista_required
@require_http_methods(["POST"])
def suspender_processo(request, processo_id):
    """
    Suspende um processo aguardando documentos adicionais.
    """
    
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)
    
    if processo.analista_responsavel != request.user:
        messages.error(request, 'Você não tem permissão para suspender este processo.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    motivo = request.POST.get('motivo', '')
    
    if not motivo:
        messages.error(request, 'É obrigatório informar o motivo da suspensão.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    with transaction.atomic():
        # Atualizar processo
        processo.status = StatusAnalise.SUSPENSO
        processo.observacoes_analista = motivo
        processo.save()
        
        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo suspenso aguardando documentos',
            status_anterior=StatusAnalise.EM_ANALISE,
            status_novo=StatusAnalise.SUSPENSO,
            observacoes=motivo
        )
    
    messages.success(request, 'Processo suspenso com sucesso!')
    return redirect('analise:detalhe_processo', processo_id=processo_id)


@login_required
@analista_required
@csrf_exempt
def atualizar_checklist(request, processo_id):
    """
    Atualiza um item do checklist via AJAX.
    """
    
    if request.method != 'POST':
        return JsonResponse({'success': False, 'error': 'Método não permitido'})
    
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)
    
    if processo.analista_responsavel != request.user:
        return JsonResponse({'success': False, 'error': 'Sem permissão'})
    
    item_id = request.POST.get('item_id')
    verificado = request.POST.get('verificado') == 'true'
    observacoes = request.POST.get('observacoes', '')
    
    try:
        item = ChecklistAnalise.objects.get(id=item_id, processo=processo)
        item.verificado = verificado
        item.observacoes = observacoes
        item.verificado_por = request.user if verificado else None
        item.data_verificacao = timezone.now() if verificado else None
        item.save()
        
        return JsonResponse({'success': True})
    except ChecklistAnalise.DoesNotExist:
        return JsonResponse({'success': False, 'error': 'Item não encontrado'})


@login_required
@analista_required
def relatorio_analise(request):
    """
    Relatório de performance da análise.
    """
    
    # Estatísticas por período
    from datetime import datetime, timedelta
    
    hoje = timezone.now().date()
    inicio_mes = hoje.replace(day=1)
    inicio_semana = hoje - timedelta(days=hoje.weekday())
    
    # Processos por período
    processos_hoje = AnaliseProcesso.objects.filter(data_entrada__date=hoje).count()
    processos_semana = AnaliseProcesso.objects.filter(data_entrada__date__gte=inicio_semana).count()
    processos_mes = AnaliseProcesso.objects.filter(data_entrada__date__gte=inicio_mes).count()
    
    # Tempo médio de análise
    processos_concluidos = AnaliseProcesso.objects.filter(
        data_conclusao__isnull=False,
        data_entrada__date__gte=inicio_mes
    )
    
    tempo_medio = None
    if processos_concluidos.exists():
        tempos = [(p.data_conclusao - p.data_entrada).total_seconds() / 3600 for p in processos_concluidos]
        tempo_medio = sum(tempos) / len(tempos)
    
    context = {
        'processos_hoje': processos_hoje,
        'processos_semana': processos_semana,
        'processos_mes': processos_mes,
        'tempo_medio_horas': tempo_medio,
        'processos_concluidos': processos_concluidos.count(),
    }
    
    return render(request, 'analise/relatorio.html', context)


@login_required
@analista_required
@require_http_methods(["POST"])
def cancelar_processo(request, processo_id):
    """
    Cancela definitivamente um processo de análise.
    """
    
    processo = get_object_or_404(AnaliseProcesso, id=processo_id)
    
    if processo.analista_responsavel != request.user:
        messages.error(request, 'Você não tem permissão para cancelar este processo.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    motivo_cancelamento = request.POST.get('motivo_cancelamento', '')
    
    if not motivo_cancelamento:
        messages.error(request, 'É obrigatório informar o motivo do cancelamento.')
        return redirect('analise:detalhe_processo', processo_id=processo_id)
    
    with transaction.atomic():
        # Atualizar processo
        processo.status = StatusAnalise.REJEITADO  # Usar REJEITADO como cancelado
        processo.data_conclusao = timezone.now()
        processo.feedback_agente = f'CADASTRO CANCELADO: {motivo_cancelamento}'
        processo.observacoes_analista = f'Processo cancelado pelo analista: {motivo_cancelamento}'
        processo.save()
        
        # Atualizar status do cadastro para cancelado
        processo.cadastro.status = StatusCadastro.CANCELLED
        processo.cadastro.save()
        
        # Registrar no histórico
        HistoricoAnalise.objects.create(
            processo=processo,
            usuario=request.user,
            acao='Processo cancelado definitivamente',
            status_anterior=StatusAnalise.EM_ANALISE,
            status_novo=StatusAnalise.REJEITADO,
            observacoes=f'Motivo: {motivo_cancelamento}'
        )
    
    messages.success(request, f'Processo #{processo_id} cancelado definitivamente!')
    return redirect('analise:esteira_analise')
