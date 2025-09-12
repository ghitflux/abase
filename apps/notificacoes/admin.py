from django.contrib import admin
from .models import NotificacaoLog

@admin.register(NotificacaoLog)
class NotificacaoLogAdmin(admin.ModelAdmin):
    list_display = ['data_criacao', 'tipo', 'assunto', 'destinatarios', 'status', 'contexto']
    list_filter = ['tipo', 'status', 'contexto', 'data_criacao']
    search_fields = ['assunto', 'destinatarios', 'corpo']
    readonly_fields = ['data_criacao']
    date_hierarchy = 'data_criacao'
    
    fieldsets = (
        ('Informações Básicas', {
            'fields': ('tipo', 'status', 'contexto', 'data_criacao')
        }),
        ('Conteúdo', {
            'fields': ('destinatarios', 'assunto', 'corpo')
        }),
        ('Rastreamento', {
            'fields': ('usuario_origem', 'erro'),
            'classes': ('collapse',)
        }),
    )
    
    def has_add_permission(self, request):
        # Não permitir criação manual de logs
        return False
    
    def has_change_permission(self, request, obj=None):
        # Não permitir edição de logs
        return False
