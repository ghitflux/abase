from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator
from apps.accounts.decorators import admin_required
from .models import SecurityLog

@login_required
@admin_required
def logs_list(request):
    logs = SecurityLog.objects.all()
    
    event_filter = request.GET.get('event')
    if event_filter:
        logs = logs.filter(event=event_filter)
    
    username_filter = request.GET.get('username')
    if username_filter:
        logs = logs.filter(username__icontains=username_filter)
    
    ip_filter = request.GET.get('ip')
    if ip_filter:
        logs = logs.filter(ip__icontains=ip_filter)
    
    paginator = Paginator(logs, 50)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    event_choices = [
        ('LOGIN', 'Login'),
        ('LOGOUT', 'Logout'),
        ('LOGIN_FAILED', 'Login Failed')
    ]
    
    context = {
        'page_obj': page_obj,
        'event_choices': event_choices,
        'current_event': event_filter,
        'current_username': username_filter,
        'current_ip': ip_filter,
    }
    return render(request, 'auditoria/logs_list.html', context)