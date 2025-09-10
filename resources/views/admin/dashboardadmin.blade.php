<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Admin | Dashboard</title>
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

    .grid{display:grid;gap:16px}
    .grid-4{grid-template-columns:repeat(4,minmax(0,1fr))}
    .grid-3{grid-template-columns:repeat(3,minmax(0,1fr))}
    @media (max-width:1100px){ .grid-4{grid-template-columns:repeat(2,minmax(0,1fr))} }
    @media (max-width:640px){ .grid-4,.grid-3{grid-template-columns:1fr} }
    .card{background:var(--panel);border:1px solid var(--border);border-radius:12px;padding:16px;box-shadow:0 4px 12px rgba(0,0,0,.15)}

    .kpi{display:flex;align-items:flex-start;justify-content:space-between}
    .kpi h4{font-size:13px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:.5px}
    .kpi .value{font-size:26px;font-weight:700;margin-top:6px}
    .kpi i{font-size:22px;color:var(--brand);opacity:.9}

    .panel{background:var(--panel);border:1px solid var(--border);border-radius:12px;padding:20px;margin-top:24px;box-shadow:0 4px 12px rgba(0,0,0,.15)}
    .panel-title{font-size:18px;font-weight:600;margin-bottom:16px;display:flex;align-items:center;gap:8px}
    .panel-title i{color:var(--brand)}
    .panel-desc{font-size:13px;color:var(--muted);margin:-8px 0 12px}
    .table-container{overflow:auto;border-radius:10px;border:1px solid var(--border);position:relative}
    table{width:100%;border-collapse:separate;border-spacing:0;min-width:1100px;background:rgba(11,18,32,.5)}
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
    .role{display:inline-flex;align-items:center;gap:6px;padding:6px 10px;border-radius:999px;background:rgba(34,211,238,.12);border:1px solid var(--border);font-size:12px}
    .role i{color:var(--brand)}

    .badge{display:inline-flex;align-items:center;gap:6px;padding:6px 10px;border-radius:999px;font-size:12px;border:1px solid var(--border);background:rgba(11,18,32,.6)}
    .badge i{color:var(--brand)}
    .logs{display:flex;flex-direction:column;gap:12px}
    .log-item{display:flex;gap:12px;align-items:flex-start;background:rgba(11,18,32,.6);border:1px solid var(--border);padding:12px;border-radius:10px}
    .log-item i{color:var(--brand)}
    .log-meta{font-size:12px;color:var(--muted)}

    .filters{display:flex;gap:10px;flex-wrap:wrap;margin:10px 0 14px}
    .input{background:rgba(11,18,32,.6);border:1px solid var(--border);border-radius:8px;color:var(--ink);padding:10px 12px;font-size:13px}
    .input:focus{outline:none;border-color:var(--brand)}

    @media (max-width:768px){
      .wrap{padding:0 16px}
      .header{flex-direction:column;align-items:flex-start}
      .btn-group{width:100%;justify-content:space-between}
    }

    /* 🔧 Hotfix: garante que todos os canvases apareçam imediatamente */
    .panel canvas,
    .chart-card canvas,
    .chartjs-render-monitor{
      opacity:1 !important;
      visibility:visible !important;
      filter:none !important;
      transform:none !important;
      transition:none !important;
    }
  </style>
</head>
<body>
@php
  // Helpers locais
  if (!function_exists('maskDoc')) {
    function maskDoc($doc) {
      $d = preg_replace('/\D+/', '', (string)$doc);
      if (strlen($d) === 11) return substr($d,0,3).'.'.substr($d,3,3).'.'.substr($d,6,3).'-'.substr($d,9,2);
      if (strlen($d) === 14) return substr($d,0,2).'.'.substr($d,2,3).'.'.substr($d,5,3).'/'.substr($d,8,4).'-'.substr($d,12,2);
      return $doc ?: '—';
    }
  }
  if (!function_exists('money')) {
    function money($v) { return ($v===null||$v==='') ? '—' : 'R$ '.number_format((float)$v, 2, ',', '.'); }
  }
  if (!function_exists('toFloat')) {
    function toFloat($v) {
      if (is_numeric($v)) return (float)$v;
      $s = preg_replace('/[^\d,.\-]+/','', (string)$v);
      $s = str_replace('.', '', $s);
      $s = str_replace(',', '.', $s);
      return (float)$s;
    }
  }

  // URLs vindas do controller (com defaults)
  $storeAgenteUrl = $storeAgenteUrl ?? '#';
  $cadListUrl     = $cadListUrl ?? '#';

  // Coleções básicas (com defaults seguros)
  $cadastros   = $cadastros   ?? collect();
  $docIssues   = $docIssues   ?? collect();
  $pagamentos  = collect($pagamentos ?? []);
  $analistas   = $analistas   ?? [];
  $logs        = $logs        ?? [];

  // Metadados/paginação
  $cadMeta = $cadMeta ?? [
    'current_page'=>1,'last_page'=>1,'from'=>0,'to'=>0,
    'total'=> ($cadastros instanceof \Illuminate\Pagination\LengthAwarePaginator ? $cadastros->total() : (is_countable($cadastros)?count($cadastros):0)),
    'page_name'=> $cadPageName ?? 'cad_page'
  ];
  $cadPageName = $cadPageName ?? ($cadMeta['page_name'] ?? 'cad_page');
  $cadPerPage  = $cadPerPage  ?? 10;
  $cadSearch   = $cadSearch   ?? '';

  $cadCol        = ($cadastros instanceof \Illuminate\Pagination\AbstractPaginator) ? $cadastros->getCollection() : collect($cadastros);
  $kpiCadastros  = $cadMeta['total'] ?? $cadCol->count();

  $docRows       = ($docIssues instanceof \Illuminate\Pagination\AbstractPaginator) ? $docIssues->getCollection() : collect($docIssues);
  $kpiPendencias = $docRows->where('status','incomplete')->count();

  // KPIs de pagamentos (mantidos)
  $kpiPagPend    = $pagamentos->where('status','pendente')->count();
  $kpiPagos      = $pagamentos->where('status','pago')->count();

  /*
    ===== VALOR TOTAL LIBERADO =====
    Somatório das margens disponíveis
  */
  $valorTotalLiberado = (float)\App\Models\AgenteCadastro::whereNotNull('contrato_margem_disponivel')
                        ->sum('contrato_margem_disponivel');
  $valorPago = $valorTotalLiberado;

  // Mantido para compatibilidade (não exibido)
  $valorPendente = $pagamentos->where('status','pendente')->sum('contrato_valor_antecipacao');

  /*
    ===== RETORNO RECEBIDO =====
    (Valor antecipação) − (Margem disponível) − (Comissão do agente) + (Mensalidades concluídas)
  */
  $retornoRecebido = \App\Models\AgenteCadastro::query()
      ->whereNotNull('contrato_valor_antecipacao')
      ->whereNotNull('contrato_margem_disponivel')
      ->get()
      ->sum(function($c){
            $valorAnt = (float)$c->contrato_valor_antecipacao;
            $margem   = (float)$c->contrato_margem_disponivel;
            $perc     = is_null($c->auxilio_taxa) ? 10.0 : (float)$c->auxilio_taxa;
            $comissao = $margem * ($perc/100);
            $base     = $valorAnt - $margem - $comissao;

            $raw = $c->anticipations_json
                  ?? $c->contrato_antecipacoes
                  ?? $c->contrato_antecipacoes_json
                  ?? null;

            if ($raw instanceof \Illuminate\Support\Collection)      $items = $raw->toArray();
            elseif (is_array($raw))                                  $items = $raw;
            elseif (is_string($raw) && trim($raw) !== '')            $items = (array) (json_decode($raw, true) ?: []);
            else                                                     $items = [];

            $sumConcluidas = 0.0;
            foreach ($items as $it) {
              $status   = strtolower((string)($it['status'] ?? $it['situacao'] ?? $it['state'] ?? ''));
              $paidFlag = $it['pago']   ?? $it['paid']   ?? null;

              $isConcluida =
                in_array($status, ['concluida','concluída','concluido','concluído','pago','paga','quitado','quitada','liquidado','liquidada'], true)
                || (is_bool($paidFlag) && $paidFlag === true)
                || (is_string($paidFlag) && in_array(strtolower($paidFlag), ['sim','true','1'], true));

              if ($isConcluida) {
                $valor = $it['valorAuxilio'] ?? $it['valor'] ?? $it['value'] ?? $it['amount'] ?? ($c->contrato_mensalidade ?? 0);
                $sumConcluidas += (float) (function_exists('toFloat') ? toFloat($valor) : $valor);
              }
            }

            return round($base + $sumConcluidas, 2);
        });

  /*
    ===== RETORNO ESTIMADO =====
    “Todas as mensalidades pendentes” das antecipações.
  */
  $retornoEstimado = \App\Models\AgenteCadastro::query()->get()->sum(function($c){
      $raw = $c->anticipations_json
            ?? $c->contrato_antecipacoes
            ?? $c->contrato_antecipacoes_json
            ?? null;

      if ($raw instanceof \Illuminate\Support\Collection)      $items = $raw->toArray();
      elseif (is_array($raw))                                  $items = $raw;
      elseif (is_string($raw) && trim($raw) !== '')            $items = (array) (json_decode($raw, true) ?: []);
      else                                                     $items = [];

      $sum = 0.0;
      foreach ($items as $it) {
        $status   = strtolower((string)($it['status'] ?? $it['situacao'] ?? $it['state'] ?? ''));
        $paidFlag = $it['pago']   ?? $it['paid']   ?? null;

        $isPendente = in_array($status, ['pendente','pending','em aberto','aberto'], true)
                      || (is_bool($paidFlag) && $paidFlag === false)
                      || (is_string($paidFlag) && in_array(strtolower($paidFlag), ['nao','não','false','0'], true));

        if ($isPendente) {
          $valor = $it['valorAuxilio'] ?? $it['valor'] ?? $it['value'] ?? $it['amount'] ?? ($c->contrato_mensalidade ?? 0);
          $sum  += (float) (function_exists('toFloat') ? toFloat($valor) : $valor);
        }
      }
      return round($sum, 2);
  });

  /*
    ===== DOAÇÕES DOS ASSOCIADOS =====
    Soma de todas as doações registradas em contrato_doacao_associado
  */
  $totalDoacoesAssociados = (float)\App\Models\AgenteCadastro::whereNotNull('contrato_doacao_associado')
                              ->sum('contrato_doacao_associado');
@endphp

