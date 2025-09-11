from django import template
from django.contrib.auth.models import Group

register = template.Library()

@register.filter
def has_group(user, group_name):
    """
    Verifica se o usuário pertence ao grupo especificado.
    Uso: {{ user|has_group:"AGENTE" }}
    """
    if not user or not user.is_authenticated:
        return False
    
    if user.is_superuser:
        return True
        
    try:
        group = Group.objects.get(name=group_name)
        return user.groups.filter(name=group_name).exists()
    except Group.DoesNotExist:
        return False