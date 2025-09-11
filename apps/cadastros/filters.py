import django_filters
from .models import Pessoa

class PessoaFilter(django_filters.FilterSet):
    nome = django_filters.CharFilter(lookup_expr='icontains', label='Nome')
    cpf = django_filters.CharFilter(lookup_expr='icontains', label='CPF')
    email = django_filters.CharFilter(lookup_expr='icontains', label='Email')
    
    class Meta:
        model = Pessoa
        fields = ['nome', 'cpf', 'email']