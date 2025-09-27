#!/usr/bin/env python
import os
import sys
import django

# Adiciona o diretório do projeto ao path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Configura o Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.db import connection
from apps.cadastros.models import Cadastro

def check_table_schema():
    """Verifica o schema da tabela cadastros_cadastro"""
    with connection.cursor() as cursor:
        # Verifica a estrutura da tabela
        cursor.execute("""
            SELECT column_name, data_type, is_nullable, column_default
            FROM information_schema.columns 
            WHERE table_name = 'cadastros_cadastro' 
            AND column_name IN ('cpf', 'cnpj')
            ORDER BY ordinal_position;
        """)
        
        columns = cursor.fetchall()
        
        print("=== Schema da tabela cadastros_cadastro ===")
        for column in columns:
            column_name, data_type, is_nullable, column_default = column
            print(f"Campo: {column_name}")
            print(f"  Tipo: {data_type}")
            print(f"  Permite NULL: {is_nullable}")
            print(f"  Valor padrão: {column_default}")
            print()

def check_model_fields():
    """Verifica os campos do modelo Django"""
    print("=== Campos do modelo Cadastro ===")
    for field in Cadastro._meta.fields:
        if field.name in ['cpf', 'cnpj']:
            print(f"Campo: {field.name}")
            print(f"  Tipo: {type(field).__name__}")
            print(f"  Permite NULL: {field.null}")
            print(f"  Permite blank: {field.blank}")
            print(f"  Obrigatório: {not field.null and not field.blank}")
            print()

if __name__ == "__main__":
    try:
        check_table_schema()
        check_model_fields()
    except Exception as e:
        print(f"Erro: {e}")
        import traceback
        traceback.print_exc()