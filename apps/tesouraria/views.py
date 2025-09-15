"""
Views da app Tesouraria

Este módulo contém as views para gerenciar movimentações de tesouraria
de organizações sem fins lucrativos, oferecendo controle transparente
de entradas e saídas de recursos.
"""

from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.core.paginator import Paginator
from django.db.models import Q, Sum
from django.utils import timezone
from django.db import transaction
from datetime import datetime, timedelta

from .models import MovimentacaoTesouraria, Mensalidade, ReconciliacaoLog, StatusMensalidade, ProcessoTesouraria, StatusProcessoTesouraria
from .services import ReconciliacaoService
from apps.accounts.decorators import admin_required, tesouraria_required
from apps.documentos.models import Documento


@login_required
def dashboard_tesouraria(request):
    """
    Dashboard principal da tesouraria
    
    Exibe resumo das movimentações, saldos e estatísticas importantes
    para gestão da tesouraria da organização.
    """
    # Cálculos de saldo
    total_entradas = MovimentacaoTesouraria.objects.filter(
        tipo='entrada'
    ).aggregate(Sum('valor'))['valor__sum'] or 0
    
    total_saidas = MovimentacaoTesouraria.objects.filter(
        tipo='saida'
    ).aggregate(Sum('valor'))['valor__sum'] or 0
    
    saldo_atual = total_entradas - total_saidas
    
    # Movimentações do mês atual
    hoje = timezone.now().date()
    inicio_mes = hoje.replace(day=1)
    
    entradas_mes = MovimentacaoTesouraria.objects.filter(
        tipo='entrada',
        data__gte=inicio_mes
    ).aggregate(Sum('valor'))['valor__sum'] or 0
    
    saidas_mes = MovimentacaoTesouraria.objects.filter(
        tipo='saida',
        data__gte=inicio_mes
    ).aggregate(Sum('valor'))['valor__sum'] or 0
    
    # Últimas movimentações
    ultimas_movimentacoes = MovimentacaoTesouraria.objects.all()[:5]
    
    context = {
        'total_entradas': total_entradas,
        'total_saidas': total_saidas,
        'saldo_atual': saldo_atual,
        'entradas_mes': entradas_mes,
        'saidas_mes': saidas_mes,
        'saldo_mes': entradas_mes - saidas_mes,
        'ultimas_movimentacoes': ultimas_movimentacoes,
        'total_movimentacoes': MovimentacaoTesouraria.objects.count(),
    }
    
    return render(request, 'tesouraria/dashboard.html', context)


@login_required
def lista_movimentacoes(request):
    """
    Lista todas as movimentações de tesouraria com filtros e paginação
    """
    # Filtros
    tipo = request.GET.get('tipo')
    data_inicio = request.GET.get('data_inicio')
    data_fim = request.GET.get('data_fim')
    busca = request.GET.get('busca')
    
    # QuerySet base
    movimentacoes = MovimentacaoTesouraria.objects.all()
    
    # Aplicar filtros
    if tipo and tipo != 'todos':
        movimentacoes = movimentacoes.filter(tipo=tipo)
    
    if data_inicio:
        try:
            data_inicio_obj = datetime.strptime(data_inicio, '%Y-%m-%d').date()
            movimentacoes = movimentacoes.filter(data__gte=data_inicio_obj)
        except ValueError:
            messages.warning(request, 'Data de início inválida')
    
    if data_fim:
        try:
            data_fim_obj = datetime.strptime(data_fim, '%Y-%m-%d').date()
            movimentacoes = movimentacoes.filter(data__lte=data_fim_obj)
        except ValueError:
            messages.warning(request, 'Data de fim inválida')
    
    if busca:
        movimentacoes = movimentacoes.filter(
            Q(descricao__icontains=busca) |
            Q(observacoes__icontains=busca) |
            Q(usuario__username__icontains=busca)
        )
    
    # Paginação
    paginator = Paginator(movimentacoes, 20)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'filtros': {
            'tipo': tipo,
            'data_inicio': data_inicio,
            'data_fim': data_fim,
            'busca': busca,
        },
        'tipos_choices': MovimentacaoTesouraria.TIPO_CHOICES,
    }
    
    return render(request, 'tesouraria/lista_movimentacoes.html', context)


