from django.apps import AppConfig


class TesourariaConfig(AppConfig):
    """
    Configuração da app Tesouraria
    
    Esta app gerencia entradas e saídas de recursos do sistema,
    sem fins lucrativos, focada em gestão de tesouraria de organizações.
    """
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.tesouraria'