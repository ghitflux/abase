from django.urls import path
from . import views

app_name = "importar_cadastros"

urlpatterns = [
    path("", views.index, name="index"),
    path("dry-run/", views.dry_run, name="dry_run"),
    path("confirm/", views.confirm, name="confirm"),
    path("batch/<int:batch_id>/", views.batch_detail, name="batch_detail"),
    path("batch/<int:batch_id>/rows/", views.batch_rows_json, name="batch_rows_json"),
    path("batch/<int:batch_id>/delete/", views.delete_batch, name="delete_batch"),
]