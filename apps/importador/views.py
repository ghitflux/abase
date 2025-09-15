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
        if not form.is_valid():
            return render(request, "importador/importar.html", {"form": form}, status=400)

        f = form.cleaned_data["arquivo"]
        modo = form.cleaned_data["modo"]
        content = f.read()

        if modo == "preview":
            try:
                lines = content.decode("latin1", errors="ignore").splitlines()
                ref, data_gen = parse_header_ref(lines)
                colspec = find_columns_index(lines)
                # pega só as 30 primeiras para prévia
                regs = list(r for i,r in zip(range(30), iter_registros(lines, colspec)))
                sha = sha256_bytes(content)
                ctx = {"form": form, "preview": regs, "referencia": ref, "data_geracao": data_gen, "sha256": sha}
                messages.info(request, f"Pré-visualização: {len(regs)} linhas exibidas (arquivo hash {sha[:12]}…).")
                return render(request, "importador/importar.html", ctx)
            except Exception as ex:
                messages.error(request, f"Erro na leitura: {ex}")
                log.exception("Prévia do importador falhou")
                return render(request, "importador/importar.html", {"form": form}, status=400)

        # confirm
        try:
            imp = importar_contribuicoes(content, f.name, request.user)
            messages.success(request, f"Importado com sucesso. Atualizados: {imp.total_atualizados}, ignorados: {imp.total_ignorados}, não encontrados: {imp.total_nao_encontrados}.")
            return redirect("importador:detalhe", pk=imp.id)
        except Exception as ex:
            messages.error(request, f"Falha ao importar: {ex}")
            log.exception("Falha na importação")
            return render(request, "importador/importar.html", {"form": form}, status=400)
    else:
        form = ImportarTXTForm()
    return render(request, "importador/importar.html", {"form": form})

@login_required
def detalhe(request, pk):
    from .models import ImportacaoContribuicao
    imp = ImportacaoContribuicao.objects.select_related("criado_por").prefetch_related("ocorrencias").get(pk=pk)
    return render(request, "importador/detalhe.html", {"imp": imp})
