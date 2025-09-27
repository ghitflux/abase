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
from apps.importar_cadastros.services import ImportService
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import TipoPessoa, EstadoCivil, TipoConta, StatusCadastro
from django.contrib.auth import get_user_model
import pandas as pd
import re

User = get_user_model()

def clean_and_transform_data(dados_mapeados):
    """Aplica todas as correções necessárias aos dados mapeados"""
    dados_corrigidos = dados_mapeados.copy()
    
    # 1. Define tipo_pessoa como PF (Pessoa Física)
    dados_corrigidos['tipo_pessoa'] = TipoPessoa.PF
    
    # 2. Para PF, cnpj deve ser string vazia (não None devido ao NOT NULL no banco)
    dados_corrigidos['cnpj'] = ''
    
    # 3. Garante que cpf não seja None
    if 'cpf' not in dados_corrigidos or dados_corrigidos['cpf'] is None:
        dados_corrigidos['cpf'] = ''
    
    # 4. Corrige CEP removendo ponto decimal
    if 'cep' in dados_corrigidos and dados_corrigidos['cep']:
        cep_limpo = str(dados_corrigidos['cep']).replace('.0', '').replace('.', '')[:8]
        dados_corrigidos['cep'] = cep_limpo
    
    # 5. Corrige estado_civil para valor válido
    if 'estado_civil' in dados_corrigidos and dados_corrigidos['estado_civil']:
        estado_original = str(dados_corrigidos['estado_civil'])
        if 'Divorciado' in estado_original:
            dados_corrigidos['estado_civil'] = EstadoCivil.DIVORCIADO
        elif 'Casado' in estado_original:
            dados_corrigidos['estado_civil'] = EstadoCivil.CASADO
        elif 'Solteiro' in estado_original:
            dados_corrigidos['estado_civil'] = EstadoCivil.SOLTEIRO
        elif 'Viúvo' in estado_original or 'Viuvo' in estado_original:
            dados_corrigidos['estado_civil'] = EstadoCivil.VIUVO
        else:
            dados_corrigidos['estado_civil'] = ''
    
    # 6. Corrige tipo_conta para valor válido
    if 'tipo_conta' in dados_corrigidos and dados_corrigidos['tipo_conta']:
        tipo_original = str(dados_corrigidos['tipo_conta']).lower()
        if 'corrente' in tipo_original:
            dados_corrigidos['tipo_conta'] = TipoConta.CC
        elif 'poupança' in tipo_original or 'poupanca' in tipo_original:
            dados_corrigidos['tipo_conta'] = TipoConta.PP
        else:
            dados_corrigidos['tipo_conta'] = ''
    
    # 7. Corrige status para valor válido
    if 'status' in dados_corrigidos and dados_corrigidos['status']:
        dados_corrigidos['status'] = StatusCadastro.DRAFT  # Usa DRAFT como padrão
    
    # 8. Corrige mes_averbacao para formato AAAA-MM
    if 'mes_averbacao' in dados_corrigidos and dados_corrigidos['mes_averbacao']:
        mes_original = str(dados_corrigidos['mes_averbacao'])
        if len(mes_original) > 7:
            # Extrai AAAA-MM de uma data completa
            if '-' in mes_original:
                partes = mes_original.split('-')
                if len(partes) >= 2:
                    dados_corrigidos['mes_averbacao'] = f"{partes[0]}-{partes[1]}"
    
    # 9. NOVA CORREÇÃO: Corrige emails com vírgulas
    if 'email' in dados_corrigidos and dados_corrigidos['email']:
        email_original = str(dados_corrigidos['email'])
        # Substitui vírgulas por pontos nos emails
        email_corrigido = email_original.replace(',', '.')
        dados_corrigidos['email'] = email_corrigido
    
    # 10. NOVA CORREÇÃO: Trunca campo 'numero' para máximo de 10 caracteres
    if 'numero' in dados_corrigidos and dados_corrigidos['numero']:
        numero_original = str(dados_corrigidos['numero'])
        if len(numero_original) > 10:
            dados_corrigidos['numero'] = numero_original[:10]
    
    # 11. Define agente_responsavel
    if 'agente_responsavel' not in dados_corrigidos or not dados_corrigidos['agente_responsavel']:
        agente = User.objects.first()
        if agente:
            dados_corrigidos['agente_responsavel'] = agente
    
    # 12. Remove campos que não devem estar no modelo
    campos_validos = [f.name for f in Cadastro._meta.fields]
    campos_para_remover = []
    for campo in dados_corrigidos.keys():
        if campo not in campos_validos:
            campos_para_remover.append(campo)
    
    for campo in campos_para_remover:
        del dados_corrigidos[campo]
    
    # 13. Garante que campos obrigatórios não sejam None
    for campo, valor in dados_corrigidos.items():
        if valor is None:
            # Para campos de texto, usa string vazia
            field = Cadastro._meta.get_field(campo)
            if hasattr(field, 'max_length'):
                dados_corrigidos[campo] = ''
    
    return dados_corrigidos

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Reprocessando lote #{batch.id} com correções finais ===")
    
    # Limpa registros anteriores de ImportRow para este lote
    ImportRow.objects.filter(batch=batch).delete()
    print("Registros anteriores de ImportRow removidos")
    
    # Remove cadastros criados anteriormente para evitar duplicatas
    # (Opcional - descomente se quiser limpar cadastros anteriores)
    # Cadastro.objects.filter(created_at__gte=batch.created_at).delete()
    
    # Cria o serviço de importação
    service = ImportService(batch)
    
    # Lê a planilha
    df = service._read_spreadsheet()
    print(f"Planilha lida com sucesso: {len(df)} linhas")
    
    success_count = 0
    error_count = 0
    errors = []
    
    for index, row in df.iterrows():
        linha_numero = index + 1
        dados_brutos = row.to_dict()
        
        try:
            # Mapeia os dados da planilha para campos do modelo
            dados_mapeados = service._map_row_data(dados_brutos)
            
            # Aplica as correções (incluindo as novas)
            dados_corrigidos = clean_and_transform_data(dados_mapeados)
            
            # Tenta criar o cadastro
            cadastro = Cadastro(**dados_corrigidos)
            cadastro.full_clean()  # Validação
            cadastro.save()
            
            # Registra a linha como sucesso
            ImportRow.objects.create(
                batch=batch,
                linha_numero=linha_numero,
                dados_brutos=dados_brutos,
                sucesso=True,
                cadastro=cadastro
            )
            
            success_count += 1
            
            if success_count % 20 == 0:
                print(f"Processadas {success_count} linhas com sucesso...")
            
        except Exception as e:
            # Registra a linha como erro
            error_msg = str(e)
            errors.append({
                'linha': linha_numero,
                'erro': error_msg,
                'dados': dados_brutos
            })
            
            ImportRow.objects.create(
                batch=batch,
                linha_numero=linha_numero,
                dados_brutos=dados_brutos,
                sucesso=False,
                mensagem_erro=error_msg
            )
            
            error_count += 1
            
            if error_count <= 10:  # Mostra apenas os primeiros 10 erros
                print(f"Erro na linha {linha_numero}: {error_msg}")
    
    # Atualiza o status do lote
    batch.status = 'COMPLETED'
    batch.save()
    
    print(f"\n=== Resultado final do processamento ===")
    print(f"Total de linhas: {len(df)}")
    print(f"Sucessos: {success_count} ({success_count/len(df)*100:.1f}%)")
    print(f"Erros: {error_count} ({error_count/len(df)*100:.1f}%)")
    
    if errors:
        print(f"\nErros restantes:")
        from collections import Counter
        error_types = Counter([error['erro'] for error in errors])
        for error_type, count in error_types.most_common(5):
            print(f"  {count}x: {error_type}")
    
    print(f"\n✅ Lote #{batch.id} reprocessado com correções finais!")
    
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()