import csv
import io
from decimal import Decimal, InvalidOperation
from django.utils import timezone
from django.db import transaction
from apps.tesouraria.models import Mensalidade, StatusMensalidade
from .models import ArquivoImportacao, StatusImportacao

class ImportadorService:
    
    @staticmethod
    def processar_arquivo(arquivo_importacao):
        arquivo_importacao.status = StatusImportacao.PROCESSANDO
        arquivo_importacao.data_processamento = timezone.now()
        arquivo_importacao.save()
        
        erros = []
        linhas_processadas = 0
        linhas_com_erro = 0
        
        try:
            arquivo_importacao.arquivo.seek(0)
            conteudo = arquivo_importacao.arquivo.read()
            
            if arquivo_importacao.tipo_arquivo == 'CSV':
                linhas = ImportadorService._processar_csv(conteudo.decode('utf-8'))
            else:  # TXT
                linhas = ImportadorService._processar_txt(conteudo.decode('utf-8'))
            
            arquivo_importacao.total_linhas = len(linhas)
            
            for i, linha in enumerate(linhas, 1):
                try:
                    with transaction.atomic():
                        ImportadorService._criar_mensalidade(
                            linha, 
                            arquivo_importacao.competencia
                        )
                        linhas_processadas += 1
                except Exception as e:
                    linhas_com_erro += 1
                    erros.append(f"Linha {i}: {str(e)}")
            
            arquivo_importacao.linhas_processadas = linhas_processadas
            arquivo_importacao.linhas_com_erro = linhas_com_erro
            arquivo_importacao.log_erros = "\n".join(erros)
            arquivo_importacao.status = StatusImportacao.CONCLUIDO
            
        except Exception as e:
            arquivo_importacao.status = StatusImportacao.ERRO
            arquivo_importacao.log_erros = f"Erro geral: {str(e)}"
        
        arquivo_importacao.save()
        return arquivo_importacao
    
    @staticmethod
    def _processar_csv(conteudo):
        reader = csv.DictReader(io.StringIO(conteudo))
        return list(reader)
    
    @staticmethod
    def _processar_txt(conteudo):
        linhas = []
        for linha in conteudo.strip().split('\n'):
            if linha.strip():
                partes = linha.split('|')  # Assumindo separador pipe
                if len(partes) >= 3:
                    linhas.append({
                        'cpf': partes[0].strip(),
                        'matricula': partes[1].strip(),
                        'valor': partes[2].strip()
                    })
        return linhas
    
    @staticmethod
    def _criar_mensalidade(dados, competencia):
        cpf = dados.get('cpf', '').strip()
        matricula = dados.get('matricula', '').strip()
        valor_str = dados.get('valor', '').strip()
        
        if not cpf or not matricula or not valor_str:
            raise ValueError("CPF, matrícula e valor são obrigatórios")
        
        # Limpar CPF (manter apenas números)
        cpf = ''.join(filter(str.isdigit, cpf))
        if len(cpf) != 11:
            raise ValueError(f"CPF inválido: {cpf}")
        
        # Formatar CPF
        cpf = f"{cpf[:3]}.{cpf[3:6]}.{cpf[6:9]}-{cpf[9:11]}"
        
        # Converter valor
        try:
            valor_str = valor_str.replace(',', '.')
            valor = Decimal(valor_str)
            if valor <= 0:
                raise ValueError("Valor deve ser positivo")
        except (InvalidOperation, ValueError):
            raise ValueError(f"Valor inválido: {valor_str}")
        
        # Criar ou atualizar mensalidade
        mensalidade, created = Mensalidade.objects.get_or_create(
            competencia=competencia,
            cpf=cpf,
            matricula=matricula,
            defaults={
                'valor': valor,
                'status': StatusMensalidade.PENDENTE
            }
        )
        
        if not created:
            # Se já existe, atualizar o valor se diferente
            if mensalidade.valor != valor:
                mensalidade.valor = valor
                mensalidade.save()
        
        return mensalidade