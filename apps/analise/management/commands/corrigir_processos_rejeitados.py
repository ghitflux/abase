from django.core.management.base import BaseCommand
from apps.analise.models import AnaliseProcesso, StatusAnalise, HistoricoAnalise
from apps.cadastros.models import Cadastro
from apps.cadastros.choices import StatusCadastro


class Command(BaseCommand):
    help = 'Corrige processos rejeitados onde o cadastro foi atualizado pelo agente'

    def handle(self, *args, **options):
        """
        Comando para corrigir processos que ficaram inconsistentes:
        - Processo rejeitado mas cadastro foi atualizado depois da rejeição
        - Cadastro com status RESUBMITTED mas processo não foi atualizado
        """
        self.stdout.write("Iniciando correção de processos rejeitados...")
        
        # Encontrar processos rejeitados onde o cadastro foi atualizado após a rejeição
        processos_corrigidos = 0
        
        for processo in AnaliseProcesso.objects.filter(status=StatusAnalise.REJEITADO):
            cadastro = processo.cadastro
            
            # Verificar se o cadastro foi atualizado após a rejeição do processo
            if (processo.data_conclusao and 
                cadastro.updated_at > processo.data_conclusao):
                
                self.stdout.write(
                    f"Corrigindo processo #{processo.id} - Cadastro {cadastro.nome_completo}"
                )
                
                # Atualizar o status do processo
                processo.status = StatusAnalise.CORRECAO_FEITA
                processo.analista_responsavel = None
                processo.data_inicio_analise = None
                processo.save()
                
                # Registrar no histórico
                HistoricoAnalise.objects.create(
                    processo=processo,
                    usuario=None,  # Sistema
                    acao='Processo corrigido automaticamente - cadastro atualizado após rejeição',
                    status_anterior=StatusAnalise.REJEITADO,
                    status_novo=StatusAnalise.CORRECAO_FEITA
                )
                
                processos_corrigidos += 1
        
        # Verificar cadastros com status RESUBMITTED mas processo não atualizado
        for cadastro in Cadastro.objects.filter(status=StatusCadastro.RESUBMITTED):
            try:
                processo = cadastro.analise_processo
                if processo.status == StatusAnalise.REJEITADO:
                    self.stdout.write(
                        f"Corrigindo processo #{processo.id} para status RESUBMITTED - {cadastro.nome_completo}"
                    )
                    
                    # Atualizar o status do processo
                    processo.status = StatusAnalise.CORRECAO_FEITA
                    processo.analista_responsavel = None
                    processo.data_inicio_analise = None
                    processo.save()
                    
                    # Registrar no histórico
                    HistoricoAnalise.objects.create(
                        processo=processo,
                        usuario=None,  # Sistema
                        acao='Processo corrigido - cadastro marcado como RESUBMITTED',
                        status_anterior=StatusAnalise.REJEITADO,
                        status_novo=StatusAnalise.CORRECAO_FEITA
                    )
                    
                    processos_corrigidos += 1
            except AnaliseProcesso.DoesNotExist:
                continue
        
        self.stdout.write(
            self.style.SUCCESS(f'Correção concluída! {processos_corrigidos} processos corrigidos.')
        )