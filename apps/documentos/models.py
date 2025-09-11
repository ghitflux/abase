from django.db import models
from django.conf import settings
from .storage import PrivateStorage

class Documento(models.Model):
    """
    Documento final vinculado a um cadastro salvo com sucesso.
    """
    cadastro   = models.ForeignKey("cadastros.Cadastro", on_delete=models.CASCADE, related_name="documentos")
    tipo       = models.CharField(max_length=32)   # ex.: DOC_FRENTE, DOC_VERSO, COMP_ENDERECO, ...
    arquivo    = models.FileField(storage=PrivateStorage(), upload_to="docs/%Y/%m/")
    criado_em  = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-criado_em"]

class DocumentoRascunho(models.Model):
    """
    Arquivos anexados antes do submit final, ligados a um draft_token (sessão) e usuário.
    Promovidos a Documento quando o cadastro é salvo.
    """
    user        = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    draft_token = models.CharField(max_length=40, db_index=True)
    tipo        = models.CharField(max_length=32)
    arquivo     = models.FileField(storage=PrivateStorage(), upload_to="docs_draft/%Y/%m/")
    criado_em   = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-criado_em"]