@login_required
def detalhe_movimentacao(request, pk):
    """
    Exibe detalhes de uma movimentação específica
    """
    movimentacao = get_object_or_404(MovimentacaoTesouraria, pk=pk)
    
    context = {
        'movimentacao': movimentacao,
    }
    
    return render(request, 'tesouraria/detalhe_movimentacao.html', context)


@login_required
def nova_movimentacao(request):
    """
    Cria uma nova movimentação de tesouraria
    """
    if request.method == 'POST':
        # Capturar dados do formulário
        descricao = request.POST.get('descricao', '').strip()
        valor = request.POST.get('valor')
        tipo = request.POST.get('tipo')
        data = request.POST.get('data')
        observacoes = request.POST.get('observacoes', '').strip()
        
        # Validações básicas
        erros = []
        
        if not descricao:
            erros.append('Descrição é obrigatória')
        
        if not valor:
            erros.append('Valor é obrigatório')
        else:
            try:
                valor = float(valor.replace(',', '.'))
                if valor <= 0:
                    erros.append('Valor deve ser maior que zero')
            except ValueError:
                erros.append('Valor deve ser um número válido')
        
        if not tipo or tipo not in ['entrada', 'saida']:
            erros.append('Tipo de movimentação é obrigatório')
        
        if not data:
            erros.append('Data é obrigatória')
        else:
            try:
                data_obj = datetime.strptime(data, '%Y-%m-%d').date()
                if data_obj > timezone.now().date():
                    erros.append('Data não pode ser no futuro')
            except ValueError:
                erros.append('Data deve estar no formato correto')
        
        if erros:
            for erro in erros:
                messages.error(request, erro)
        else:
            # Criar movimentação
            try:
                movimentacao = MovimentacaoTesouraria.objects.create(
                    descricao=descricao,
                    valor=valor,
                    tipo=tipo,
                    data=data_obj,
                    usuario=request.user,
                    observacoes=observacoes
                )
                
                messages.success(
                    request, 
                    f'Movimentação "{movimentacao.descricao}" registrada com sucesso!'
                )
                return redirect('tesouraria:detalhe_movimentacao', pk=movimentacao.pk)
                
            except Exception as e:
                messages.error(request, f'Erro ao salvar movimentação: {str(e)}')
    
    context = {
        'tipos_choices': MovimentacaoTesouraria.TIPO_CHOICES,
        'data_hoje': timezone.now().date().strftime('%Y-%m-%d'),
    }
    
    return render(request, 'tesouraria/nova_movimentacao.html', context)


@login_required
def relatorio_tesouraria(request):
    """
    Gera relatórios da tesouraria com filtros por período
    """
    # Período padrão: últimos 30 dias
    data_fim = timezone.now().date()
    data_inicio = data_fim - timedelta(days=30)
    
    # Sobrescrever com filtros do usuário se fornecidos
    if request.GET.get('data_inicio'):
        try:
            data_inicio = datetime.strptime(
                request.GET.get('data_inicio'), '%Y-%m-%d'
            ).date()
        except ValueError:
            pass
    
    if request.GET.get('data_fim'):
        try:
            data_fim = datetime.strptime(
                request.GET.get('data_fim'), '%Y-%m-%d'
            ).date()
        except ValueError:
            pass
    
    # Filtrar movimentações do período
    movimentacoes = MovimentacaoTesouraria.objects.filter(
        data__range=[data_inicio, data_fim]
    )
    
    # Cálculos do período
    entradas = movimentacoes.filter(tipo='entrada')
    saidas = movimentacoes.filter(tipo='saida')
    
    total_entradas = entradas.aggregate(Sum('valor'))['valor__sum'] or 0
    total_saidas = saidas.aggregate(Sum('valor'))['valor__sum'] or 0
    saldo_periodo = total_entradas - total_saidas
    
    context = {
        'data_inicio': data_inicio,
        'data_fim': data_fim,
        'movimentacoes': movimentacoes,
        'entradas': entradas,
        'saidas': saidas,
        'total_entradas': total_entradas,
        'total_saidas': total_saidas,
        'saldo_periodo': saldo_periodo,
        'quantidade_entradas': entradas.count(),
        'quantidade_saidas': saidas.count(),
    }
    
    return render(request, 'tesouraria/relatorio.html', context)


# ========== VIEWS DE MENSALIDADES E RECONCILIAÇÃO ==========

