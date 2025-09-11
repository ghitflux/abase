from django.contrib.auth.decorators import login_required, user_passes_test
from django.shortcuts import render
from django.http import HttpResponse
from django.db.models import Count, Sum, Avg, F, DurationField, ExpressionWrapper
from django.utils import timezone
from django.db.models.functions import TruncMonth
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import StatusCadastro
from .services import (
    build_xlsx_resumo_associados, build_xlsx_resumo_por_orgao,
    generate_pdf_associados, generate_pdf_por_orgao, generate_dashboard_pdf
)

def is_admin(u):
    return u.is_superuser or u.groups.filter(name__in=["ADMIN"]).exists()

@login_required
@user_passes_test(is_admin)
def dashboard_diretoria(request):
    now = timezone.now()
    last180 = now - timezone.timedelta(days=180)

    qtd_efetivados = Cadastro.objects.filter(status=StatusCadastro.EFFECTIVATED).count()
    qtd_fila = Cadastro.objects.filter(status__in=[StatusCadastro.SENT_REVIEW, StatusCadastro.RESUBMITTED]).count()

    soma_total = Cadastro.objects.aggregate(Sum("valor_total_antecipacao"))["valor_total_antecipacao__sum"] or 0
    soma_doacoes = Cadastro.objects.aggregate(Sum("doacao_associado"))["doacao_associado__sum"] or 0

    top_orgaos = (Cadastro.objects
                  .values("orgao_publico")
                  .annotate(qtd=Count("id"), soma=Sum("valor_total_antecipacao"))
                  .order_by("-qtd")[:10])

    aprov_por_mes = (Cadastro.objects
                     .filter(approved_at__gte=last180)
                     .annotate(m=TruncMonth("approved_at"))
                     .values("m")
                     .annotate(qtd=Count("id"), soma=Sum("valor_total_antecipacao"))
                     .order_by("m"))

    # TMA
    dur_analise = ExpressionWrapper(F("approved_at") - F("created_at"), output_field=DurationField())
    dur_pagto   = ExpressionWrapper(F("paid_at") - F("approved_at"), output_field=DurationField())
    tma_analise = Cadastro.objects.exclude(approved_at__isnull=True).aggregate(Avg(dur_analise))["%s__avg" % dur_analise.name]
    tma_pagto   = Cadastro.objects.exclude(paid_at__isnull=True).aggregate(Avg(dur_pagto))["%s__avg" % dur_pagto.name]

    def dur_to_str(d):
        if not d: return "-"
        s = int(d.total_seconds()); h = s//3600; m = (s%3600)//60
        return f"{h}h{m:02d}m"

    ctx = dict(
        qtd_efetivados=qtd_efetivados,
        qtd_fila=qtd_fila,
        soma_total=float(soma_total or 0),
        soma_doacoes=float(soma_doacoes or 0),
        top_orgaos=list(top_orgaos),
        aprov_por_mes=[{"mes": x["m"].strftime("%Y-%m"), "qtd": x["qtd"], "soma": float(x["soma"] or 0)} for x in aprov_por_mes],
        tma_analise=dur_to_str(tma_analise), tma_pagto=dur_to_str(tma_pagto),
    )
    return render(request, "relatorios/dashboard.html", ctx)


# ===== XLSX EXPORT VIEWS =====

