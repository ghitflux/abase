#!/usr/bin/env python
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from apps.analise.models import HistoricoAnalise, AnaliseProcesso  # noqa: E402

# Removed unused User import


print('=== ÚLTIMOS 10 HISTÓRICOS DE ANÁLISE ===')
for h in HistoricoAnalise.objects.order_by('-data_acao')[:10]:
    print(f'ID: {h.processo.id} | {h.data_acao.strftime("%d/%m/%Y %H:%M")} | {h.acao} | {h.status_anterior} -> {h.status_novo} | User: {h.usuario}')

print('\n=== PROCESSOS COM STATUS CORRECAO_FEITA ===')
for p in AnaliseProcesso.objects.filter(status='correcao_feita'):
    print(f'Processo #{p.id} | Cadastro: {p.cadastro.nome_completo} | Status: {p.status} | Analista: {p.analista_responsavel}')

print('\n=== PROCESSOS PENDENTES ===')
for p in AnaliseProcesso.objects.filter(status='pendente'):
    print(f'Processo #{p.id} | Cadastro: {p.cadastro.nome_completo} | Status: {p.status} | Analista: {p.analista_responsavel}')