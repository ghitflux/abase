"""
Serviços para importação de cadastros e efetivados.
"""

import pandas as pd
import zipfile
import os
import re
from decimal import Decimal, InvalidOperation
from datetime import datetime, date
from typing import Dict, Any, Tuple, Optional
from django.db import transaction
from django.core.files.base import ContentFile
from django.utils import timezone
from django.contrib.auth.models import User

from apps.cadastros.models import Cadastro
from .models import ImportBatch, ImportRow, ImportDocument, StatusImportacao


class ImportService:
    """Serviço principal para importação de cadastros"""
    
    def __init__(self, batch: ImportBatch):
        self.batch = batch
        self.mapping = batch.mapping_json or {}
        self.errors = []
        self.success_count = 0
        self.error_count = 0
    
    def import_batch(self, dry_run: bool = True) -> Dict[str, Any]:
        """
        Executa a importação do lote.
        
        Args:
            dry_run: Se True, não persiste as alterações no banco
            
        Returns:
            Dict com estatísticas e resultados da importação
        """
        try:
            with transaction.atomic():
                # Atualiza status do lote
                self.batch.status = StatusImportacao.PROCESSING
                self.batch.started_at = timezone.now()
                self.batch.save()
                
                # Lê a planilha
                df = self._read_spreadsheet()
                self.batch.total_linhas = len(df)
                self.batch.save()
                
                # Processa cada linha
                for index, row in df.iterrows():
                    self._process_row(index + 1, row.to_dict(), dry_run)
                
                # Processa anexos se houver
                if self.batch.anexos_zip and not dry_run:
                    self._process_attachments()
                
                # Atualiza estatísticas finais
                self.batch.linhas_processadas = len(df)
                self.batch.linhas_sucesso = self.success_count
                self.batch.linhas_erro = self.error_count
                self.batch.status = StatusImportacao.COMPLETED
                self.batch.completed_at = timezone.now()
                self.batch.save()
                
                # Se for dry_run, desfaz todas as alterações
                if dry_run:
                    transaction.set_rollback(True)
                    self.batch.status = StatusImportacao.DRY_RUN
                
                return {
                    'success': True,
                    'total_linhas': self.batch.total_linhas,
                    'linhas_sucesso': self.success_count,
                    'linhas_erro': self.error_count,
                    'errors': self.errors[:50],  # Limita a 50 erros para não sobrecarregar
                    'dry_run': dry_run
                }
                
        except Exception as e:
            self.batch.status = StatusImportacao.ERROR
            self.batch.save()
            return {
                'success': False,
                'error': str(e),
                'dry_run': dry_run
            }
    
    def _read_spreadsheet(self) -> pd.DataFrame:
        """Lê a planilha CSV ou XLSX"""
        file_path = self.batch.planilha.path
        file_extension = os.path.splitext(file_path)[1].lower()
        
        if file_extension == '.csv':
            # Tenta diferentes encodings para CSV
            for encoding in ['utf-8', 'latin-1', 'cp1252']:
                try:
                    df = pd.read_csv(file_path, encoding=encoding)
                    break
                except UnicodeDecodeError:
                    continue
            else:
                raise ValueError("Não foi possível ler o arquivo CSV com nenhum encoding suportado")
        
        elif file_extension in ['.xlsx', '.xls']:
            df = pd.read_excel(file_path)
        
        else:
            raise ValueError(f"Formato de arquivo não suportado: {file_extension}")
        
        # Remove linhas completamente vazias
        df = df.dropna(how='all')
        
        # Converte colunas para string para facilitar o mapeamento
        df = df.astype(str)
        
        return df
    
    def _process_row(self, linha_numero: int, dados_brutos: Dict[str, Any], dry_run: bool):
        """Processa uma linha individual da planilha"""
        try:
            # Mapeia os dados da planilha para campos do modelo
            dados_mapeados = self._map_row_data(dados_brutos)
            
            # Busca ou cria o cadastro
            cadastro = self._upsert_cadastro(dados_mapeados)
            
            # Registra a linha como sucesso
            if not dry_run:
                ImportRow.objects.create(
                    batch=self.batch,
                    linha_numero=linha_numero,
                    dados_brutos=dados_brutos,
                    sucesso=True,
                    cadastro=cadastro
                )
            
            self.success_count += 1
            
        except Exception as e:
            # Registra a linha como erro
            error_msg = str(e)
            self.errors.append({
                'linha': linha_numero,
                'erro': error_msg,
                'dados': dados_brutos
            })
            
            if not dry_run:
                ImportRow.objects.create(
                    batch=self.batch,
                    linha_numero=linha_numero,
                    dados_brutos=dados_brutos,
                    sucesso=False,
                    mensagem_erro=error_msg
                )
            
            self.error_count += 1
    
    def _map_row_data(self, dados_brutos: Dict[str, Any]) -> Dict[str, Any]:
        """Mapeia os dados da planilha usando o mapping_json"""
        dados_mapeados = {}
        
        for campo_planilha, campo_modelo in self.mapping.items():
            if campo_planilha in dados_brutos:
                valor = dados_brutos[campo_planilha]
                
                # Limpa valores 'nan' do pandas
                if pd.isna(valor) or valor == 'nan':
                    valor = None
                elif isinstance(valor, str):
                    valor = valor.strip()
                    if valor == '':
                        valor = None
                
                # Aplica transformações específicas por campo
                valor = self._transform_field_value(campo_modelo, valor)
                
                dados_mapeados[campo_modelo] = valor
        
        return dados_mapeados
    
    def _transform_field_value(self, campo: str, valor: Any) -> Any:
        """Aplica transformações específicas para cada tipo de campo"""
        if valor is None:
            return valor
        
        # Campos de CPF/CNPJ - remove formatação
        if campo in ['cpf_cnpj']:
            return re.sub(r'[^\d]', '', str(valor))
        
        # Campos decimais
        if campo in ['valor_bruto_total', 'valor_liquido', 'margem_liquido', 
                     'prazo_antecipacao_meses', 'trinta_porcento_bruto',
                     'margem_liquido_menos_30_bruto', 'mensalidade_associativa',
                     'taxa_antecipacao_percent', 'valor_total_antecipacao',
                     'doacao_associado', 'auxilio_agente_taxa_percent',
                     'auxilio_agente_valor']:
            try:
                # Remove formatação de moeda brasileira
                valor_str = str(valor).replace('R$', '').replace('.', '').replace(',', '.')
                return Decimal(valor_str)
            except (InvalidOperation, ValueError):
                return Decimal('0.00')
        
        # Campos de data
        if campo in ['birth_date', 'data_aprovacao', 'data_primeira_mensalidade',
                     'auxilio_data_envio']:
            if isinstance(valor, str):
                # Tenta diferentes formatos de data
                for fmt in ['%d/%m/%Y', '%Y-%m-%d', '%d-%m-%Y']:
                    try:
                        return datetime.strptime(valor, fmt).date()
                    except ValueError:
                        continue
                return None
            elif isinstance(valor, (date, datetime)):
                return valor.date() if isinstance(valor, datetime) else valor
        
        # Campos booleanos
        if campo in ['agente_padrao', 'disponivel']:
            if isinstance(valor, str):
                return valor.lower() in ['true', '1', 'sim', 's', 'verdadeiro']
            return bool(valor)
        
        # Campos de texto - limita tamanho
        if isinstance(valor, str):
            # Mapeamento de tamanhos máximos por campo
            max_lengths = {
                'nome_completo': 180,
                'profession': 120,
                'address': 180,
                'complement': 60,
                'neighborhood': 80,
                'city': 80,
                'bank': 120,
                'public_agency': 120,
                'server_register': 30,
                'pix_key': 120,
                # Adicione outros campos conforme necessário
            }
            
            max_length = max_lengths.get(campo, 255)
            return valor[:max_length] if len(valor) > max_length else valor
        
        return valor
    
    def _upsert_cadastro(self, dados_mapeados: Dict[str, Any]) -> Cadastro:
        """Busca ou cria um cadastro usando CPF e matrícula como chave natural"""
        
        # Campos obrigatórios
        if not dados_mapeados.get('nome_completo'):
            raise ValueError("Nome completo é obrigatório")
        
        # Busca por CPF ou matrícula
        cpf = dados_mapeados.get('cpf')
        matricula = dados_mapeados.get('matricula_servidor')
        
        if not cpf and not matricula:
            raise ValueError("CPF ou matrícula do servidor é obrigatório")
        
        # Tenta encontrar cadastro existente
        cadastro = None
        if cpf:
            try:
                cadastro = Cadastro.objects.get(cpf=cpf)
            except Cadastro.DoesNotExist:
                pass
        
        if not cadastro and matricula:
            try:
                cadastro = Cadastro.objects.get(matricula_servidor=matricula)
            except Cadastro.DoesNotExist:
                pass
        
        # Define agente responsável (usa o usuário do lote se não especificado)
        if 'agente_responsavel' not in dados_mapeados:
            dados_mapeados['agente_responsavel'] = self.batch.usuario
        elif isinstance(dados_mapeados['agente_responsavel'], str):
            # Se for string, tenta buscar usuário por username ou email
            try:
                user = User.objects.get(username=dados_mapeados['agente_responsavel'])
                dados_mapeados['agente_responsavel'] = user
            except User.DoesNotExist:
                dados_mapeados['agente_responsavel'] = self.batch.usuario
        
        # Cria ou atualiza o cadastro
        if cadastro:
            # Atualiza campos existentes
            for campo, valor in dados_mapeados.items():
                if hasattr(cadastro, campo) and valor is not None:
                    setattr(cadastro, campo, valor)
            cadastro.save()
        else:
            # Cria novo cadastro
            cadastro = Cadastro.objects.create(**dados_mapeados)
        
        return cadastro
    
    def _process_attachments(self):
        """Processa o arquivo ZIP de anexos"""
        if not self.batch.anexos_zip:
            return
        
        try:
            with zipfile.ZipFile(self.batch.anexos_zip.path, 'r') as zip_file:
                for file_info in zip_file.filelist:
                    if file_info.is_dir():
                        continue
                    
                    # Extrai CPF da estrutura de pastas
                    path_parts = file_info.filename.split('/')
                    if len(path_parts) < 2:
                        continue
                    
                    cpf_pasta = re.sub(r'[^\d]', '', path_parts[0])  # Remove não-dígitos
                    if len(cpf_pasta) != 11:
                        continue
                    
                    # Busca o cadastro pelo CPF
                    try:
                        cadastro = Cadastro.objects.get(cpf_cnpj=cpf_pasta)
                    except Cadastro.DoesNotExist:
                        continue
                    
                    # Extrai o arquivo
                    file_content = zip_file.read(file_info.filename)
                    file_name = os.path.basename(file_info.filename)
                    
                    # Determina o tipo do documento pelo nome do arquivo
                    tipo_documento = self._determine_document_type(file_name)
                    
                    # Cria o ImportDocument
                    import_doc = ImportDocument(
                        batch=self.batch,
                        cadastro=cadastro,
                        tipo=tipo_documento,
                        nome_original=file_name,
                        cpf_pasta=cpf_pasta
                    )
                    
                    # Salva o arquivo
                    import_doc.arquivo.save(
                        file_name,
                        ContentFile(file_content),
                        save=True
                    )
                    
        except Exception as e:
            # Log do erro, mas não interrompe o processo
            self.errors.append({
                'linha': 'ANEXOS',
                'erro': f"Erro ao processar anexos: {str(e)}",
                'dados': {}
            })
    
    def _determine_document_type(self, filename: str) -> str:
        """Determina o tipo do documento baseado no nome do arquivo"""
        filename_lower = filename.lower()
        
        # Mapeamento de padrões para tipos
        patterns = {
            'rg': ['rg', 'identidade'],
            'cpf': ['cpf'],
            'comprovante_endereco': ['comprovante', 'endereco', 'residencia'],
            'comprovante_renda': ['renda', 'salario', 'holerite'],
            'foto': ['foto', 'selfie'],
            'procuracao': ['procuracao'],
            'contrato': ['contrato'],
            'outros': []  # Fallback
        }
        
        for tipo, keywords in patterns.items():
            if any(keyword in filename_lower for keyword in keywords):
                return tipo
        
        return 'outros'


