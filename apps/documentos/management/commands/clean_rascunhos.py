from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import timedelta
from apps.documentos.models import DocumentoRascunho

class Command(BaseCommand):
    help = "Remove rascunhos de documentos com mais de 7 dias."

    def handle(self, *args, **options):
        lim = timezone.now() - timedelta(days=7)
        qs = DocumentoRascunho.objects.filter(criado_em__lt=lim)
        total = qs.count()
        qs.delete()
        self.stdout.write(self.style.SUCCESS(f"Rascunhos removidos: {total}"))