#!/usr/bin/env python
import os
import django

# Configurar Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.db import connection

def get_table_columns(table_name):
    """Obtém informações das colunas de uma tabela específica"""
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT 
                column_name,
                data_type,
                character_maximum_length,
                is_nullable,
                column_default,
                ordinal_position
            FROM information_schema.columns 
            WHERE table_name = %s 
            ORDER BY ordinal_position;
        """, [table_name])
        
        columns = cursor.fetchall()
        
        print(f"\n📋 COLUNAS DA TABELA: {table_name.upper()}")
        print("=" * 80)
        print(f"{'#':<3} {'COLUNA':<30} {'TIPO':<20} {'TAMANHO':<10} {'NULO':<8} {'PADRÃO':<15}")
        print("-" * 80)
        
        for i, col in enumerate(columns, 1):
            column_name = col[0]
            data_type = col[1]
            max_length = col[2] if col[2] else '-'
            nullable = 'SIM' if col[3] == 'YES' else 'NÃO'
            default = col[4] if col[4] else '-'
            
            print(f"{i:<3} {column_name:<30} {data_type:<20} {max_length:<10} {nullable:<8} {default:<15}")
        
        print(f"\n📊 Total de colunas: {len(columns)}")
        return columns

if __name__ == "__main__":
    # Consultar tabela cadastros_cadastro
    get_table_columns('cadastros_cadastro')