<div class="wrap">
  <div class="header">
    <div class="title">
      <i class="fas fa-shield-halved"></i>
      <span>Dashboard — ADMIN</span>
    </div>
    <div class="btn-group">
      <div class="user-chip" title="Usuário logado">
        <i class="fas fa-user-shield"></i>
        <span>Admin: <strong>{{ auth()->user()->name ?? 'Usuário' }}</strong></span>
      </div>
      <a class="btn" href="{{ url('/') }}"><i class="fas fa-arrow-left"></i>Voltar à Home</a>
      <form method="POST" action="{{ route('logout') }}">
        @csrf
        <button class="btn" type="submit"><i class="fas fa-sign-out-alt"></i>Sair</button>
      </form>
    </div>
  </div>

  <div class="grid grid-4">
    <div class="card">
      <div class="kpi">
        <div>
          <h4>Cadastros (Agentes/Associados)</h4>
          <div class="value">{{ number_format($kpiCadastros,0,',','.') }}</div>
        </div>
        <i class="fas fa-id-card-clip"></i>
      </div>
    </div>

    <div class="card">
      <div class="kpi">
        <div>
          <h4>Pendências de Documentos</h4>
          <div class="value">{{ number_format($kpiPendencias,0,',','.') }}</div>
        </div>
        <i class="fas fa-folder-open"></i>
      </div>
    </div>

    <div class="card">
      <div class="kpi">
        <div>
          <h4>Pagamentos Pendentes</h4>
          <div class="value">{{ number_format($kpiPagPend,0,',','.') }}</div>
        </div>
        <i class="fas fa-hourglass-half"></i>
      </div>
    </div>

    <div class="card">
      <div class="kpi">
        <div>
          <h4>Pagamentos Confirmados</h4>
          <div class="value">{{ number_format($kpiPagos,0,',','.') }}</div>
        </div>
        <i class="fas fa-circle-check"></i>
      </div>
    </div>
  </div>

  <div class="panel" id="financeiro">
    <div class="panel-title"><i class="fas fa-sack-dollar"></i>Resumo Financeiro</div>
    <div class="grid grid-4">
      <div class="card">
        <div class="kpi">
          <div>
            <h4>Valor Total Liberado</h4>
            <div class="value">{{ money($valorPago) }}</div>
          </div>
          <i class="fas fa-money-bill-trend-up"></i>
        </div>
      </div>

      <div class="card">
        <div class="kpi">
          <div>
            <h4>Retorno Recebido</h4>
            <div class="value">{{ money($retornoRecebido) }}</div>
          </div>
          <i class="fas fa-scale-unbalanced"></i>
        </div>
      </div>

      <div class="card">
        <div class="kpi">
          <div>
            <h4>Retorno Estimado</h4>
            <div class="value">{{ money($retornoEstimado) }}</div>
          </div>
          <i class="fas fa-calendar-check"></i>
        </div>
      </div>

      <div class="card">
        <div class="kpi">
          <div>
            <h4>Doações dos Associados</h4>
            <div class="value">{{ money($totalDoacoesAssociados) }}</div>
          </div>
          <i class="fas fa-hand-holding-heart"></i>
        </div>
      </div>
    </div>
  </div>

  <!-- Parte gráfica (ATUALIZADA: períodos rápidos + calendário de datas e meses + Pizza Situação do Servidor) -->
  <div class="panel" id="graficos-dashboard">
    <div class="panel-title"><i class="fas fa-chart-area"></i>Gráficos — Visão Analítica</div>

    @php
      use Illuminate\Support\Carbon;

      // Limites de data
      $nowEnd  = Carbon::now()->endOfDay();
      $start30 = Carbon::now()->subDays(29)->startOfDay();

      // Base all-time (limite 2 anos)
      $minCreated = \App\Models\TesourariaPagamento::min('created_at');
      $minPaid    = \App\Models\TesourariaPagamento::selectRaw('MIN(COALESCE(paid_at, created_at)) as m')->value('m');
      $minBase    = $minCreated && $minPaid ? min($minCreated, $minPaid) : ($minCreated ?: $minPaid);

      $maxSpanDays = 730; // 2 anos máx
      $baseStart   = $minBase ? Carbon::parse($minBase)->startOfDay() : $start30->copy();
      if ($baseStart->diffInDays($nowEnd) > ($maxSpanDays - 1)) {
        $baseStart = $nowEnd->copy()->subDays($maxSpanDays - 1)->startOfDay();
      }

      // Labels (ISO e exibível) e índice
      $labelsIso = []; $labelsDisp = []; $idxMap = [];
      $d = $baseStart->copy(); $i = 0;
      while ($d <= $nowEnd) {
        $iso = $d->format('Y-m-d');
        $labelsIso[]  = $iso;
        $labelsDisp[] = $d->format('d/m');
        $idxMap[$iso] = $i;
        $d->addDay(); $i++;
      }

      // Séries por dia
      $solicAll = array_fill(0, count($labelsIso), 0);
      $aprovAll = array_fill(0, count($labelsIso), 0);

      $solicRaw = \App\Models\TesourariaPagamento::selectRaw('DATE(created_at) d, COUNT(*) c')
        ->whereBetween('created_at', [$baseStart, $nowEnd])
        ->groupBy('d')->pluck('c','d')->toArray();

      $aprovRaw = \App\Models\TesourariaPagamento::selectRaw('DATE(COALESCE(paid_at, created_at)) d, COUNT(*) c')
        ->where('status','pago')
        ->whereBetween(\DB::raw('COALESCE(paid_at, created_at)'), [$baseStart, $nowEnd])
        ->groupBy('d')->pluck('c','d')->toArray();

      foreach ($solicRaw as $date=>$c) if(isset($idxMap[$date])) $solicAll[$idxMap[$date]] = (int)$c;
      foreach ($aprovRaw as $date=>$c) if(isset($idxMap[$date])) $aprovAll[$idxMap[$date]] = (int)$c;

      // Blocos fixos (30 dias) — para os gráficos inferiores
      $start30 = Carbon::now()->subDays(29)->startOfDay();
      $perfilSolicitado = \App\Models\TesourariaPagamento::whereBetween('created_at', [$start30, $nowEnd])->count();
      $perfilAnalise    = \App\Models\AgenteDocIssue::where('status','incomplete')->whereBetween('updated_at', [$start30, $nowEnd])->count();
      $perfilDoc        = \App\Models\AgenteDocIssue::where('status','resolved')->whereBetween('updated_at', [$start30, $nowEnd])->count();
      $perfilAprovado   = \App\Models\TesourariaPagamento::where('status','pago')->whereBetween(\DB::raw('COALESCE(paid_at, created_at)'), [$start30, $nowEnd])->count();
      $perfilLiquidado  = \App\Models\PagamentoMensalidade::whereIn('status_code',['1','4'])->whereBetween('created_at', [$start30, $nowEnd])->count();

      $perfilLabels = ['Solicitado','Em Análise','Documentação','Aprovado','Liquidado'];
      $perfilValues = [(int)$perfilSolicitado,(int)$perfilAnalise,(int)$perfilDoc,(int)$perfilAprovado,(int)$perfilLiquidado];

      /*
        ===== Situação do Servidor (Pizza) =====
        Lê agente_cadastros.situacao_servidor e normaliza em:
        Ativo, Aposentado, Pensionista, Comissionado, Contratado, Não informado, Outros
      */
      $rawSit = \App\Models\AgenteCadastro::query()
        ->selectRaw('LOWER(TRIM(COALESCE(situacao_servidor,""))) as st, COUNT(*) as c')
        ->groupBy('st')->pluck('c','st')->toArray();

      $order = ['Ativo','Aposentado','Pensionista','Comissionado','Contratado','Não informado','Outros'];
      $counts = array_fill_keys($order, 0);

      foreach ($rawSit as $stLower => $cnt) {
        $s = (string)$stLower;

        if ($s === '' || in_array($s, ['selecione','selecionar','nao informado','não informado','n/a','-'], true)) {
          $counts['Não informado'] += (int)$cnt; continue;
        }
        if (str_starts_with($s,'ativ'))       { $counts['Ativo']        += (int)$cnt; continue; }
        if (str_starts_with($s,'aposent'))    { $counts['Aposentado']   += (int)$cnt; continue; }
        if (str_starts_with($s,'pension'))    { $counts['Pensionista']  += (int)$cnt; continue; }
        if (str_starts_with($s,'comiss'))     { $counts['Comissionado'] += (int)$cnt; continue; }
        if (str_starts_with($s,'contrat'))    { $counts['Contratado']   += (int)$cnt; continue; }
        $counts['Outros'] += (int)$cnt;
      }

      $situLabels = [];
      $situValues = [];
      foreach ($order as $k) {
        if (($counts[$k] ?? 0) > 0) { $situLabels[] = $k; $situValues[] = (int)$counts[$k]; }
      }

      /*
        ===== Tempo até aprovação (ULT. 30 DIAS) — NOVO para Períodos Rápidos (gráfico da direita) =====
        Bins: ≤1, 2–3, 4–7, 8–14, 15+ dias
      */
      $tempoBins = ['≤1 dia'=>0,'2–3 dias'=>0,'4–7 dias'=>0,'8–14 dias'=>0,'15+ dias'=>0];
      $diasList  = [];

      $aprovUlt30 = \App\Models\TesourariaPagamento::query()
        ->where('status','pago')
        ->whereBetween(\DB::raw('COALESCE(paid_at, created_at)'), [$start30, $nowEnd])
        ->get(['created_at','paid_at']);

      foreach ($aprovUlt30 as $p) {
        $created = Carbon::parse($p->created_at);
        $paid    = $p->paid_at ? Carbon::parse($p->paid_at) : Carbon::parse($p->created_at);
        $dias    = max(0, $created->diffInDays($paid));
        $diasList[] = (float)$dias;

        if    ($dias <= 1)  $tempoBins['≤1 dia']++;
        elseif($dias <= 3)  $tempoBins['2–3 dias']++;
        elseif($dias <= 7)  $tempoBins['4–7 dias']++;
        elseif($dias <= 14) $tempoBins['8–14 dias']++;
        else                $tempoBins['15+ dias']++;
      }

      $tempoLabels = array_keys($tempoBins);
      $tempoValues = array_values($tempoBins);

      $nDias = count($diasList);
      $avgT  = $nDias ? array_sum($diasList)/$nDias : 0;
      sort($diasList);
      $medT  = $nDias ? (($diasList[intdiv($nDias-1,2)] + $diasList[intval(ceil(($nDias-1)/2))]) / 2) : 0;
      $p90T  = $nDias ? $diasList[intval(floor(0.9*($nDias-1)))] : 0;
      $tempoMeta = ['avg'=>$avgT,'med'=>$medT,'p90'=>$p90T];
    @endphp

    <style>
      #graficos-dashboard .charts-grid-2x2{display:grid;gap:16px;grid-template-columns:1fr}
      @media (min-width:1024px){ #graficos-dashboard .charts-grid-2x2{grid-template-columns:1fr 1fr} }
      #graficos-dashboard .chart-card{background:var(--panel);border:1px solid var(--border);border-radius:12px;padding:16px}
      #graficos-dashboard .chart-title{font-size:16px;font-weight:600;text-align:left;color:var(--ink)}
      #graficos-dashboard .chart-wrap{position:relative;width:100%;height:320px;margin-top:8px}
      #graficos-dashboard .chart-legend{display:flex;gap:12px;flex-wrap:wrap;justify-content:center;margin-top:8px;color:var(--muted);font-size:12px}
      .chart-head{display:flex;align-items:center;justify-content:space-between;gap:8px}

      /* Controles de período */
      .filters-row{display:flex;flex-wrap:wrap;gap:12px;align-items:center;margin:0 0 12px}
      .group{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
      .label{color:var(--muted);font-size:12px;display:flex;align-items:center;gap:6px}
      .btn-period,.btn-toggle,.btn-mini{
        border:1px solid var(--border);background:rgba(11,18,32,.6);color:var(--ink);
        padding:6px 10px;border-radius:8px;font-size:12px;cursor:pointer
      }
      .btn-mini{padding:6px 8px;font-size:11px}
      .btn-period:hover,.btn-toggle:hover,.btn-mini:hover{border-color:var(--brand);background:var(--hover)}
      .btn-period.active,.btn-toggle.active{border-color:var(--brand);color:var(--brand);background:rgba(34,211,238,.12)}
      .input{background:rgba(11,18,32,.6);border:1px solid var(--border);border-radius:8px;color:var(--ink);padding:7px 10px;font-size:12px}
      .apply{padding:7px 12px}
    </style>

    <!-- CONTROLES DE PERÍODO -->
    <div class="filters-row">
      <!-- Modo -->
      <div class="group">
        <span class="label"><i class="fas fa-layer-group"></i>Modo:</span>
        <button class="btn-toggle active" id="modeDays">Dias</button>
        <button class="btn-toggle" id="modeMonths">Meses</button>
      </div>

      <!-- Presets: Dias -->
      <div class="group" id="quickDays">
        <span class="label"><i class="fas fa-bolt"></i>Rápido (dias):</span>
        <button class="btn-period" data-days="7">7</button>
        <button class="btn-period" data-days="15">15</button>
        <button class="btn-period active" data-days="30">30</button>
        <button class="btn-period" data-days="182">6 meses</button>
        <button class="btn-period" data-days="all">Todo o período</button>
      </div>

      <!-- Calendário (Dias) -->
      <div class="group" id="calendarDays">
        <span class="label"><i class="fas fa-calendar-day"></i>Calendário (datas):</span>
        <input type="date" class="input" id="dateStart">
        <input type="date" class="input" id="dateEnd">
        <button class="btn-mini apply" id="applyDates">Aplicar</button>
      </div>

      <!-- Presets: Meses -->
      <div class="group" id="quickMonths" style="display:none">
        <span class="label"><i class="fas fa-bolt"></i>Rápido (meses):</span>
        <button class="btn-period" data-months="3">3m</button>
        <button class="btn-period" data-months="6">6m</button>
        <button class="btn-period" data-months="12">12m</button>
        <button class="btn-period" data-months="all">Todo</button>
      </div>

      <!-- Calendário (Meses) -->
      <div class="group" id="calendarMonths" style="display:none">
        <span class="label"><i class="fas fa-calendar-alt"></i>Calendário (meses):</span>
        <input type="month" class="input" id="monthStart">
        <input type="month" class="input" id="monthEnd">
        <button class="btn-mini apply" id="applyMonths">Aplicar</button>
      </div>
    </div>

    <div class="grid charts-grid-2x2">
      <div class="chart-card">
        <div class="chart-head">
          <div class="chart-title" id="titleSolic">Solicitações por dia</div>
          <div class="btns">
            <button class="btn-mini" data-export="solic-img"><i class="fas fa-download"></i> Imagem</button>
            <button class="btn-mini" data-export="solic-csv"><i class="fas fa-file-csv"></i> CSV</button>
          </div>
        </div>
        <div class="chart-wrap">
          <canvas id="chartSolicitacoes"></canvas>
        </div>
        <div class="chart-legend muted" id="legendSolic"></div>
      </div>

      <div class="chart-card">
        <div class="chart-head">
          <div class="chart-title" id="titleAprov">Aprovações por dia &amp; Taxa de Aprovação</div>
          <div class="btns">
            <button class="btn-mini" data-export="aprov-img"><i class="fas fa-download"></i> Imagem</button>
            <button class="btn-mini" data-export="aprov-csv"><i class="fas fa-file-csv"></i> CSV</button>
          </div>
        </div>
        <div class="chart-wrap">
          <canvas id="chartAprovacoes"></canvas>
        </div>
        <div class="chart-legend muted" id="legendAprov"></div>
      </div>

      <div class="chart-card">
        <div class="chart-head">
          <div class="chart-title">Perfil do Pipeline <span class="muted">— últimos 30 dias</span></div>
        </div>
        <div class="chart-wrap">
          <canvas id="chartPerfil"></canvas>
        </div>
      </div>

      <div class="chart-card">
        <div class="chart-head">
          <div class="chart-title">Situação do Servidor <span class="muted">— base atual</span></div>
        </div>
        <div class="chart-wrap">
          <canvas id="chartSituacao"></canvas>
        </div>
      </div>
    </div>

    <!-- Chart.js + DataLabels (carregar UMA vez) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>
    <script>
      // ===== Dados do PHP =====
      const LABELS_ISO  = @json($labelsIso);   // ['YYYY-MM-DD', ...]
      const LABELS_DISP = @json($labelsDisp);  // ['dd/mm', ...]
      const SERIES_SOLIC = @json($solicAll);   // [int,...] por dia
      const SERIES_APROV = @json($aprovAll);   // [int,...] por dia

      const PERFIL_LABELS = @json($perfilLabels);
      const PERFIL_VALUES = @json($perfilValues);

      // Situação do Servidor (pizza)
      const SITU_LABELS = @json($situLabels);
      const SITU_VALUES = @json($situValues);

      // ===== Helpers =====
      const fmt = (n) => new Intl.NumberFormat('pt-BR').format(n);
      const pct = (n) => `${Number(n).toFixed(1).replace('.',',')}%`;
      const money = (n) => 'R$ ' + (new Intl.NumberFormat('pt-BR',{minimumFractionDigits:2, maximumFractionDigits:2}).format(n));

      function movingAvg(arr, win=7){
        const out=[], q=[]; let sum=0;
        for(let i=0;i<arr.length;i++){ q.push(arr[i]); sum+=arr[i]; if(q.length>win){sum-=q.shift()} out.push(Number((sum/q.length).toFixed(2))); }
        return out;
      }
      function byDaysSliceFromTo(startISO, endISO){
        const n = LABELS_ISO.length;
        let s = 0, e = n-1;
        if (startISO) { for(let i=0;i<n;i++){ if (LABELS_ISO[i] >= startISO){ s=i; break; } } }
        if (endISO)   { for(let i=n-1;i>=0;i--){ if (LABELS_ISO[i] <= endISO){ e=i; break; } } }
        if (e < s) return {labelsISO:[], labels:[], solic:[], aprov:[]};
        return { labelsISO: LABELS_ISO.slice(s, e+1), labels: LABELS_DISP.slice(s, e+1), solic: SERIES_SOLIC.slice(s, e+1), aprov: SERIES_APROV.slice(s, e+1) };
      }
      function byDaysQuick(days){
        if (days==='all') return byDaysSliceFromTo(null, null);
        const n=LABELS_ISO.length, start=Math.max(0, n-Number(days));
        return { labelsISO: LABELS_ISO.slice(start), labels: LABELS_DISP.slice(start), solic: SERIES_SOLIC.slice(start), aprov: SERIES_APROV.slice(start) };
      }

      // ===== Agregação Mensal =====
      function monthKey(iso){ return iso.slice(0,7); }
      function monthLabel(iso){ const [y,m]=iso.split('-'); return `${m}/${y.slice(2)}`; }

      function byMonthsFromTo(startYYYYMM, endYYYYMM){
        const agg = {};
        for (let i=0;i<LABELS_ISO.length;i++){
          const key = monthKey(LABELS_ISO[i]);
          if (startYYYYMM && key < startYYYYMM) continue;
          if (endYYYYMM   && key > endYYYYMM) continue;
          if (!agg[key]) agg[key] = {s:0, a:0};
          agg[key].s += SERIES_SOLIC[i] || 0;
          agg[key].a += SERIES_APROV[i] || 0;
        }
        const keys = Object.keys(agg).sort();
        return { labelsISO: keys, labels: keys.map(monthLabel), solic: keys.map(k=>agg[k].s), aprov: keys.map(k=>agg[k].a) };
      }
      function byMonthsQuick(months){
        if (months==='all') return byMonthsFromTo(null,null);
        if (!LABELS_ISO.length) return {labelsISO:[],labels:[],solic:[],aprov:[]};
        const last = monthKey(LABELS_ISO[LABELS_ISO.length-1]);
        const [ly,lm] = last.split('-').map(Number);
        const d = new Date(ly, lm-1, 1);
        d.setMonth(d.getMonth() - (Number(months)-1));
        const sy = d.getFullYear(), sm = String(d.getMonth()+1).padStart(2,'0');
        return byMonthsFromTo(`${sy}-${sm}`, last);
      }

      function downloadCSV(filename, rows){
        const body = rows.map(r=>r.map(v=>String(v).includes(',')?`"${String(v).replace(/"/g,'""')}"`:v).join(',')).join('\n');
        const blob = new Blob([body], {type:'text/csv;charset=utf-8;'}); const url = URL.createObjectURL(blob);
        const a=document.createElement('a'); a.href=url; a.download=filename+'.csv'; a.click(); URL.revokeObjectURL(url);
      }

      // ===== Cores e defaults =====
      const COLORS = { brand:'#22d3ee', ok:'#10b981', warn:'#f59e0b', mut:'#94a3b8' };
      const SITU_COLORS = {
        'Ativo':'#3b82f6',
        'Aposentado':'#8b5cf6',
        'Pensionista':'#f59e0b',
        'Comissionado':'#22d3ee',
        'Contratado':'#10b981',
        'Não informado':'#94a3b8',
        'Outros':'#ef4444'
      };

      Chart.register(ChartDataLabels);
      Chart.defaults.color = '#e5e7eb';
      Chart.defaults.font.family = 'Poppins, system-ui, sans-serif';
      Chart.defaults.elements.point.radius = 3;
      Chart.defaults.elements.point.hoverRadius = 4;
      Chart.defaults.elements.line.tension = .35;
      Chart.defaults.animation = false; // 🔇 sem animação (evita “só aparece no hover”)

      let chartSolic, chartAprov, chartPerfil, chartSituacao;
      let mode = 'day'; // 'day' | 'month'

      function buildTopCharts(dataset){
        // ----- Solicitações -----
        if (chartSolic) chartSolic.destroy();
        chartSolic = new Chart(document.getElementById('chartSolicitacoes').getContext('2d'), {
          type: 'bar',
          data: {
            labels: dataset.labels,
            datasets: [
              {
                type: 'bar',
                label: (mode==='day'?'Solicitações':'Solicitações (mês)'),
                data: dataset.solic,
                backgroundColor: '#22d3ee66',
                borderColor: COLORS.brand,
                borderWidth: 1,
                borderRadius: 6,
                order: 1,
                barPercentage: 0.7, categoryPercentage: 0.7,
                maxBarThickness: 34, minBarLength: 1,
                datalabels: { anchor:'end', align:'end', clip:true, formatter:(v)=> v>0?fmt(v):'', color:'#cbd5e1', offset:2, font:{weight:600,size:10} }
              },
              {
                type:'line',
                label:(mode==='day'?'Média móvel (7d)':'Média móvel (3m)'),
                data: movingAvg(dataset.solic, mode==='day'?7:3),
                borderColor: COLORS.brand, backgroundColor:'transparent', pointRadius:0, order:0,
                datalabels:{ display:false }
              }
            ]
          },
          options:{
            maintainAspectRatio:false,
            animation:false,
            plugins:{
              legend:{ labels:{ color:'#e5e7eb' } },
              tooltip:{ enabled:true },
              title:{ display:true, text:`Total no período: ${fmt(dataset.solic.reduce((a,b)=>a+b,0))}`, color:'#e5e7eb', font:{weight:'600', size:12} }
            },
            scales:{
              x:{ ticks:{ color:'#9ca3af' }, grid:{ display:false } },
              y:{ ticks:{ color:'#9ca3af' }, grid:{ color:'rgba(148,163,184,.15)' } }
            }
          }
        });
        document.getElementById('legendSolic').textContent =
          `Média ${(mode==='day'?'diária':'mensal')}: ${fmt((dataset.solic.reduce((a,b)=>a+b,0)/(dataset.solic.length||1)).toFixed(2))}`;

        // ----- Aprovações + Taxa -----
        if (chartAprov) chartAprov.destroy();
        const rate = dataset.solic.map((v,i)=> v>0 ? Number((dataset.aprov[i]*100/v).toFixed(2)) : 0);
        chartAprov = new Chart(document.getElementById('chartAprovacoes').getContext('2d'), {
          data:{
            labels: dataset.labels,
            datasets:[
              {
                type:'bar',
                label:(mode==='day'?'Aprovações':'Aprovações (mês)'),
                data:dataset.aprov,
                backgroundColor:'#10b98166',
                borderColor:COLORS.ok, borderWidth:1, borderRadius:6, yAxisID:'y', order:1,
                barPercentage:0.7, categoryPercentage:0.7, maxBarThickness:34, minBarLength:1,
                datalabels:{ anchor:'end', align:'end', clip:true, formatter:(v)=> v>0?fmt(v):'', color:'#cbd5e1', offset:2, font:{weight:600,size:10} }
              },
              {
                type:'line',
                label:(mode==='day'?'Média móvel (7d)':'Média móvel (3m)'),
                data:movingAvg(dataset.aprov, mode==='day'?7:3),
                borderColor:COLORS.ok, backgroundColor:'transparent', pointRadius:0, yAxisID:'y', order:0, datalabels:{ display:false }
              },
              {
                type:'line',
                label:'Taxa de aprovação (%)',
                data:rate,
                borderColor:COLORS.warn, backgroundColor:'transparent', borderDash:[6,4],
                yAxisID:'y1', order:2, cubicInterpolationMode:'monotone', tension:.25, spanGaps:true, clip:true,
                datalabels:{ align:'top', anchor:'end', clip:true, formatter:(v)=> v>0?pct(v):'', color:'#fbbf24', offset:4, font:{weight:700, size:10} }
              }
            ]
          },
          options:{
            maintainAspectRatio:false,
            animation:false,
            plugins:{
              legend:{ labels:{ color:'#e5e7eb' } },
              tooltip:{ enabled:true },
              title:{ display:true, text:`Total aprovado: ${fmt(dataset.aprov.reduce((a,b)=>a+b,0))} | Taxa média: ${pct((rate.reduce((a,b)=>a+b,0)/(rate.filter(v=>v>0).length||1))||0)}`, color:'#e5e7eb', font:{weight:'600', size:12} }
            },
            scales:{
              x:{ ticks:{ color:'#9ca3af' }, grid:{ display:false } },
              y:{ position:'left', ticks:{ color:'#9ca3af' }, grid:{ color:'rgba(148,163,184,.15)' } },
              y1:{ position:'right', beginAtZero:true, min:0, max:100, suggestedMax:100, bounds:'ticks', ticks:{ color:'#9ca3af', callback:(v)=>v+'%' }, grid:{ drawOnChartArea:false } }
            },
            layout:{ padding:{ top:6, right:6 } }
          }
        });

        // Títulos conforme modo
        document.getElementById('titleSolic').textContent = mode==='day' ? 'Solicitações por dia' : 'Solicitações por mês';
        document.getElementById('titleAprov').textContent = mode==='day'
          ? 'Aprovações por dia & Taxa de Aprovação'
          : 'Aprovações por mês & Taxa de Aprovação';
      }

      // ---------- Perfil ----------
      (function initPerfil(){
        const total = PERFIL_VALUES.reduce((a,b)=>a+b,0) || 1;
        const pctVals = PERFIL_VALUES.map(v => Number((v*100/total).toFixed(1)));
        chartPerfil = new Chart(document.getElementById('chartPerfil').getContext('2d'), {
          type:'bar',
          data:{ labels:PERFIL_LABELS,
            datasets:[{ data:PERFIL_VALUES, backgroundColor:['#22d3ee66','#f59e0b66','#3b82f666','#10b98166','#8b5cf666'],
              borderColor:['#22d3ee','#f59e0b','#3b82f6','#10b981','#8b5cf6'], borderWidth:1, borderRadius:6,
              datalabels:{ anchor:'end', align:'right', clip:true, formatter:(v,ctx)=>`${fmt(v)} (${pctVals[ctx.dataIndex].toString().replace('.',',')}%)`, color:'#e5e7eb', font:{weight:600, size:11} }
            }]}
          ,
          options:{ indexAxis:'y', maintainAspectRatio:false, animation:false,
            plugins:{ legend:{display:false}, tooltip:{enabled:true}, title:{ display:true, text:`Total (30d): ${fmt(total)}`, color:'#e5e7eb', font:{weight:'600', size:12} } },
            scales:{ x:{ ticks:{ color:'#9ca3af' }, grid:{ color:'rgba(148,163,184,.15)' } }, y:{ ticks:{ color:'#9ca3af' }, grid:{ display:false } } }
          }
        });
      })();

      // ---------- Situação do Servidor (Pizza) ----------
      (function initSituacao(){
        if (chartSituacao) chartSituacao.destroy();
        const total = SITU_VALUES.reduce((a,b)=>a+b,0) || 1;
        const bg = SITU_LABELS.map(l => (SITU_COLORS[l] || '#64748b') + 'cc');
        const bc = SITU_LABELS.map(l => (SITU_COLORS[l] || '#64748b'));
        chartSituacao = new Chart(document.getElementById('chartSituacao').getContext('2d'), {
          type:'pie',
          data:{ labels:SITU_LABELS,
            datasets:[{ data:SITU_VALUES, backgroundColor:bg, borderColor:bc, borderWidth:1,
              datalabels:{ formatter:(v)=> `${fmt(v)} • ${pct(v*100/total)}`, color:'#e5e7eb', font:{weight:600, size:10}, clip:true }
            }]
          },
          options:{ maintainAspectRatio:false, animation:false,
            plugins:{ legend:{ position:'bottom', labels:{ color:'#e5e7eb' } },
              tooltip:{ callbacks:{ label:(ctx)=>` ${ctx.label}: ${fmt(ctx.parsed)} (${pct((ctx.parsed*100/total)||0)})` } } }
          }
        });
      })();

      // ===== Controles: modo & presets =====
      const modeDaysBtn   = document.getElementById('modeDays');
      const modeMonthsBtn = document.getElementById('modeMonths');
      const quickDays     = document.getElementById('quickDays');
      const calendarDays  = document.getElementById('calendarDays');
      const quickMonths   = document.getElementById('quickMonths');
      const calendarMonths= document.getElementById('calendarMonths');

      function setMode(newMode){
        mode = newMode;
        if (mode==='day'){
          modeDaysBtn.classList.add('active'); modeMonthsBtn.classList.remove('active');
          quickDays.style.display='flex'; calendarDays.style.display='flex';
          quickMonths.style.display='none'; calendarMonths.style.display='none';
          buildTopCharts(byDaysQuick(30));
        } else {
          modeMonthsBtn.classList.add('active'); modeDaysBtn.classList.remove('active');
          quickDays.style.display='none'; calendarDays.style.display='none';
          quickMonths.style.display='flex'; calendarMonths.style.display='flex';
          buildTopCharts(byMonthsQuick(6));
        }
      }
      modeDaysBtn.addEventListener('click', ()=> setMode('day'));
      modeMonthsBtn.addEventListener('click', ()=> setMode('month'));

      // Presets dias
      document.querySelectorAll('#quickDays .btn-period').forEach(b=>{
        b.addEventListener('click', ()=>{
          document.querySelectorAll('#quickDays .btn-period').forEach(x=>x.classList.remove('active'));
          b.classList.add('active');
          buildTopCharts(byDaysQuick(b.dataset.days));
        });
      });

      // Aplicar calendário (datas)
      const dateStart = document.getElementById('dateStart');
      const dateEnd   = document.getElementById('dateEnd');
      document.getElementById('applyDates').addEventListener('click', ()=>{
        const s = dateStart.value || null;
        const e = dateEnd.value   || null;
        buildTopCharts(byDaysSliceFromTo(s, e));
        document.querySelectorAll('#quickDays .btn-period').forEach(x=>x.classList.remove('active'));
      });

      // Presets meses
      document.querySelectorAll('#quickMonths .btn-period').forEach(b=>{
        b.addEventListener('click', ()=>{
          document.querySelectorAll('#quickMonths .btn-period').forEach(x=>x.classList.remove('active'));
          b.classList.add('active');
          buildTopCharts(byMonthsQuick(b.dataset.months));
        });
      });

      // Aplicar calendário (meses)
      const monthStart = document.getElementById('monthStart');
      const monthEnd   = document.getElementById('monthEnd');
      document.getElementById('applyMonths').addEventListener('click', ()=>{
        const s = monthStart.value || null;
        const e = monthEnd.value   || null;
        buildTopCharts(byMonthsFromTo(s, e));
        document.querySelectorAll('#quickMonths .btn-period').forEach(x=>x.classList.remove('active'));
      });

      // ===== Exportações =====
      function exportImg(chart, name){ const a=document.createElement('a'); a.href=chart.toBase64Image('image/png',1); a.download=name+'.png'; a.click(); }
      function exportCSV(labels, arr1, arr2, name){
        const rows=[['Período','Solicitações','Aprovações','Taxa(%)']];
        for(let i=0;i<labels.length;i++){ const s=arr1[i]||0, a=arr2[i]||0, r=s>0?(a*100/s):0; rows.push([labels[i], s, a, r.toFixed(2).replace('.',',')]); }
        downloadCSV(name+'.csv', rows);
      }
      document.querySelector('[data-export="solic-img"]').addEventListener('click', ()=> exportImg(chartSolic, 'solicitacoes'));
      document.querySelector('[data-export="aprov-img"]').addEventListener('click', ()=> exportImg(chartAprov, 'aprovacoes'));
      document.querySelector('[data-export="solic-csv"]').addEventListener('click', ()=>{
        const d = currentDataset; exportCSV(d.labels, d.solic, d.aprov, mode==='day'?'solicitacoes_dia':'solicitacoes_mes');
      });
      document.querySelector('[data-export="aprov-csv"]').addEventListener('click', ()=>{
        const d = currentDataset; exportCSV(d.labels, d.solic, d.aprov, mode==='day'?'aprovacoes_dia':'aprovacoes_mes');
      });

      // Mantém referência do último dataset para exportar
      let currentDataset = {labels:[], solic:[], aprov:[]};
      const _origBuild = buildTopCharts;
      buildTopCharts = function(ds){ currentDataset = ds; _origBuild(ds); }

      // ===== Inicialização =====
      if (LABELS_ISO.length){
        document.getElementById('dateStart').value = LABELS_ISO[Math.max(0, LABELS_ISO.length-30)];
        document.getElementById('dateEnd').value   = LABELS_ISO[LABELS_ISO.length-1];
        const lastMonth  = LABELS_ISO[LABELS_ISO.length-1].slice(0,7);
        monthStart.value = lastMonth; monthEnd.value = lastMonth;
      }
      setMode('day'); // começa em DIAS com 30 dias
    </script>
  </div>

  <!-- ==== OUTROS GRÁFICOS: Períodos Rápidos (sem recarregar Chart.js) ==== -->
  <div class="panel" id="graficos-periodos">
    <div class="panel-title"><i class="fas fa-sliders"></i>Gráficos — Períodos Rápidos</div>

    <style>
      #graficos-periodos .charts-2col{display:grid;gap:16px;grid-template-columns:1fr}
      @media (min-width:1024px){ #graficos-periodos .charts-2col{grid-template-columns:1fr 1fr} }
      #graficos-periodos .chart-card{background:var(--panel);border:1px solid var(--border);border-radius:12px;padding:16px}
      #graficos-periodos .chart-title{font-size:16px;font-weight:600;text-align:left;color:var(--ink)}
      #graficos-periodos .chart-wrap{position:relative;width:100%;height:320px;margin-top:8px}
      #gp-ranges{display:flex;gap:6px;flex-wrap:wrap}
      #gp-ranges .btn{border:1px solid var(--border);background:rgba(11,18,32,.6);color:var(--ink);padding:6px 10px;border-radius:8px;font-size:12px;cursor:pointer}
      #gp-ranges .btn:hover{border-color:var(--brand);background:var(--hover)}
      #gp-ranges .btn.active{border-color:var(--brand);color:var(--brand);background:rgba(34,211,238,.12)}
    </style>

    <div class="charts-2col">
      <div class="chart-card">
        <div class="chart-head">
          <div class="chart-title">Solicitado e Aprovado (acumulado)</div>
          <div id="gp-ranges">
            <button class="btn" data-r="7d">7d</button>
            <button class="btn" data-r="15d">15d</button>
            <button class="btn active" data-r="30d">30d</button>
            <button class="btn" data-r="6m">6m</button>
            <button class="btn" data-r="1a">1a</button>
            <button class="btn" data-r="all">Tudo</button>
          </div>
        </div>
        <div class="chart-wrap"><canvas id="gpLine"></canvas></div>
      </div>

      <div class="chart-card">
        <div class="chart-title">Tempo até Aprovação (distribuição — últimos 30 dias)</div>
        <div class="chart-wrap"><canvas id="gpPerfil"></canvas></div>
      </div>
    </div>

    <script>
      (function(){
        if (!window.Chart) { console.error('Chart.js não encontrado'); return; }

        const ink   = getComputedStyle(document.documentElement).getPropertyValue('--ink')   || '#e5e7eb';
        const muted = getComputedStyle(document.documentElement).getPropertyValue('--muted') || '#94a3b8';
        const gridC = 'rgba(148,163,184,.12)';

        const common = {
          responsive:true, maintainAspectRatio:false,
          animation:false,
          plugins:{ legend:{ labels:{ color:ink.trim() } }, title:{display:false} },
          scales:{
            x:{ ticks:{ color:muted.trim() }, grid:{ color:gridC } },
            y:{ ticks:{ color:muted.trim() }, grid:{ color:gridC }, beginAtZero:true }
          }
        };

        const cum = (arr)=>{ let s=0; return arr.map(v=> (s += (v||0))); };

        function daysFor(r){
          switch(r){
            case '7d': return 7;
            case '15d': return 15;
            case '30d': return 30;
            case '6m': return 182;
            case '1a': return 365;
            case 'all': return LABELS_ISO.length;
            default: return 30;
          }
        }
        function sliceFor(r){
          const total = LABELS_ISO.length;
          const n = Math.min(daysFor(r), total);
          const start = Math.max(0, total - n);
          return {
            labels: LABELS_DISP.slice(start),
            solic:  cum(SERIES_SOLIC).slice(start),
            aprov:  cum(SERIES_APROV).slice(start),
          };
        }

        const ctxLine = document.getElementById('gpLine');
        let gpCurrent = '30d';
        let s = sliceFor(gpCurrent);

        const gpLineChart = new Chart(ctxLine, {
          type:'line',
          data:{
            labels:s.labels,
            datasets:[
              { label:'Solicitado', data:s.solic, borderColor:'#3b82f6', backgroundColor:'rgba(59,130,246,.18)', tension:.3, fill:true, pointRadius:3, pointHoverRadius:4 },
              { label:'Aprovado', data:s.aprov, borderColor:'#10b981', backgroundColor:'rgba(16,185,129,.18)', tension:.3, fill:true, pointRadius:3, pointHoverRadius:4 }
            ]
          },
          options: common
        });

        document.querySelectorAll('#gp-ranges .btn').forEach(btn=>{
          btn.addEventListener('click', ()=>{
            document.querySelectorAll('#gp-ranges .btn').forEach(b=>b.classList.remove('active'));
            btn.classList.add('active');
            gpCurrent = btn.getAttribute('data-r');
            const s2 = sliceFor(gpCurrent);
            gpLineChart.data.labels = s2.labels;
            gpLineChart.data.datasets[0].data = s2.solic;
            gpLineChart.data.datasets[1].data = s2.aprov;
            gpLineChart.update();
          });
        });

        // ===== NOVO: Histograma de Tempo até Aprovação (30 dias) =====
        const HIST_LABELS = @json($tempoLabels);
        const HIST_VALUES = @json($tempoValues);
        const HIST_META   = @json($tempoMeta);

        const histTotal = (HIST_VALUES || []).reduce((a,b)=>a+b,0) || 1;

        const gpPerfilChart = new Chart(document.getElementById('gpPerfil'), {
          type:'bar',
          data:{
            labels: HIST_LABELS,
            datasets:[{
              label:'Qtd.',
              data:HIST_VALUES,
              backgroundColor:'rgba(59,130,246,.75)',
              borderColor:'#3b82f6',
              borderWidth:1,
              borderRadius:6,
              datalabels:{
                anchor:'end', align:'end', clip:true,
                formatter:(v)=> `${v} • ${(v*100/histTotal).toFixed(1).replace('.',',')}%`,
                color: ink.trim(), font:{weight:600, size:11}, offset:4
              }
            }]
          },
          options:Object.assign({}, common, {
            plugins:{
              legend:{display:false},
              title:{
                display:true,
                text:`Média: ${HIST_META.avg?.toFixed(1) ?? '0'} d • Mediana: ${HIST_META.med?.toFixed(1) ?? '0'} d • P90: ${HIST_META.p90?.toFixed(1) ?? '0'} d`,
                color:ink.trim(), font:{weight:'600', size:12}
              },
              tooltip:{
                callbacks:{
                  label:(ctx)=>` ${ctx.label}: ${ctx.parsed.y} (${(ctx.parsed.y*100/histTotal).toFixed(1).replace('.',',')}%)`
                }
              }
            }
          })
        });
      })();
    </script>
  </div>
  <!-- ==== /OUTROS GRÁFICOS ==== -->

</div>

<!-- Parte gráfica fim -->





  <div class="panel" id="cadastro-agente">
    <div class="panel-title"><i class="fas fa-user-plus"></i>Criar Agente</div>
    <div class="panel-desc">Cria usuário na tabela <code>users</code> e atribui o papel <code>agente</code>.</div>

    @if (session('ok'))
      <div class="alert alert-success" role="status" aria-live="polite" style="margin-top:12px">
        <i class="fas fa-check-circle"></i>
        <div><strong>Sucesso:</strong> {{ session('ok') }}</div>
      </div>
    @endif
    @if ($errors->any())
      <div class="alert alert-error" role="alert" style="margin-top:12px">
        <i class="fas fa-exclamation-circle"></i>
        <div><strong>Erros:</strong><ul style="margin:8px 0 0;padding-left:18px">@foreach ($errors->all() as $e) <li>{{ $e }}</li> @endforeach</ul></div>
      </div>
    @endif

    <style>
      #cadastro-agente .form-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}
      @media (max-width:980px){#cadastro-agente .form-grid{grid-template-columns:1fr}}
      #cadastro-agente .field{display:flex;flex-direction:column;gap:6px}
      #cadastro-agente .field label{font-size:12px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:.4px}
      #cadastro-agente .hint{font-size:12px;color:var(--muted)}
      #cadastro-agente .row-actions{display:flex;gap:8px;flex-wrap:wrap}
      #cadastro-agente .pass-wrap{display:flex;gap:8px;align-items:center}
      #cadastro-agente .pass-wrap .input{flex:1}
      #cadastro-agente .meter{height:8px;border-radius:10px;background:rgba(148,163,184,.18);overflow:hidden}
      #cadastro-agente .meter > span{display:block;height:8px;width:0%;background:linear-gradient(90deg,#ef4444,#f59e0b,#10b981);transition:width .2s}
      #cadastro-agente .role-badge{display:inline-flex;align-items:center;gap:6px;padding:8px 12px;border-radius:999px;border:1px solid var(--border);background:rgba(34,211,238,.12);font-size:13px}
      #cadastro-agente .role-badge i{color:var(--brand)}
      #cadastro-agente pre{background:rgba(11,18,32,.6);border:1px solid var(--border);border-radius:10px;padding:12px;overflow:auto}

      #toast-top{position:fixed;top:16px;right:16px;z-index:9999;display:flex;flex-direction:column;gap:10px}
      .toast{min-width:280px;max-width:420px;background:var(--panel);border:1px solid var(--border);box-shadow:0 6px 18px rgba(0,0,0,.25);
             border-left:4px solid var(--brand);color:var(--ink);padding:12px 14px;border-radius:10px;display:flex;gap:10px;align-items:flex-start}
      .toast-success{border-left-color:#10b981}
      .toast-error{border-left-color:#ef4444}
      .toast .t-icon{margin-top:2px}
      .toast .t-msg{line-height:1.35}
      .toast .t-close{margin-left:auto;background:transparent;border:none;color:var(--muted);cursor:pointer}
      .toast .t-progress{height:3px;background:rgba(148,163,184,.25);border-radius:999px;overflow:hidden;margin-top:8px}
      .toast .t-progress > span{display:block;height:3px;width:0%}
      .toast-success .t-progress > span{background:#10b981}
      .toast-error .t-progress > span{background:#ef4444}
    </style>

    <form id="form-agente" method="POST" action="{{ $storeAgenteUrl }}">
      @csrf
      <input type="hidden" name="role" value="agente">

      <div class="form-grid">
        <div class="field">
          <label for="ag-name">Nome completo *</label>
          <input class="input" id="ag-name" name="name" type="text" placeholder="Ex.: João Pedro da Silva" required minlength="3" autocomplete="off" value="{{ old('name') }}">
        </div>

        <div class="field">
          <label for="ag-email">E-mail *</label>
          <input class="input" id="ag-email" name="email" type="email" placeholder="email@exemplo.com" required autocomplete="off" value="{{ old('email') }}">
          <div class="hint">Será o login do agente.</div>
        </div>

        <div class="field">
          <label for="ag-password">Senha *</label>
          <div class="pass-wrap">
            <input class="input" id="ag-password" name="password" type="password" placeholder="Mín. 8 caracteres" required minlength="8" autocomplete="new-password">
            <button type="button" class="btn btn-mini" id="btn-toggle-pwd" title="Mostrar/ocultar"><i class="fas fa-eye"></i></button>
            <button type="button" class="btn btn-mini" id="btn-gen" title="Gerar senha forte"><i class="fas fa-wand-magic-sparkles"></i> Gerar</button>
            <button type="button" class="btn btn-mini" id="btn-copy" title="Copiar senha"><i class="fas fa-copy"></i> Copiar</button>
          </div>
          <div class="meter" aria-hidden="true"><span id="pwd-meter-bar"></span></div>
          <div class="hint" id="pwd-hint">Força da senha: —</div>
        </div>

        <div class="field">
          <label for="ag-password2">Confirmar senha *</label>
          <input class="input" id="ag-password2" name="password_confirmation" type="password" placeholder="Repita a senha" required minlength="8" autocomplete="new-password">
        </div>

        <div class="field">
          <label>Papel atribuído</label>
          <span class="role-badge"><i class="fas fa-user-tag"></i> agente</span>
          <div class="hint">Fixo neste formulário.</div>
        </div>

        <div class="field">
          <label>&nbsp;</label>
          <div class="row-actions">
            <button class="btn btn-success" type="submit" id="btn-submit"><i class="fas fa-user-plus"></i> Criar agente</button>
            <button class="btn" type="reset" id="btn-reset"><i class="fas fa-eraser"></i> Limpar</button>
          </div>
        </div>
      </div>

      <details style="margin-top:12px">
        <summary style="cursor:pointer">Pré-visualizar payload (client-side)</summary>
        <pre id="payloadPreview">{}</pre>
      </details>
    </form>
  </div>

  <div id="toast-top" aria-live="polite" aria-atomic="true"></div>

  <script>
  (function(){
    const $ = sel => document.querySelector(sel);
    const nameEl = $('#ag-name');
    const emailEl = $('#ag-email');
    const pwdEl = $('#ag-password');
    const pwd2El = $('#ag-password2');
    const meterBar = $('#pwd-meter-bar');
    const pwdHint = $('#pwd-hint');
    const submitBtn = $('#btn-submit');

    function ensureToastRoot(){
      let root = document.getElementById('toast-top');
      if(!root){ root = document.createElement('div'); root.id = 'toast-top'; document.body.appendChild(root); }
      return root;
    }
    function topToast(msg, type='success', ttl=4000){
      const root = ensureToastRoot();
      const toast = document.createElement('div');
      toast.className = 'toast toast-' + (type==='error'?'error':'success');
      toast.innerHTML = `
        <i class="t-icon fas ${type==='error'?'fa-circle-xmark':'fa-circle-check'}"></i>
        <div style="flex:1">
          <div class="t-msg">${msg}</div>
          <div class="t-progress"><span></span></div>
        </div>
        <button class="t-close" aria-label="Fechar"><i class="fas fa-xmark"></i></button>
      `;
      root.appendChild(toast);
      const bar = toast.querySelector('.t-progress > span');
      requestAnimationFrame(()=>{ bar.style.width = '100%'; bar.style.transition = `width ${ttl}ms linear`; });
      const close = ()=>{ toast.style.opacity='0'; toast.style.transform='translateY(-6px)'; setTimeout(()=>toast.remove(), 180); };
      const timer = setTimeout(close, ttl);
      toast.querySelector('.t-close').addEventListener('click', ()=>{ clearTimeout(timer); close(); });
    }
    window.topToast = topToast;

    @if (session('ok'))
      document.addEventListener('DOMContentLoaded', function(){ topToast(@json(session('ok')), 'success', 4500); });
    @endif
    @if ($errors->any())
      document.addEventListener('DOMContentLoaded', function(){ topToast(@json($errors->first()), 'error', 6000); });
    @endif

    function scorePwd(p){ let s=0; if(!p) return 0; [/([a-z])/,/([A-Z])/,/([0-9])/,/([^A-Za-z0-9])/].forEach(rx=>{ if(rx.test(p)) s++; }); if(p.length>=12) s++; if(p.length>=16) s++; return Math.min(s,6); }
    function renderMeter(){ const s=scorePwd(pwdEl.value); meterBar.style.width=((s/6)*100)+'%'; pwdHint.textContent='Força da senha: '+(s<=2?'Fraca':(s<=4?'Média':'Forte')); updatePreview(); }
    function genPwd(){ const U='ABCDEFGHJKLMNPQRSTUVWXYZ',L='abcdefghijkmnopqrstuvwxyz',D='23456789',S='!@#$%^&*()-_=+[]{};:,.?'; const all=U+L+D+S,pick=(pool,n)=>Array.from({length:n},()=>pool[Math.floor(Math.random()*pool.length)]).join(''); let p=pick(U,1)+pick(L,1)+pick(D,1)+pick(S,1)+pick(all,8); p=p.split('').sort(()=>Math.random()-0.5).join(''); pwdEl.value=p; pwd2El.value=p; renderMeter(); }
    function updatePreview(){ const payload={ name:nameEl.value||null, email:emailEl.value||null, password: pwdEl.value ? '********' : null, password_confirmation: pwd2El.value ? '********' : null, role:'agente' }; const pre=document.querySelector('#payloadPreview'); if(pre) pre.textContent=JSON.stringify(payload,null,2); }

    $('#btn-gen')?.addEventListener('click', genPwd);
    $('#btn-copy')?.addEventListener('click', ()=>{ if(pwdEl.value) navigator.clipboard.writeText(pwdEl.value); });
    $('#btn-toggle-pwd')?.addEventListener('click', ()=>{ const t=pwdEl.type==='password'?'text':'password'; pwdEl.type=t; pwd2El.type=t; });
    ['input','change'].forEach(evt=>{ [nameEl,emailEl,pwdEl,pwd2El].forEach(el=>el?.addEventListener(evt, renderMeter)); });
    renderMeter(); updatePreview();

    document.getElementById('form-agente')?.addEventListener('submit', function(){
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Criando...';
    });
  })();
  </script>

  @php
    $meta = $cadMeta;
    $cad_pageName   = $meta['page_name'];
    $cad_current    = (int)$meta['current_page'];
    $cad_last       = (int)$meta['last_page'];
    $cad_from       = (int)$meta['from'];
    $cad_to         = (int)$meta['to'];
    $cad_total      = (int)$meta['total'];
    $cad_rangeStart = max(1, $cad_current - 2);
    $cad_rangeEnd   = min($cad_last, $cad_current + 2);
  @endphp

<!-- Cadastros (Agentes e Associados) inicio-->
<div class="panel" id="cadastros">
  <div class="panel-title">
    <i class="fas fa-id-card-clip"></i>Cadastros (Agentes e Associados)
  </div>

  <div class="filters" style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin-bottom:12px">
    <input class="input" type="text" placeholder="Buscar por nome, CPF/CNPJ, matrícula, contrato..." id="f-cad" value="{{ $cadSearch }}" style="min-width:280px">
    <a class="btn btn-mini" href="#pagamentos"><i class="fas fa-money-bill"></i> Ir para Pagamentos</a>
  </div>

  <div class="table-container">
    <table id="tbl-cad">
      <thead>
        <tr>
          <th>Nome</th>
          <th>CPF/CNPJ</th>
          <th>Matrícula</th> {{-- NOVO --}}
          <th>E-mail</th>
          <th>Órgão Público / Situação</th>
          <th>Contrato</th>
          <th>Mensalidade</th>
          <th>Valor do Auxílio</th>
          <th>Liberação do Auxílio</th>
          <th>Status do Contrato</th>
          <th>Agente Resp.</th>
          <th>Ações</th>
        </tr>
      </thead>
      <tbody id="cad-body">
        @php
          $cadList = ($cadastros instanceof \Illuminate\Pagination\AbstractPaginator)
            ? $cadastros->getCollection()
            : collect($cadastros);
        @endphp

        @forelse($cadList as $c)
          @php
            $id        = data_get($c, 'id');
            $full_name = data_get($c, 'full_name');
            $cpf_cnpj  = data_get($c, 'cpf_cnpj');
            $matricula = data_get($c, 'matricula_servidor_publico'); // NOVO
            $email     = data_get($c, 'email');
            $orgao     = data_get($c, 'orgao_publico');
            $sit       = data_get($c, 'situacao_servidor');
            $cod       = data_get($c, 'contrato_codigo_contrato');
            $prazo     = data_get($c, 'contrato_prazo_meses');
            $taxa      = data_get($c, 'contrato_taxa_antecipacao');
            $mensal    = data_get($c, 'contrato_mensalidade');
            $valorAnt  = data_get($c, 'contrato_valor_antecipacao');
            $margem    = data_get($c, 'contrato_margem_disponivel');
            $status    = strtolower(data_get($c, 'contrato_status_contrato', 'Pendente'));
            $agResp    = data_get($c, 'agente_responsavel');
            $obs       = (string) data_get($c, 'observacoes', '');
            $isMig     = stripos($obs, 'MIGRACAO_ABASE') !== false;
            $cls       = $status==='aprovado' ? 'status-ok' : ($status==='pendente' ? 'status-warn' : 'status-bad');

            $pdfUrl = \Illuminate\Support\Facades\Route::has('admin.cadastros.pdf')
              ? route('admin.cadastros.pdf', $id)
              : url('admin/cadastros/'.$id.'/pdf');
          @endphp

          <tr data-cpf="{{ $cpf_cnpj }}" data-contrato="{{ $cod }}">
            <td style="min-width:220px">
              <div style="display:flex;flex-direction:column">
                <span style="font-weight:600">{{ $full_name }}</span>
                <span style="font-size:12px;color:var(--muted)">#{{ $id }}</span>
              </div>
            </td>
            <td style="font-family:ui-monospace,Menlo,Consolas,monospace">{{ maskDoc($cpf_cnpj) }}</td>
            <td style="font-family:ui-monospace,Menlo,Consolas,monospace">{{ $matricula ?: '—' }}</td> {{-- NOVO --}}
            <td>{{ $email ?? '—' }}</td>
            <td>
              <div style="display:flex;flex-direction:column">
                <span>{{ $orgao ?: '—' }}</span>
                <span style="font-size:12px;color:var(--muted)">{{ $sit ?: '—' }}</span>
              </div>
            </td>
            <td>
              <div style="display:flex;flex-direction:column">
                <span style="font-family:ui-monospace">{{ $cod ?: '—' }}</span>
                <span style="font-size:12px;color:var(--muted)">Prazo: {{ $prazo ?? '—' }}m • Taxa: {{ $taxa ?? '—' }}%</span>
              </div>
            </td>
            <td>{{ money($mensal) }}</td>
            <td>{{ money($valorAnt) }}</td>
            <td>{{ money($margem) }}</td>
            <td><span class="status {{ $cls }}"><span class="status-dot"></span>{{ ucfirst($status) }}</span></td>
            <td>
              {{ $agResp ?? '—' }}
              @if($isMig)
                <span class="badge" title="Criado automaticamente via importação ABASE"><i class="fas fa-database"></i> Migração</span>
              @endif
            </td>
            <td>
              <div style="display:flex;gap:8px;flex-wrap:wrap">
                <a class="btn btn-mini" href="{{ $pdfUrl }}" target="_blank" rel="noopener">
                  <i class="fas fa-file-pdf"></i> Documentos (PDF)
                </a>
              </div>
            </td>
          </tr>
        @empty
          <tr><td colspan="12" class="empty"><i class="fas fa-folder-open"></i><div>Nenhum cadastro.</div></td></tr>
        @endforelse
      </tbody>
    </table>
  </div>

  {{-- Paginação (estilo uniforme) --}}
  @php
    if ($cadastros instanceof \Illuminate\Pagination\AbstractPaginator) {
      $cad_current   = $cadastros->currentPage();
      $cad_last      = $cadastros->lastPage();
      $cad_from      = $cadastros->firstItem() ?? 0;
      $cad_to        = $cadastros->lastItem() ?? 0;
      $cad_total     = $cadastros->total();
      $cad_pageName  = method_exists($cadastros,'getPageName') ? $cadastros->getPageName() : 'page';
    } else {
      $cad_current = 1; $cad_last = 1; $cad_from = 0; $cad_to = 0; $cad_total = is_countable($cadastros)?count($cadastros):0; $cad_pageName='page';
    }
    $cad_rangeStart = max(1, $cad_current - 2);
    $cad_rangeEnd   = min($cad_last, $cad_current + 2);
  @endphp

  <div class="pagi" id="cad-pagi" aria-label="Paginação Cadastros" style="margin-top:12px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap">
    <div>
      @if($cad_total>0)
        Mostrando {{ $cad_from }}–{{ $cad_to }} de {{ $cad_total }}
      @else
        Nenhum registro
      @endif
    </div>

    <div class="pagi-ctr" style="display:flex;align-items:center;gap:8px;flex-wrap:wrap">
      <a href="{{ request()->fullUrlWithQuery([$cad_pageName => max(1,$cad_current-1)]) }}" data-page="{{ max(1,$cad_current-1) }}" class="{{ $cad_current>1 ? '' : 'disabled' }}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;opacity:{{ $cad_current>1?1:.5 }};pointer-events:{{ $cad_current>1?'auto':'none' }}">« Anterior</a>

      @if($cad_rangeStart > 1)
        <a href="{{ request()->fullUrlWithQuery([$cad_pageName => 1]) }}" data-page="1" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">1</a>
        @if($cad_rangeStart > 2)<span class="page" aria-hidden="true" style="opacity:.6">…</span>@endif
      @endif

      @for($p = $cad_rangeStart; $p <= $cad_rangeEnd; $p++)
        @if($p === $cad_current)
          <span class="page current" aria-current="page" style="padding:6px 10px;border:1px solid var(--brand);color:var(--brand);border-radius:8px">{{ $p }}</span>
        @else
          <a href="{{ request()->fullUrlWithQuery([$cad_pageName => $p]) }}" data-page="{{ $p }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $p }}</a>
        @endif
      @endfor

      @if($cad_rangeEnd < $cad_last)
        @if($cad_rangeEnd < $cad_last - 1)<span class="page" aria-hidden="true" style="opacity:.6">…</span>@endif
        <a href="{{ request()->fullUrlWithQuery([$cad_pageName => $cad_last]) }}" data-page="{{ $cad_last }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $cad_last }}</a>
      @endif

      <a href="{{ request()->fullUrlWithQuery([$cad_pageName => min($cad_last,$cad_current+1)]) }}" data-page="{{ min($cad_last,$cad_current+1) }}" class="{{ $cad_current<$cad_last ? '' : 'disabled' }}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;opacity:{{ $cad_current<$cad_last?1:.5 }};pointer-events:{{ $cad_current<$cad_last?'auto':'none' }}">Próxima »</a>
    </div>
  </div>
</div>

@php
  $pdfPattern = \Illuminate\Support\Facades\Route::has('admin.cadastros.pdf')
    ? route('admin.cadastros.pdf', ['id' => '__ID__'])
    : url('admin/cadastros/__ID__/pdf');
@endphp

<script>
(() => {
  const CAD_URL     = @json($cadListUrl);
  const PER_PAGE    = @json($cadPerPage);
  const PAGE_NAME   = @json($cadPageName);
  const CAD_PDF_URL = @json($pdfPattern);

  const $ = sel => document.querySelector(sel);
  const cadBody = $('#cad-body');
  const cadPagi = $('#cad-pagi');
  const inputQ  = $('#f-cad');

  const fmtBRL = new Intl.NumberFormat('pt-BR', { style:'currency', currency:'BRL' });
  const money  = v => (v == null || v === '') ? '—' : fmtBRL.format(parseFloat(v));

  function maskDoc(doc){
    const d = String(doc || '').replace(/\D+/g,'');
    if (d.length === 11) return d.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/,'$1.$2.$3-$4');
    if (d.length === 14) return d.replace(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/,'$1.$2.$3/$4-$5');
    return doc || '—';
  }
  const esc = s => (s==null?'':String(s)).replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));

  function renderRows(items){
    if (!items || !items.length) {
      return `<tr><td colspan="12" class="empty"><i class="fas fa-folder-open"></i><div>Nenhum cadastro.</div></td></tr>`;
    }
    return items.map(c => {
      const status = (c.status_norm || c.contrato_status_contrato || 'pendente').toLowerCase();
      const cls = status === 'aprovado' ? 'status-ok' : (status === 'pendente' ? 'status-warn' : 'status-bad');
      const prazo = c.contrato_prazo_meses ?? '—';
      const taxa  = c.contrato_taxa_antecipacao ?? '—';
      const isMig = String(c.observacoes || '').toLowerCase().includes('migracao_abase');
      const pdfUrl = CAD_PDF_URL.replace('__ID__', encodeURIComponent(c.id));

      return `
      <tr data-cpf="${esc(c.cpf_cnpj)}" data-contrato="${esc(c.contrato_codigo_contrato || '')}">
        <td style="min-width:220px">
          <div style="display:flex;flex-direction:column">
            <span style="font-weight:600">${esc(c.full_name)}</span>
            <span style="font-size:12px;color:var(--muted)">#${esc(c.id)}</span>
          </div>
        </td>
        <td style="font-family:ui-monospace,Menlo,Consolas,monospace">${maskDoc(c.cpf_cnpj)}</td>
        <td style="font-family:ui-monospace,Menlo,Consolas,monospace">${esc(c.matricula_servidor_publico) || '—'}</td> <!-- NOVO -->
        <td>${esc(c.email) || '—'}</td>
        <td>
          <div style="display:flex;flex-direction:column">
            <span>${esc(c.orgao_publico) || '—'}</span>
            <span style="font-size:12px;color:var(--muted)">${esc(c.situacao_servidor) || '—'}</span>
          </div>
        </td>
        <td>
          <div style="display:flex;flex-direction:column">
            <span style="font-family:ui-monospace">${esc(c.contrato_codigo_contrato) || '—'}</span>
            <span style="font-size:12px;color:var(--muted)">Prazo: ${esc(prazo)}m • Taxa: ${esc(taxa)}%</span>
          </div>
        </td>
        <td>${money(c.contrato_mensalidade)}</td>
        <td>${money(c.contrato_valor_antecipacao)}</td>
        <td>${money(c.contrato_margem_disponivel)}</td>
        <td><span class="status ${cls}"><span class="status-dot"></span>${status.charAt(0).toUpperCase()+status.slice(1)}</span></td>
        <td>${esc(c.agente_responsavel) || '—'} ${isMig?'<span class="badge" title="Criado automaticamente via importação ABASE"><i class="fas fa-database"></i> Migração</span>':''}</td>
        <td>
          <div style="display:flex;gap:8px;flex-wrap:wrap">
            <a class="btn btn-mini" href="${pdfUrl}" target="_blank" rel="noopener">
              <i class="fas fa-file-pdf"></i> Documentos (PDF)
            </a>
          </div>
        </td>
      </tr>`;
    }).join('');
  }

  function renderPagi(meta){
    const cur = meta.current_page, last = meta.last_page, total = meta.total, from = meta.from || 0, to = meta.to || 0;
    const rangeStart = Math.max(1, cur - 2);
    const rangeEnd   = Math.min(last, cur + 2);
    const parts = [];
    parts.push(`<a href="#" data-page="${Math.max(1,cur-1)}" class="${cur>1?'':'disabled'}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;${cur>1?'':'opacity:.5;pointer-events:none'}">« Anterior</a>`);
    if (rangeStart > 1) {
      parts.push(`<a href="#" data-page="1" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">1</a>`);
      if (rangeStart > 2) parts.push(`<span class="page" aria-hidden="true" style="opacity:.6">…</span>`);
    }
    for (let p=rangeStart; p<=rangeEnd; p++){
      if (p === cur) parts.push(`<span class="page current" aria-current="page" style="padding:6px 10px;border:1px solid var(--brand);color:var(--brand);border-radius:8px">${p}</span>`);
      else parts.push(`<a href="#" data-page="${p}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">${p}</a>`);
    }
    if (rangeEnd < last) {
      if (rangeEnd < last - 1) parts.push(`<span class="page" aria-hidden="true" style="opacity:.6">…</span>`);
      parts.push(`<a href="#" data-page="${last}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">${last}</a>`);
    }
    parts.push(`<a href="#" data-page="${Math.min(last,cur+1)}" class="${cur<last?'':'disabled'}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;${cur<last?'':'opacity:.5;pointer-events:none'}">Próxima »</a>`);
    cadPagi.innerHTML = `<div>${ total>0 ? `Mostrando ${from}–${to} de ${total}` : 'Nenhum registro' }</div><div class="pagi-ctr" style="display:flex;align-items:center;gap:8px;flex-wrap:wrap">${parts.join(' ')}</div>`;
  }

  let typingTimer;

  function normalizeMeta(json){
    if (json && json.meta && typeof json.meta === 'object') return json.meta;
    const keys = ['current_page','last_page','from','to','total'];
    const hasTop = keys.every(k => Object.prototype.hasOwnProperty.call(json || {}, k));
    return hasTop ? {
      current_page: json.current_page,
      last_page: json.last_page,
      from: json.from,
      to: json.to,
      total: json.total
    } : { current_page:1, last_page:1, from:0, to:0, total:0 };
  }

  function fetchList(page=1){
    const q = (inputQ.value || '').trim();
    const url = new URL(CAD_URL, window.location.origin);
    url.searchParams.set('per_page', PER_PAGE);
    url.searchParams.set('q', q);
    url.searchParams.set('page', page);
    if (PAGE_NAME) url.searchParams.set(PAGE_NAME, page);

    cadBody.innerHTML = `<tr><td colspan="12" class="empty"><i class="fas fa-spinner fa-spin"></i><div>Carregando...</div></td></tr>`;

    fetch(url.toString(), { headers: { 'X-Requested-With':'XMLHttpRequest' } })
      .then(r => r.json())
      .then(json => {
        const meta = normalizeMeta(json);
        if (meta.last_page && page > meta.last_page && meta.last_page >= 1) {
          fetchList(meta.last_page);
          return;
        }
        cadBody.innerHTML = renderRows((json.data || json.items || json.results || []));
        renderPagi(meta);
        cadBody.closest('.table-container')?.scrollIntoView({behavior:'smooth', block:'start'});
      })
      .catch(() => {
        cadBody.innerHTML = `<tr><td colspan="12" class="empty"><i class="fas fa-triangle-exclamation"></i><div>Erro ao carregar.</div></td></tr>`;
      });
  }

  cadPagi?.addEventListener('click', (e)=>{
    const a = e.target.closest('a[data-page]'); if (!a || a.classList.contains('disabled')) return;
    e.preventDefault(); const page = parseInt(a.getAttribute('data-page') || '1', 10); fetchList(page);
  });

  inputQ?.addEventListener('input', ()=>{ clearTimeout(typingTimer); typingTimer = setTimeout(()=> fetchList(1), 350); });
  inputQ?.addEventListener('keydown', (e)=>{ if(e.key==='Enter'){ e.preventDefault(); fetchList(1); } });
})();
</script>
<!-- Cadastros (Agentes e Associados) fim-->






<!-- Pendências de Documentos inicio -->

<div class="panel" id="pendencias">
  <div class="panel-title">
    <i class="fas fa-file-circle-exclamation"></i>
    Pendências de Documentos (Analista)
  </div>

  @php
    $isPaginator = $docIssues instanceof \Illuminate\Pagination\AbstractPaginator;
    $rows        = $isPaginator ? $docIssues->getCollection() : collect($docIssues);

    $openCount = $rows->filter(fn($r) => data_get($r, 'status') === 'incomplete')->count();
    $resCount  = $rows->filter(fn($r) => data_get($r, 'status') === 'resolved')->count();

    $mask = function ($doc) {
      $d = preg_replace('/\D/', '', (string) $doc);
      if (strlen($d) === 11) return preg_replace('/(\d{3})(\d{3})(\d{3})(\d{2})/', '$1.$2.$3-$4', $d);
      if (strlen($d) === 14) return preg_replace('/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/', '$1.$2.$3/$4-$5', $d);
      return $doc ?: '—';
    };
  @endphp

  <div class="filters">
    <input class="input" type="text" value="{{ request('q') }}" placeholder="Buscar..." disabled>
    <span class="badge"><i class="fas fa-circle"></i> Abertas: <b>{{ $openCount }}</b></span>
    <span class="badge"><i class="fas fa-circle-check"></i> Resolvidas: <b>{{ $resCount }}</b></span>
  </div>

  <div class="table-container">
    <table id="tbl-pend">
      <thead>
        <tr>
          <th>CPF/CNPJ</th>
          <th>Contrato</th>
          <th>Analista</th>
          <th>Status</th>
          <th>Mensagem</th>
          <th>Reenvios</th>
          <th>Atualizado</th>
        </tr>
      </thead>
      <tbody>
        @forelse($rows as $r)
          @php
            $cpf      = data_get($r, 'cpf_cnpj');
            $contrato = data_get($r, 'contrato_codigo_contrato');
            $status   = data_get($r, 'status');

            $isInc  = $status === 'incomplete';
            $cls    = $isInc ? 'status-warn' : 'status-ok';
            $msg    = data_get($r, 'mensagem');

            $analistaId = (int) data_get($r, 'analista_id');
            $analista   = $analistas[$analistaId] ?? ($analistaId ? '#'.$analistaId : '—');

            $uploads  = data_get($r, 'agent_uploads_json');
            $reenvios = is_array($uploads)
              ? count($uploads)
              : (is_string($uploads) ? count(json_decode($uploads, true) ?: []) : 0);

            $upd = data_get($r, 'updated_at');
            try {
              $updFmt = $upd instanceof \Illuminate\Support\Carbon
                ? $upd->format('d/m/Y H:i')
                : ($upd ? \Illuminate\Support\Carbon::parse($upd)->format('d/m/Y H:i') : '—');
            } catch (\Throwable $e) {
              $updFmt = '—';
            }
          @endphp

          <tr data-cpf="{{ $cpf }}" data-contrato="{{ $contrato }}">
            <td style="font-family:ui-monospace">{{ $mask($cpf) }}</td>
            <td style="font-family:ui-monospace">{{ $contrato ?: '—' }}</td>
            <td>{{ $analista }}</td>
            <td>
              <span class="status {{ $cls }}">
                <span class="status-dot"></span>
                {{ $isInc ? 'Aberta' : 'Resolvida' }}
              </span>
            </td>
            <td style="max-width:420px">{{ $msg }}</td>
            <td>{{ $reenvios }}</td>
            <td>{{ $updFmt }}</td>
          </tr>
        @empty
          <tr>
            <td colspan="7" class="empty">
              <i class="fas fa-folder-open"></i>
              <div>Nenhuma pendência.</div>
            </td>
          </tr>
        @endforelse
      </tbody>
    </table>
  </div>

  @if($isPaginator)
    @php
      $doc_cur   = $docIssues->currentPage();
      $doc_last  = $docIssues->lastPage();
      $doc_from  = $docIssues->firstItem() ?? 0;
      $doc_to    = $docIssues->lastItem() ?? 0;
      $doc_total = $docIssues->total();
      $doc_name  = method_exists($docIssues, 'getPageName') ? $docIssues->getPageName() : 'page';
      $doc_start = max(1, $doc_cur - 2);
      $doc_end   = min($doc_last, $doc_cur + 2);

      $href = function ($p) use ($doc_name) {
        return request()->fullUrlWithQuery([$doc_name => $p]) . '#pendencias';
      };
    @endphp

    <div class="pagi" id="pend-pagi" aria-label="Paginação Pendências"
         style="margin-top:12px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap">
      <div>
        @if($doc_total > 0)
          Mostrando {{ $doc_from }}–{{ $doc_to }} de {{ $doc_total }}
        @else
          Nenhum registro
        @endif
      </div>

      <div class="pagi-ctr" style="display:flex;align-items:center;gap:8px;flex-wrap:wrap">
        <a href="{{ $href(max(1, $doc_cur - 1)) }}"
           class="{{ $doc_cur > 1 ? '' : 'disabled' }}"
           style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;{{ $doc_cur > 1 ? '' : 'opacity:.5;pointer-events:none' }}">
          « Anterior
        </a>

        @if($doc_start > 1)
          <a href="{{ $href(1) }}" class="page"
             style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">1</a>
          @if($doc_start > 2)
            <span class="page" aria-hidden="true" style="opacity:.6">…</span>
          @endif
        @endif

        @for($p = $doc_start; $p <= $doc_end; $p++)
          @if($p === $doc_cur)
            <span class="page current" aria-current="page"
                  style="padding:6px 10px;border:1px solid var(--brand);color:var(--brand);border-radius:8px">{{ $p }}</span>
          @else
            <a href="{{ $href($p) }}" class="page"
               style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $p }}</a>
          @endif
        @endfor

        @if($doc_end < $doc_last)
          @if($doc_end < $doc_last - 1)
            <span class="page" aria-hidden="true" style="opacity:.6">…</span>
          @endif
          <a href="{{ $href($doc_last) }}" class="page"
             style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $doc_last }}</a>
        @endif

        <a href="{{ $href(min($doc_last, $doc_cur + 1)) }}"
           class="{{ $doc_cur < $doc_last ? '' : 'disabled' }}"
           style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;{{ $doc_cur < $doc_last ? '' : 'opacity:.5;pointer-events:none' }}">
          Próxima »
        </a>
      </div>
    </div>
  @endif
</div>

<!-- Pendências de Documentos fim -->



<!-- Tesouraria — Pagamentos inicio -->
@php
  // Helper de moeda (fallback)
  if (!function_exists('money')) {
    function money($v) {
      return $v === null ? '—' : 'R$ '.number_format((float)$v, 2, ',', '.');
    }
  }

  // Coleção base (garante Collection mesmo que venha array)
  $pagCol = ($pagamentos instanceof \Illuminate\Pagination\AbstractPaginator)
              ? $pagamentos->getCollection()
              : collect($pagamentos ?? []);

  // Contadores (total do dataset)
  $pagosCount     = $pagCol->where('status','pago')->count();
  $pendentesCount = $pagCol->where('status','pendente')->count();

  // Paginação manual (mínimo 10 por página)
  $payPageName = 'pay_page';
  $payPerPage  = max(10, (int) request('pay_pp', 10)); // mínimo 10
  $payTotal    = $pagCol->count();
  $payLast     = max(1, (int) ceil($payTotal / $payPerPage));
  $payCurrent  = min(max(1, (int) request($payPageName, 1)), $payLast);
  $payFrom     = $payTotal ? (($payCurrent - 1) * $payPerPage + 1) : 0;
  $payTo       = min($payCurrent * $payPerPage, $payTotal);

  // Fatia a coleção para a página atual
  $payRows = $pagCol->slice(($payCurrent - 1) * $payPerPage, $payPerPage);

  // Helper para links mantendo query string + âncora
  $payHref = function($p) use ($payPageName) {
    return request()->fullUrlWithQuery([$payPageName => $p]) . '#pagamentos';
  };

  // Faixa central
  $payStart = max(1, $payCurrent - 2);
  $payEnd   = min($payLast, $payCurrent + 2);
@endphp

<div class="panel" id="pagamentos">
  <div class="panel-title"><i class="fas fa-money-check-dollar"></i>Tesouraria — Pagamentos</div>

  <div class="filters">
    <input class="input" type="text" placeholder="Buscar por nome, CPF/CNPJ ou contrato..." id="f-pag">
    <span class="badge"><i class="fas fa-circle-check"></i> Pagos: {{ $pagosCount }}</span>
    <span class="badge"><i class="fas fa-hourglass-half"></i> Pendentes: {{ $pendentesCount }}</span>
  </div>

  <div class="table-container">
    <table id="tbl-pag">
      <thead>
        <tr>
          <th>Nome</th>
          <th>CPF/CNPJ</th>
          <th>Contrato</th>
          <th>Valor</th>
          <th>Status</th>
          <th>Pago em</th>
          <th>Forma</th>
          <th>Comprovante</th>
        </tr>
      </thead>
      <tbody>
      @forelse($payRows as $p)
        @php
          $status = data_get($p,'status');
          $isPago = $status === 'pago';
          $cls    = $isPago ? 'status-ok' : ($status==='pendente' ? 'status-warn' : 'status-bad');

          $paid = data_get($p,'paid_at');
          try {
            $paidFmt = $paid ? \Illuminate\Support\Carbon::parse($paid)->format('d/m/Y H:i') : '—';
          } catch (\Throwable $e) { $paidFmt = '—'; }

          // Valor mostrado: prioriza valor_pago; se vazio, usa contrato_valor_antecipacao
          $valorShow = data_get($p,'valor_pago');
          if ($valorShow === null || $valorShow === '') {
            $valorShow = data_get($p,'contrato_valor_antecipacao');
          }

          // Forma mostrada: se vazio e pago => "PIX"; senão "—"
          $forma = trim((string) data_get($p,'forma_pagamento', ''));
          $formaShow = $forma !== '' ? $forma : ($isPago ? 'PIX' : '—');
        @endphp
        <tr data-cpf="{{ data_get($p,'cpf_cnpj') }}" data-contrato="{{ data_get($p,'contrato_codigo_contrato') }}">
          <td style="min-width:220px">
            <div style="display:flex;flex-direction:column">
              <span style="font-weight:600">{{ data_get($p,'full_name') }}</span>
              <span style="font-size:12px;color:var(--muted)">Agente: {{ data_get($p,'agente_responsavel') ?: '—' }}</span>
            </div>
          </td>
          <td style="font-family:ui-monospace">{{ maskDoc(data_get($p,'cpf_cnpj')) }}</td>
          <td style="font-family:ui-monospace">{{ data_get($p,'contrato_codigo_contrato') ?: '—' }}</td>
          <td>{{ money($valorShow) }}</td>
          <td><span class="status {{ $cls }}"><span class="status-dot"></span>{{ ucfirst($status) }}</span></td>
          <td>{{ $paidFmt }}</td>
          <td>{{ $formaShow }}</td>
          <td>
            @php
              $payId   = data_get($p,'id');
              $hasFile = (string) data_get($p,'comprovante_path') !== '';
            @endphp
            @if($payId && $hasFile)
              <a class="btn btn-mini"
                 href="{{ route('tesouraria.comprovantes.ver', ['pagamento' => $payId]) }}"
                 target="_blank" rel="noopener">
                <i class="fas fa-eye"></i> Ver
              </a>
            @else
              —
            @endif
          </td>
        </tr>
      @empty
        <tr>
          <td colspan="8" class="empty">
            <i class="fas fa-folder-open"></i>
            <div>Nenhum pagamento.</div>
          </td>
        </tr>
      @endforelse
      </tbody>
    </table>
  </div>

  {{-- Paginação mini (sempre exibida, com botões desabilitados quando necessário) --}}
  <div class="pagi" id="pay-pagi" aria-label="Paginação Pagamentos" style="margin-top:12px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap">
    <div>
      @if($payTotal>0)
        Mostrando {{ $payFrom }}–{{ $payTo }} de {{ $payTotal }}
      @else
        Nenhum registro
      @endif
    </div>

    <div class="pagi-ctr" style="display:flex;align-items:center;gap:8px;flex-wrap:wrap">
      <a href="{{ $payHref(max(1,$payCurrent-1)) }}" class="{{ $payCurrent>1 ? '' : 'disabled' }}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;opacity:{{ $payCurrent>1?1:.5 }};pointer-events:{{ $payCurrent>1?'auto':'none' }}">« Anterior</a>

      @if($payStart > 1)
        <a href="{{ $payHref(1) }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">1</a>
        @if($payStart > 2)<span class="page" aria-hidden="true" style="opacity:.6">…</span>@endif
      @endif

      @for($p=$payStart; $p<=$payEnd; $p++)
        @if($p === $payCurrent)
          <span class="page current" aria-current="page" style="padding:6px 10px;border:1px solid var(--brand);color:var(--brand);border-radius:8px">{{ $p }}</span>
        @else
          <a href="{{ $payHref($p) }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $p }}</a>
        @endif
      @endfor

      @if($payEnd < $payLast)
        @if($payEnd < $payLast - 1)<span class="page" aria-hidden="true" style="opacity:.6">…</span>@endif
        <a href="{{ $payHref($payLast) }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $payLast }}</a>
      @endif

      <a href="{{ $payHref(min($payLast,$payCurrent+1)) }}" class="{{ $payCurrent<$payLast ? '' : 'disabled' }}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;opacity:{{ $payCurrent<$payLast?1:.5 }};pointer-events:{{ $payCurrent<$payLast?'auto':'none' }}">Próxima »</a>
    </div>
  </div>
</div>
<!-- Tesouraria — Pagamentos fim -->







 {{-- Mensalidades — Recebimentos (ABASE) inicio --}}
<div class="panel" id="mensalidades">
  <div class="panel-title"><i class="fas fa-calendar-check"></i>Mensalidades — Recebimentos (ABASE)</div>

  @php
    if (!isset($mensalidades)) {
      $mensalidades = \App\Models\PagamentoMensalidade::query()
        ->with(['cadastro:id,full_name,cpf_cnpj,contrato_status_contrato'])
        ->orderByDesc('referencia_month')->orderByDesc('created_at')
        ->paginate(10, ['*'], 'mens_page');
    }

    $isPaginator = $mensalidades instanceof \Illuminate\Pagination\AbstractPaginator;
    $rows        = $isPaginator ? $mensalidades->getCollection() : collect($mensalidades);

    $okStatuses = ['1','4'];
    $okCount    = $rows->whereIn('status_code', $okStatuses)->count();
    $otherCount = $rows->count() - $okCount;

    $statusLabels = [
      '1' => 'Efetivado',
      '2' => 'Sem margem (temp.)',
      '3' => 'Não lançado (outros)',
      '4' => 'Efetivado c/ diferença',
      '5' => 'Problemas técnicos',
      '6' => 'Com erros',
      'S' => 'Compra dívida / Suspensão',
    ];
  @endphp

  <div class="filters">
    <input class="input" type="text" placeholder="Buscar por nome, CPF/CNPJ..." id="f-mens" disabled>
    <span class="badge"><i class="fas fa-circle-check"></i> Efetivados: <b>{{ $okCount }}</b></span>
    <span class="badge"><i class="fas fa-hourglass-half"></i> Outros: <b>{{ $otherCount }}</b></span>
    @isset($mensalidadesMes)
      <span class="badge"><i class="fas fa-calendar"></i> Este mês: <b>{{ $mensalidadesMes }}</b></span>
    @endisset
  </div>

  <div class="table-container">
    <table id="tbl-mens">
      <thead>
        <tr>
          <th>Nome</th>
          <th>CPF/CNPJ</th>
          <th>Referência</th>
          <th>Valor</th>
          <th>Status</th>
          <th>Órgão Pagto</th>
          <th>Cadastro</th>
          <th>Arquivo</th>
        </tr>
      </thead>
      <tbody>
        @forelse($rows as $r)
          @php
            $cad     = data_get($r, 'cadastro');
            $nome    = data_get($cad,'full_name') ?: data_get($r,'nome_relatorio') ?: '—';
            $cpf     = data_get($r,'cpf_cnpj');

            $ref     = data_get($r,'referencia_month');
            try { $refFmt = $ref ? \Illuminate\Support\Carbon::parse($ref)->format('m/Y') : '—'; }
            catch (\Throwable $e) { $refFmt = '—'; }

            $valor   = (float) data_get($r,'valor');
            $status  = (string) data_get($r,'status_code');
            $label   = $statusLabels[$status] ?? $status;
            $cls     = in_array($status, ['1','4'], true) ? 'status-ok'
                     : (in_array($status, ['2','3'], true) ? 'status-warn' : 'status-bad');

            $orgao   = data_get($r,'orgao_pagto') ?: '—';
            $contrSt = data_get($cad,'contrato_status_contrato') ?: '—';

            // >>> LINK DO ARQUIVO (usa a rota que faz stream; não depende de symlink /storage)
            $mensId  = data_get($r,'id');
            $src     = (string) data_get($r,'source_file_path');
            $hasFile = $mensId && $src !== '';
            $srcUrl  = $hasFile ? route('admin.baixas.ver', ['mensalidade' => $mensId]) : null;
          @endphp

          <tr data-cpf="{{ $cpf }}">
            <td style="min-width:220px">
              <div style="display:flex;flex-direction:column">
                <span style="font-weight:600">{{ $nome }}</span>
              </div>
            </td>
            <td style="font-family:ui-monospace">{{ function_exists('maskDoc') ? maskDoc($cpf) : $cpf }}</td>
            <td style="font-family:ui-monospace">{{ $refFmt }}</td>
            <td>{{ function_exists('money') ? money($valor) : number_format($valor,2,',','.') }}</td>
            <td><span class="status {{ $cls }}"><span class="status-dot"></span>{{ $label }}</span></td>
            <td>{{ $orgao }}</td>
            <td><span class="badge"><i class="fas fa-tag"></i> {{ $contrSt }}</span></td>
            <td>
              @if($srcUrl)
                <a class="btn btn-mini" href="{{ $srcUrl }}" target="_blank" rel="noopener">
                  <i class="fas fa-eye"></i> Ver
                </a>
              @else
                —
              @endif
            </td>
          </tr>
        @empty
          <tr>
            <td colspan="8" class="empty">
              <i class="fas fa-folder-open"></i>
              <div>Nenhuma mensalidade importada.</div>
            </td>
          </tr>
        @endforelse
      </tbody>
    </table>
  </div>

  @if($isPaginator)
    @php
      $mens_cur   = $mensalidades->currentPage();
      $mens_last  = $mensalidades->lastPage();
      $mens_from  = $mensalidades->firstItem() ?? 0;
      $mens_to    = $mensalidades->lastItem() ?? 0;
      $mens_total = $mensalidades->total();
      $mens_name  = method_exists($mensalidades,'getPageName') ? $mensalidades->getPageName() : 'page';
      $mens_start = max(1, $mens_cur - 2);
      $mens_end   = min($mens_last, $mens_cur + 2);
      $href = function($p) use($mens_name){
        return request()->fullUrlWithQuery([$mens_name => $p]) . '#mensalidades';
      };
    @endphp

    <div class="pagi" id="mens-pagi" aria-label="Paginação Mensalidades" style="margin-top:12px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap">
      <div>
        @if($mens_total>0)
          Mostrando {{ $mens_from }}–{{ $mens_to }} de {{ $mens_total }}
        @else
          Nenhum registro
        @endif
      </div>

      <div class="pagi-ctr" style="display:flex;align-items:center;gap:8px;flex-wrap:wrap">
        <a href="{{ $href(max(1,$mens_cur-1)) }}" class="{{ $mens_cur>1 ? '' : 'disabled' }}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;opacity:{{ $mens_cur>1?1:.5 }};pointer-events:{{ $mens_cur>1?'auto':'none' }}">« Anterior</a>

        @if($mens_start > 1)
          <a href="{{ $href(1) }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">1</a>
          @if($mens_start > 2)<span class="page" aria-hidden="true" style="opacity:.6">…</span>@endif
        @endif

        @for($p=$mens_start; $p<=$mens_end; $p++)
          @if($p === $mens_cur)
            <span class="page current" aria-current="page" style="padding:6px 10px;border:1px solid var(--brand);color:var(--brand);border-radius:8px">{{ $p }}</span>
          @else
            <a href="{{ $href($p) }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $p }}</a>
          @endif
        @endfor

        @if($mens_end < $mens_last)
          @if($mens_end < $mens_last - 1)<span class="page" aria-hidden="true" style="opacity:.6">…</span>@endif
          <a href="{{ $href($mens_last) }}" class="page" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px">{{ $mens_last }}</a>
        @endif

        <a href="{{ $href(min($mens_last,$mens_cur+1)) }}" class="{{ $mens_cur<$mens_last ? '' : 'disabled' }}" style="padding:6px 10px;border:1px solid var(--border);border-radius:8px;opacity:{{ $mens_cur<$mens_last?1:.5 }};pointer-events:{{ $mens_cur<$mens_last?'auto':'none' }}">Próxima »</a>
      </div>
    </div>
  @endif

  <div style="margin-top:8px;color:var(--muted);font-size:12px">
    <i class="fas fa-circle-info"></i>
    Consideramos <b>Efetivado</b> quando o status é <b>1</b> ou <b>4</b>. Ao atingir 3 referências efetivadas para o mesmo cadastro, o contrato é marcado como <b>Concluído</b>.
  </div>
</div>
{{-- Mensalidades — Recebimentos (ABASE) fim --}}

	
 <!-- Atalhos Inicio-->
<div class="panel">
  <div class="panel-title"><i class="fas fa-grid-2"></i>Atalhos de Administração</div>

  <div class="grid grid-3">
    <!-- 
    <div class="card">
      <div style="display:flex;justify-content:space-between;align-items:center">
        <div>
          <div style="font-weight:600">Papéis & Permissões</div>
          <div style="color:var(--muted);font-size:13px">Gerencie acessos</div>
        </div>
        <span class="badge"><i class="fas fa-user-lock"></i> Segurança</span>
      </div>

      <div style="margin-top:12px"><a class="btn btn-mini" href="#"><i class="fas fa-gear"></i> Abrir</a></div>
    </div>
    -->

    {{-- ====== CARD: baixa ABASE ====== --}}
    <div class="card">
      <div style="display:flex;justify-content:space-between;align-items:center">
        <div>
          <div style="font-weight:600">Dar Baixa em Pagamento</div>
          <div style="color:var(--muted);font-size:13px">Importar ABASE.txt (folha)</div>
        </div>
        <span class="badge"><i class="fas fa-sliders"></i> Quitar</span>
      </div>

      <div style="margin-top:12px">
        <form id="form-baixa" method="POST" action="{{ route('admin.baixa.upload') }}" enctype="multipart/form-data">
          @csrf
          <input type="file" name="abase" id="inp-abase" accept=".txt" style="display:none"
                 onchange="if(this.files.length){ document.getElementById('form-baixa').submit(); }">
          <button type="button" class="btn btn-mini" onclick="document.getElementById('inp-abase').click()">
            <i class="fas fa-wrench"></i> Selecionar arquivo
          </button>
        </form>
        <div style="margin-top:8px;color:var(--muted);font-size:12px">
          <i class="fas fa-circle-info"></i>
          <b>Obs.:</b> Se o CPF do arquivo não existir em <b>Cadastros</b>, ele será <b>criado automaticamente</b> e
          atribuído ao <b>Admin</b> que fez a importação. Esses cadastros aparecem com o selo
          <span class="badge"><i class="fas fa-database"></i> Migração</span>.
        </div>
      </div>
    </div>

{{-- ========= CARD: RELATÓRIOS (CSV) ========= --}}
<div class="card" id="card-relatorios">
  <div style="display:flex;justify-content:space-between;align-items:center">
    <div>
      <div style="font-weight:600">Relatórios</div>
      <div style="color:var(--muted);font-size:13px">Exportações e estatísticas</div>
    </div>
    <span class="badge"><i class="fas fa-chart-line"></i> Insights</span>
  </div>

  <div style="margin-top:12px">
    <button type="button" class="btn btn-mini" id="btn-rel-open">
      <i class="fas fa-file-arrow-down"></i> Abrir
    </button>
  </div>
</div>
</div>
</div>

{{-- ======= CSS leve para os modais ======= --}}
<style>
  .modal-sheet{position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(0,0,0,.55);z-index:10000;padding:20px}
  .modal-sheet[open]{display:flex}
  .modal-card{width:100%;max-width:560px;background:var(--panel);border:1px solid var(--border);border-radius:12px;box-shadow:0 12px 32px rgba(0,0,0,.5)}
  .modal-hd{display:flex;align-items:center;justify-content:space-between;padding:14px 16px;border-bottom:1px solid var(--border)}
  .modal-tt{font-weight:600}
  .modal-bd{padding:14px 16px}
  .modal-ft{padding:14px 16px;border-top:1px solid var(--border);display:flex;gap:8px;justify-content:flex-end}
  .grid-2{display:grid;grid-template-columns:1fr 1fr;gap:10px}
  @media (max-width:640px){ .grid-2{grid-template-columns:1fr} }
</style>

{{-- ======= MODAL MENU (escolher qual exportar) ======= --}}
<div class="modal-sheet" id="mdl-rel-menu" aria-hidden="true">
  <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="rel-menu-tt">
    <div class="modal-hd">
      <div class="modal-tt" id="rel-menu-tt">Exportar CSV</div>
      <button type="button" class="btn btn-mini" data-close="#mdl-rel-menu"><i class="fas fa-xmark"></i></button>
    </div>
    <div class="modal-bd">
      <div class="grid-2">
        <button type="button" class="btn" data-open="#mdl-exp-cad"><i class="fas fa-id-card-clip"></i> Cadastros</button>
        <button type="button" class="btn" data-open="#mdl-exp-pag"><i class="fas fa-money-check-dollar"></i> Pagamentos</button>
        <button type="button" class="btn" data-open="#mdl-exp-mens"><i class="fas fa-calendar-check"></i> Mensalidades</button>
      </div>
      <div style="color:var(--muted);font-size:12px;margin-top:12px">
        Escolha um tópico para aplicar filtros e baixar o CSV.
      </div>
    </div>
    <div class="modal-ft">
      <button type="button" class="btn btn-mini" data-close="#mdl-rel-menu"><i class="fas fa-check"></i> Fechar</button>
    </div>
  </div>
</div>

{{-- ======= MODAL: Cadastros CSV ======= --}}
<div class="modal-sheet" id="mdl-exp-cad">
  <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="tt-exp-cad">
    <div class="modal-hd">
      <div class="modal-tt" id="tt-exp-cad"><i class="fas fa-id-card-clip"></i> Exportar Cadastros (CSV)</div>
      <button type="button" class="btn btn-mini" data-close="#mdl-exp-cad"><i class="fas fa-xmark"></i></button>
    </div>

    <form class="modal-bd"
          method="GET"
          action="{{ Route::has('admin.export.cadastros')
                        ? route('admin.export.cadastros')
                        : (Route::has('admin.cadastros.export.csv')
                            ? route('admin.cadastros.export.csv')
                            : url('/admin/export/cadastros.csv')) }}"
          target="_blank"
          id="form-exp-cad">
      <div class="row-flex" style="margin-bottom:8px;gap:16px">
        <label class="hint-muted" style="display:flex;align-items:center;gap:8px">
          <input type="checkbox" id="cad-all" name="all" value="1">
          <span><strong>Todos os registros</strong> (ignorar período)</span>
        </label>

        <label class="hint-muted" style="display:flex;align-items:center;gap:8px">
          <input type="checkbox" id="cad-full" name="full" value="1" checked>
          <span><strong>Campos completos</strong> (tabela inteira)</span>
        </label>
      </div>

      <div class="grid-2">
        <div>
          <label class="hint-muted">Busca</label>
          <input class="input" type="text" name="q" placeholder="nome, CPF/CNPJ, contrato...">
        </div>
        <div>
          <label class="hint-muted">Status do contrato</label>
          <select class="input" name="status">
            <option value="">Todos</option>
            <option>Pendente</option>
            <option>Aprovado</option>
            <option>Concluído</option>
            <option>Cancelado</option>
          </select>
        </div>
        <div>
          <label class="hint-muted">Criado de</label>
          <input class="input" type="date" name="date_from" id="cad-from">
        </div>
        <div>
          <label class="hint-muted">Até</label>
          <input class="input" type="date" name="date_to" id="cad-to">
        </div>
      </div>

      <div class="modal-ft">
        <button type="button" class="btn btn-mini" data-close="#mdl-exp-cad">Cancelar</button>
        <button type="submit" class="btn btn-mini btn-success"><i class="fas fa-download"></i> Baixar CSV</button>
      </div>
    </form>
  </div>
