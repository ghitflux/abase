#!/usr/bin/env python
import os
import sys
import django
import pandas as pd
import json

# Adiciona o diretório do projeto ao path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Configura o Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from apps.importar_cadastros.models import ImportBatch
from django.conf import settings

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Análise do Lote #{batch.id} ===")
    print(f"Status: {batch.status}")
    print(f"Arquivo: {batch.planilha.name}")
    print(f"Tamanho: {batch.planilha.size} bytes")
    
    # Caminho completo do arquivo
    file_path = os.path.join(settings.MEDIA_ROOT, batch.planilha.name)
    print(f"Caminho completo: {file_path}")
    print(f"Arquivo existe: {os.path.exists(file_path)}")
    
    if os.path.exists(file_path):
        # Ler a planilha
        try:
            df = pd.read_excel(file_path)
            print(f"\n=== Conteúdo da Planilha ===")
            print(f"Número de linhas: {len(df)}")
            print(f"Número de colunas: {len(df.columns)}")
            print(f"Colunas: {list(df.columns)}")
            
            # Mostrar as primeiras linhas
            print(f"\n=== Primeiras 3 linhas ===")
            print(df.head(3).to_string())
            
            # Verificar se há dados válidos
            print(f"\n=== Verificação de Dados ===")
            print(f"Linhas não vazias: {len(df.dropna(how='all'))}")
            
            # Analisar o mapeamento
            print(f"\n=== Análise do Mapeamento ===")
            mapping = batch.mapping_json  # Já é um dict, não precisa de json.loads
            print("Mapeamento atual:")
            for planilha_col, model_field in mapping.items():
                if planilha_col in df.columns:
                    non_null_count = df[planilha_col].notna().sum()
                    print(f"  {planilha_col} -> {model_field} (valores não nulos: {non_null_count})")
                else:
                    print(f"  {planilha_col} -> {model_field} (COLUNA NÃO ENCONTRADA)")
            
            # Verificar colunas da planilha que não estão no mapeamento
            unmapped_cols = [col for col in df.columns if col not in mapping.keys()]
            if unmapped_cols:
                print(f"\nColunas não mapeadas: {unmapped_cols}")
                
        except Exception as e:
            print(f"Erro ao ler a planilha: {e}")
            import traceback
            traceback.print_exc()
    else:
        print("Arquivo da planilha não encontrado!")
        
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()