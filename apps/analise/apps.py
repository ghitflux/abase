from django.apps import AppConfig


class AnaliseConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.analise'
    
    def ready(self):
        import apps.analise.signals