</div>

{{-- ======= MODAL: Pagamentos CSV ======= --}}
<div class="modal-sheet" id="mdl-exp-pag">
  <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="tt-exp-pag">
    <div class="modal-hd">
      <div class="modal-tt" id="tt-exp-pag"><i class="fas fa-money-check-dollar"></i> Exportar Pagamentos (CSV)</div>
      <button type="button" class="btn btn-mini" data-close="#mdl-exp-pag"><i class="fas fa-xmark"></i></button>
    </div>
    <form class="modal-bd"
          method="GET"
          action="{{ Route::has('admin.export.pagamentos')
                        ? route('admin.export.pagamentos')
                        : (Route::has('admin.pagamentos.export.csv')
                            ? route('admin.pagamentos.export.csv')
                            : url('/admin/export/pagamentos.csv')) }}"
          target="_blank"
          id="form-exp-pag">
      <div class="grid-2">
        <div>
          <label style="font-size:12px;color:var(--muted)">Status</label>
          <select class="input" name="status" id="pag-status">
            <option value="">Todos</option>
            <option value="pendente">Pendente</option>
            <option value="pago">Pago</option>
            <option value="cancelado">Cancelado</option>
          </select>
        </div>
        <div>
          <label style="font-size:12px;color:var(--muted)">Forma de pagamento</label>
          <input class="input" type="text" name="forma" placeholder="PIX, TED...">
        </div>
        <div>
          <label style="font-size:12px;color:var(--muted)">Período (criado/quitado)</label>
          <input class="input" type="date" name="date_from" id="pag-from">
        </div>
        <div>
          <label style="font-size:12px;color:var(--muted)">Até</label>
          <input class="input" type="date" name="date_to" id="pag-to">
        </div>
      </div>
      <div class="modal-ft">
        <button type="button" class="btn btn-mini" data-close="#mdl-exp-pag">Cancelar</button>
        <button type="submit" class="btn btn-mini btn-success"><i class="fas fa-download"></i> Baixar CSV</button>
      </div>
    </form>
  </div>
