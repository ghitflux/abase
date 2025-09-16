from django.urls import path
from . import views

app_name = "cadastros"

urlpatterns = [
    path("", views.agente_list, name="agente-list"),
    path("novo/", views.agente_create, name="agente-create"),
    path("<int:cadastro_id>/", views.agente_detail, name="agente-detail"),
    path("<int:cadastro_id>/renovacao/verificar/", views.verificar_elegibilidade_renovacao, name="verificar-renovacao"),
    path("<int:cadastro_id>/renovacao/", views.renovar_cadastro, name="renovar-cadastro"),
    # path("<int:cadastro_id>/reenviar/", views.reenviar_apos_correcao, name="reenviar-apos-correcao"), # Removido - reenvio agora é automático
]