from django.contrib import admin
from django.http import HttpResponse
import csv
from .models import Cadastro, ParcelaAntecipacao
from apps.documentos.models import Documento

# ---------------- Inlines ----------------
class ParcelaInline(admin.TabularInline):
    model = ParcelaAntecipacao
    extra = 0
    fields = ("numero","valor","vencimento","status")
    can_delete = False

class DocumentoInline(admin.TabularInline):
    model = Documento
    extra = 0
    fields = ("tipo","arquivo","criado_em")
    readonly_fields = ("criado_em",)

# ---------------- Ações ----------------
@admin.action(description="Exportar selecionados (CSV)")
def export_csv(modeladmin, request, queryset):
    resp = HttpResponse(content_type="text/csv; charset=utf-8")
    resp["Content-Disposition"] = 'attachment; filename="cadastros.csv"'
    writer = csv.writer(resp)
    cols = [
        "id","status","tipo_pessoa","cpf","cnpj","nome_completo",
        "orgao_publico","situacao_servidor","matricula_servidor",
        "mensalidade_associativa","valor_total_antecipacao","doacao_associado","disponivel",
        "created_at","approved_at","paid_at"
    ]
    writer.writerow(cols)
    for c in queryset:
        row = [getattr(c, k, "") for k in cols]
        writer.writerow(row)
    return resp

# ---------------- CadastroAdmin ----------------
@admin.register(Cadastro)
class CadastroAdmin(admin.ModelAdmin):
    list_display = (
        "id","nome_completo","doc","matricula_servidor",
        "orgao_publico","status","valor_total_antecipacao","created_at"
    )
    list_filter = ("status","tipo_pessoa","situacao_servidor","orgao_publico","created_at")
    search_fields = ("nome_completo","cpf","cnpj","matricula_servidor","orgao_publico")
    date_hierarchy = "created_at"
    inlines = [ParcelaInline, DocumentoInline]
    actions = [export_csv]
    list_select_related = ()
    autocomplete_fields = ()  # habilite se usar ForeignKeys longas (ex.: agente_responsavel)
    readonly_fields = (
        "trinta_porcento_bruto","margem_liquido_menos_30_bruto",
        "valor_total_antecipacao","doacao_associado","disponivel"
    )

    def doc(self, obj: Cadastro):
        return obj.cpf or obj.cnpj or "—"
    doc.short_description = "CPF/CNPJ"

@admin.register(ParcelaAntecipacao)
class ParcelaAntecipacaoAdmin(admin.ModelAdmin):
    list_display = ['cadastro', 'numero', 'valor', 'vencimento', 'status']
    list_filter = ['status', 'numero']