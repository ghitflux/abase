{{-- resources/views/agente/contratos.blade.php --}}
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Agente | Meus Contratos</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="{{ asset('css/agente.css') }}?v={{ filemtime(public_path('css/agente.css')) }}">

  <style>
    :root{
      --bg:#f5f8ff; --panel:#ffffff; --field:#f8fafc; --ink:#0f172a; --muted:#64748b; --border:#e5e7eb;
      --brand:#2563eb; --brand-600:#1d4ed8; --brand-50:#eff6ff; --ok:#059669; --warn:#f59e0b; --bad:#ef4444;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0;background:var(--bg);color:var(--ink);font:14px/1.55 'Poppins',system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,sans-serif}
    a{color:var(--brand);text-decoration:none}

    .wrap{max-width:1280px;margin:24px auto;padding:0 16px}
    .header{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:18px;padding-bottom:12px;border-bottom:1px solid var(--border)}
    .title{font-size:22px;font-weight:800;color:var(--brand)}

    .btn-group{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
    .user-chip{display:inline-flex;align-items:center;gap:8px;background:var(--panel);border:1px solid var(--border);padding:8px 12px;border-radius:999px;font-size:13px;color:var(--muted)}
    .user-chip i{color:var(--brand)}
    .btn{border:1px solid var(--border);background:var(--panel);color:var(--ink);padding:10px 14px;border-radius:10px;cursor:pointer;font-weight:600;display:inline-flex;align-items:center;gap:8px;transition:.15s;box-shadow:0 1px 0 rgba(15,23,42,.03)}
    .btn:hover{border-color:var(--brand);box-shadow:0 0 0 3px var(--brand-50)}
    .btn[disabled]{opacity:.55;cursor:not-allowed}
    .btn-mini{padding:8px 10px;font-size:12px;border-radius:8px}
    .btn-compact{padding:6px 8px;font-size:12px;border-radius:8px}
    .btn-primary{background:linear-gradient(#2563eb,#1d4ed8);color:#fff;border-color:#1d4ed8;box-shadow:0 6px 14px rgba(37,99,235,.18)}

    .card{border:1px solid var(--border);border-radius:14px;background:var(--panel);padding:16px;margin-bottom:14px;box-shadow:0 1px 2px rgba(15,23,42,.03)}
    .card h3{margin:0 0 10px;font-size:14px;color:var(--muted);text-transform:uppercase;letter-spacing:.4px}

    .kpis{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px}
    .kpi{background:var(--field);border:1px dashed var(--border);border-radius:12px;padding:12px}
    .kpi .v{font-size:22px;font-weight:800}
    .kpi .l{font-size:12px;color:var(--muted)}
    @media (max-width:780px){.kpis{grid-template-columns:1fr}}

    /* Tabela */
    .table-container{overflow:auto;border:1px solid var(--border);border-radius:12px}
    table.table{width:100%;border-collapse:separate;border-spacing:0;min-width:1200px;background:#fff}
    thead th{font-size:12px;color:var(--muted);text-transform:uppercase;letter-spacing:.4px;padding:10px 12px;border-bottom:1px solid var(--border);white-space:nowrap}
    tbody td{padding:10px 12px;border-bottom:1px solid var(--border);vertical-align:top;background:#fff}

    .col-assoc{min-width:200px;max-width:260px}
    .col-cpf{min-width:140px;white-space:nowrap}
    .col-org{min-width:220px}
    .col-status{min-width:120px;white-space:nowrap}
    .col-money{min-width:140px;text-align:right;white-space:nowrap}
    .col-pag{min-width:120px;white-space:nowrap}
    .col-assopay{min-width:160px;white-space:nowrap}
    .col-actions{min-width:170px;width:170px}

    .badge{display:inline-flex;align-items:center;gap:6px;padding:4px 8px;border-radius:999px;font-weight:700;font-size:12px;border:1px solid}
    .b-ok{color:var(--ok);border-color:rgba(5,150,105,.35);background:#ecfdf5}
    .b-warn{color:var(--warn);border-color:rgba(245,158,11,.35);background:#fffbeb}
    .b-bad{color:var(--bad);border-color:rgba(239,68,68,.35);background:#fef2f2}
    .b-info{color:#1d4ed8;border-color:rgba(37,99,235,.35);background:#eff6ff}

    .payrow{background:#fafbff}
    .paybox{padding:10px 12px;border:1px dashed var(--border);border-radius:10px;background:#fafbff}
    .paylist{list-style:none;margin:0;padding:0;display:grid;grid-template-columns:1fr;gap:8px}
    .payitem{display:flex;justify-content:space-between;gap:12px;background:var(--field);border:1px solid var(--border);border-radius:10px;padding:8px 10px}

    .muted{color:var(--muted);font-size:12px}
    .filterbar{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-bottom:8px}
    .input{background:var(--field);border:1px solid var(--border);padding:10px 12px;border-radius:10px;font:inherit;min-height:40px}
    .pager{display:flex;align-items:center;justify-content:flex-end;gap:10px;margin-top:10px}
    .info-badge{font-size:12px;color:var(--muted)}
    .actions-stack{display:flex;flex-direction:column;gap:8px}
    .num{ text-align:right; font-variant-numeric:tabular-nums; }
    .mono{ font-family:ui-monospace,Menlo,Consolas,monospace }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div class="title">Meus Contratos — AGENTE</div>
      <div class="btn-group">
        <div class="user-chip">
          <i class="fas fa-user"></i>
          <span>Agente: <strong>{{ auth()->user()->name ?? 'Usuário' }}</strong></span>
        </div>
        <a href="{{ route('agente.dashboardagente') }}" class="btn btn-mini">
          <i class="fas fa-user-plus"></i> Novo cadastro
        </a>
        <a href="{{ route('agente.pendencias') }}" class="btn btn-mini">
          <i class="fas fa-file-circle-question"></i> Pendências de documentação
        </a>
        <a href="{{ route('agente.contratos') }}" class="btn btn-mini btn-primary">
          <i class="fas fa-file-signature"></i> Meus contratos
        </a>
        <form method="POST" action="{{ route('logout') }}" novalidate>
          @csrf
          <button class="btn btn-mini" type="submit" formnovalidate>
            <i class="fas fa-sign-out-alt"></i> Sair
          </button>
        </form>
      </div>
    </div>

    @isset($erroQuery)
      <div class="card" style="border-color:#fecaca;background:#fef2f2;color:#991b1b">
        <strong>Falha ao carregar dados:</strong> {{ $erroQuery }}
      </div>
    @endisset

    @php
      $moneyBR = fn($v) => 'R$ '.number_format((float)$v, 2, ',', '.');
      $cpfMask = function($s){
        $d = preg_replace('/\D/','',$s??'');
        if(strlen($d)===11) return preg_replace('/(\d{3})(\d{3})(\d{3})(\d{2})/','${1}.${2}.${3}-${4}',$d);
        if(strlen($d)===14) return preg_replace('/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/','${1}.${2}.${3}/${4}-${5}',$d);
        return $s;
      };
      $statusBadge = function($status){
        $map=['Concluído'=>'b-ok','Pendente'=>'b-warn','Congelado'=>'b-bad'];
        $cls=$map[$status ?? ''] ?? 'b-info';
        return '<span class="badge '.$cls.'">'.($status ?: '—').'</span>';
      };
      $payStatus = function($code){
        $m=['0'=>['Pendente','b-warn'],'1'=>['Efetivado','b-ok'],'2'=>['Em análise','b-info'],
            '3'=>['Recusado','b-bad'],'4'=>['Efetivado','b-ok'],'9'=>['Cancelado','b-bad']];
        [$txt,$cls]=$m[(string)$code] ?? ['—','b-info'];
        return '<span class="badge '.$cls.'">'.$txt.'</span>';
      };
      // Status da tesouraria para MOSTRAR APENAS NA COLUNA "Liberação do Auxílio"
      $tesShort = function($tStatus, $tPaidAt = null){
        $s = is_string($tStatus) ? strtolower(trim($tStatus)) : null;
        $paid = $tPaidAt ? \Carbon\Carbon::parse($tPaidAt)->format('d/m/Y') : null;
        if ($s === 'pago')      return '<span class="badge b-ok">Pago</span>'.($paid ? ' <span class="muted">em '.$paid.'</span>' : '');
        if ($s === 'cancelado') return '<span class="badge b-bad">Cancelado</span>';
        if ($s === 'pendente')  return '<span class="badge b-warn">Pendente</span>';
        return '<span class="badge b-info">—</span>';
      };

      $tot=$contratos->count();
      $concl=$contratos->where('status_contrato','Concluído')->count();
      $pend=$contratos->where('status_contrato','Pendente')->count();
    @endphp

    <div class="card">
      <h3>Resumo</h3>
      <div class="kpis">
        <div class="kpi"><div class="v">{{ $tot }}</div><div class="l">Contratos cadastrados</div></div>
        <div class="kpi"><div class="v">{{ $concl }}</div><div class="l">Concluídos (3 ref. efetivadas)</div></div>
        <div class="kpi"><div class="v">{{ $pend }}</div><div class="l">Pendentes</div></div>
      </div>
    </div>

    <div class="card">
      <h3>Lista de contratos</h3>

      <div class="filterbar">
        <input id="searchName" class="input" type="text" placeholder="Pesquisar por nome..." autocomplete="off" style="min-width:260px">
        <label class="info-badge" for="pageSize">Por página</label>
        <select id="pageSize" class="input" style="width:110px">
          <option value="10" selected>10</option>
          <option value="20">20</option>
          <option value="30">30</option>
        </select>
        <span class="muted" id="resultInfo" style="margin-left:auto">Mostrando 0–0 de 0</span>
      </div>

      <div class="table-container">
        <table class="table" id="tbl">
          <colgroup>
            <col class="col-assoc">
            <col class="col-cpf">
            <col class="col-org">
            <col class="col-status">
            <col class="col-money">   {{-- Mensalidade --}}
            <col class="col-money">   {{-- Auxílio do agente (10%) --}}
            <col class="col-pag">
            <col class="col-assopay"> {{-- Pagamento do associado (tesouraria) --}}
            <col class="col-actions">
          </colgroup>
          <thead>
            <tr>
              <th>Associado</th>
              <th>CPF/CNPJ</th>
              <th>Órgão / Matrícula</th>
              <th>Status do Contrato</th>
              <th>Mensalidade</th>
              <th>Auxílio do agente (10%)</th>
              <th>Mensalidades</th>
              <th>Liberação do Auxiílio</th>
              <th>Ações</th>
            </tr>
          </thead>
          <tbody>
          @forelse ($contratos as $c)
            @php
              $pag = $paymentsByContrato[$c->id] ?? collect();
              $auxPerc  = is_null($c->auxilio_taxa) ? 10.00 : (float)$c->auxilio_taxa;
              $margem   = isset($c->margem_disponivel) ? (float)$c->margem_disponivel : null;
              $auxValor = is_null($margem) ? null : round($margem * ($auxPerc/100), 2);
              $isConcluido = ($c->status_contrato === 'Concluído');

              // dados de tesouraria vindos do controller
              $tStatus = $c->tes_status ?? null;
              $tPaidAt = $c->tes_paid_at ?? null;
            @endphp

            <tr class="row-contrato"
                data-name="{{ strtolower($c->full_name ?? '') }}"
                data-search="{{ strtolower(($c->full_name ?? '').' '.($c->cpf_cnpj ?? '').' '.($c->orgao_publico ?? '').' '.($c->matricula_servidor_publico ?? '')) }}">
              <td class="col-assoc">
                <strong>{{ $c->full_name ?? '—' }}</strong><br>
                <span class="muted">ID #{{ $c->id }}</span>
              </td>
              <td class="col-cpf mono">{{ $cpfMask($c->cpf_cnpj) }}</td>
              <td class="col-org">
                <div>{{ $c->orgao_publico ?? '—' }}</div>
                <div class="muted">Matrícula: {{ $c->matricula_servidor_publico ?? '—' }}</div>
              </td>
              <td class="col-status">{!! $statusBadge($c->status_contrato ?? 'Pendente') !!}</td>

              {{-- Mensalidade --}}
              <td class="col-money num">{{ $c->mensalidade !== null ? $moneyBR($c->mensalidade) : '—' }}</td>

              {{-- Auxílio do agente (apenas valores; sem status/comprovante) --}}
              <td class="col-money num">
                @if(!is_null($auxValor))
                  {{ $moneyBR($auxValor) }}
                  <div class="muted">{{ number_format($auxPerc,0) }}% de margem</div>
                @else
                  —
                @endif
              </td>

              {{-- Resumo de mensalidades do ABASE --}}
              <td class="col-pag">
                <strong>{{ (int)$c->pagamentos_efetivados }}/{{ (int)$c->pagamentos_total }}</strong><br>
                <span class="muted">Efetivados</span>
              </td>

              {{-- Pagamento do associado (tesouraria) --}}
              <td class="col-assopay">{!! $tesShort($tStatus, $tPaidAt) !!}</td>

              <td class="col-actions">
                <div class="actions-stack">
                  <form method="POST" action="{{ route('agente.contratos.renovar', $c->id) }}"
                        onsubmit="return confirm('Criar um novo contrato com os mesmos dados deste?')">
                    @csrf
                    <button class="btn btn-compact" type="submit" {{ $isConcluido ? '' : 'disabled' }}>
                      <i class="fas fa-rotate-right"></i> Renovar contrato
                    </button>
                  </form>
                </div>
              </td>
            </tr>

            {{-- (opcional) lista de mensalidades detalhada --}}
            <tr id="pay-{{ $c->id }}" class="payrow" style="display:none">
              <td colspan="9">
                <div class="paybox">
                  <div class="muted" style="margin-bottom:6px">
                    Status “Efetivado” considera códigos 1 e 4 do ABASE.
                  </div>
                  @if($pag->count())
                    <ul class="paylist">
                      @foreach($pag as $p)
                        <li class="payitem">
                          <div>
                            <div><strong>{{ \Carbon\Carbon::parse($p->referencia_month)->isoFormat('MMM/YYYY') }}</strong></div>
                            <div class="muted">Matrícula: {{ $p->matricula ?? '—' }} • Órgão: {{ $p->orgao ?? '—' }}</div>
                          </div>
                          <div>{!! $payStatus($p->status_code ?? null) !!}</div>
                          <div>{{ isset($p->valor) ? $moneyBR($p->valor) : '—' }}</div>
                        </li>
                      @endforeach
                    </ul>
                  @else
                    <div class="muted">Sem lançamentos de mensalidade para este contrato até o momento.</div>
                  @endif
                </div>
              </td>
            </tr>
          @empty
            <tr><td colspan="9" class="muted">Nenhum contrato encontrado para o seu usuário.</td></tr>
          @endforelse

          <tr id="noResultsRow" style="display:none">
            <td colspan="9" class="muted">Nenhum contrato encontrado com esse nome.</td>
          </tr>
          </tbody>
        </table>
      </div>

      <div class="pager">
        <button class="btn btn-mini" id="prevPage" type="button"><i class="fas fa-chevron-left"></i> Anterior</button>
        <span id="pageInfo" class="muted">Página 1 de 1</span>
        <button class="btn btn-mini" id="nextPage" type="button">Próxima <i class="fas fa-chevron-right"></i></button>
      </div>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <script>
    (function(){
      const nameInput  = document.getElementById('searchName');
      const pageSizeEl = document.getElementById('pageSize');
      const infoTop    = document.getElementById('resultInfo');
      const pageInfo   = document.getElementById('pageInfo');
      const prevBtn    = document.getElementById('prevPage');
      const nextBtn    = document.getElementById('nextPage');
      const rows       = Array.from(document.querySelectorAll('#tbl tbody tr.row-contrato'));
      const noResults  = document.getElementById('noResultsRow');

      let pageSize = parseInt(pageSizeEl?.value || '10', 10);
      let currentPage = 1;

      function hideAll(){
        rows.forEach(tr => {
          tr.style.display = 'none';
          const nx = tr.nextElementSibling;
          if (nx && nx.classList.contains('payrow')) nx.style.display = 'none';
        });
      }

      function filteredRows(){
        const needle = (nameInput?.value || '').trim().toLowerCase();
        if (!needle) return rows;
        return rows.filter(tr => (tr.getAttribute('data-name') || '').toLowerCase().includes(needle));
      }

      function updateInfoCounters(startIdx, endIdx, total){
        if (infoTop) infoTop.textContent = `Mostrando ${total ? (startIdx+1) : 0}–${endIdx} de ${total}`;
        const totalPages = Math.max(1, Math.ceil(total / pageSize));
        if (pageInfo) pageInfo.textContent = `Página ${Math.min(currentPage, totalPages)} de ${totalPages}`;
        prevBtn.disabled = (currentPage <= 1);
        nextBtn.disabled = (currentPage >= totalPages);
      }

      function render(){
        hideAll();
        const list = filteredRows();
        const total = list.length;
        noResults.style.display = total === 0 ? '' : 'none';

        const totalPages = Math.max(1, Math.ceil(total / pageSize));
        if (currentPage > totalPages) currentPage = totalPages;

        const start = (currentPage - 1) * pageSize;
        const end   = Math.min(start + pageSize, total);

        for (let i = start; i < end; i++){
          list[i].style.display = '';
        }

        updateInfoCounters(start, end, total);
      }

      nameInput?.addEventListener('input', () => { currentPage = 1; render(); }, {passive:true});
      pageSizeEl?.addEventListener('change', () => {
        pageSize = parseInt(pageSizeEl.value || '10', 10);
        currentPage = 1;
        render();
      }, {passive:true});
      prevBtn?.addEventListener('click', () => { if (currentPage > 1) { currentPage--; render(); } });
      nextBtn?.addEventListener('click', () => {
        const total = filteredRows().length;
        const totalPages = Math.max(1, Math.ceil(total / pageSize));
        if (currentPage < totalPages) { currentPage++; render(); }
      });

      render();
    })();
  </script>
</body>
</html>
