from django.utils import timezone
from django.db.models import Q
from apps.cadastros.models import Cadastro, StatusCadastro, ParcelaAntecipacao
from .models import Mensalidade, StatusMensalidade, ReconciliacaoLog

class ReconciliacaoService:
    
    @staticmethod
    def executar_reconciliacao(user=None):
        log = ReconciliacaoLog.objects.create(executado_por=user)
        detalhes = []
        total_processados = 0
        total_conciliados = 0
        
        mensalidades_pendentes = Mensalidade.objects.filter(
            status=StatusMensalidade.PENDENTE
        )
        
        for mensalidade in mensalidades_pendentes:
            total_processados += 1
            
            cadastros_ativos = Cadastro.objects.filter(
                cpf=mensalidade.cpf,
                matricula=mensalidade.matricula,
                status=StatusCadastro.EFFECTIVATED
            )
            
            if cadastros_ativos.exists():
                cadastro = cadastros_ativos.first()
                
                parcelas_pendentes = ParcelaAntecipacao.objects.filter(
                    cadastro=cadastro,
                    status='PENDENTE'
                )
                
                if parcelas_pendentes.exists():
                    parcela = parcelas_pendentes.first()
                    
                    if abs(parcela.valor - mensalidade.valor) <= 0.01:
                        parcela.status = 'LIQUIDADA'
                        parcela.save()
                        
                        mensalidade.status = StatusMensalidade.LIQUIDADA
                        mensalidade.data_liquidacao = timezone.now()
                        mensalidade.save()
                        
                        total_conciliados += 1
                        detalhes.append(f"✓ Conciliado: {mensalidade.competencia} - {mensalidade.cpf}")
                    else:
                        detalhes.append(f"⚠ Valor divergente: {mensalidade.competencia} - {mensalidade.cpf} - Parcela: {parcela.valor} / Mensalidade: {mensalidade.valor}")
                else:
                    detalhes.append(f"⚠ Parcela não encontrada: {mensalidade.competencia} - {mensalidade.cpf}")
            else:
                detalhes.append(f"⚠ Cadastro não encontrado ou inativo: {mensalidade.cpf} - {mensalidade.matricula}")
        
        log.total_processados = total_processados
        log.total_conciliados = total_conciliados
        log.detalhes = "\n".join(detalhes)
        log.save()
        
        return {
            'total_processados': total_processados,
            'total_conciliados': total_conciliados,
            'detalhes': detalhes,
            'log_id': log.id
        }