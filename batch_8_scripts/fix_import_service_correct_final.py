#!/usr/bin/env python
import os
import sys
import django

# Adiciona o diretório do projeto ao path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Configura o Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from apps.importar_cadastros.models import ImportBatch
from apps.importar_cadastros.services import ImportService
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import TipoPessoa
from django.contrib.auth import get_user_model

User = get_user_model()

try:
    batch = ImportBatch.objects.get(id=8)
    print(f"=== Testando processamento final corrigido do Lote #{batch.id} ===")
    
    # Cria o serviço de importação
    service = ImportService(batch)
    
    # Lê a planilha
    df = service._read_spreadsheet()
    print(f"Planilha lida com sucesso: {len(df)} linhas")
    
    if len(df) > 0:
        primeira_linha = df.iloc[0].to_dict()
        
        # Testa o mapeamento
        dados_mapeados = service._map_row_data(primeira_linha)
        print("\nDados mapeados originais:")
        for key, value in dados_mapeados.items():
            if value is not None and str(value) != 'nan':
                print(f"  {key}: '{value}'")
        
        # Corrige os dados mapeados
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
            estado_original = dados_corrigidos['estado_civil']
            if 'Divorciado' in estado_original:
                dados_corrigidos['estado_civil'] = 'DIVORCIADO'
            elif 'Casado' in estado_original:
                dados_corrigidos['estado_civil'] = 'CASADO'
            elif 'Solteiro' in estado_original:
                dados_corrigidos['estado_civil'] = 'SOLTEIRO'
            elif 'Viúvo' in estado_original or 'Viuvo' in estado_original:
                dados_corrigidos['estado_civil'] = 'VIUVO'
        
        # 6. Corrige tipo_conta para valor válido
        if 'tipo_conta' in dados_corrigidos and dados_corrigidos['tipo_conta']:
            tipo_original = dados_corrigidos['tipo_conta'].lower()
            if 'corrente' in tipo_original:
                dados_corrigidos['tipo_conta'] = 'CC'
            elif 'poupança' in tipo_original or 'poupanca' in tipo_original:
                dados_corrigidos['tipo_conta'] = 'PP'
        
        # 7. Corrige status para valor válido
        if 'status' in dados_corrigidos and dados_corrigidos['status']:
            status_original = dados_corrigidos['status']
            if 'Pendente' in status_original:
                dados_corrigidos['status'] = 'DRAFT'  # Usa DRAFT como padrão
        
        # 8. Corrige mes_averbacao para formato AAAA-MM
        if 'mes_averbacao' in dados_corrigidos and dados_corrigidos['mes_averbacao']:
            mes_original = str(dados_corrigidos['mes_averbacao'])
            if len(mes_original) > 7:
                # Extrai AAAA-MM de uma data completa
                if '-' in mes_original:
                    partes = mes_original.split('-')
                    if len(partes) >= 2:
                        dados_corrigidos['mes_averbacao'] = f"{partes[0]}-{partes[1]}"
        
        # 9. Define agente_responsavel
        if 'agente_responsavel' not in dados_corrigidos or not dados_corrigidos['agente_responsavel']:
            # Usa o primeiro usuário disponível
            try:
                agente = User.objects.first()
                if agente:
                    dados_corrigidos['agente_responsavel'] = agente
                else:
                    print("Nenhum usuário encontrado no sistema")
                    exit(1)
            except Exception as e:
                print(f"Erro ao definir agente: {e}")
        
        # 10. Remove campos que não devem estar no modelo
        campos_validos = [f.name for f in Cadastro._meta.fields]
        campos_para_remover = []
        for campo in dados_corrigidos.keys():
            if campo not in campos_validos:
                campos_para_remover.append(campo)
        
        for campo in campos_para_remover:
            del dados_corrigidos[campo]
            print(f"Removido campo inválido: {campo}")
        
        # 11. Garante que campos obrigatórios não sejam None
        for campo, valor in dados_corrigidos.items():
            if valor is None:
                # Para campos de texto, usa string vazia
                field = Cadastro._meta.get_field(campo)
                if hasattr(field, 'max_length'):
                    dados_corrigidos[campo] = ''
        
        print("\nDados corrigidos finais:")
        for key, value in dados_corrigidos.items():
            if value is not None and str(value) != 'nan':
                print(f"  {key}: '{value}' (len: {len(str(value)) if isinstance(value, str) else 'N/A'})")
        
        # Tenta criar o cadastro
        print("\nTentando criar cadastro...")
        try:
            cadastro = Cadastro(**dados_corrigidos)
            cadastro.full_clean()  # Validação sem salvar
            print("✅ Validação passou!")
            
            # Salva o cadastro
            cadastro.save()
            print(f"✅ Cadastro criado com sucesso! ID: {cadastro.id}")
            
        except Exception as e:
            print(f"❌ Erro na validação: {e}")
            import traceback
            traceback.print_exc()
        
except ImportBatch.DoesNotExist:
    print("Lote #8 não encontrado")
except Exception as e:
    print(f"Erro: {e}")
    import traceback
    traceback.print_exc()