#!/usr/bin/env python
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
from apps.cadastros.models import Cadastro
from django.contrib.auth import get_user_model

User = get_user_model()

def test_form_with_instance():
    """Testa se o formulário preserva valores da instância"""
    print("TESTE: Testando preservacao de valores no formulario...")

    # Criar um mock cadastro com valor 200
    from unittest.mock import Mock
    mock_cadastro = Mock()
    mock_cadastro.pk = 1
    mock_cadastro.mensalidade_associativa = Decimal("200.00")
    mock_cadastro.prazo_antecipacao_meses = 3

    # Criar form com instância
    form = CadastroForm(instance=mock_cadastro)

    # Verificar se o campo tem as opções corretas
    mensalidade_field = form.fields['mensalidade_associativa']
    choices = mensalidade_field.choices

    print(f"OK Campo criado com {len(choices)} opcoes")

    # Verificar se o valor 200 está nas opções
    values = [choice[0] for choice in choices]
    if '200' in values:
        print("OK Valor 200 encontrado nas opcoes")
    else:
        print("ERRO Valor 200 NAO encontrado nas opcoes")
        print(f"   Opcoes disponiveis: {values}")

    # Verificar initial
    initial = mensalidade_field.initial
    print(f"OK Initial definido como: '{initial}'")

    if initial == '200':
        print("OK Initial corretamente definido como '200'")
    else:
        print(f"ERRO Initial deveria ser '200', mas e '{initial}'")

def test_form_with_custom_value():
    """Testa comportamento com valor personalizado"""
    print("\n🧪 Testando valor personalizado (175)...")

    from unittest.mock import Mock
    mock_cadastro = Mock()
    mock_cadastro.pk = 1
    mock_cadastro.mensalidade_associativa = Decimal("175.00")
    mock_cadastro.prazo_antecipacao_meses = 3

    form = CadastroForm(instance=mock_cadastro)
    mensalidade_field = form.fields['mensalidade_associativa']
    choices = mensalidade_field.choices

    values = [choice[0] for choice in choices]
    if '175' in values:
        print("✅ Valor personalizado 175 adicionado às opções")
    else:
        print("❌ Valor personalizado 175 NÃO foi adicionado")
        print(f"   Opções: {values}")

    initial = mensalidade_field.initial
    if initial == '175':
        print("✅ Initial corretamente definido para valor personalizado")
    else:
        print(f"❌ Initial deveria ser '175', mas é '{initial}'")

def test_form_validation():
    """Testa validação do formulário"""
    print("\n🧪 Testando validação do campo...")

    form = CadastroForm()

    # Teste com valor válido
    form.data = {'mensalidade_associativa': '200'}
    mensalidade_field = form.fields['mensalidade_associativa']

    try:
        cleaned_value = form.clean_mensalidade_associativa()
        if cleaned_value == Decimal('200'):
            print("✅ Validação com '200' funcionou corretamente")
        else:
            print(f"❌ Validação retornou {cleaned_value} em vez de Decimal('200')")
    except Exception as e:
        print(f"❌ Erro na validação: {e}")

if __name__ == "__main__":
    print("=" * 60)
    print("TESTE: Campo Contribuição Associativa")
    print("=" * 60)

    test_form_with_instance()
    test_form_with_custom_value()
    test_form_validation()

    print("\n" + "=" * 60)
    print("✅ Testes concluídos!")
    print("=" * 60)