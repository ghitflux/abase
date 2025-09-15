from django.contrib import admin
from .models import ImportacaoContribuicao, ImportacaoOcorrencia

@admin.register(ImportacaoContribuicao)
class ImportacaoContribuicaoAdmin(admin.ModelAdmin):
    list_display = ('referencia', 'arquivo_nome', 'total_linhas', 'total_processados', 'total_atualizados', 'total_ignorados', 'criado_em', 'criado_por')
    list_filter = ('referencia', 'criado_em')
    search_fields = ('arquivo_nome', 'criado_por__username')
    readonly_fields = ('arquivo_sha256', 'criado_em', 'total_linhas', 'total_processados', 'total_atualizados', 'total_ignorados', 'total_nao_encontrados')
    ordering = ['-criado_em']

@admin.register(ImportacaoOcorrencia)
class ImportacaoOcorrenciaAdmin(admin.ModelAdmin):
    list_display = ('importacao', 'cpf', 'matricula', 'nome', 'acao', 'criado_em')
    list_filter = ('acao', 'criado_em', 'importacao__referencia')
    search_fields = ('cpf', 'matricula', 'nome')
    readonly_fields = ('criado_em',)
    ordering = ['-criado_em']