</div>

{{-- ======= MODAL: Mensalidades CSV ======= --}}
<div class="modal-sheet" id="mdl-exp-mens">
  <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="tt-exp-mens">
    <div class="modal-hd">
      <div class="modal-tt" id="tt-exp-mens"><i class="fas fa-calendar-check"></i> Exportar Mensalidades (CSV)</div>
      <button type="button" class="btn btn-mini" data-close="#mdl-exp-mens"><i class="fas fa-xmark"></i></button>
    </div>
    <form class="modal-bd"
          method="GET"
          action="{{ Route::has('admin.export.mensalidades')
                        ? route('admin.export.mensalidades')
                        : (Route::has('admin.mensalidades.export.csv')
                            ? route('admin.mensalidades.export.csv')
                            : url('/admin/export/mensalidades.csv')) }}"
          target="_blank"
          id="form-exp-mens">
      <div class="grid-2">
        <div>
          <label style="font-size:12px;color:var(--muted)">Status</label>
          <select class="input" name="status">
            <option value="">Todos</option>
            <option value="ok">Efetivados (1/4)</option>
            <option value="2">Sem margem (2)</option>
            <option value="3">Não lançado (3)</option>
            <option value="5">Problemas técnicos (5)</option>
            <option value="6">Com erros (6)</option>
            <option value="S">Compra dívida / Suspensão (S)</option>
          </select>
        </div>
        <div>
          <label style="font-size:12px;color:var(--muted)">Órgão Pagto (contém)</label>
          <input class="input" type="text" name="orgao" placeholder="PBPREV, PMJP...">
        </div>
        <div>
          <label style="font-size:12px;color:var(--muted)">Ref. de</label>
          <input class="input" type="month" name="ref_from" id="mens-from">
        </div>
        <div>
          <label style="font-size:12px;color:var(--muted)">Até</label>
          <input class="input" type="month" name="ref_to" id="mens-to">
        </div>
      </div>
      <div class="modal-ft">
        <button type="button" class="btn btn-mini" data-close="#mdl-exp-mens">Cancelar</button>
        <button type="submit" class="btn btn-mini btn-success"><i class="fas fa-download"></i> Baixar CSV</button>
      </div>
    </form>
  </div>