def get_default_mapping() -> Dict[str, str]:
    """
    Retorna o mapeamento padrão de colunas da planilha para campos do modelo Cadastro.
    Baseado no arquivo mapping-cadastros-CADASTROS_CADASTRO.json fornecido.
    
    Returns:
        dict: Mapeamento padrão {coluna_planilha: campo_modelo}
    """
    return {
        # Mapeamento baseado no JSON fornecido
        "cpf": "cpf_cnpj",
        "cnpj": "cpf_cnpj", 
        "nome_completo": "nome_completo",
        "rg": "rg",
        "orgao_expedidor": "orgao_expedidor",
        "data_nascimento": "birth_date",
        "profissao": "profession",
        "estado_civil": "marital_status",
        "cep": "cep",
        "endereco": "address",
        "numero": "address_number",
        "complemento": "complement",
        "bairro": "neighborhood",
        "cidade": "city",
        "uf": "state",
        "banco": "bank",
        "agencia": "agency",
        "conta": "account",
        "tipo_conta": "account_type",
        "chave_pix": "pix_key",
        "tipo_chave_pix": "pix_key_type",
        "celular": "phone",
        "email": "email",
        "orgao_publico": "public_agency",
        "situacao_servidor": "server_status",
        "matricula_servidor": "server_register",
        "valor_bruto_total": "calc_valor_bruto",
        "valor_liquido": "calc_liquido_cc",
        "prazo_antecipacao_meses": "calc_prazo_antecipacao",
        "mensalidade_associativa": "calc_mensalidade_associativa",
        "mes_averbacao": "contrato_mes_averbacao",
        "doacao_associado": "contrato_doacao_associado",
        "auxilio_agente_taxa_percent": "auxilio_taxa",
        "data_envio": "auxilio_data_envio",
        "status": "auxilio_status",
        "created_at": "created_at",
        
        # Mapeamentos alternativos comuns (para flexibilidade)
        "nome": "nome_completo",
        "nascimento": "birth_date",
        "telefone": "phone",
        "matricula": "server_register",
        "estado": "state",
    }


def import_batch(batch: ImportBatch, dry_run: bool = True) -> Dict[str, Any]:
    """
    Função principal para importar um lote.
    
    Args:
        batch: Lote de importação
        dry_run: Se True, não persiste as alterações
        
    Returns:
        Dict com resultados da importação
    """
    service = ImportService(batch)
    return service.import_batch(dry_run=dry_run)