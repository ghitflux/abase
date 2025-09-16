from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib.admin.views.decorators import staff_member_required
from django.core.paginator import Paginator
from django.db.models import Q
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from .models import NotificacaoLog, Notificacao

@staff_member_required
def logs_notificacoes(request):
    """Lista os logs de notificações com filtros."""
    
    # Filtros
    search = request.GET.get('search', '')
    status_filter = request.GET.get('status', '')
    tipo_filter = request.GET.get('tipo', '')
    
    # Query base
    logs = NotificacaoLog.objects.all()
    
    # Aplicar filtros
    if search:
        logs = logs.filter(
            Q(assunto__icontains=search) |
            Q(destinatarios__icontains=search) |
            Q(contexto__icontains=search)
        )
    
    if status_filter:
        logs = logs.filter(status=status_filter)
    
    if tipo_filter:
        logs = logs.filter(tipo=tipo_filter)
    
    # Paginação
    paginator = Paginator(logs, 25)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'search': search,
        'status_filter': status_filter,
        'tipo_filter': tipo_filter,
        'status_choices': NotificacaoLog.STATUS_CHOICES,
        'tipo_choices': NotificacaoLog.TIPO_CHOICES,
    }
    
    return render(request, 'notificacoes/logs_list.html', context)


@login_required
def listar_notificacoes(request):
    """Lista as notificações do usuário logado."""
    notificacoes = request.user.notificacoes.all()[:10]  # Últimas 10
    nao_lidas = request.user.notificacoes.filter(lida=False).count()
    
    return JsonResponse({
        'notificacoes': [{
            'id': n.id,
            'titulo': n.titulo,
            'mensagem': n.mensagem,
            'tipo': n.get_tipo_display(),
            'lida': n.lida,
            'data_criacao': n.data_criacao.strftime('%d/%m/%Y %H:%M'),
            'url_acao': n.url_acao
        } for n in notificacoes],
        'nao_lidas': nao_lidas
    })


@login_required
@require_POST
def marcar_como_lida(request, notificacao_id):
    """Marca uma notificação como lida."""
    notificacao = get_object_or_404(
        Notificacao, 
        id=notificacao_id, 
        usuario=request.user
    )
    
    notificacao.marcar_como_lida()
    
    return JsonResponse({'success': True})


@login_required
@require_POST
def marcar_todas_como_lidas(request):
    """Marca todas as notificações do usuário como lidas."""
    request.user.notificacoes.filter(lida=False).update(lida=True)
    
    return JsonResponse({'success': True})
