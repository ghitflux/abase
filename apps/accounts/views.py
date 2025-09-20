from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from decimal import Decimal

from django.db.models import Count, Sum, Q
from django.utils import timezone
from datetime import datetime, timedelta
from django.contrib.auth.models import User
from apps.cadastros.models import Cadastro
from apps.tesouraria.models import MovimentacaoTesouraria, Mensalidade
import json

def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('accounts:dashboard')
        else:
            messages.error(request, 'Credenciais inválidas')
    return render(request, 'accounts/login.html')

def logout_view(request):
    logout(request)
    return redirect('accounts:login')

@login_required
def dashboard(request):
    # Filtros de data
    data_inicio = request.GET.get('data_inicio')
    data_fim = request.GET.get('data_fim')
    
    if not data_inicio:
        data_inicio = timezone.now().date() - timedelta(days=30)
    else:
        data_inicio = datetime.strptime(data_inicio, '%Y-%m-%d').date()
    
    if not data_fim:
        data_fim = timezone.now().date()
    else:
        data_fim = datetime.strptime(data_fim, '%Y-%m-%d').date()
    
    # Período anterior para comparação
    periodo_dias = (data_fim - data_inicio).days
    data_inicio_anterior = data_inicio - timedelta(days=periodo_dias)
    data_fim_anterior = data_inicio
    
    # KPIs básicos
    total_users = User.objects.count()
    total_associados = Cadastro.objects.count()
    associados_periodo = Cadastro.objects.filter(
        created_at__date__range=[data_inicio, data_fim]
    ).count()
    associados_periodo_anterior = Cadastro.objects.filter(
        created_at__date__range=[data_inicio_anterior, data_fim_anterior]
    ).count()
    
    # Variação percentual de associados
    variacao_associados = 0
    if associados_periodo_anterior > 0:
        variacao_associados = ((associados_periodo - associados_periodo_anterior) / associados_periodo_anterior) * 100
    
    # Dados financeiros
    entradas = MovimentacaoTesouraria.objects.filter(
        tipo='entrada',
        data__range=[data_inicio, data_fim]
    ).aggregate(total=Sum('valor'))['total'] or 0
    
    saidas = MovimentacaoTesouraria.objects.filter(
        tipo='saida',
        data__range=[data_inicio, data_fim]
    ).aggregate(total=Sum('valor'))['total'] or 0
    
    # Doações (movimentações do tipo doação)
    doacoes = MovimentacaoTesouraria.objects.filter(
        tipo='doacao',
        data__range=[data_inicio, data_fim]
    ).aggregate(total=Sum('valor'))['total'] or 0
    
    saldo_atual = entradas - saidas
    
    # Retorno estimado (mensalidades totais menos liquidadas)
    mensalidades_totais = Mensalidade.objects.aggregate(
        total=Sum('valor'),
        liquidadas=Sum('valor', filter=Q(status='LIQUIDADA'))
    )

    total_mensalidades = mensalidades_totais.get('total') or Decimal('0')
    total_liquidadas = mensalidades_totais.get('liquidadas') or Decimal('0')
    retorno_estimado = total_mensalidades - total_liquidadas
    if retorno_estimado < 0:
        retorno_estimado = Decimal('0')
    
    # Taxas mensais pendentes de membros cadastrados
    # Soma total de todas as parcelas de antecipação pendentes
    from apps.cadastros.models import ParcelaAntecipacao
    from apps.cadastros.choices import StatusParcela
    
    taxas_mensais_pendentes = ParcelaAntecipacao.objects.filter(
        status=StatusParcela.PENDENTE
    ).aggregate(total=Sum('valor'))['total'] or 0
    
    # Associados ativos (com pelo menos uma movimentação nos últimos 90 dias)
    data_limite_ativo = timezone.now().date() - timedelta(days=90)
    associados_ativos = Cadastro.objects.filter(
        created_at__date__gte=data_limite_ativo
    ).distinct().count()
    
    # Tempo médio de aprovação
    cadastros_aprovados = Cadastro.objects.filter(
        approved_at__isnull=False,
        created_at__isnull=False
    )
    tempo_aprovacao = None
    if cadastros_aprovados.exists():
        tempos = [(c.approved_at.date() - c.created_at.date()).days for c in cadastros_aprovados if c.approved_at and c.created_at]
        if tempos:
            tempo_medio_dias = sum(tempos) / len(tempos)
            tempo_aprovacao = timedelta(days=int(tempo_medio_dias))
    
    # Dados para gráficos
    
    # 1. Status dos processos (para gráfico de pizza)
    status_processos = list(Cadastro.objects.values('status').annotate(
        total=Count('id')
    ).order_by('-total'))
    
    # 2. Cadastros por dia (para gráfico de barras)
    cadastros_por_dia = []
    current_date = data_inicio
    while current_date <= data_fim:
        count = Cadastro.objects.filter(created_at__date=current_date).count()
        cadastros_por_dia.append({
            'dia': current_date.isoformat(),
            'total': count
        })
        current_date += timedelta(days=1)
    
    # 3. Aprovações por dia (para gráfico de linhas)
    aprovacoes_por_dia = []
    current_date = data_inicio
    while current_date <= data_fim:
        count = Cadastro.objects.filter(approved_at__date=current_date).count()
        aprovacoes_por_dia.append({
            'dia': current_date.isoformat(),
            'total': count
        })
        current_date += timedelta(days=1)
    
    # 4. Cargos dos associados (para gráfico horizontal)
    cargos_associados = list(Cadastro.objects.values('profissao').annotate(
        total=Count('id')
    ).order_by('-total')[:10])  # Top 10 profissões
    
    # 5. Liquidações por mês (para gráfico de ondas)
    liquidadas_por_mes = []
    # Últimos 12 meses
    for i in range(12):
        mes_atual = timezone.now().date().replace(day=1) - timedelta(days=30*i)
        proximo_mes = (mes_atual.replace(day=28) + timedelta(days=4)).replace(day=1)
        
        count = Mensalidade.objects.filter(
            status='LIQUIDADA',
            data_liquidacao__gte=mes_atual,
            data_liquidacao__lt=proximo_mes
        ).count()
        
        liquidadas_por_mes.append({
            'mes': mes_atual.isoformat(),
            'total': count
        })
    
    liquidadas_por_mes.reverse()  # Ordem cronológica
    
    # 6. Dados para gráfico de progresso até aprovação e efetivação
    progresso_aprovacao = []
    
    # Etapas do processo
    etapas = [
        {'nome': 'Cadastrado', 'campo': None},
        {'nome': 'Enviado para Análise', 'campo': 'SENT_REVIEW'},
        {'nome': 'Em Análise', 'campo': 'APPROVED_REVIEW'},
        {'nome': 'Aprovado', 'campo': 'approved_at'},
        {'nome': 'Efetivado', 'campo': 'EFFECTIVATED'}
    ]
    
    for etapa in etapas:
        if etapa['campo'] is None:
            # Todos os cadastrados
            total = Cadastro.objects.count()
        elif etapa['campo'] == 'approved_at':
            total = Cadastro.objects.filter(approved_at__isnull=False).count()
        elif etapa['campo'] in ['SENT_REVIEW', 'APPROVED_REVIEW', 'EFFECTIVATED']:
            total = Cadastro.objects.filter(status=etapa['campo']).count()
        else:
            total = 0
            
        progresso_aprovacao.append({
            'etapa': etapa['nome'],
            'total': total,
            'percentual': (total / total_associados * 100) if total_associados > 0 else 0
        })
    
    context = {
        'data_inicio': data_inicio,
        'data_fim': data_fim,
        'total_users': total_users,
        'total_associados': total_associados,
        'associados_periodo': associados_periodo,
        'variacao_associados': variacao_associados,
        'associados_ativos': associados_ativos,
        'total_entradas': entradas,
        'total_saidas': saidas,
        'total_doacoes': doacoes,
        'saldo_atual': saldo_atual,
        'retorno_estimado': retorno_estimado,
        'taxas_mensais_pendentes': taxas_mensais_pendentes,
        'tempo_aprovacao': tempo_aprovacao,
        
        # Dados para gráficos (convertidos para JSON)
        'status_processos': json.dumps(status_processos),
        'cadastros_por_dia': json.dumps(cadastros_por_dia),
        'aprovacoes_por_dia': json.dumps(aprovacoes_por_dia),
        'cargos_associados': json.dumps(cargos_associados),
        'liquidadas_por_mes': json.dumps(liquidadas_por_mes),
        'progresso_aprovacao': json.dumps(progresso_aprovacao),
    }
    
    return render(request, 'accounts/dashboard.html', context)

def home(request):
    if request.user.is_authenticated:
        return redirect('accounts:dashboard')
    return redirect('accounts:login')
