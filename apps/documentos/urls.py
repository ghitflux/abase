from django.urls import path
from .views import serve_private, upload_draft, delete_draft

app_name = "documentos"

urlpatterns = [
    path("serve/", serve_private, name="serve"),
    path("draft/upload/", upload_draft, name="draft-upload"),
    path("draft/<int:pk>/delete/", delete_draft, name="draft-delete"),
]