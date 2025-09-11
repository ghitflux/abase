#!/usr/bin/env python
"""
Script para inicializar o sistema Abase
"""
import os
import sys

# Adiciona o diretório do projeto ao Python path
project_root = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, project_root)

# Configura as variáveis de ambiente do Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')


def check_requirements():
    """Verifica se os requisitos estão instalados"""
    print("✅ Verificando dependências...")
    try:
        import django  # noqa: F401
        import psycopg2  # noqa: F401
        from decouple import config  # noqa: F401
        print("   ✓ Todas as dependências estão instaladas")
        return True
    except ImportError as e:
        print(f"   ❌ Dependência faltando: {e}")
        return False


def check_database():
    """Verifica conexão com o banco de dados"""
    print("✅ Testando conexão com banco de dados...")
    try:
        import django  # noqa: F401
        django.setup()
        from django.db import connection
        connection.ensure_connection()
        print("   ✓ Conexão com banco de dados OK")
        return True
    except Exception as e:
        print(f"   ❌ Erro na conexão: {e}")
        return False


def run_migrations():
    """Executa migrações do Django"""
    print("✅ Executando migrações...")
    try:
        import django
        django.setup()
        from django.core.management import execute_from_command_line
        execute_from_command_line(['manage.py', 'migrate'])
        print("   ✓ Migrações executadas com sucesso")
        return True
    except Exception as e:
        print(f"   ❌ Erro nas migrações: {e}")
        return False


def create_superuser():
    """Cria um superusuário se não existir"""
    print("✅ Verificando superusuário...")
    try:
        import django
        django.setup()
        from django.contrib.auth.models import User

        if not User.objects.filter(is_superuser=True).exists():
            print("   ⚠️  Nenhum superusuário encontrado")
            print("   💡 Execute: python manage.py createsuperuser")
        else:
            print("   ✓ Superusuário já existe")
        return True
    except Exception as e:
        print(f"   ❌ Erro ao verificar superusuário: {e}")
        return False


def start_server():
    """Inicia o servidor Django"""
    print("🚀 Iniciando servidor de desenvolvimento...")
    try:
        from django.core.management import execute_from_command_line
        execute_from_command_line(['manage.py', 'runserver', '0.0.0.0:8000'])
    except KeyboardInterrupt:
        print("\n👋 Servidor interrompido pelo usuário")
    except Exception as e:
        print(f"❌ Erro ao iniciar servidor: {e}")


def main():
    """Função principal"""
    print("🎯 ABASE - Sistema de Gestão Empresarial")
    print("=" * 50)

    # Verifica dependências
    if not check_requirements():
        return

    # Testa banco de dados
    if not check_database():
        return

    # Executa migrações
    if not run_migrations():
        return

    # Verifica superusuário
    create_superuser()

    # Inicia servidor
    start_server()


if __name__ == '__main__':
    main()