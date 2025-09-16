from django.urls import path
from . import views

app_name = 'notificacoes'

urlpatterns = [
    path('logs/', views.logs_notificacoes, name='logs_list'),
    path('api/listar/', views.listar_notificacoes, name='listar'),
    path('api/<int:notificacao_id>/marcar-lida/', views.marcar_como_lida, name='marcar_lida'),
    path('api/marcar-todas-lidas/', views.marcar_todas_como_lidas, name='marcar_todas_lidas'),
]