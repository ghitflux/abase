#!/usr/bin/env python
import os
import sys
import django

# Adiciona o diretório do projeto ao path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Configura o Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from apps.importar_cadastros.models import ImportBatch, ImportRow

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"Lote #{batch.id}")
    print(f"Status: {batch.status}")
    print(f"Tipo: {batch.tipo}")
    print(f"Usuário: {batch.usuario}")
    print(f"Planilha: {batch.planilha}")
    print(f"Mapping JSON: {batch.mapping_json}")
    print(f"Total linhas: {batch.total_linhas}")
    print(f"Linhas sucesso: {batch.linhas_sucesso}")
    print(f"Linhas erro: {batch.linhas_erro}")
    print(f"Data criação: {batch.created_at}")  # Usando created_at em vez de data_criacao
    
    rows = ImportRow.objects.filter(batch=batch)
    print(f"\nRegistros ImportRow: {rows.count()}")
    
    if rows.count() > 0:
        print("\nPrimeiras 5 linhas:")
        for i, row in enumerate(rows[:5]):
            print(f"  Linha {row.linha_numero}: Sucesso={row.sucesso}, Erro='{row.mensagem_erro}'")
    else:
        print("Nenhum registro ImportRow encontrado para este lote.")
        
    # Verificar se há dados na planilha
    if batch.planilha:
        print(f"\nArquivo da planilha: {batch.planilha.name}")
        print(f"Tamanho do arquivo: {batch.planilha.size} bytes")
    else:
        print("\nNenhuma planilha associada ao lote.")
        
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()