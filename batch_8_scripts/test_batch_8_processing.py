#!/usr/bin/env python
import os
import sys
import django

# Adiciona o diretório do projeto ao path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Configura o Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from apps.importar_cadastros.models import ImportBatch
from apps.importar_cadastros.services import ImportService

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Testando processamento do Lote #{batch.id} ===")
    
    # Cria o serviço de importação
    service = ImportService(batch)
    
    # Tenta ler a planilha
    print("Lendo planilha...")
    try:
        df = service._read_spreadsheet()
        print(f"Planilha lida com sucesso: {len(df)} linhas")
        print(f"Colunas: {list(df.columns)}")
        
        # Testa o processamento de uma linha
        print("\nTestando processamento da primeira linha...")
        if len(df) > 0:
            primeira_linha = df.iloc[0].to_dict()
            print(f"Dados da primeira linha: {primeira_linha}")
            
            # Testa o mapeamento
            print("\nTestando mapeamento...")
            try:
                dados_mapeados = service._map_row_data(primeira_linha)
                print(f"Dados mapeados: {dados_mapeados}")
                
                # Testa a validação
                print("\nTestando validação...")
                try:
                    cadastro = service._upsert_cadastro(dados_mapeados)
                    print(f"Validação passou! Cadastro: {cadastro}")
                except Exception as e:
                    print(f"Erro na validação: {e}")
                    
            except Exception as e:
                print(f"Erro no mapeamento: {e}")
                import traceback
                traceback.print_exc()
        
    except Exception as e:
        print(f"Erro ao ler planilha: {e}")
        import traceback
        traceback.print_exc()
        
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()