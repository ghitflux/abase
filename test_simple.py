#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Script de teste para validar a correção do campo Contribuição Associativa
"""
import os
import sys
import django
from decimal import Decimal

# Configurar Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
django.setup()

from apps.cadastros.forms import CadastroForm
from unittest.mock import Mock

def test_form_preservation():
    """Testa se o formulário preserva valores da instância"""
    print("TESTE: Preservacao de valores no formulario")

    # Criar um mock cadastro com valor 200
    mock_cadastro = Mock()
    mock_cadastro.pk = 1
    mock_cadastro.mensalidade_associativa = Decimal("200.00")
    mock_cadastro.prazo_antecipacao_meses = 3

    # Criar form com instância
    form = CadastroForm(instance=mock_cadastro)

    # Verificar campo
    mensalidade_field = form.fields['mensalidade_associativa']
    choices = mensalidade_field.choices
    values = [choice[0] for choice in choices]

    print(f"Campo criado com {len(choices)} opcoes")
    print(f"Opcoes: {values}")

    if '200' in values:
        print("OK: Valor 200 encontrado nas opcoes")
    else:
        print("ERRO: Valor 200 NAO encontrado")

    initial = mensalidade_field.initial
    print(f"Initial: '{initial}'")

    if initial == '200':
        print("OK: Initial correto")
    else:
        print(f"ERRO: Initial incorreto")

if __name__ == "__main__":
    print("=" * 50)
    print("TESTE CAMPO CONTRIBUICAO")
    print("=" * 50)
    test_form_preservation()
    print("=" * 50)