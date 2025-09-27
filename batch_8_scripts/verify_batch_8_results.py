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
from apps.cadastros.models import Cadastro
from collections import Counter

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Verificação dos resultados do Lote #{batch.id} ===")
    
    # Estatísticas gerais
    total_rows = ImportRow.objects.filter(batch=batch).count()
    success_rows = ImportRow.objects.filter(batch=batch, sucesso=True).count()
    error_rows = ImportRow.objects.filter(batch=batch, sucesso=False).count()
    
    print(f"\n📊 Estatísticas Gerais:")
    print(f"  Total de linhas processadas: {total_rows}")
    print(f"  Sucessos: {success_rows} ({success_rows/total_rows*100:.1f}%)")
    print(f"  Erros: {error_rows} ({error_rows/total_rows*100:.1f}%)")
    
    # Análise dos erros
    error_messages = []
    error_import_rows = ImportRow.objects.filter(batch=batch, sucesso=False)
    
    for row in error_import_rows:
        if row.mensagem_erro:
            error_messages.append(row.mensagem_erro)
    
    # Conta os tipos de erro mais comuns
    error_counter = Counter(error_messages)
    
    print(f"\n❌ Tipos de erro mais comuns:")
    for error, count in error_counter.most_common(10):
        print(f"  {count}x: {error}")
    
    # Verifica cadastros criados
    cadastros_criados = Cadastro.objects.filter(
        id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True)
    ).count()
    
    print(f"\n✅ Cadastros criados com sucesso: {cadastros_criados}")
    
    # Mostra algumas linhas de erro para análise
    print(f"\n🔍 Exemplos de linhas com erro:")
    sample_errors = ImportRow.objects.filter(batch=batch, sucesso=False)[:5]
    
    for i, row in enumerate(sample_errors, 1):
        print(f"\n  Exemplo {i} - Linha {row.linha_numero}:")
        print(f"    Erro: {row.mensagem_erro}")
        if row.dados_brutos:
            # Mostra alguns campos relevantes dos dados brutos
            dados = row.dados_brutos
            campos_relevantes = ['nome', 'cpf', 'email', 'numero', 'cep']
            for campo in campos_relevantes:
                if campo in dados and dados[campo] and str(dados[campo]) != 'nan':
                    valor = str(dados[campo])
                    print(f"    {campo}: '{valor}' (len: {len(valor)})")
    
    # Status do lote
    print(f"\n📋 Status do lote: {batch.status}")
    print(f"   Criado em: {batch.created_at}")
    print(f"   Atualizado em: {batch.updated_at}")
    
    # Recomendações
    print(f"\n💡 Recomendações:")
    
    if error_rows > 0:
        print(f"  - {error_rows} linhas ainda apresentam erros")
        
        # Analisa os erros mais comuns
        for error, count in error_counter.most_common(3):
            if 'email' in error.lower():
                print(f"  - Corrigir validação de email ({count} ocorrências)")
            elif 'numero' in error.lower() and 'caracteres' in error.lower():
                print(f"  - Truncar campo 'numero' para máximo de 10 caracteres ({count} ocorrências)")
            elif 'cpf' in error.lower():
                print(f"  - Validar formato do CPF ({count} ocorrências)")
    
    if success_rows > 0:
        print(f"  - {success_rows} cadastros foram importados com sucesso")
        print(f"  - Taxa de sucesso atual: {success_rows/total_rows*100:.1f}%")
    
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()