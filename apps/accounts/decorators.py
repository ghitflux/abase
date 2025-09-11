from functools import wraps
from django.http import HttpResponseForbidden
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