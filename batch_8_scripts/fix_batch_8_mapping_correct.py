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
    
    # Novo mapeamento corrigido baseado nos campos REAIS do modelo Cadastro
    novo_mapeamento = {
        'rg': 'rg',
        'uf': 'uf', 
        'cep': 'cep',
        'cpf': 'cpf',  
        'cnpj': 'cnpj',  
        'nome': 'nome_completo',
        'banco': 'banco',
        'conta': 'conta',
        'email': 'email',
        'bairro': 'bairro',
        'cidade': 'cidade',
        'estado': 'uf',  # estado -> uf
        'numero': 'numero',
        'status': 'status',
        'agencia': 'agencia',
        'celular': 'celular',
        'endereco': 'endereco',
        'telefone': 'celular',  # telefone -> celular
        'chave_pix': 'chave_pix',
        'matricula': 'matricula_servidor',
        'profissao': 'profissao',
        'created_at': 'created_at',
        'data_envio': 'data_envio',
        'nascimento': 'data_nascimento',
        'tipo_conta': 'tipo_conta',
        'complemento': 'complemento',
        'estado_civil': 'estado_civil',
        'mes_averbacao': 'mes_averbacao',
        'nome_completo': 'nome_completo',
        'orgao_publico': 'orgao_publico',
        'valor_liquido': 'valor_liquido',
        'tipo_chave_pix': 'tipo_chave_pix',
        'data_nascimento': 'data_nascimento',
        'orgao_expedidor': 'orgao_expedidor',
        'doacao_associado': 'doacao_associado',
        'situacao_servidor': 'situacao_servidor',
        'valor_bruto_total': 'valor_bruto_total',
        'matricula_servidor': 'matricula_servidor',
        'mensalidade_associativa': 'mensalidade_associativa',
        'prazo_antecipacao_meses': 'prazo_antecipacao_meses',
        'auxilio_agente_taxa_percent': 'auxilio_agente_taxa_percent'
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