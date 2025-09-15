from django.urls import path
from . import views

app_name = 'analise'

urlpatterns = [
    # Dashboard principal
    path('', views.dashboard, name='dashboard'),
    
    # Esteira de análise
    path('esteira/', views.esteira_analise, name='esteira_analise'),
    
    # Detalhes do processo
    path('processo/<int:processo_id>/', views.detalhe_processo, name='detalhe_processo'),
    
    # Ações do processo
    path('processo/<int:processo_id>/assumir/', views.assumir_processo, name='assumir_processo'),
    path('processo/<int:processo_id>/aprovar/', views.aprovar_processo, name='aprovar_processo'),
    path('processo/<int:processo_id>/rejeitar/', views.rejeitar_processo, name='rejeitar_processo'),
    path('processo/<int:processo_id>/suspender/', views.suspender_processo, name='suspender_processo'),
    path('processo/<int:processo_id>/cancelar/', views.cancelar_processo, name='cancelar_processo'),
    
    # AJAX
    path('processo/<int:processo_id>/checklist/', views.atualizar_checklist, name='atualizar_checklist'),
    
    # Ações em lote
    path('processos/assumir-multiplos/', views.assumir_processos_multiplos, name='assumir_processos_multiplos'),
    
    # Relatórios
    path('relatorio/', views.relatorio_analise, name='relatorio_analise'),
]