<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Tesoureiro | Dashboard</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root{
      --bg:#0f172a; --panel:#111827; --ink:#e5e7eb; --muted:#94a3b8; --border:rgba(148,163,184,.25);
      --brand:#22d3ee; --ok:#10b981; --warn:#f59e0b; --bad:#ef4444; --hover:rgba(34,211,238,.08);
    }
    *{box-sizing:border-box;margin:0;padding:0}
    html,body{background:var(--bg);color:var(--ink);font-family:'Poppins',system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,sans-serif;font-size:14px;line-height:1.5}
    a{color:var(--brand);text-decoration:none}
    .wrap{max-width:1400px;margin:24px auto;padding:0 20px}

    .header{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:24px;padding-bottom:16px;border-bottom:1px solid var(--border)}
    .title{font-size:22px;font-weight:700;color:var(--brand);display:flex;align-items:center;gap:10px}
    .title i{font-size:24px}

    .btn-group{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
    .btn{border:1px solid var(--border);background:rgba(11,18,32,.6);color:var(--ink);padding:10px 16px;border-radius:8px;cursor:pointer;font-weight:500;display:inline-flex;align-items:center;gap:6px;transition:all .2s}
    .btn:hover{border-color:var(--brand);background:var(--hover)}
    .btn-mini{padding:6px 10px;font-size:12px;border-radius:6px}

    .user-chip{display:inline-flex;align-items:center;gap:8px;background:rgba(11,18,32,.6);border:1px solid var(--border);padding:8px 12px;border-radius:999px;font-size:13px;color:var(--ink)}
    .user-chip i{color:var(--brand)}

    .panel{background:var(--panel);border:1px solid var(--border);border-radius:12px;padding:20px;margin-bottom:24px;box-shadow:0 4px 12px rgba(0,0,0,.15)}
    .panel-title{font-size:18px;font-weight:600;margin-bottom:16px;display:flex;align-items:center;gap:8px}
    .panel-title i{color:var(--brand)}
    .filters{display:flex;flex-wrap:wrap;gap:10px;align-items:center;margin:0 0 12px}
    .table-container{overflow:auto;border-radius:10px;border:1px solid var(--border);position:relative}
    table{width:100%;border-collapse:separate;border-spacing:0;min-width:1200px;background:rgba(11,18,32,.5)}
    thead th{position:sticky;top:0;background:#0e1628;border-bottom:1px solid var(--border);text-align:left;font-size:13px;color:var(--muted);padding:14px 16px;font-weight:600;text-transform:uppercase;letter-spacing:.5px}
    tbody td{padding:16px;border-bottom:1px solid var(--border);vertical-align:middle}
    tbody tr{transition:background .2s}
    tbody tr:hover{background:var(--hover)}
    .empty{color:var(--muted);padding:24px;text-align:center}
    .empty i{font-size:32px;margin-bottom:10px;opacity:.5}

    .status{display:inline-flex;align-items:center;gap:6px;font-size:13px;font-weight:500}
    .status-dot{width:8px;height:8px;border-radius:50%;display:inline-block}
    .status-ok{color:var(--ok)} .status-ok .status-dot{background:var(--ok)}
    .status-warn{color:var(--warn)} .status-warn .status-dot{background:var(--warn)}
    .status-bad{color:var(--bad)} .status-bad .status-dot{background:var(--bad)}

    .payment-info{font-size:13px;line-height:1.4}
    .comprovante-actions{display:flex;flex-direction:column;gap:10px}
    .file-input-wrapper{position:relative;display:flex;flex-direction:column;align-items:stretch;gap:8px}
    .input{background:rgba(11,18,32,.6);border:1px solid var(--border);border-radius:8px;color:var(--ink);padding:10px 12px;font-size:13px;width:100%}
    .input:focus{outline:none;border-color:var(--brand)}

    .btn-success{background:rgba(16,185,129,.15);color:#10b981;border-color:rgba(16,185,129,.35)}
    .btn-success:hover{background:rgba(16,185,129,.25);border-color:#10b981}
    .btn-disabled{opacity:.5;cursor:not-allowed}
    .btn-disabled:hover{border-color:var(--border);background:rgba(11,18,32,.6)}
    .btn-info{background:rgba(34,211,238,.12);color:#22d3ee;border-color:rgba(34,211,238,.35)}
    .btn-info:hover{background:rgba(34,211,238,.2);border-color:#22d3ee}
    .btn-muted{background:rgba(148,163,184,.15);color:#94a3b8;border-color:rgba(148,163,184,.35)}
    .btn-muted:hover{background:rgba(148,163,184,.15);border-color:rgba(148,163,184,.35)}

    .alert{padding:14px 16px;border-radius:8px;margin-bottom:20px;display:flex;align-items:flex-start;gap:12px}
    .alert-success{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);color:#10b981}
    .alert-error{background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.3);color:#ef4444}
    .alert-icon{font-size:18px}
    .user-info{display:flex;flex-direction:column}
    .user-name{font-weight:500}
    .user-email{font-size:13px;color:var(--muted)}

    .pagi{display:flex;justify-content:space-between;align-items:center;margin-top:12px;color:var(--muted);font-size:12px;gap:12px;flex-wrap:wrap}
    .pagi-ctr{display:flex;gap:6px;align-items:center;flex-wrap:wrap}
    .pagi a,.pagi span.page{border:1px solid var(--border);background:rgba(11,18,32,.6);color:var(--ink);padding:6px 10px;border-radius:8px;text-decoration:none;font-size:12px}
    .pagi a:hover{border-color:var(--brand);background:var(--hover)}
    .pagi span.current{background:rgba(34,211,238,.12);border-color:var(--brand);color:var(--brand)}
    .pagi a.disabled{opacity:.5;pointer-events:none}

    .num{ text-align:right; font-variant-numeric:tabular-nums; }
    @media (max-width:768px){
      .wrap{padding:0 16px}
      .header{flex-direction:column;align-items:flex-start}
      .btn-group{width:100%;justify-content:space-between}
    }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div class="title">
        <i class="fas fa-coins"></i>
        <span>Dashboard — TESOUREIRO</span>
      </div>

      <div class="btn-group">
        <div class="user-chip" title="Usuário logado">
          <i class="fas fa-user-shield"></i>
          <span>Tesoureiro: <strong>{{ auth()->user()->name ?? 'Usuário' }}</strong></span>
        </div>

        <a class="btn" href="{{ url('/') }}"><i class="fas fa-arrow-left"></i>Voltar à Home</a>
        <form method="POST" action="{{ route('logout') }}">
          @csrf
          <button class="btn" type="submit"><i class="fas fa-sign-out-alt"></i>Sair</button>
        </form>
      </div>
    </div>

    @if (session('ok'))
      <div class="alert alert-success" role="status" aria-live="polite">
        <i class="fas fa-check-circle alert-icon"></i>
        <div><strong>Sucesso:</strong> {{ session('ok') }}</div>
      </div>
    @endif

    @if ($errors->any())
      <div class="alert alert-error" role="alert">
        <i class="fas fa-exclamation-circle alert-icon"></i>
        <div>
          <strong>Erros:</strong>
          <ul style="margin:8px 0 0;padding-left:18px">
            @foreach ($errors->all() as $e) <li>{{ $e }}</li> @endforeach
          </ul>
        </div>
      </div>
    @endif

    @php
      if (!function_exists('maskDoc')) {
        function maskDoc($doc) {
          $d = preg_replace('/\D+/', '', (string)$doc);
          if (strlen($d) === 11) return substr($d,0,3).'.'.substr($d,3,3).'.'.substr($d,6,3).'-'.substr($d,9,2);
          if (strlen($d) === 14) return substr($d,0,2).'.'.substr($d,2,3).'.'.substr($d,5,3).'/'.substr($d,8,4).'-'.substr($d,12,2);
          return $doc;
        }
      }

      // >>> FILTRO DE PAGAMENTO <<<
      $payFilter = request('pay_status', 'all'); // all | pendente | pago | cancelado

      if (!function_exists('payStatusOf')) {
        function payStatusOf($cad) {
          try {
            $pay = $cad->pagamentoTesouraria ?? null;
          } catch (\Throwable $e) {
            $pay = null;
          }
          $s = optional($pay)->status;
          if ($s === 'pago' || $s === 'cancelado') return $s;
          return 'pendente'; // inclui null/ausente
        }
      }

      $concluidos = $concluidos ?? collect();

      // Aplica filtro quando a fonte é Collection (caso atual do controller)
      if ($concluidos instanceof \Illuminate\Support\Collection && $payFilter !== 'all') {
        $concluidos = $concluidos->filter(fn($c) => payStatusOf($c) === $payFilter)->values();
      }

      $PER_PAGE = 5;

      $isPaginator = ($concluidos instanceof \Illuminate\Pagination\LengthAwarePaginator)
                  || ($concluidos instanceof \Illuminate\Pagination\Paginator);

      if ($isPaginator) {
        $rows        = $concluidos;
        $currentPage = method_exists($concluidos,'currentPage') ? (int)$concluidos->currentPage() : (int)request()->query('page',1);
        $lastPage    = method_exists($concluidos,'lastPage') ? (int)$concluidos->lastPage() : $currentPage;
        $total       = method_exists($concluidos,'total') ? (int)$concluidos->total() : ($concluidos->count() ?: 0);
        $from        = $concluidos->firstItem() ?? (($currentPage-1)*$PER_PAGE+1);
        $to          = $concluidos->lastItem()  ?? min($currentPage*$PER_PAGE, $total);
        $pageUrl     = fn($p) => $concluidos->url($p);
        $prevUrl     = $concluidos->previousPageUrl();
        $nextUrl     = $concluidos->nextPageUrl();
      } else {
        $total       = (int)$concluidos->count();
        $lastPage    = (int)max(1, ceil($total / $PER_PAGE));
        $currentPage = (int)max(1, min((int)request()->query('page',1), $lastPage));
        $rows        = $concluidos->slice(($currentPage-1)*$PER_PAGE, $PER_PAGE);
        $from        = $total ? (($currentPage-1)*$PER_PAGE + 1) : 0;
        $to          = min($currentPage*$PER_PAGE, $total);
        $pageUrl     = function($p){ return request()->fullUrlWithQuery(['page'=>$p]); };
        $prevUrl     = $currentPage>1 ? $pageUrl($currentPage-1) : null;
        $nextUrl     = $currentPage<$lastPage ? $pageUrl($currentPage+1) : null;
      }
    @endphp

    <div class="panel">
      <div class="panel-title"><i class="fas fa-file-contract"></i>Contratos</div>

      <!-- Filtro por status de pagamento -->
      <form method="GET" action="{{ url()->current() }}" class="filters" aria-label="Filtro de pagamento">
        <input type="hidden" name="mes" value="{{ request('mes', now()->format('Y-m')) }}">
        <input type="hidden" name="page" value="1">
        <label for="pay_status" style="color:var(--muted);font-size:13px;">Filtrar pagamento:</label>
        <select id="pay_status" name="pay_status" class="input" style="max-width:240px" onchange="this.form.submit()">
          <option value="all" {{ $payFilter==='all' ? 'selected' : '' }}>Todos</option>
          <option value="pendente" {{ $payFilter==='pendente' ? 'selected' : '' }}>Pendente</option>
          <option value="pago" {{ $payFilter==='pago' ? 'selected' : '' }}>Pagamento recebido</option>
          <option value="cancelado" {{ $payFilter==='cancelado' ? 'selected' : '' }}>Cancelado</option>
        </select>
        @if($payFilter!=='all')
          <a class="btn btn-mini" href="{{ request()->fullUrlWithQuery(['pay_status'=>'all','page'=>1]) }}">
            <i class="fas fa-times"></i> Limpar filtro
          </a>
        @endif
      </form>

      <div class="table-container">
        <table>
          <thead>
            <tr>
              <th>Nome</th>
              <th>CPF/CNPJ</th>
              <th>Chave Pix</th>
              <th>Cód. Contrato</th>
              <th>Status</th>
              <th>Agente responsável</th>
              <th style="text-align:right">Margem disponível (R$)</th>
              <th style="text-align:right">Auxílio do agente (10%)</th>
              <th>Pagamento</th>
              <th>Comprovante</th>
              <th>Ação</th>
            </tr>
          </thead>
          <tbody>
            @forelse($rows as $c)
              @php
                $hasPayModel = class_exists(\App\Models\TesourariaPagamento::class);
                $pay        = $hasPayModel ? $c->pagamentoTesouraria : null;
                $statusPay  = optional($pay)->status;
                $pago       = $statusPay === 'pago';
                $cancelado  = $statusPay === 'cancelado';

                $margem     = $c->contrato_margem_disponivel;
                $auxPerc    = $c->auxilio_taxa ?? 10.00;
                $auxValor   = is_null($margem) ? null : round((float)$margem * ($auxPerc/100), 2);

                $valor      = $pay?->valor_pago ?? $margem;
                $paidAt     = optional($pay?->paid_at)->format('d/m/Y H:i');

                // Link seguro do comprovante (sempre que existir)
                $temComprovante = !empty($pay?->comprovante_path);
                $compUrl        = ($temComprovante && !empty($pay?->id))
                                  ? route('tesouraria.comprovantes.ver', $pay->id)
                                  : null;
              @endphp
              <tr>
                <td>
                  <div class="user-info">
                    <span class="user-name">{{ $c->full_name ?? '—' }}</span>
                    @if($c->pix_key) <span class="user-email">{{ $c->pix_key }}</span> @endif
                  </div>
                </td>
                <td>{{ maskDoc($c->cpf_cnpj) }}</td>
                <td>{{ $c->pix_key ?? '—' }}</td>
                <td style="font-family:ui-monospace,Menlo,Consolas,monospace">{{ $c->contrato_codigo_contrato ?? '—' }}</td>
                <td><span class="status status-ok"><span class="status-dot"></span>Concluído</span></td>

                <td>{{ $c->agente_responsavel ?? '—' }}</td>

                <td class="num">
                  @if(!is_null($margem))
                    R$ {{ number_format((float)$margem, 2, ',', '.') }}
                  @else
                    —
                  @endif
                </td>

                <td class="num">
                  @if(!is_null($auxValor))
                    R$ {{ number_format($auxValor, 2, ',', '.') }}
                    <div style="color:#94a3b8;font-size:12px">({{ number_format($auxPerc,0) }}%)</div>
                  @else
                    —
                  @endif
                </td>

                <td>
                  @if($hasPayModel && $pago)
                    <div class="payment-info">
                      <span class="status status-ok"><span class="status-dot"></span>Pagamento recebido</span>
                      <div style="margin-top:4px;font-size:12px;">
                        {{ $paidAt ? 'Em '.$paidAt : '' }}
                        @if(!is_null($valor))
                          <div>Valor base: R$ {{ number_format((float)$valor, 2, ',', '.') }}</div>
                        @endif
                      </div>
                    </div>
                  @elseif($hasPayModel && $cancelado)
                    <div class="payment-info">
                      <span class="status status-bad"><span class="status-dot"></span>Cancelado</span>
                      <div style="margin-top:4px;font-size:12px;color:#94a3b8">
                        Contrato não formalizado.
                      </div>
                    </div>
                  @else
                    <span class="status status-warn"><span class="status-dot"></span>Pendente</span>
                  @endif
                </td>

                {{-- COMPROVANTE --}}
                <td>
                  @if(!$hasPayModel)
                    —
                  @else
                    <div class="comprovante-actions">
                      @if($temComprovante && $compUrl)
                        <a class="btn btn-mini" href="{{ $compUrl }}" target="_blank" rel="noopener">
                          <i class="fas fa-eye"></i> Ver comprovante
                        </a>
                      @endif

                      {{-- Upload só enquanto estiver pendente (sem substituir/sem botão enviar) --}}
                      @if(!$pago && !$cancelado)
                        <form method="POST" action="{{ route('tesoureiro.pagamentos.upload_comprovante', $c->id) }}"
                              enctype="multipart/form-data" class="file-input-wrapper">
                          @csrf
                          <input class="input" type="file" name="comprovante"
                                 accept=".pdf,.jpg,.jpeg,.png,.webp" required
                                 id="file-{{ $c->id }}" onchange="this.form.submit()">
                        </form>
                      @endif
                    </div>
                  @endif
                </td>

                {{-- AÇÃO --}}
                <td>
                  @if(!$hasPayModel)
                    —
                  @elseif($pago)
                    —
                  @elseif($cancelado)
                    <button class="btn btn-mini btn-muted btn-disabled" type="button" disabled title="Contrato congelado">
                      <i class="fas fa-snowflake"></i> Congelar contrato
                    </button>
                  @else
                    @php $canPay = $temComprovante; @endphp

                    @if($canPay)
                      <form method="POST" action="{{ route('tesoureiro.pagamentos.efetuar', $c->id) }}">
                        @csrf
                        <input type="hidden" name="valor_pago" value="{{ $margem }}">
                        <button class="btn btn-mini btn-success"
                                type="submit"
                                onclick="return confirm('Efetivar pagamento de {{ $margem ? 'R$ '.number_format((float)$margem,2,',','.') : 'valor informado' }}?')">
                          <i class="fas fa-check-circle"></i> Efetuar
                        </button>
                      </form>
                    @else
                      <form method="POST" action="{{ route('tesoureiro.pagamentos.congelar', $c->id) }}">
                        @csrf
                        <button class="btn btn-mini btn-info" type="submit"
                                onclick="return confirm('Congelar este contrato (não formalizar agora)?')">
                          <i class="fas fa-snowflake"></i> Congelar contrato
                        </button>
                      </form>
                    @endif
                  @endif
                </td>
              </tr>
            @empty
              <tr>
                <td colspan="11" class="empty">
                  <i class="fas fa-folder-open"></i>
                  <div>Nenhum contrato concluído para a competência selecionada.</div>
                </td>
              </tr>
            @endforelse
          </tbody>
        </table>
      </div>

      @php
        $rangeStart = max(1, $currentPage - 2);
        $rangeEnd   = min($lastPage, $currentPage + 2);
      @endphp
      <div class="pagi" aria-label="Paginação de resultados">
        <div>
          @if($total > 0)
            Mostrando {{ $from }}–{{ $to }} de {{ $total }}
          @else
            Nenhum registro
          @endif
        </div>
        <div class="pagi-ctr">
          <a href="{{ $prevUrl ?? '#' }}" class="{{ $prevUrl ? '' : 'disabled' }}">« Anterior</a>

          @if($rangeStart > 1)
            <a href="{{ $pageUrl(1) }}" class="page">1</a>
            @if($rangeStart > 2)
              <span class="page" aria-hidden="true">…</span>
            @endif
          @endif

          @for($p = $rangeStart; $p <= $rangeEnd; $p++)
            @if($p === $currentPage)
              <span class="page current" aria-current="page">{{ $p }}</span>
            @else
              <a href="{{ $pageUrl($p) }}" class="page">{{ $p }}</a>
            @endif
          @endfor

          @if($rangeEnd < $lastPage)
            @if($rangeEnd < $lastPage - 1)
              <span class="page" aria-hidden="true">…</span>
            @endif
            <a href="{{ $pageUrl($lastPage) }}" class="page">{{ $lastPage }}</a>
          @endif

          <a href="{{ $nextUrl ?? '#' }}" class="{{ $nextUrl ? '' : 'disabled' }}">Próxima »</a>
        </div>
      </div>
    </div>
  </div>

  <script>
    // Envia automaticamente ao escolher o arquivo
    document.querySelectorAll('input[type="file"]').forEach(input => {
      input.addEventListener('change', function() {
        const form = this.form;
        const btn = form?.querySelector('button[type="submit"]');
        if (btn) { btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Enviando...'; btn.disabled = true; }
      });
    });
  </script>
</body>
</html>