@login_required
@admin_required
def mensalidades_list(request):
    mensalidades = Mensalidade.objects.all()
    
    status_filter = request.GET.get('status')
    if status_filter:
        mensalidades = mensalidades.filter(status=status_filter)
    
    competencia_filter = request.GET.get('competencia')
    if competencia_filter:
        mensalidades = mensalidades.filter(competencia=competencia_filter)
    
    search = request.GET.get('search')
    if search:
        mensalidades = mensalidades.filter(
            Q(cpf__icontains=search) |
            Q(matricula__icontains=search)
        )
    
    paginator = Paginator(mensalidades, 25)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'status_choices': StatusMensalidade.choices,
        'current_status': status_filter,
        'current_competencia': competencia_filter,
        'current_search': search,
    }
    return render(request, 'tesouraria/mensalidades_list.html', context)

@login_required
@admin_required
def executar_reconciliacao(request):
    if request.method == 'POST':
        resultado = ReconciliacaoService.executar_reconciliacao(user=request.user)
        messages.success(
            request, 
            f"Reconciliação executada: {resultado['total_conciliados']} de {resultado['total_processados']} processados"
        )
        return redirect('tesouraria:reconciliacao_logs')
    
    return render(request, 'tesouraria/executar_reconciliacao.html')

@login_required
@admin_required
def reconciliacao_logs(request):
    logs = ReconciliacaoLog.objects.all()
    
    paginator = Paginator(logs, 10)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    return render(request, 'tesouraria/reconciliacao_logs.html', {'page_obj': page_obj})


# ========== VIEWS DE PROCESSOS DA TESOURARIA ==========

@login_required
@tesouraria_required
def processos_tesouraria(request):
    """
    Lista todos os processos aprovados que chegaram da análise
    """
    # Filtros
    status_filter = request.GET.get('status', '')
    agente_filter = request.GET.get('agente', '')
    search = request.GET.get('search', '')
    
    # QuerySet base
    processos = ProcessoTesouraria.objects.select_related(
        'cadastro', 'origem_analise', 'agente_responsavel', 'processado_por'
    ).prefetch_related('cadastro__documentos')
    
    # Aplicar filtros
    if status_filter:
        processos = processos.filter(status=status_filter)
    
    if agente_filter:
        processos = processos.filter(agente_responsavel_id=agente_filter)
    
    if search:
        processos = processos.filter(
            Q(cadastro__nome_completo__icontains=search) |
            Q(cadastro__cpf__icontains=search) |
            Q(cadastro__cnpj__icontains=search) |
            Q(cadastro__matricula_servidor__icontains=search)
        )
    
    # Ordenação por data de entrada
    processos = processos.order_by('-data_entrada')
    
    # Paginação
    paginator = Paginator(processos, 15)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    # Agentes disponíveis para filtro
    from django.contrib.auth.models import User
    agentes = User.objects.filter(groups__name='AGENTE').order_by('username')
    
    context = {
        'page_obj': page_obj,
        'status_choices': StatusProcessoTesouraria.choices,
        'agentes': agentes,
        'current_filters': {
            'status': status_filter,
            'agente': agente_filter, 
            'search': search,
        }
    }
    
    return render(request, 'tesouraria/processos_lista.html', context)


@login_required
@tesouraria_required
def detalhe_processo_tesouraria(request, processo_id):
    """
    Exibe detalhes de um processo da tesouraria com modal de ações
    """
    processo = get_object_or_404(
        ProcessoTesouraria.objects.select_related(
            'cadastro', 'origem_analise', 'agente_responsavel', 'processado_por'
        ).prefetch_related('cadastro__documentos'),
        id=processo_id
    )
    
    context = {
        'processo': processo,
        'status_choices': StatusProcessoTesouraria.choices,
    }
    
    return render(request, 'tesouraria/detalhe_processo.html', context)


