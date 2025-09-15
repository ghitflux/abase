#!/usr/bin/env python
import os
import django

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'abasenew.settings')
django.setup()

from apps.cadastros.models import Cadastro
from apps.analise.models import AnaliseProcesso

try:
    cadastro = Cadastro.objects.get(id=7)
    print(f'=== CADASTRO #{cadastro.id} ===')
    print(f'Nome: {cadastro.nome_completo}')
    print(f'Status atual: {cadastro.status} ({cadastro.get_status_display()})')
    print(f'Agente: {cadastro.agente_responsavel.username}')
    print(f'Criado em: {cadastro.created_at}')
    print(f'Atualizado em: {cadastro.updated_at}')
    print()
    
    # Verificar processo de análise
    try:
        processo = cadastro.analise_processo
        print(f'=== PROCESSO DE ANÁLISE ===')
        print(f'Status: {processo.status} ({processo.get_status_display()})')
        print(f'Analista: {processo.analista_responsavel.username if processo.analista_responsavel else "Não atribuído"}')
        print(f'Data entrada: {processo.data_entrada}')
        print(f'Data última atualização: {processo.data_ultima_atualizacao}')
        print(f'Feedback agente: {processo.feedback_agente}')
        print(f'Observações internas: {processo.observacoes_internas}')
    except Exception as e:
        print(f'Erro ao acessar processo de análise: {e}')
        print('Verificando se existe AnaliseProcesso...')
        processos = AnaliseProcesso.objects.filter(cadastro_id=7)
        print(f'Processos encontrados: {processos.count()}')
        for p in processos:
            print(f'  - ID: {p.id}, Status: {p.status}')
            
except Cadastro.DoesNotExist:
    print('Cadastro #7 não encontrado')
except Exception as e:
    print(f'Erro: {e}')