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
from datetime import datetime, timedelta

from .models import MovimentacaoTesouraria, Mensalidade, ReconciliacaoLog, StatusMensalidade
from .services import ReconciliacaoService
from apps.accounts.decorators import admin_required


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