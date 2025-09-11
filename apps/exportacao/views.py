from django.contrib.auth.decorators import login_required, user_passes_test
from django.http import HttpResponse
from django.utils import timezone
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import StatusCadastro
from .services import build_xlsx_resumo_associados, build_xlsx_resumo_por_orgao


def is_admin(u):  # diretoria/admin
    return u.is_superuser or u.groups.filter(name__in=["ADMIN"]).exists()


@login_required
@user_passes_test(is_admin)
def export_associados(request):
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
def export_por_orgao(request):
    qs = Cadastro.objects.all()
    wb = build_xlsx_resumo_por_orgao(qs)
    now = timezone.now().strftime("%Y%m%d-%H%M")
    resp = HttpResponse(content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    resp["Content-Disposition"] = f'attachment; filename="OrgaosPublicos-{now}.xlsx"'
    wb.save(resp)
    return resp
