from django.urls import path
from .views import (
    dashboard_diretoria,
    export_associados_xlsx, export_orgaos_xlsx,
    export_associados_pdf, export_orgaos_pdf, export_dashboard_pdf
)

app_name = "relatorios"

urlpatterns = [
    path("", dashboard_diretoria, name="dashboard-diretoria"),
    
    # XLSX Exports
    path("associados.xlsx", export_associados_xlsx, name="export-associados-xlsx"),
    path("orgaos.xlsx", export_orgaos_xlsx, name="export-orgaos-xlsx"),
    
    # PDF Exports
    path("associados.pdf", export_associados_pdf, name="export-associados-pdf"),
    path("orgaos.pdf", export_orgaos_pdf, name="export-orgaos-pdf"),
    path("dashboard.pdf", export_dashboard_pdf, name="export-dashboard-pdf"),
]