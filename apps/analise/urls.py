from django.urls import path
from . import views

app_name = "analise"

urlpatterns = [
    path("", views.analise_redirect, name="index"),             # /analise/  -> esteira
    path("esteira/", views.esteira, name="esteira"),            # tela principal
    path("esteira/", views.esteira, name="esteira_analise"),    # alias para compatibilidade
    path("esteira/block/", views.esteira_block, name="esteira_block"),  # fragmento HTMX

    path("processo/<int:processo_id>/", views.detalhe_processo, name="detalhe_processo"),  # detalhe
    path("processo/<int:processo_id>/assumir/", views.assumir_processo, name="assumir_processo"),
    path("processo/<int:processo_id>/aprovar/", views.aprovar_processo, name="aprovar_processo"),
    path("processo/<int:processo_id>/correcao/", views.enviar_para_correcao, name="enviar_para_correcao"),
    path("processo/<int:processo_id>/cancelar/", views.cancelar_processo, name="cancelar_processo"),
]
