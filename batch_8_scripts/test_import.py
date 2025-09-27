#!/usr/bin/env python
import os
import sys
import django

# Configura o Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from apps.importar_cadastros.models import ImportBatch, TipoImportacao, StatusImportacao
from apps.importar_cadastros.services import import_batch
from django.contrib.auth.models import User
from django.core.files import File

def test_import():
    # Busca um usuário
    user = User.objects.first()
    print(f'Usuário encontrado: {user}')

    # Cria um lote de teste com mapeamento correto
    batch = ImportBatch.objects.create(
        tipo=TipoImportacao.CADASTROS,
        usuario=user,
        status=StatusImportacao.DRAFT,
        mapping_json={'nome_completo': 'nome_completo', 'cpf': 'cpf', 'email': 'email', 'telefone': 'celular'}
    )

    # Anexa o arquivo de teste correto
    with open('test_planilha_correta.csv', 'rb') as f:
        batch.planilha.save('test_planilha_correta.csv', File(f))

    print(f'Lote criado: {batch.id}')

    # Testa o dry run
    try:
        results = import_batch(batch, dry_run=True)
        print(f'Resultado do dry run: {results}')
        print(f'Sucesso: {results.get("success")}')
        print(f'Total linhas: {results.get("total_linhas")}')
        print(f'Linhas sucesso: {results.get("linhas_sucesso")}')
        print(f'Linhas erro: {results.get("linhas_erro")}')
        if results.get('errors'):
            print(f'Primeiros erros: {results.get("errors")[:2]}')
    except Exception as e:
        print(f'Erro no dry run: {e}')
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    test_import()