from django.urls import path
from . import views

app_name = 'importador'

urlpatterns = [
    path('upload/', views.upload_arquivo, name='upload_arquivo'),
    path('', views.listar_importacoes, name='listar_importacoes'),
    path('<uuid:importacao_id>/', views.detalhe_importacao, name='detalhe_importacao'),
    path('<uuid:importacao_id>/reprocessar/', views.reprocessar_arquivo, name='reprocessar_arquivo'),
]