"""
Configuração do Django Admin para a app Tesouraria

Este módulo configura a interface administrativa para gerenciar
movimentações de tesouraria da organização.
"""

from django.contrib import admin
from .models import MovimentacaoTesouraria, Mensalidade, ReconciliacaoLog


@admin.register(MovimentacaoTesouraria)
class MovimentacaoTesourariaAdmin(admin.ModelAdmin):
    """
    Configuração do admin para MovimentacaoTesouraria
    
    Fornece interface completa para gerenciar movimentações de tesouraria,
    incluindo filtros, busca e hierarquia por data.
    """
    
    # Campos exibidos na listagem
    list_display = [
        'descricao', 
        'get_valor_formatado', 
        'tipo', 
        'data', 
        'usuario', 
        'created_at'
    ]
    
    # Filtros laterais
    list_filter = [
        'tipo', 
        'data', 
        'created_at', 
        'usuario'
    ]
    
    # Campos de busca
    search_fields = [
        'descricao', 
        'usuario__username',
        'usuario__first_name',
        'usuario__last_name'
    ]
    
    # Hierarquia por data
    date_hierarchy = 'data'
    
    # Campos somente leitura
    readonly_fields = ['created_at', 'updated_at']
    
    # Organização dos campos no formulário
    fieldsets = (
        ('Informações da Movimentação', {
            'fields': ('descricao', 'valor', 'tipo', 'data')
        }),
        ('Responsável', {
            'fields': ('usuario',)
        }),
        ('Observações', {
            'fields': ('observacoes',),
            'classes': ('collapse',)
        }),
        ('Auditoria', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
    
    # Ações em massa customizadas
    actions = ['exportar_movimentacoes']
    
    def get_valor_formatado(self, obj):
        """Retorna valor formatado para exibição na listagem"""
        return obj.get_valor_formatado()
    get_valor_formatado.short_description = 'Valor'
    get_valor_formatado.admin_order_field = 'valor'
    
    def exportar_movimentacoes(self, request, queryset):
        """Ação para exportar movimentações selecionadas"""
        # Implementar exportação futuramente
        self.message_user(request, f"{queryset.count()} movimentações selecionadas para exportação.")
    exportar_movimentacoes.short_description = "Exportar movimentações selecionadas"


@admin.register(Mensalidade)
class MensalidadeAdmin(admin.ModelAdmin):
    list_display = ('competencia', 'cpf', 'matricula', 'status', 'valor', 'data_importacao')
    list_filter = ('status', 'competencia', 'data_importacao')
    search_fields = ('cpf', 'matricula', 'competencia')
    readonly_fields = ('id', 'data_importacao', 'data_liquidacao')
    ordering = ['-competencia', 'cpf']


@admin.register(ReconciliacaoLog)
class ReconciliacaoLogAdmin(admin.ModelAdmin):
    list_display = ('data_execucao', 'total_processados', 'total_conciliados', 'executado_por')
    list_filter = ('data_execucao', 'executado_por')
    readonly_fields = ('data_execucao', 'total_processados', 'total_conciliados', 'detalhes', 'executado_por')