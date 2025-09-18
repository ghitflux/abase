from django.urls import path
from . import views

app_name = 'importador'

urlpatterns = [
    path("", views.importar, name="importar"),
    path("importar/", views.importar, name="importar-alt"),
    path("listar/", views.listar, name="listar"),
    path("<int:pk>/", views.detalhe, name="detalhe"),
]