</div>

</div> {{-- fecha .wrap se aqui for o fim do container principal --}}

<script>
  // ===== util: filtro de tabelas (já existia) =====
  function filterTable(inputId, tableId) {
    const q = (document.getElementById(inputId)?.value || '').trim().toLowerCase();
    const rows = document.querySelectorAll(`#${tableId} tbody tr`);
    rows.forEach(tr=>{ const txt = tr.innerText.toLowerCase(); tr.style.display = txt.includes(q) ? '' : 'none'; });
  }
  ['f-cad','f-pag'].forEach(id=>{
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', ()=>{ if (id==='f-cad') filterTable('f-cad','tbl-cad'); if (id==='f-pag') filterTable('f-pag','tbl-pag'); });
  });

  function scrollToMatch(sectionId, cpf, contrato) {
    const elSection = document.querySelector(sectionId); if (!elSection) return;
    const match = elSection.querySelector(`tr[data-cpf="${cpf}"][data-contrato="${contrato}"], tr[data-cpf="${cpf}"], tr[data-contrato="${contrato}"]`);
    if (match) { match.scrollIntoView({behavior:'smooth', block:'center'}); match.style.outline='2px solid var(--brand)'; setTimeout(()=>{ match.style.outline='none'; }, 2000); }
    else { document.querySelector(sectionId).scrollIntoView({behavior:'smooth'}); }
  }
  document.querySelectorAll('#tbl-cad [data-go-pend]')?.forEach(btn=>{
    btn.addEventListener('click', (e)=>{ e.preventDefault(); const tr = btn.closest('tr'); if (!tr) return; scrollToMatch('#pendencias', tr.dataset.cpf, tr.dataset.contrato); });
  });
  document.querySelectorAll('#tbl-cad [data-go-pag]')?.forEach(btn=>{
    btn.addEventListener('click', (e)=>{ e.preventDefault(); const tr = btn.closest('tr'); if (!tr) return; scrollToMatch('#pagamentos', tr.dataset.cpf, tr.dataset.contrato); });
  });
  document.querySelectorAll('#tbl-pend [data-go-cad], #tbl-pag [data-go-cad]')?.forEach(btn=>{
    btn.addEventListener('click', (e)=>{ e.preventDefault(); const tr = btn.closest('tr'); if (!tr) return; scrollToMatch('#cadastros', tr.dataset.cpf, tr.dataset.contrato); });
  });

  // ===== JS dos Modais de Relatórios =====
  (function(){
    const $ = s => document.querySelector(s);
    const $$ = s => Array.from(document.querySelectorAll(s));

    function openSheet(id){ const el = $(id); if(el){ el.setAttribute('open',''); } }
    function closeSheet(id){ const el = $(id); if(el){ el.removeAttribute('open'); } }

    // Botão principal
    $('#btn-rel-open')?.addEventListener('click', ()=> openSheet('#mdl-rel-menu'));

    // Abrir cada export
    $$('#mdl-rel-menu [data-open]').forEach(b=> b.addEventListener('click', ()=> {
      closeSheet('#mdl-rel-menu');
      openSheet(b.getAttribute('data-open'));
    }));

    // Fechar
    $$('.modal-sheet [data-close]').forEach(b=> b.addEventListener('click', ()=> {
      closeSheet(b.getAttribute('data-close'));
    }));

    // Fechar ao clicar fora
    $$('.modal-sheet').forEach(sheet=>{
      sheet.addEventListener('click', (e)=>{ if(e.target === sheet) sheet.removeAttribute('open'); });
    });

    // Pré-preencher períodos
    const today = new Date(); const d30 = new Date(); d30.setDate(today.getDate()-29);
    const toDate  = v => v.toISOString().slice(0,10);
    const toMonth = v => v.toISOString().slice(0,7);

    // Cadastros
    const cadFrom = document.getElementById('cad-from'); const cadTo = document.getElementById('cad-to');
    if(cadFrom && cadTo){ cadFrom.value = toDate(d30); cadTo.value = toDate(today); }

    // Pagamentos
    const pagFrom = document.getElementById('pag-from'); const pagTo = document.getElementById('pag-to');
    if(pagFrom && pagTo){ pagFrom.value = toDate(d30); pagTo.value = toDate(today); }

    // Mensalidades (mês corrente)
    const mensFrom = document.getElementById('mens-from'); const mensTo = document.getElementById('mens-to');
    if(mensFrom && mensTo){ mensFrom.value = toMonth(today); mensTo.value = toMonth(today); }
  })();
</script>
</body>
</html>
