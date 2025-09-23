import uuid
from pathlib import Path
from django.conf import settings
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_http_methods
from django.shortcuts import render
from django.http import HttpResponseBadRequest, FileResponse, Http404
from .models import Documento, DocumentoRascunho

# Limites de upload
MAX_SIZE = 10 * 1024 * 1024  # 10MB
ALLOWED_CONTENT_TYPES = {"application/pdf","image/jpeg","image/png","image/webp"}

@login_required
def ensure_draft_token(request):
    """
    Gera um token de rascunho e o mantém na sessão do usuário.
    """
    if "draft_token" not in request.session:
        request.session["draft_token"] = uuid.uuid4().hex
    return request.session["draft_token"]

@login_required
@require_http_methods(["POST"])
def upload_draft(request):
    """
    Recebe 'tipo' e 'arquivo' (multipart) e anexa ao rascunho do usuário.
    Retorna a lista atualizada (_draft_list.html).
    """
    draft_token = ensure_draft_token(request)
    tipo = request.POST.get("tipo")
    arquivo = request.FILES.get("arquivo") or request.FILES.get("arquivo_doc")

    if not tipo or not arquivo:
        return HttpResponseBadRequest("Tipo e arquivo são obrigatórios.")

    if arquivo.size > MAX_SIZE:
        return HttpResponseBadRequest("Arquivo maior que 10MB.")
    if arquivo.content_type not in ALLOWED_CONTENT_TYPES:
        return HttpResponseBadRequest("Apenas PDF/JPG/PNG/WEBP.")

    DocumentoRascunho.objects.create(
        user=request.user, draft_token=draft_token, tipo=tipo, arquivo=arquivo
    )
    docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
    return render(request, "documentos/_draft_list.html", {"docs": docs})

@login_required
@require_http_methods(["POST"])
def delete_draft(request, pk):
    """
    Remove um arquivo do rascunho.
    """
    d = DocumentoRascunho.objects.filter(pk=pk, user=request.user).first()
    if d:
        d.delete()
    draft_token = ensure_draft_token(request)
    docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
    return render(request, "documentos/_draft_list.html", {"docs": docs})

def _can_view(user, doc) -> bool:
    # Regra mínima: logado. Aqui você pode aplicar RBAC por papel/cadastro relacionado.
    return user.is_authenticated

@login_required
def serve_private(request):
    """
    DEV: retorna o arquivo diretamente.
    PROD: se PRIVATE_ACCEL_ENABLED=True, responde com cabeçalho X-Accel-Redirect para o Nginx entregar.
    Uso: GET /p/serve/?path=docs/2025/08/arquivo.pdf
    Uso: GET /p/serve/?doc_id=54
    """
    from django.http import HttpResponseForbidden, HttpResponse

    # Suporte a doc_id (novo) e path (compatibilidade)
    doc_id = request.GET.get("doc_id")
    rel_path = request.GET.get("path")

    doc = None

    if doc_id:
        # Buscar documento por ID
        try:
            doc = Documento.objects.get(id=doc_id)
            rel_path = str(doc.arquivo)
        except Documento.DoesNotExist:
            raise Http404("Documento não encontrado")

        # Verificar permissão
        if not _can_view(request.user, doc):
            return HttpResponseForbidden("Sem permissão.")

    elif rel_path:
        # Método original por caminho
        doc = Documento.objects.filter(arquivo=rel_path).first()
        if doc and not _can_view(request.user, doc):
            return HttpResponseForbidden("Sem permissão.")
    else:
        raise Http404("Parâmetro doc_id ou path é obrigatório")

    abs_path = settings.PRIVATE_MEDIA_ROOT / rel_path
    abs_path = Path(abs_path)
    if not abs_path.exists() or not abs_path.is_file():
        raise Http404("Arquivo não encontrado no sistema de arquivos")

    if getattr(settings, "PRIVATE_ACCEL_ENABLED", False):
        internal = f"{settings.PRIVATE_ACCEL_INTERNAL_URL}/{rel_path.replace('\\','/')}"
        resp = HttpResponse()
        resp["Content-Type"] = "application/octet-stream"
        # inline por padrão, pode forçar download com attachment
        resp["Content-Disposition"] = f'inline; filename="{abs_path.name}"'
        resp["X-Accel-Redirect"] = internal
        return resp

    # DEV local
    return FileResponse(open(abs_path, "rb"))