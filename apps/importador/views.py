import logging
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.views.decorators.http import require_http_methods

from .forms import ImportarTXTForm
from .parser import parse_header_ref, find_columns_index, iter_registros, sha256_bytes
from .service import importar_contribuicoes

log = logging.getLogger("apps")

@login_required
@require_http_methods(["GET","POST"])
def importar(request):
    if request.method == "POST":
        form = ImportarTXTForm(request.POST, request.FILES)
        
        # Check if we have a file hash for confirmation (from preview)
        arquivo_hash = request.POST.get('arquivo_hash')
        modo = request.POST.get('modo')
        
        # If confirming from preview, get file from session
        if modo == "confirm" and arquivo_hash:
            stored_data = request.session.get(f'upload_file_{arquivo_hash}')
            if stored_data:
                try:
                    import base64
                    content = base64.b64decode(stored_data['content'])
                    filename = stored_data['filename']
                    
                    imp = importar_contribuicoes(content, filename, request.user)
                    messages.success(request, f"Importado com sucesso. Atualizados: {imp.total_atualizados}, ignorados: {imp.total_ignorados}, não encontrados: {imp.total_nao_encontrados}.")
                    
                    # Clean up session data
                    del request.session[f'upload_file_{arquivo_hash}']
                    
                    return redirect("importador:detalhe", pk=imp.id)
                except Exception as ex:
                    messages.error(request, f"Falha ao importar: {ex}")
                    log.exception("Falha na importação")
                    from .models import ImportacaoContribuicao
                    context = {"form": ImportarTXTForm(), "recent_imports": ImportacaoContribuicao.objects.select_related("criado_por").order_by("-criado_em")[:20]}
                    return render(request, "importador/importar.html", context, status=400)
            else:
                messages.error(request, "Arquivo não encontrado. Por favor, faça upload novamente.")
                context = {"form": ImportarTXTForm(), "recent_imports": []}
                return render(request, "importador/importar.html", context, status=400)
        
        # Regular form processing
        if not form.is_valid():
            from .models import ImportacaoContribuicao
            recent_imports = ImportacaoContribuicao.objects.select_related("criado_por").order_by("-criado_em")[:20]
            context = {"form": form, "recent_imports": recent_imports}
            return render(request, "importador/importar.html", context, status=400)

        f = form.cleaned_data["arquivo"]
        content = f.read()

        # Always do preview mode (removed modo selection)
        try:
            import base64
            lines = content.decode("latin1", errors="ignore").splitlines()
            ref, data_gen = parse_header_ref(lines)
            colspec = find_columns_index(lines)
            # pega só as 30 primeiras para prévia
            regs = list(r for i,r in zip(range(30), iter_registros(lines, colspec)))
            sha = sha256_bytes(content)
            
            # Store file in session for later confirmation
            request.session[f'upload_file_{sha}'] = {
                'content': base64.b64encode(content).decode('utf-8'),
                'filename': f.name
            }
            
            ctx = {"form": form, "preview": regs, "referencia": ref, "data_geracao": data_gen, "sha256": sha}
            messages.info(request, f"Pré-visualização: {len(regs)} linhas exibidas (arquivo hash {sha[:12]}…).")
            return render(request, "importador/importar.html", ctx)
        except Exception as ex:
            messages.error(request, f"Erro na leitura: {ex}")
            log.exception("Prévia do importador falhou")
            recent_imports = ImportacaoContribuicao.objects.select_related("criado_por").order_by("-criado_em")[:20]
            context = {"form": form, "recent_imports": recent_imports}
            return render(request, "importador/importar.html", context, status=400)
    else:
        form = ImportarTXTForm()

    # Get recent imports for the sidebar
    from .models import ImportacaoContribuicao
    recent_imports = ImportacaoContribuicao.objects.select_related("criado_por").order_by("-criado_em")[:20]

    context = {
        "form": form,
        "recent_imports": recent_imports
    }
    return render(request, "importador/importar.html", context)

@login_required
def detalhe(request, pk):
    from .models import ImportacaoContribuicao
    imp = ImportacaoContribuicao.objects.select_related("criado_por").prefetch_related("ocorrencias").get(pk=pk)
    return render(request, "importador/detalhe.html", {"imp": imp})

@login_required
def listar(request):
    from .models import ImportacaoContribuicao
    from django.core.paginator import Paginator

    # Get filter parameters
    current_status = request.GET.get('status', '')
    current_competencia = request.GET.get('competencia', '')

    # Base queryset
    importacoes = ImportacaoContribuicao.objects.select_related("criado_por").order_by("-criado_em")

    # Apply filters
    if current_status:
        importacoes = importacoes.filter(status=current_status)
    if current_competencia:
        # Assuming competencia is stored as date, filter by month/year
        try:
            year, month = current_competencia.split('-')
            importacoes = importacoes.filter(referencia__year=year, referencia__month=month)
        except (ValueError, AttributeError):
            pass

    # Status choices for the dropdown
    status_choices = [
        ('PENDENTE', 'Pendente'),
        ('PROCESSANDO', 'Processando'),
        ('CONCLUIDO', 'Concluído'),
        ('ERRO', 'Erro'),
    ]

    paginator = Paginator(importacoes, 10)  # 10 importações por página
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    context = {
        'page_obj': page_obj,
        'status_choices': status_choices,
        'current_status': current_status,
        'current_competencia': current_competencia,
    }

    return render(request, "importador/listar_importacoes.html", context)
