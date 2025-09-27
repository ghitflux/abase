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
from django.db.models import Count
from datetime import datetime

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Verificação Final do Lote #{batch.id} ===")
    print(f"Status do lote: {batch.status}")
    print(f"Tipo: {batch.tipo}")
    print(f"Planilha: {batch.planilha}")
    print(f"Criado em: {batch.created_at}")
    print(f"Atualizado em: {batch.updated_at}")
    
    # Estatísticas das linhas processadas
    total_rows = ImportRow.objects.filter(batch=batch).count()
    success_rows = ImportRow.objects.filter(batch=batch, sucesso=True).count()
    error_rows = ImportRow.objects.filter(batch=batch, sucesso=False).count()
    
    print(f"\n=== Estatísticas de Processamento ===")
    print(f"Total de linhas processadas: {total_rows}")
    print(f"Sucessos: {success_rows} ({success_rows/total_rows*100:.1f}%)")
    print(f"Erros: {error_rows} ({error_rows/total_rows*100:.1f}%)")
    
    # Verifica se há erros restantes
    if error_rows > 0:
        print(f"\n⚠️  Ainda existem {error_rows} erros:")
        error_import_rows = ImportRow.objects.filter(batch=batch, sucesso=False)
        for error_row in error_import_rows[:5]:  # Mostra apenas os primeiros 5
            print(f"  Linha {error_row.linha_numero}: {error_row.mensagem_erro}")
    else:
        print(f"\n✅ Nenhum erro restante!")
    
    # Estatísticas dos cadastros criados
    cadastros_criados = Cadastro.objects.filter(
        id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True)
    ).count()
    
    print(f"\n=== Cadastros Criados ===")
    print(f"Total de cadastros criados: {cadastros_criados}")
    
    # Verifica alguns cadastros criados
    if cadastros_criados > 0:
        print(f"\n=== Amostra de Cadastros Criados ===")
        sample_cadastros = Cadastro.objects.filter(
            id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True)
        )[:5]
        
        for cadastro in sample_cadastros:
            print(f"ID: {cadastro.id}")
            print(f"  Nome: {cadastro.nome_completo}")
            print(f"  CPF: {cadastro.cpf}")
            print(f"  Email: {cadastro.email}")
            print(f"  Tipo Pessoa: {cadastro.tipo_pessoa}")
            print(f"  Status: {cadastro.status}")
            print(f"  Agente: {cadastro.agente_responsavel}")
            print(f"  Criado em: {cadastro.created_at}")
            print()
    
    # Estatísticas por tipo de pessoa
    tipo_pessoa_stats = Cadastro.objects.filter(
        id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True)
    ).values('tipo_pessoa').annotate(count=Count('id'))
    
    print(f"=== Distribuição por Tipo de Pessoa ===")
    for stat in tipo_pessoa_stats:
        print(f"  {stat['tipo_pessoa']}: {stat['count']} cadastros")
    
    # Estatísticas por status
    status_stats = Cadastro.objects.filter(
        id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True)
    ).values('status').annotate(count=Count('id'))
    
    print(f"\n=== Distribuição por Status ===")
    for stat in status_stats:
        print(f"  {stat['status']}: {stat['count']} cadastros")
    
    # Verifica campos importantes
    print(f"\n=== Verificação de Campos Importantes ===")
    
    # CPFs válidos
    cpfs_validos = Cadastro.objects.filter(
        id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True),
        cpf__isnull=False,
        cpf__gt=''
    ).count()
    print(f"Cadastros com CPF válido: {cpfs_validos}")
    
    # Emails válidos
    emails_validos = Cadastro.objects.filter(
        id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True),
        email__isnull=False,
        email__gt='',
        email__contains='@'
    ).count()
    print(f"Cadastros com email válido: {emails_validos}")
    
    # CEPs válidos
    ceps_validos = Cadastro.objects.filter(
        id__in=ImportRow.objects.filter(batch=batch, sucesso=True).values_list('cadastro_id', flat=True),
        cep__isnull=False,
        cep__gt=''
    ).count()
    print(f"Cadastros com CEP válido: {ceps_validos}")
    
    print(f"\n=== Resumo Final ===")
    if error_rows == 0 and cadastros_criados == total_rows:
        print(f"🎉 SUCESSO TOTAL! Todos os {total_rows} registros foram processados e {cadastros_criados} cadastros foram criados!")
        print(f"✅ O lote #{batch.id} foi processado com 100% de sucesso!")
    else:
        print(f"⚠️  Processamento parcial: {success_rows}/{total_rows} sucessos, {cadastros_criados} cadastros criados")
    
    print(f"\n📊 Taxa de sucesso final: {success_rows/total_rows*100:.1f}%")
    
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()