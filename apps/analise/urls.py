from django.urls import path
from . import views

app_name = 'analise'

urlpatterns = [
    path('esteira/', views.esteira, name='esteira'),
    path('esteira/block/', views.esteira_block, name='esteira_block'),
    path('processo/<int:processo_id>/', views.detalhe_processo, name='detalhe_processo'),
    path('assumir/<int:processo_id>/', views.assumir_processo, name='assumir_processo'),
    path('aprovar/<int:processo_id>/', views.aprovar_processo, name='aprovar_processo'),
    path('enviar-correcao/<int:processo_id>/', views.enviar_para_correcao, name='enviar_para_correcao'),
    path('cancelar/<int:processo_id>/', views.cancelar_processo, name='cancelar_processo'),
    path('toggle-checklist/<int:item_id>/', views.toggle_checklist_item, name='toggle_checklist_item'),
    path('', views.analise_redirect, name='redirect'),
]
