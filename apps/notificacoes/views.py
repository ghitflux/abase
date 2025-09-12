from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.contrib.admin.views.decorators import staff_member_required
from django.core.paginator import Paginator
from django.db.models import Q
from .models import NotificacaoLog

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
