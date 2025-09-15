import re
import hashlib
from datetime import date
from decimal import Decimal

STATUS_MAP = {
    "1": "Lançado e Efetivado",
    "2": "Não Lançado por Falta de Margem Temporariamente",
    "3": "Não Lançado por Outros Motivos (ex.: Matrícula não encontrada; mudança de órgão)",
    "4": "Lançado com Valor Diferente",
    "5": "Não Lançado por Problemas Técnicos",
    "6": "Lançamento com Erros",
    "S": "Não Lançado: Compra de Dívida ou Suspensão SEAD",
}

def sha256_bytes(content: bytes) -> str:
    return hashlib.sha256(content).hexdigest()

def parse_header_ref(lines):
    """
    Ex.: 'Entidade: ... Referência: 05/2025   Data da Geração: 23/05/2025'
    Retorna: referencia=date(2025,5,1), data_geracao=date(2025,5,23)
    """
    ref_re = re.compile(r"Referência:\s*(\d{2})/(\d{4}).*Data da Geração:\s*(\d{2})/(\d{2})/(\d{4})")
    for ln in lines[:40]:
        m = ref_re.search(ln)
        if m:
            mm, yyyy = int(m.group(1)), int(m.group(2))
            dg = date(int(m.group(5)), int(m.group(4)), int(m.group(3)))
            return date(yyyy, mm, 1), dg
    raise ValueError("Cabeçalho: não encontrei Referência/Data da Geração no arquivo.")

def find_columns_index(lines):
    """
    Usa a linha do cabeçalho de colunas para derivar offsets.
    Linha tipo:
    STATUS MATRICULA NOME ... CPF
    e logo abaixo uma linha com '======' delimitando
    """
    idx = -1
    for i,ln in enumerate(lines):
        if ln.strip().startswith("STATUS MATRICULA"):
            idx = i
            break
    if idx == -1:
        raise ValueError("Não encontrei a linha de cabeçalho das colunas.")
    header = lines[idx]
    # Posições aproximadas (por nome). Fatiamento de largura fixa por 'start:end'
    # Monta mapa por ocorrências do início de cada palavra no header:
    cols = {}
    for m in re.finditer(r"(STATUS|MATRICULA|NOME|CARGO|ORGAO PAGTO|CPF|VALOR|TOTAL PAGO)", header):
        cols[m.group(1)] = m.start()

    # Helpers para normalizar índices
    def _safe_idx(v):
        return v if isinstance(v, int) and v >= 0 else None

    start_status = _safe_idx(cols.get("STATUS", 0)) or 0
    start_matric = _safe_idx(cols.get("MATRICULA", 7)) or 7
    start_nome   = _safe_idx(cols.get("NOME", 18)) or 18
    start_valor  = _safe_idx(cols.get("VALOR", header.find("VALOR")))
    start_orgao  = _safe_idx(cols.get("ORGAO PAGTO", header.find("ORGAO PAGTO")))
    start_cpf    = _safe_idx(cols.get("CPF", header.find("CPF")))
    if start_cpf is None:
        start_cpf = len(header) - 11  # fallback seguro para CPF alinhado à direita

    def seg(s, e):
        # Se não houver 'fim' válido, deixe ir até o final da linha
        if e is None or e <= s:
            return slice(s, None)
        return slice(s, e)

    # Primeiro "fim" à direita do NOME entre VALOR/ÓRGÃO/CPF
    end_nome_candidates = [
        x for x in (start_valor, start_orgao, start_cpf)
        if x is not None and x > start_nome
    ]
    end_nome = min(end_nome_candidates) if end_nome_candidates else None

    # Fim do VALOR: antes de ORGAO, senão antes de CPF
    if start_valor is not None:
        if start_orgao is not None and start_orgao > start_valor:
            end_valor = start_orgao
        else:
            end_valor = start_cpf
    else:
        # Se não achou VALOR, não fatie; deixe vazio/None na leitura
        end_valor = None

    return {
        "status":      seg(start_status, start_matric),
        "matricula":   seg(start_matric, start_nome),
        "nome":        seg(start_nome, end_nome),
        "valor":       seg(start_valor or 0, end_valor),
        "orgao_pagto": seg(start_orgao or (end_valor or 0), start_cpf),
        "cpf":         seg(start_cpf, None),
        "header_index": idx,
    }

def iter_registros(lines, colspec):
    """
    Itera linhas entre cabeçalho e 'Legenda do Status'.
    Ignora linhas em branco e linhas-sumário ('Órgão Pagamento:' / 'Total do Status').
    """
    stop_idx = None
    for i,ln in enumerate(lines):
        if ln.strip().startswith("Legenda do Status"):
            stop_idx = i
            break
    start = colspec["header_index"] + 2  # pula header e '======' logo abaixo
    for ln in lines[start: stop_idx]:
        if not ln.strip(): 
            continue
        if ln.strip().startswith(("Órgão Pagamento:", "Total do Status:", "Governo do Estado", "Empresa de Tecnologia")):
            continue
        # linha de dados começa com status (1 digito ou 'S')
        if not re.match(r"^\s*([0-9S])\s", ln):
            continue
        status = ln[colspec["status"]].strip()
        matricula = ln[colspec["matricula"]].strip()
        nome = ln[colspec["nome"]].strip()
        valor_s = (ln[colspec["valor"]].strip() or "0").replace(".", "").replace(",", ".")
        try:
            valor = Decimal(valor_s)
        except Exception:
            valor = None
        orgao_pagto = ln[colspec["orgao_pagto"]].strip()
        cpf = ln[colspec["cpf"]].strip()
        legenda = STATUS_MAP.get(status, f"Status {status} (desconhecido)")
        yield {
            "status": status, "legenda": legenda,
            "matricula": matricula, "cpf": cpf,
            "nome": nome, "orgao_pagto": orgao_pagto, "valor": valor,
        }
