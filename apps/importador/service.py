import logging
from datetime import date
from django.db import transaction
from django.utils import timezone
# Remove unused import since sha256_bytes is used from parser module instead

from .models import ImportacaoContribuicao, ImportacaoOcorrencia
from .parser import parse_header_ref, find_columns_index, iter_registros, sha256_bytes
from apps.cadastros.models import Cadastro, ParcelaAntecipacao
from apps.cadastros.choices import StatusCadastro, StatusParcela

log = logging.getLogger("apps")

def _competencia_eq(dt: date, referencia_primeiro_dia: date) -> bool:
    return dt.year == referencia_primeiro_dia.year and dt.month == referencia_primeiro_dia.month

def importar_contribuicoes(file_bytes: bytes, filename: str, user):
    """
    Executa importação com transação e histórico.
    Regras:
    - Só considera cadastros com status EFFECTIVATED
    - Marca a parcela do mês 'referencia' como Registrada quando status externo == '1'
    - Para outros status, registra ocorrência sem alterar parcela
    """
    lines = file_bytes.decode("latin1", errors="ignore").splitlines()
    referencia, data_geracao = parse_header_ref(lines)
    colspec = find_columns_index(lines)

    # Evitar duplicidade por hash do arquivo
    sha = sha256_bytes(file_bytes)
    if ImportacaoContribuicao.objects.filter(arquivo_sha256=sha).exists():
        raise ValueError("Este arquivo já foi importado (hash duplicado).")

    imp = ImportacaoContribuicao.objects.create(
        referencia=referencia, data_geracao=data_geracao,
        arquivo_nome=filename, arquivo_sha256=sha, criado_por=user
    )

    total_linhas = 0
    total_proc = total_ok = total_ign = total_nao = 0

    with transaction.atomic():
        for reg in iter_registros(lines, colspec):
            total_linhas += 1
            cpf = reg["cpf"].replace(".", "").replace("-", "")
            matricula = reg["matricula"].strip()
            status_ext = reg["status"]
            legenda = reg["legenda"]

            # localizar cadastro efetivado por cpf+matricula
            cad = Cadastro.objects.filter(
                cpf=cpf, matricula_servidor=matricula, status=StatusCadastro.EFFECTIVATED
            ).first()

            if not cad:
                ImportacaoOcorrencia.objects.create(
                    importacao=imp, cpf=reg["cpf"], matricula=matricula, nome=reg["nome"],
                    orgao_pagto=reg["orgao_pagto"], valor=reg["valor"],
                    status_externo=status_ext, status_legenda=legenda,
                    acao="CPF_MATRICULA_NAO_ENCONTRADO",
                    mensagem="Cadastro não encontrado ou não efetivado."
                )
                total_nao += 1
                continue

            # parcela do mês de referência
            parcela_mes = ParcelaAntecipacao.objects.filter(
                cadastro=cad
            ).filter(
                vencimento__year=referencia.year, vencimento__month=referencia.month
            ).first()

            if status_ext == "1":
                if parcela_mes:
                    if parcela_mes.status != StatusParcela.LIQUIDADA:  # Usar LIQUIDADA em vez de Registrada
                        parcela_mes.status = StatusParcela.LIQUIDADA     # Usar LIQUIDADA em vez de Registrada
                        parcela_mes.atualizado_em = timezone.now()
                        parcela_mes.status_origem_txt = legenda
                        parcela_mes.save(update_fields=["status","atualizado_em","status_origem_txt"])
                    ImportacaoOcorrencia.objects.create(
                        importacao=imp, cpf=reg["cpf"], matricula=matricula, nome=reg["nome"],
                        orgao_pagto=reg["orgao_pagto"], valor=reg["valor"],
                        status_externo=status_ext, status_legenda=legenda,
                        acao="MARCADA_LIQUIDADA",  # Ajustar a ação também
                        cadastro_id=cad.id, parcela_id=parcela_mes.id,
                        mensagem=f"Parcela {parcela_mes.numero} marcada como Liquidada pela competência {referencia:%Y-%m}."
                    )
                    total_ok += 1
                else:
                    ImportacaoOcorrencia.objects.create(
                        importacao=imp, cpf=reg["cpf"], matricula=matricula, nome=reg["nome"],
                        orgao_pagto=reg["orgao_pagto"], valor=reg["valor"],
                        status_externo=status_ext, status_legenda=legenda,
                        acao="PARCELA_DO_MES_NAO_ENCONTRADA", cadastro_id=cad.id,
                        mensagem=f"Não foi encontrada parcela com vencimento na competência {referencia:%Y-%m}."
                    )
                    total_nao += 1
            else:
                # Apenas registra a situação (não altera parcela)
                ImportacaoOcorrencia.objects.create(
                    importacao=imp, cpf=reg["cpf"], matricula=matricula, nome=reg["nome"],
                    orgao_pagto=reg["orgao_pagto"], valor=reg["valor"],
                    status_externo=status_ext, status_legenda=legenda,
                    acao="IGNORADA_STATUS", cadastro_id=cad.id if cad else None,
                    mensagem="Status externo não é '1 - Lançado e Efetivado'."
                )
                total_ign += 1

            total_proc += 1

        imp.total_linhas = total_linhas
        imp.total_processados = total_proc
        imp.total_atualizados = total_ok
        imp.total_ignorados = total_ign
        imp.total_nao_encontrados = total_nao
        imp.save()

    log.info("Importação %s finalizada: linhas=%s, processados=%s, atualizados=%s, ignorados=%s, nao_encontrados=%s",
             imp.id, total_linhas, total_proc, total_ok, total_ign, total_nao)
    return imp
