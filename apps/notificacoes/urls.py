from django.urls import path
from . import views

app_name = 'notificacoes'

urlpatterns = [
    path('logs/', views.logs_notificacoes, name='logs_list'),
]