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
from apps.cadastros.models import Cadastro

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Testando processamento detalhado do Lote #{batch.id} ===")
    
    # Cria o serviço de importação
    service = ImportService(batch)
    
    # Lê a planilha
    df = service._read_spreadsheet()
    print(f"Planilha lida com sucesso: {len(df)} linhas")
    
    if len(df) > 0:
        primeira_linha = df.iloc[0].to_dict()
        
        # Testa o mapeamento
        dados_mapeados = service._map_row_data(primeira_linha)
        print("\nDados mapeados:")
        for key, value in dados_mapeados.items():
            if value is not None and str(value) != 'nan':
                print(f"  {key}: '{value}' (len: {len(str(value))})")
        
        # Verifica campos que podem ter problemas de tamanho
        print("\nVerificando campos com possíveis problemas de tamanho:")
        
        # CEP deve ter no máximo 8 caracteres
        if 'cep' in dados_mapeados and dados_mapeados['cep']:
            cep_value = str(dados_mapeados['cep'])
            print(f"  CEP: '{cep_value}' (len: {len(cep_value)}) - Max: 8")
            if len(cep_value) > 8:
                print(f"    PROBLEMA: CEP muito longo!")
        
        # CPF deve ter no máximo 11 caracteres
        if 'cpf' in dados_mapeados and dados_mapeados['cpf']:
            cpf_value = str(dados_mapeados['cpf'])
            print(f"  CPF: '{cpf_value}' (len: {len(cpf_value)}) - Max: 11")
            if len(cpf_value) > 11:
                print(f"    PROBLEMA: CPF muito longo!")
        
        # Outros campos com limites
        campos_limites = {
            'rg': 20,
            'orgao_expedidor': 20,
            'uf': 2,
            'numero': 10,
            'complemento': 60,
            'bairro': 80,
            'cidade': 80,
            'celular': 20,
            'matricula_servidor': 30,
            'mes_averbacao': 7
        }
        
        for campo, limite in campos_limites.items():
            if campo in dados_mapeados and dados_mapeados[campo]:
                valor = str(dados_mapeados[campo])
                print(f"  {campo}: '{valor}' (len: {len(valor)}) - Max: {limite}")
                if len(valor) > limite:
                    print(f"    PROBLEMA: {campo} muito longo!")
        
        # Tenta criar o cadastro com validação manual
        print("\nTentando criar cadastro...")
        try:
            # Remove campos que podem estar causando problema
            dados_limpos = dados_mapeados.copy()
            
            # Limpa CEP removendo pontos
            if 'cep' in dados_limpos and dados_limpos['cep']:
                cep_limpo = str(dados_limpos['cep']).replace('.', '').replace('-', '')[:8]
                dados_limpos['cep'] = cep_limpo
                print(f"CEP limpo: '{cep_limpo}'")
            
            cadastro = Cadastro(**dados_limpos)
            cadastro.full_clean()  # Validação sem salvar
            print("Validação passou!")
            
        except Exception as e:
            print(f"Erro na validação: {e}")
            import traceback
            traceback.print_exc()
        
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()