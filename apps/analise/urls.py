from django.urls import path
from . import views

app_name = 'analise'

urlpatterns = [
    # Dashboard principal
    path('', views.dashboard, name='dashboard'),
    
    # Esteira de análise
    path('esteira/', views.esteira_analise, name='esteira_analise'),
    path('esteira/fragment/', views.esteira_fragment, name='esteira_fragment'),
    
    # Detalhes do processo
    path('processo/<int:processo_id>/', views.detalhe_processo, name='detalhe_processo'),
    
    # Ações do processo
    path('processo/<int:processo_id>/assumir/', views.assumir_processo, name='assumir_processo'),
    path('processo/<int:processo_id>/aprovar/', views.aprovar_processo, name='aprovar_processo'),
    path('processo/<int:processo_id>/rejeitar/', views.rejeitar_processo, name='rejeitar_processo'),
    path('processo/<int:processo_id>/pendenciar/', views.pendenciar_processo, name='pendenciar_processo'),
    path('processo/<int:processo_id>/suspender/', views.suspender_processo, name='suspender_processo'),
    path('processo/<int:processo_id>/cancelar/', views.cancelar_processo, name='cancelar_processo'),
    path('processo/<int:processo_id>/marcar-correcao/', views.marcar_correcao_realizada, name='marcar_correcao_realizada'),
    path('processo/<int:processo_id>/validar-correcao/', views.validar_correcao_e_aprovar, name='validar_correcao_e_aprovar'),
    path('processo/<int:processo_id>/pendenciar-correcao/', views.pendenciar_correcao_novamente, name='pendenciar_correcao_novamente'),
    
    # AJAX
    path('processo/<int:processo_id>/checklist/', views.atualizar_checklist, name='atualizar_checklist'),
    
    # Ações em lote
    path('processos/assumir-multiplos/', views.assumir_processos_multiplos, name='assumir_processos_multiplos'),
    
    # Relatórios
    path('relatorio/', views.relatorio_analise, name='relatorio_analise'),
]