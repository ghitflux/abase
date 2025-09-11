"""
URLs da app Tesouraria

Configuração das rotas para gerenciamento de movimentações de tesouraria
de organizações sem fins lucrativos.
"""

from django.urls import path
from . import views

app_name = 'tesouraria'

urlpatterns = [
    # Dashboard principal da tesouraria
    path('', views.dashboard_tesouraria, name='dashboard'),
    
    # Movimentações
    path('movimentacoes/', views.lista_movimentacoes, name='lista_movimentacoes'),
    path('movimentacoes/<int:pk>/', views.detalhe_movimentacao, name='detalhe_movimentacao'),
    path('movimentacoes/nova/', views.nova_movimentacao, name='nova_movimentacao'),
    
    # Relatórios
    path('relatorio/', views.relatorio_tesouraria, name='relatorio'),
    
    # Mensalidades e Reconciliação
    path('mensalidades/', views.mensalidades_list, name='mensalidades_list'),
    path('reconciliacao/executar/', views.executar_reconciliacao, name='executar_reconciliacao'),
    path('reconciliacao/logs/', views.reconciliacao_logs, name='reconciliacao_logs'),
]