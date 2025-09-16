# apps/analise/apps.py
from django.apps import AppConfig
import importlib

class AnaliseConfig(AppConfig):
    name = "apps.analise"

    def ready(self) -> None:
        # importa o módulo para registrar os receivers
        importlib.import_module("apps.analise.signals")