@login_required
@user_passes_test(is_admin)
def export_associados_xlsx(request):
    """Exporta associados em formato XLSX."""
    qs = Cadastro.objects.all().order_by("-created_at")
    # filtros opcionais
    org = request.GET.get("orgao")
    st = request.GET.get("status")
    if org:
        qs = qs.filter(orgao_publico__icontains=org)
    if st:
        qs = qs.filter(status=st)

    wb = build_xlsx_resumo_associados(qs)
    now = timezone.now().strftime("%Y%m%d-%H%M")
    resp = HttpResponse(content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    resp["Content-Disposition"] = f'attachment; filename="Associados-{now}.xlsx"'
    wb.save(resp)
    return resp


@login_required
@user_passes_test(is_admin)
def export_orgaos_xlsx(request):
    """Exporta resumo por órgão em formato XLSX."""
    qs = Cadastro.objects.all()
    wb = build_xlsx_resumo_por_orgao(qs)
    now = timezone.now().strftime("%Y%m%d-%H%M")
    resp = HttpResponse(content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    resp["Content-Disposition"] = f'attachment; filename="OrgaosPublicos-{now}.xlsx"'
    wb.save(resp)
    return resp


# ===== PDF EXPORT VIEWS =====

@login_required
@user_passes_test(is_admin)
def export_associados_pdf(request):
    """Exporta associados em formato PDF."""
    qs = Cadastro.objects.all().order_by("-created_at")
    # filtros opcionais
    org = request.GET.get("orgao")
    st = request.GET.get("status")
    if org:
        qs = qs.filter(orgao_publico__icontains=org)
    if st:
        qs = qs.filter(status=st)

    pdf_content = generate_pdf_associados(qs)
    now = timezone.now().strftime("%Y%m%d-%H%M")
    resp = HttpResponse(pdf_content, content_type="application/pdf")
    resp["Content-Disposition"] = f'attachment; filename="Associados-{now}.pdf"'
    return resp


@login_required
@user_passes_test(is_admin)
def export_orgaos_pdf(request):
    """Exporta resumo por órgão em formato PDF."""
    qs = Cadastro.objects.all()
    pdf_content = generate_pdf_por_orgao(qs)
    now = timezone.now().strftime("%Y%m%d-%H%M")
    resp = HttpResponse(pdf_content, content_type="application/pdf")
    resp["Content-Disposition"] = f'attachment; filename="OrgaosPublicos-{now}.pdf"'
    return resp


@login_required
@user_passes_test(is_admin)
def export_dashboard_pdf(request):
    """Exporta dashboard em formato PDF."""
    # Reutiliza a lógica do dashboard_diretoria
    now = timezone.now()
    last180 = now - timezone.timedelta(days=180)

    qtd_efetivados = Cadastro.objects.filter(status=StatusCadastro.EFFECTIVATED).count()
    qtd_fila = Cadastro.objects.filter(status__in=[StatusCadastro.SENT_REVIEW, StatusCadastro.RESUBMITTED]).count()

    soma_total = Cadastro.objects.aggregate(Sum("valor_total_antecipacao"))["valor_total_antecipacao__sum"] or 0
    soma_doacoes = Cadastro.objects.aggregate(Sum("doacao_associado"))["doacao_associado__sum"] or 0

    top_orgaos = (Cadastro.objects
                  .values("orgao_publico")
                  .annotate(qtd=Count("id"), soma=Sum("valor_total_antecipacao"))
                  .order_by("-qtd")[:10])

    aprov_por_mes = (Cadastro.objects
                     .filter(approved_at__gte=last180)
                     .annotate(m=TruncMonth("approved_at"))
                     .values("m")
                     .annotate(qtd=Count("id"), soma=Sum("valor_total_antecipacao"))
                     .order_by("m"))

    # TMA
    dur_analise = ExpressionWrapper(F("approved_at") - F("created_at"), output_field=DurationField())
    dur_pagto   = ExpressionWrapper(F("paid_at") - F("approved_at"), output_field=DurationField())
    tma_analise = Cadastro.objects.exclude(approved_at__isnull=True).aggregate(Avg(dur_analise))["%s__avg" % dur_analise.name]
    tma_pagto   = Cadastro.objects.exclude(paid_at__isnull=True).aggregate(Avg(dur_pagto))["%s__avg" % dur_pagto.name]

    def dur_to_str(d):
        if not d: return "-"
        s = int(d.total_seconds()); h = s//3600; m = (s%3600)//60
        return f"{h}h{m:02d}m"

    ctx = dict(
        qtd_efetivados=qtd_efetivados,
        qtd_fila=qtd_fila,
        soma_total=float(soma_total or 0),
        soma_doacoes=float(soma_doacoes or 0),
        top_orgaos=list(top_orgaos),
        aprov_por_mes=[{"mes": x["m"].strftime("%Y-%m"), "qtd": x["qtd"], "soma": float(x["soma"] or 0)} for x in aprov_por_mes],
        tma_analise=dur_to_str(tma_analise), tma_pagto=dur_to_str(tma_pagto),
    )

    pdf_content = generate_dashboard_pdf(ctx)
    now_str = timezone.now().strftime("%Y%m%d-%H%M")
    resp = HttpResponse(pdf_content, content_type="application/pdf")
    resp["Content-Disposition"] = f'attachment; filename="Dashboard-{now_str}.pdf"'
    return resp