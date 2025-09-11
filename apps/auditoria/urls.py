from django.urls import path
from . import views

app_name = 'auditoria'

urlpatterns = [
    path('', views.logs_list, name='logs_list'),
]