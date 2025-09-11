from django.urls import path
from .views import export_associados, export_por_orgao

app_name = "exportacao"
urlpatterns = [
    path("associados.xlsx", export_associados, name="associados"),
    path("orgaos.xlsx", export_por_orgao, name="orgaos"),
]