@login_required 
@tesouraria_required
def efetivar_contrato(request, processo_id):
    """
    Efetiva um contrato na tesouraria
    """
    if request.method != 'POST':
        return redirect('tesouraria:detalhe_processo', processo_id=processo_id)
        
    processo = get_object_or_404(ProcessoTesouraria, id=processo_id)
    
    observacoes = request.POST.get('observacoes_efetivacao', '')
    comprovante_associado = request.FILES.get('comprovante_associado')
    comprovante_agente = request.FILES.get('comprovante_agente')
    
    try:
        with transaction.atomic():
            # Atualizar processo
            processo.status = StatusProcessoTesouraria.PROCESSADO
            processo.data_processamento = timezone.now()
            processo.processado_por = request.user
            processo.observacoes_tesouraria = observacoes
            processo.save()
            
            # Atualizar cadastro para efetivado
            from apps.cadastros.choices import StatusCadastro
            processo.cadastro.status = StatusCadastro.EFFECTIVATED
            processo.cadastro.save()
            
            # Salvar comprovantes se fornecidos
            if comprovante_associado:
                processo.comprovante_associado = comprovante_associado
            
            if comprovante_agente:
                processo.comprovante_agente = comprovante_agente
            
            processo.save()
            
            # Registrar movimentação na tesouraria
            MovimentacaoTesouraria.objects.create(
                descricao=f'Contrato efetivado - {processo.cadastro.nome_completo}',
                valor=processo.cadastro.disponivel or 0,
                tipo='saida',
                data=timezone.now().date(),
                usuario=request.user,
                observacoes=f'Processo #{processo.id} - Agente: {processo.agente_responsavel}. {observacoes}'
            )
            
        messages.success(request, f'Contrato #{processo_id} efetivado com sucesso!')
        
    except Exception as e:
        messages.error(request, f'Erro ao efetivar contrato: {str(e)}')
    
    return redirect('tesouraria:processos')


@login_required
@tesouraria_required  
def cancelar_contrato(request, processo_id):
    """
    Cancela um contrato na tesouraria
    """
    if request.method != 'POST':
        return redirect('tesouraria:detalhe_processo', processo_id=processo_id)
        
    processo = get_object_or_404(ProcessoTesouraria, id=processo_id)
    
    observacoes = request.POST.get('observacoes_cancelamento', '')
    
    try:
        with transaction.atomic():
            # Atualizar processo
            processo.status = StatusProcessoTesouraria.REJEITADO
            processo.data_processamento = timezone.now()
            processo.processado_por = request.user
            processo.observacoes_tesouraria = observacoes
            processo.save()
            
            # Atualizar cadastro para cancelado
            from apps.cadastros.choices import StatusCadastro
            processo.cadastro.status = StatusCadastro.CANCELLED
            processo.cadastro.save()
            
        messages.success(request, f'Contrato #{processo_id} cancelado com sucesso!')
        
    except Exception as e:
        messages.error(request, f'Erro ao cancelar contrato: {str(e)}')
    
    return redirect('tesouraria:processos')


@login_required
@tesouraria_required
def devolver_analise(request, processo_id):
    """
    Devolve um processo para a análise
    """
    if request.method != 'POST':
        return redirect('tesouraria:detalhe_processo', processo_id=processo_id)
        
    processo = get_object_or_404(ProcessoTesouraria, id=processo_id)
    
    observacoes = request.POST.get('observacoes_devolucao', '')
    
    try:
        with transaction.atomic():
            # Atualizar processo de análise original
            if processo.origem_analise:
                from apps.analise.models import StatusAnalise, HistoricoAnalise
                
                # Buscar o último analista que trabalhou no processo
                ultimo_analista = None
                historico_analistas = HistoricoAnalise.objects.filter(
                    processo=processo.origem_analise,
                    usuario__isnull=False,
                    acao__in=['assumiu_processo', 'aprovou_processo', 'rejeitou_processo', 'pendenciou_processo']
                ).order_by('-data_acao')
                
                if historico_analistas.exists():
                    ultimo_analista = historico_analistas.first().usuario
                
                processo.origem_analise.status = StatusAnalise.PENDENTE
                processo.origem_analise.analista_responsavel = ultimo_analista
                processo.origem_analise.feedback_agente = f'Devolvido pela tesouraria: {observacoes}'
                processo.origem_analise.save()
            
            # Atualizar cadastro
            from apps.cadastros.choices import StatusCadastro  
            processo.cadastro.status = StatusCadastro.PENDING_AGENT
            processo.cadastro.save()
            
            # Remover processo da tesouraria
            processo.delete()
            
        messages.success(request, f'Processo #{processo_id} devolvido para análise com sucesso!')
        
    except Exception as e:
        messages.error(request, f'Erro ao devolver processo: {str(e)}')
    
    return redirect('tesouraria:processos')