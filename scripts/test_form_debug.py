#!/usr/bin/env python3
"""
Script para testar o funcionamento do formulário de cadastro
"""
import os
import django

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.test import Client, RequestFactory
from django.contrib.auth.models import User, Group
from apps.cadastros.views import agente_create
from apps.cadastros.models import Cadastro
from apps.cadastros.forms import CadastroForm

def test_form_validation():
    """Teste básico do formulário"""
    print("TESTE: Validacao basica do formulario")
    
    # Dados mínimos para teste
    form_data = {
        'tipo_pessoa': 'PF',
        'cpf': '11144477735',
        'nome_completo': 'Teste Silva',
        'data_nascimento': '1990-01-01',
        'telefone': '11999999999',
        'email': 'teste@teste.com',
        'cep': '01234567',
        'endereco': 'Rua Teste 123',
        'cidade': 'São Paulo',
        'uf': 'SP',
        'banco': 'Banco do Brasil',
        'agencia': '1234',
        'conta': '56789',
        'valor_bruto_total': '1000.00',
        'valor_liquido': '800.00',
        'orgao_publico': 'Prefeitura SP',
        'situacao_servidor': 'ATIVO',
        'matricula': '123456',
        'mensalidade_associativa': '100.00',
        'prazo_antecipacao_meses': 3,
    }
    
    form = CadastroForm(data=form_data)
    
    print(f"Form valido: {form.is_valid()}")
    if not form.is_valid():
        print(f"Erros: {form.errors}")
        print(f"Non-field errors: {form.non_field_errors()}")
    
    return form.is_valid()

def test_user_group():
    """Teste do grupo de usuário"""
    print("TESTE: Criacao de usuario e grupo")
    
    # Criar grupo AGENTE se não existe
    agente_group, created = Group.objects.get_or_create(name='AGENTE')
    print(f"Grupo AGENTE: {'criado' if created else 'ja existe'}")
    
    # Criar usuário de teste
    user, created = User.objects.get_or_create(
        username='teste_agente',
        defaults={
            'email': 'teste@teste.com',
            'first_name': 'Teste',
            'last_name': 'Agente'
        }
    )
    
    if created:
        user.set_password('123456')
        user.save()
    
    # Adicionar ao grupo
    user.groups.add(agente_group)
    
    print(f"Usuario: {user.username}")
    print(f"Grupos: {[g.name for g in user.groups.all()]}")
    
    return user

def test_view_access():
    """Teste de acesso à view"""
    print("\n🧪 TESTE: Acesso à view agente_create")
    
    # Criar cliente de teste
    client = Client()
    
    # Teste sem login
    response = client.get('/cadastros/novo/')
    print(f"✅ GET sem login - Status: {response.status_code} (esperado: 302 redirect)")
    
    # Teste com login
    user = test_user_group()
    client.force_login(user)
    
    response = client.get('/cadastros/novo/')
    print(f"✅ GET com login - Status: {response.status_code} (esperado: 200)")
    
    if response.status_code != 200:
        print(f"❌ Conteúdo: {response.content[:200]}")
    
    return response.status_code == 200

def test_post_submit():
    """Teste de submissão POST"""
    print("\n🧪 TESTE: Submissão POST do formulário")
    
    client = Client()
    user = User.objects.get(username='teste_agente')
    client.force_login(user)
    
    # Dados do formulário
    form_data = {
        'tipo_pessoa': 'PF',
        'cpf': '11144477735',
        'nome_completo': 'Teste Silva POST',
        'data_nascimento': '1990-01-01',
        'telefone': '11999999999',
        'email': 'teste@teste.com',
        'cep': '01234567',
        'endereco': 'Rua Teste 123',
        'cidade': 'São Paulo',
        'uf': 'SP',
        'banco': 'Banco do Brasil',
        'agencia': '1234',
        'conta': '56789',
        'valor_bruto_total': '1000.00',
        'valor_liquido': '800.00',
        'orgao_publico': 'Prefeitura SP',
        'situacao_servidor': 'ATIVO',
        'matricula': '123456',
        'mensalidade_associativa': '100.00',
        'prazo_antecipacao_meses': 3,
    }
    
    print("📤 Enviando POST...")
    response = client.post('/cadastros/novo/', data=form_data)
    
    print(f"✅ POST Status: {response.status_code}")
    print(f"✅ POST Redirect: {response.get('Location', 'Nenhum')}")
    
    if response.status_code in [400, 500]:
        print(f"❌ Conteúdo de erro: {response.content[:500]}")
    
    # Verificar se cadastro foi criado
    cadastros = Cadastro.objects.filter(nome_completo='Teste Silva POST')
    print(f"✅ Cadastros criados: {cadastros.count()}")
    
    if cadastros.exists():
        cadastro = cadastros.first()
        print(f"✅ Cadastro ID: {cadastro.id}")
        print(f"✅ Status: {cadastro.status}")
        print(f"✅ Agente: {cadastro.agente_responsavel}")
    
    return response.status_code in [200, 302]

if __name__ == '__main__':
    print("INICIANDO TESTES COMPLETOS DO FORMULARIO\n")
    
    try:
        # Executar testes
        test1 = test_form_validation()
        test2 = test_view_access()
        test3 = test_post_submit()
        
        print(f"\n📊 RESUMO DOS TESTES:")
        print(f"✅ Validação Form: {'PASS' if test1 else 'FAIL'}")
        print(f"✅ Acesso View: {'PASS' if test2 else 'FAIL'}")
        print(f"✅ Submissão POST: {'PASS' if test3 else 'FAIL'}")
        
        if all([test1, test2, test3]):
            print("\n🎉 TODOS OS TESTES PASSARAM - O PROBLEMA ESTÁ NO FRONTEND!")
        else:
            print("\n❌ PROBLEMAS DETECTADOS NO BACKEND!")
            
    except Exception as e:
        print(f"\n💥 ERRO DURANTE TESTE: {e}")
        import traceback
        traceback.print_exc()