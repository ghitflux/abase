from django.contrib import admin
from .models import ArquivoImportacao

@admin.register(ArquivoImportacao)
class ArquivoImportacaoAdmin(admin.ModelAdmin):
    list_display = ('nome_arquivo', 'competencia', 'status', 'tipo_arquivo', 'total_linhas', 'linhas_processadas', 'linhas_com_erro', 'data_upload', 'usuario')
    list_filter = ('status', 'tipo_arquivo', 'competencia', 'data_upload')
    search_fields = ('nome_arquivo', 'competencia', 'usuario__username')
    readonly_fields = ('id', 'data_upload', 'data_processamento', 'total_linhas', 'linhas_processadas', 'linhas_com_erro', 'log_erros')
    ordering = ['-data_upload']
