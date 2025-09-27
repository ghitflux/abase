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

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Corrigindo mapeamento do Lote #{batch.id} ===")
    
    # Mapeamento atual (problemático)
    print("Mapeamento atual:")
    for key, value in batch.mapping_json.items():
        print(f"  {key} -> {value}")
    
    # Novo mapeamento corrigido baseado nos nomes corretos dos campos do modelo
    novo_mapeamento = {
        'rg': 'rg',
        'uf': 'state', 
        'cep': 'cep',
        'cpf': 'cpf',  # Corrigido de 'cpf_cnpj' para 'cpf'
        'cnpj': 'cpf',  # CNPJ também vai para o campo 'cpf'
        'nome': 'nome_completo',
        'banco': 'bank',
        'conta': 'account',
        'email': 'email',
        'bairro': 'neighborhood',
        'cidade': 'city',
        'estado': 'state',
        'numero': 'address_number',
        'status': 'auxilio_status',
        'agencia': 'agency',
        'celular': 'celular',  # Corrigido de 'phone' para 'celular'
        'endereco': 'address',
        'telefone': 'celular',  # Telefone também vai para 'celular'
        'chave_pix': 'pix_key',
        'matricula': 'matricula_servidor',  # Corrigido de 'server_register' para 'matricula_servidor'
        'profissao': 'profession',
        'created_at': 'created_at',
        'data_envio': 'auxilio_data_envio',
        'nascimento': 'birth_date',
        'tipo_conta': 'account_type',
        'complemento': 'complement',
        'estado_civil': 'marital_status',
        'mes_averbacao': 'contrato_mes_averbacao',
        'nome_completo': 'nome_completo',
        'orgao_publico': 'public_agency',
        'valor_liquido': 'calc_liquido_cc',
        'tipo_chave_pix': 'pix_key_type',
        'data_nascimento': 'birth_date',
        'orgao_expedidor': 'orgao_expedidor',
        'doacao_associado': 'contrato_doacao_associado',
        'situacao_servidor': 'server_status',
        'valor_bruto_total': 'calc_valor_bruto',
        'matricula_servidor': 'matricula_servidor',
        'mensalidade_associativa': 'calc_mensalidade_associativa',
        'prazo_antecipacao_meses': 'calc_prazo_antecipacao',
        'auxilio_agente_taxa_percent': 'auxilio_taxa'
    }
    
    # Atualiza o mapeamento
    batch.mapping_json = novo_mapeamento
    batch.save()
    
    print("\nNovo mapeamento aplicado:")
    for key, value in novo_mapeamento.items():
        print(f"  {key} -> {value}")
    
    print(f"\nMapeamento do lote #{batch.id} corrigido com sucesso!")
    
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()