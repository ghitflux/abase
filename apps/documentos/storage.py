from django.core.files.storage import FileSystemStorage
from django.conf import settings
from pathlib import Path

class PrivateStorage(FileSystemStorage):
    """
    Armazena arquivos em _private/ (fora de static).
    Em dev, servimos via view; em prod, use X-Accel (Passo 7).
    """
    def __init__(self, *args, **kwargs):
        location = Path(settings.BASE_DIR) / "_private"
        base_url = "/p/serve/"  # endpoint para servir via view
        super().__init__(location=str(location), base_url=base_url, *args, **kwargs)