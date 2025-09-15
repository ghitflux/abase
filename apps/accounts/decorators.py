from functools import wraps
from django.http import HttpResponseForbidden, JsonResponse
from django.shortcuts import redirect
from django.contrib.auth.decorators import login_required, user_passes_test

def admin_required(view_func):
    """
    Decorator que exige que o usuário seja um admin.
    """
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_authenticated:
            return redirect('login')
        if not request.user.is_staff:
            return HttpResponseForbidden("Acesso negado. Você precisa ser um administrador.")
        return view_func(request, *args, **kwargs)
    return _wrapped_view

def superuser_required(view_func):
    """
    Decorator que exige que o usuário seja um superusuário.
    """
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_authenticated:
            return redirect('login')
        if not request.user.is_superuser:
            return HttpResponseForbidden("Acesso negado. Você precisa ser um superusuário.")
        return view_func(request, *args, **kwargs)
    return _wrapped_view

def group_required(*names):
    def check(u):
        return u.is_authenticated and (u.is_superuser or u.groups.filter(name__in=names).exists())
    return user_passes_test(check)

def analista_required(view_func):
    """
    Decorator que exige que o usuário seja um analista ou admin.
    """
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_authenticated:
            # Verifica se é requisição AJAX
            if request.headers.get('Content-Type') == 'application/json':
                return JsonResponse({'success': False, 'message': 'Login necessário'})
            return redirect('login')
        if not (request.user.is_superuser or request.user.groups.filter(name__in=['ANALISTA', 'Analistas']).exists()):
            error_message = "Acesso negado. Você precisa ser um analista."
            # Verifica se é requisição AJAX
            if request.headers.get('Content-Type') == 'application/json':
                return JsonResponse({'success': False, 'message': error_message})
            return HttpResponseForbidden(error_message)
        return view_func(request, *args, **kwargs)
    return _wrapped_view

def tesouraria_required(view_func):
    """
    Decorator que exige que o usuário seja da tesouraria ou admin.
    """
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_authenticated:
            return redirect('login')
        if not (request.user.is_superuser or request.user.groups.filter(name__in=['TESOURARIA', 'ADMIN']).exists()):
            return HttpResponseForbidden("Acesso negado. Você precisa ter acesso à tesouraria.")
        return view_func(request, *args, **kwargs)
    return _wrapped_view