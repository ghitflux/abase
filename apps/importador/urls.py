from django.urls import path
from . import views

app_name = 'importador'

urlpatterns = [
    path("", views.importar, name="importar"),
    path("<int:pk>/", views.detalhe, name="detalhe"),
]