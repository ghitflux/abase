<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Analista | Dashboard</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
    :root{ --bg:#0f172a; --card:#111827; --muted:#94a3b8; --text:#e5e7eb; --accent:#22d3ee; --ok:#10b981; --warn:#f59e0b; --bad:#ef4444; --info:#60a5fa; --border:rgba(148,163,184,.25); }
    *{box-sizing:border-box} html,body{margin:0;padding:0;background:var(--bg);color:var(--text);font:14px/1.5 system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,'Helvetica Neue','Noto Sans',sans-serif}
    a{color:var(--accent);text-decoration:none}
    .wrap{max-width:1200px;margin:24px auto;padding:0 16px}
    .header{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:18px}
    .title{font-size:20px;font-weight:700}
    .who{font-size:12px;color:var(--muted)}
    .card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:14px;margin-bottom:16px}
    .toolbar{display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin-bottom:10px}
    .toolbar form{display:flex;gap:8px;align-items:center}
    .input{background:#0b1220;border:1px solid var(--border);border-radius:10px;color:var(--text);padding:10px 12px;min-width:260px}
    .btn{border:1px solid var(--border);background:#0b1220;color:#fff;padding:10px 14px;border-radius:10px;cursor:pointer}
    .btn:hover{border-color:var(--accent)}
    .btn-mini{padding:6px 10px;font-size:12px;border-radius:8px}
    .btn-mini.is-active{border-color:var(--accent);color:var(--accent)}
    .table-wrap{overflow:auto;border-radius:10px;border:1px solid var(--border)}
    table{width:100%;border-collapse:separate;border-spacing:0;min-width:1080px;background:#0b1220}
    thead th{position:sticky;top:0;background:#0e1628;border-bottom:1px solid var(--border);text-align:left;font-size:12px;color:var(--muted);padding:10px 12px}
    tbody td{padding:10px 12px;border-bottom:1px solid var(--border);vertical-align:top}
    tbody tr:hover{background:#101a30}
    .mono{font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,'Liberation Mono','Courier New',monospace}
    .pill{font-size:12px;font-weight:600;padding:4px 8px;border-radius:999px;display:inline-block}
    .pill-ok{background:rgba(16,185,129,.15);color:#10b981;border:1px solid rgba(16,185,129,.35)}
    .pill-warn{background:rgba(245,158,11,.12);color:#f59e0b;border:1px solid rgba(245,158,11,.35)}
    .pill-bad{background:rgba(239,68,68,.12);color:#ef4444;border:1px solid rgba(239,68,68,.35)}
    .pill-info{background:rgba(96,165,250,.15);color:var(--info);border:1px solid rgba(96,165,250,.35)}
    .muted{color:var(--muted)}
    .foot{display:flex;justify-content:space-between;align-items:center;margin-top:12px;color:var(--muted);font-size:12px;gap:10px;flex-wrap:wrap}
    .logout{margin-left:auto}
    .inline-form{display:none;margin-top:8px}
    .textarea{width:100%;min-width:380px;max-width:680px;min-height:70px;background:#0b1220;color:var(--text);border:1px solid var(--border);border-radius:10px;padding:10px}
    .ok-msg{background:rgba(16,185,129,.12);border:1px solid rgba(16,185,129,.35);color:#10b981;border-radius:10px;padding:10px 12px;margin-bottom:12px}
    .warn-msg{background:rgba(96,165,250,.12);border:1px solid rgba(96,165,250,.35);color:#60a5fa;border-radius:10px;padding:10px 12px;margin-bottom:12px}
    /* Modal */
    .modal{position:fixed;inset:0;background:rgba(2,6,23,.55);display:none;align-items:center;justify-content:center;z-index:999}
    .modal.open{display:flex}
    .modal-card{width:min(980px,95vw);max-height:85vh;overflow:auto;background:#0b1220;border:1px solid var(--border);border-radius:12px}
    .modal-hd{display:flex;align-items:center;justify-content:space-between;padding:12px 14px;border-bottom:1px solid var(--border)}
    .modal-tt{font-weight:700}
    .modal-bd{padding:12px 14px}
    .docs-table{width:100%;border-collapse:separate;border-spacing:0;min-width:780px}
    .docs-table th,.docs-table td{padding:10px 12px;border-bottom:1px solid var(--border);text-align:left}
    .docs-table thead th{position:sticky;top:0;background:#0e1628;color:var(--muted);font-size:12px}
    .flex{display:flex;gap:8px;align-items:center}
    .tag{font-size:11px;padding:2px 6px;border-radius:999px;border:1px solid var(--border);color:var(--muted)}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div>
        <div class="title">Dashboard — ANALISTA</div>
        <div class="who">
          Usuário: <strong>{{ auth()->user()->name }}</strong> •
          E-mail: <strong>{{ auth()->user()->email }}</strong>
        </div>
      </div>
      <form method="POST" action="{{ route('logout') }}" class="logout">@csrf<button type="submit" class="btn">Sair</button></form>
    </div>

    @if (session('ok'))
      <div class="ok-msg">{{ session('ok') }}</div>
    @endif

    @if (!empty($invalidSearch))
      <div class="warn-msg">
        Busca disponível <strong>apenas por Código do Contrato</strong>.
        Ex.: <span class="mono">CTR-20250903142218-X82A5</span> ou <span class="mono">20250903140511-WEW7A</span>.
      </div>
    @endif

    <!-- ===== Tabela principal ===== -->
    <div class="card">
      <div class="toolbar">
        <form method="GET" action="{{ route('analista.dashboardanalista') }}">
          <input
            class="input"
            type="search"
            name="q"
            value="{{ $search ?? '' }}"
            placeholder="Buscar SOMENTE por Código do Contrato (ex.: CTR-20250903142218-X82A5)"
            pattern="^[A-Za-z0-9]+(?:-[A-Za-z0-9]+)+$"
            title="Digite apenas o Código do Contrato (ex.: CTR-20250903142218-X82A5)"
            oninput="this.value=this.value.toUpperCase()"
          >
          <select class="input" name="pp" onchange="this.form.submit()">
            @foreach([10,20,50,100] as $pp)
              <option value="{{ $pp }}" {{ (int)($perPage ?? 20) === $pp ? 'selected':'' }}>{{ $pp }}/página</option>
            @endforeach
          </select>
          <button class="btn" type="submit">Filtrar</button>
        </form>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Código Contrato</th>
              <th>CPF/Matr.</th>
              <th>Nome do Cliente</th>
              <th>Data Assinatura</th>
              <th>Disponível (R$)</th>
              <th>Auxílio do Agente (10%)</th>
              <th>Status Contrato</th>
              <th>Status Documentação</th>
              <th>Agente</th>
              <th>Orgão Público</th>
              <th>Docs/Formulário</th>
              <th>Ações</th>
            </tr>
          </thead>
          <tbody>
            @php $__vis__ = 0; @endphp
            @forelse ($contratos as $c)
              @php
                $codContrato = $c->contrato_codigo_contrato ?: '—';
                $codCliente  = $c->matricula_servidor_publico ?: $c->cpf_cnpj;
                $dataAss     = optional($c->contrato_data_aprovacao)->format('d/m/Y') ?: optional($c->created_at)->format('d/m/Y');

                $dispBase = $c->contrato_margem_disponivel;
                $dispFmt  = is_null($dispBase) ? '—' : 'R$ '.number_format((float)$dispBase, 2, ',', '.');

                $auxBase = is_null($dispBase) ? null : ((float)$dispBase * 0.10);
                $auxFmt  = is_null($auxBase) ? '—' : 'R$ '.number_format($auxBase, 2, ',', '.');

                $stContrato = $c->contrato_status_contrato ?: '—';

                $docs     = is_array($c->documents_json) ? $c->documents_json : (json_decode($c->documents_json ?? '[]', true) ?: []);
                $docCount = is_array($docs) ? count($docs) : 0;

                $openCnt  = (int)($c->open_issues_count ?? 0);
                $resCnt   = (int)($c->resolved_issues_count ?? 0);

                $reups = $c->relationLoaded('reuploads') ? $c->reuploads : collect();
                $hasReupAny      = $reups->count() > 0;
                $hasReupReceived = $reups->contains(fn($r) => $r->status === 'received');

                $reMap = $reups->map(function($r){
                  return [
                    'original_name'   => $r->file_original_name,
                    'stored_name'     => $r->file_stored_name,
                    'mime'            => $r->file_mime ?: 'application/octet-stream',
                    'size_bytes'      => (int) $r->file_size_bytes,
                    'relative_path'   => route('analista.reuploads.ver', $r->id),
                    'uploaded_at'     => optional($r->uploaded_at)->format('d/m/Y H:i'),
                    'is_reupload'     => true,
                    'reupload_status' => $r->status,
                  ];
                });

                $docsAll    = array_values(array_merge($docs, $reMap->toArray()));
                $docsTotal  = count($docsAll);
                $hasDocsAll = $docsTotal > 0;

                if ($hasReupReceived)               { $stDocs='Reenvio pendente'; $pillClass='pill-info'; }
                elseif (!$docCount && !$hasReupAny)  { $stDocs='Pendente';         $pillClass='pill-bad'; }
                elseif ($openCnt > 0)                { $stDocs='Incompleta';       $pillClass='pill-warn'; }
                elseif ($resCnt > 0)                 { $stDocs='Concluído';        $pillClass='pill-ok'; }
                else                                 { $stDocs='Recebida';         $pillClass='pill-ok'; }

                /* APENAS ocultar concluídos */
                $ocultar = ($stDocs === 'Concluído');

                /* ===== Helpers de formatação para a aba "Formulário completo" ===== */
                $fmt_brl = function($v){ if($v===null || $v==='') return null; $n=(float)$v; return 'R$ '.number_format($n,2,',','.'); };
                $fmt_date = function($s){ if(!$s) return null; try { return \Carbon\Carbon::parse($s)->format('d/m/Y'); } catch(\Exception $e){ return $s; } };
                $fmt_month = function($s){ if(!$s) return null; try { return \Carbon\Carbon::parse($s)->format('Y-m'); } catch(\Exception $e){ return $s; } };
                $ucwords_pt = function($s){ return $s ? mb_convert_case($s, MB_CASE_TITLE, 'UTF-8') : null; };
                $acc_type = function($s){ return $s ? ($s==='corrente'?'Corrente':($s==='poupanca'?'Poupança':$s)) : null; };
                $uf_up = function($s){ return $s ? mb_strtoupper($s,'UTF-8') : null; };

                /* Antecipações (flatten bonito) */
                $ants = is_array($c->anticipations_json ?? null) ? $c->anticipations_json : [];
                $antsPayload = [];
                foreach ($ants as $idx => $row) {
                  $i = $idx + 1;
                  $antsPayload["Linha {$i} — Nº Mensalidade"] = $row['numeroMensalidade'] ?? null;
                  $antsPayload["Linha {$i} — Valor (R$)"]     = $fmt_brl($row['valorAuxilio'] ?? null);
                  $antsPayload["Linha {$i} — Vencimento"]     = $fmt_date($row['dataEnvio'] ?? null);
                  $antsPayload["Linha {$i} — Status"]         = $row['status'] ?? null;
                  $antsPayload["Linha {$i} — Observação"]     = $row['observacao'] ?? null;
                }

                /* ===== Payload COMPLETO do formulário (TODAS as colunas, sem anexos) ===== */
                $formPayload = [
                  'Dados Cadastrais' => [
                    'Tipo de Documento' => $c->doc_type,
                    'CPF/CNPJ'          => $c->cpf_cnpj,
                    'RG'                => $c->rg,
                    'Órgão Expedidor'   => $c->orgao_expedidor,
                    'Nome completo'     => $c->full_name,
                    'Data de nascimento'=> $fmt_date($c->birth_date),
                    'Profissão'         => $c->profession,
                    'Estado civil'      => $c->marital_status,
                  ],
                  'Endereço' => [
                    'CEP'               => $c->cep,
                    'Endereço'          => $c->address,
                    'Número'            => $c->address_number,
                    'Complemento'       => $c->complement,
                    'Bairro'            => $c->neighborhood,
                    'Cidade'            => $c->city,
                    'UF'                => $uf_up($c->uf),
                  ],
                  'Contato e Vínculo Público' => [
                    'Celular'                   => $c->cellphone,
                    'E-mail'                    => $c->email,
                    'Órgão Público'             => $c->orgao_publico,
                    'Situação do Servidor'      => $c->situacao_servidor,
                    'Matrícula Servidor Público'=> $c->matricula_servidor_publico,
                  ],
                  'Dados Bancários' => [
                    'Banco'             => $c->bank_name,
                    'Agência'           => $c->bank_agency,
                    'Conta'             => $c->bank_account,
                    'Tipo de Conta'     => $acc_type($c->account_type),
                    'Chave Pix'         => $c->pix_key,
                  ],
                  'Detalhes do Contrato' => [
                    'Código do Contrato'        => $c->contrato_codigo_contrato,
                    'Mensalidade (R$)'          => $fmt_brl($c->contrato_mensalidade),
                    'Prazo (meses)'             => $c->contrato_prazo_meses,
                    'Taxa de Antecipação (%)'   => $c->contrato_taxa_antecipacao,
                    'Margem disponível (R$)'    => $fmt_brl($c->contrato_margem_disponivel),
                    'Data da Aprovação'         => $fmt_date($c->contrato_data_aprovacao),
                    'Data 1ª Mensalidade'       => $fmt_date($c->contrato_data_envio_primeira),
                    'Valor total antecipação'   => $fmt_brl($c->contrato_valor_antecipacao),
                    'Status do Contrato'        => $c->contrato_status_contrato,
                    'Mês de Averbação (aaaa-mm)'=> $fmt_month($c->contrato_mes_averbacao),
                    'Doação do Associado (R$)'  => $fmt_brl($c->contrato_doacao_associado),
                  ],
                  'Simulador (Pré-validação)' => [
                    'Valor Bruto Total (R$)'    => $fmt_brl($c->calc_valor_bruto),
                    'Valor Líquido C.C. (R$)'   => $fmt_brl($c->calc_liquido_cc),
                    'Prazo da Antecipação (m)'  => $c->calc_prazo_antecipacao,
                    'Mensalidade (calc) (R$)'   => $fmt_brl($c->calc_mensalidade_associativa),
                  ],
                  'Antecipações' => $antsPayload ?: ['–' => 'Nenhuma linha registrada'],
                  'Agente / Filial e Observações' => [
                    'Agente responsável' => $c->agente_responsavel,
                    'Agente (filial)'    => $c->agente_filial,
                    'Observações'        => $c->observacoes,
                  ],
                  'Auxílio do Agente' => [
                    'Taxa (%)'           => $c->auxilio_taxa,
                    'Data do Envio'      => $fmt_date($c->auxilio_data_envio),
                    'Status'             => $c->auxilio_status,
                  ],
                  'Metadados' => [
                    'Criado em'          => optional($c->created_at)->format('d/m/Y H:i'),
                    'Atualizado em'      => optional($c->updated_at)->format('d/m/Y H:i'),
                    'Status Documentação'=> $stDocs,
                  ],
                ];
              @endphp

              @unless($ocultar)
                @php $__vis__++; @endphp
                <tr>
                  <td class="mono">{{ $codContrato }}</td>
                  <td class="mono">{{ $codCliente ?: '—' }}</td>
                  <td>{{ $c->full_name }}</td>
                  <td class="mono">{{ $dataAss }}</td>
                  <td class="mono">{{ $dispFmt }}</td>
                  <td class="mono">{{ $auxFmt }}</td>
                  <td>{{ $stContrato }}</td>
                  <td><span class="pill {{ $pillClass }}">{{ $stDocs }}</span></td>
                  <td>{{ $c->agente_responsavel ?: '—' }}</td>
                  <td>{{ $c->orgao_publico ?: '—' }}</td>
                  <td>
                    <!-- >>> Agora o botão sempre aparece; se não houver docs, abre direto na aba Formulário -->
                    <button class="btn btn-mini"
                      data-docs='@json($docsAll)'
                      data-form='@json($formPayload)'
                      data-fullname='{{ e($c->full_name) }}'
                      data-contrato='{{ e($codContrato) }}'
                      onclick='openDocsModal(this)'>
                      {{ $hasDocsAll ? "Ver documentos / formulário ($docsTotal)" : "Ver formulário" }}
                    </button>
                  </td>
                  <td>
                    @if($hasReupReceived)
                      <form method="POST" action="{{ route('analista.contrato.validate', $c->id) }}" style="display:inline">
                        @csrf
                        <button class="btn btn-mini" type="submit">Validar documento revisto</button>
                      </form>
                      <button class="btn btn-mini" onclick="toggleForm({{ $c->id }})">Solicitar correção novamente</button>
                      <div id="form-{{ $c->id }}" class="inline-form">
                        <form method="POST" action="{{ route('analista.contrato.mark_incomplete', $c->id) }}">
                          @csrf
                          <textarea class="textarea" name="mensagem" placeholder="Descreva o que está faltando" required></textarea>
                          <div style="margin-top:8px;display:flex;gap:8px;align-items:center">
                            <button type="submit" class="btn btn-mini">Enviar</button>
                            <button type="button" class="btn btn-mini" onclick="toggleForm({{ $c->id }})">Cancelar</button>
                          </div>
                        </form>
                      </div>

                    @elseif($docCount > 0 || $hasReupAny)
                      <form method="POST" action="{{ route('analista.contrato.validate', $c->id) }}" style="display:inline">
                        @csrf
                        <button class="btn btn-mini" type="submit">Validar registro</button>
                      </form>
                      <button class="btn btn-mini" onclick="toggleForm({{ $c->id }})">Marcar “incompleta”</button>
                      <div id="form-{{ $c->id }}" class="inline-form">
                        <form method="POST" action="{{ route('analista.contrato.mark_incomplete', $c->id) }}">
                          @csrf
                          <textarea class="textarea" name="mensagem" placeholder="Descreva o que está faltando" required></textarea>
                          <div style="margin-top:8px;display:flex;gap:8px;align-items:center">
                            <button type="submit" class="btn btn-mini">Enviar</button>
                            <button type="button" class="btn btn-mini" onclick="toggleForm({{ $c->id }})">Cancelar</button>
                          </div>
                        </form>
                      </div>

                    @else
                      <button class="btn btn-mini" onclick="toggleForm({{ $c->id }})">Solicitar documentos</button>
                      <div id="form-{{ $c->id }}" class="inline-form">
                        <form method="POST" action="{{ route('analista.contrato.mark_incomplete', $c->id) }}">
                          @csrf
                          <textarea class="textarea" name="mensagem" required>Não recebemos nenhum documento para este contrato. Por favor, envie a documentação completa para análise.</textarea>
                          <div style="margin-top:8px;display:flex;gap:8px;align-items:center">
                            <button type="submit" class="btn btn-mini">Enviar solicitação</button>
                            <button type="button" class="btn btn-mini" onclick="toggleForm({{ $c->id }})">Cancelar</button>
                          </div>
                        </form>
                      </div>
                    @endif
                  </td>
                </tr>
              @endunless
            @empty
              <tr><td colspan="12" class="muted">Nenhum contrato encontrado.</td></tr>
            @endforelse

            @if($__vis__ === 0 && $contratos->count() > 0)
              <tr>
                <td colspan="12" class="muted">
                  Nenhum contrato exibível nesta página (<u>concluídos</u> foram ocultados).
                </td>
              </tr>
            @endif
          </tbody>
        </table>
      </div>

      @php
        $totalReg   = $contratos->total();
        $perPage    = $contratos->perPage();
        $current    = $contratos->currentPage();
        $lastPage   = $contratos->lastPage();
        $from       = $totalReg ? (($current - 1) * $perPage + 1) : 0;
        $to         = min($current * $perPage, $totalReg);
        $startPage  = max(1, $current - 2);
        $endPage    = min($lastPage, $current + 2);
      @endphp

      <div class="foot">
        <div class="page-info">Total: {{ $totalReg }} registro(s)</div>

        @if ($lastPage > 1)
          <div class="pager-box">
            <span class="muted">Mostrando {{ $from }}–{{ $to }} de {{ $totalReg }}</span>
            <nav class="pagination-mini" aria-label="Paginação">
              @if ($contratos->onFirstPage())
                <span class="muted">«</span><span class="muted">‹</span>
              @else
                <a href="{{ $contratos->url(1) }}">«</a>
                <a href="{{ $contratos->previousPageUrl() }}" rel="prev">‹</a>
              @endif

              @if ($startPage > 1)
                <a href="{{ $contratos->url(1) }}">1</a>
                @if ($startPage > 2) <span class="muted">…</span> @endif
              @endif

              @for ($p = $startPage; $p <= $endPage; $p++)
                @if ($p == $current)
                  <span class="muted" style="font-weight:700">{{ $p }}</span>
                @else
                  <a href="{{ $contratos->url($p) }}">{{ $p }}</a>
                @endif
              @endfor

              @if ($endPage < $lastPage)
                @if ($endPage < $lastPage - 1) <span class="muted">…</span> @endif
                <a href="{{ $contratos->url($lastPage) }}">{{ $lastPage }}</a>
              @endif

              @if ($contratos->hasMorePages())
                <a href="{{ $contratos->nextPageUrl() }}" rel="next">›</a>
                <a href="{{ $contratos->url($lastPage) }}">»</a>
              @else
                <span class="muted">›</span><span class="muted">»</span>
              @endif
            </nav>
          </div>
        @endif
      </div>
    </div>

    <p style="margin-top:16px"><a href="{{ url('/') }}">Voltar ao Login</a></p>
  </div>

  <!-- Modal de Documentos / Formulário -->
  <div id="docsModal" class="modal" aria-hidden="true">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="docsModalTitle">
      <div class="modal-hd">
        <div class="modal-tt" id="docsModalTitle">Documentos</div>
        <button class="btn btn-mini" onclick="closeDocsModal()">Fechar</button>
      </div>
      <div class="modal-bd">
        <div id="docsTabs" class="flex" style="margin-bottom:8px">
          <!-- botões de aba são injetados dinamicamente -->
        </div>
        <div id="docsPane"></div>
        <div id="formPane" style="display:none"></div>
      </div>
    </div>
  </div>

  <!-- Modal de Usuário (opcional, mantido) -->
  <div id="userModal" class="modal" aria-hidden="true">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="userModalTitle">
      <div class="modal-hd">
        <div class="modal-tt" id="userModalTitle">Dados do usuário</div>
        <button class="btn btn-mini" onclick="closeUserModal()">Fechar</button>
      </div>
      <div class="modal-bd">
        <div id="userContainer"></div>
      </div>
    </div>
  </div>

  <script>
    function toggleForm(id){
      const el = document.getElementById('form-'+id);
      if(!el) return;
      el.style.display = (el.style.display === 'block') ? 'none' : 'block';
    }

    const docsModal = document.getElementById('docsModal');
    const docsPane = document.getElementById('docsPane');
    const formPane = document.getElementById('formPane');
    const docsTabs = document.getElementById('docsTabs');

    function closeDocsModal(){
      if(!docsModal) return;
      docsModal.classList.remove('open');
      docsPane.innerHTML = '';
      formPane.innerHTML = '';
      docsTabs.innerHTML = '';
      docsModal.setAttribute('aria-hidden','true');
    }

    docsModal?.addEventListener('click', (e)=>{
      if(e.target === docsModal) closeDocsModal();
    });

    function humanSize(bytes){
      const b = Number(bytes||0);
      if (b >= 1024*1024) return (b/1024/1024).toFixed(2).replace('.',',') + ' MB';
      if (b >= 1024) return (b/1024).toFixed(1).replace('.',',') + ' KB';
      return (b||0) + ' B';
    }

    function escapeHtml(s){
      return String(s||'').replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
    }

    function buildUrl(d){
      const p = d.open_url || d.relative_path || '';
      if (!p) return '';
      if (/^https?:\/\//.test(p) || p.startsWith('/')) return p;
      return `{{ asset('') }}` + p;
    }

    function statusPill(s){
      if(!s) return '<span class="muted">—</span>';
      const map = {accepted:'pill-ok', rejected:'pill-bad', received:'pill-info'};
      const cls = map[s] || 'pill-info';
      const label = s.charAt(0).toUpperCase()+s.slice(1);
      return `<span class="pill ${cls}">${label}</span>`;
    }

    function buildDocsTable(docs){
      const rows = (docs||[]).map((d,idx)=>{
        const url = buildUrl(d);
        const name = escapeHtml(d.original_name || d.stored_name || `arquivo_${idx+1}`);
        const mime = escapeHtml(d.mime || 'application/octet-stream');
        const size = humanSize(d.size_bytes);
        const upAt = escapeHtml(d.uploaded_at || '');
        const origem = d.is_reupload ? 'Reenvio' : 'Inicial';
        const st = d.is_reupload ? statusPill(String(d.reupload_status||'')) : '<span class="muted">—</span>';

        return `
          <tr>
            <td>${idx+1}</td>
            <td>${name}</td>
            <td class="mono">${mime}</td>
            <td class="mono">${size}</td>
            <td class="mono">${upAt}</td>
            <td class="mono">${origem}</td>
            <td>${st}</td>
            <td class="flex">
              ${url ? `<a class="btn btn-mini" href="${url}" target="_blank" rel="noopener">Abrir</a>` : '<span class="muted">—</span>'}
            </td>
          </tr>
        `;
      }).join('');

      return `
        <div class="table-wrap" style="border-radius:10px;border:1px solid var(--border);overflow:auto">
          <table class="docs-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Arquivo</th>
                <th>Tipo</th>
                <th>Tamanho</th>
                <th>Enviado em</th>
                <th>Origem</th>
                <th>Status</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              ${rows || `<tr><td colspan="8" class="muted">Nenhum documento encontrado.</td></tr>`}
            </tbody>
          </table>
        </div>
      `;
    }

    function buildFormView(form){
      // form = { "Seção": { "Campo": "Valor", ... }, ... }
      const sections = Object.entries(form||{});
      if (!sections.length) return '<div class="muted">Nenhum dado do formulário.</div>';

      return sections.map(([sec, fields])=>{
        const rows = Object.entries(fields||{}).map(([k,v])=>{
          const val = (v === null || v === undefined || v === '') ? '—' : String(v);
          return `<tr><th style="width:260px">${escapeHtml(k)}</th><td>${escapeHtml(val)}</td></tr>`;
        }).join('');
        return `
          <div class="card" style="background:#0b1220;border:1px solid var(--border);border-radius:10px;margin-bottom:10px">
            <div style="padding:10px 12px;border-bottom:1px solid var(--border);font-weight:700;color:var(--muted)">${escapeHtml(sec)}</div>
            <div class="table-wrap" style="border:none;border-radius:0">
              <table class="docs-table" style="min-width:680px">
                <tbody>
                  ${rows || `<tr><td colspan="2" class="muted">—</td></tr>`}
                </tbody>
              </table>
            </div>
          </div>
        `;
      }).join('');
    }

    function setDocsTabs(active){
      const btnDocs = document.createElement('button');
      btnDocs.type = 'button';
      btnDocs.className = 'btn btn-mini' + (active === 'docs' ? ' is-active' : '');
      btnDocs.textContent = 'Documentos';
      btnDocs.dataset.pane = 'docs';

      const btnForm = document.createElement('button');
      btnForm.type = 'button';
      btnForm.className = 'btn btn-mini' + (active === 'form' ? ' is-active' : '');
      btnForm.textContent = 'Formulário completo (leitura)';
      btnForm.dataset.pane = 'form';

      docsTabs.innerHTML = '';
      docsTabs.appendChild(btnDocs);
      docsTabs.appendChild(btnForm);

      btnDocs.addEventListener('click', ()=>{
        btnDocs.classList.add('is-active');
        btnForm.classList.remove('is-active');
        docsPane.style.display = '';
        formPane.style.display = 'none';
      });
      btnForm.addEventListener('click', ()=>{
        btnForm.classList.add('is-active');
        btnDocs.classList.remove('is-active');
        docsPane.style.display = 'none';
        formPane.style.display = '';
      });
    }

    function openDocsModal(btn){
      if(!docsModal || !docsPane || !formPane) return;

      // Lê atributos do botão
      let docs = []; let form = {};
      try { docs = JSON.parse(btn.getAttribute('data-docs') || '[]'); } catch(e){}
      try { form = JSON.parse(btn.getAttribute('data-form') || '{}'); } catch(e){}

      const fullName = btn.getAttribute('data-fullname') || 'Cliente';
      const codContrato = btn.getAttribute('data-contrato') || '—';

      const title = `Documentos — ${escapeHtml(fullName)} <span class="tag mono">${escapeHtml(codContrato)}</span>`;
      document.getElementById('docsModalTitle').innerHTML = title;

      // Monta conteúdo das abas
      docsPane.innerHTML = buildDocsTable(docs);
      formPane.innerHTML = buildFormView(form);

      // >>> Se não houver docs, abre direto a aba de Formulário
      setDocsTabs((docs && docs.length) ? 'docs' : 'form');

      docsModal.classList.add('open');
      docsModal.setAttribute('aria-hidden','false');
    }

    // ===== Modal de Usuário (mantido para outros pontos da tela)
    const userModal = document.getElementById('userModal');
    const userContainer = document.getElementById('userContainer');

    function closeUserModal(){
      if(!userModal) return;
      userModal.classList.remove('open');
      userContainer.innerHTML = '';
      userModal.setAttribute('aria-hidden','true');
    }
    userModal?.addEventListener('click', (e)=>{
      if(e.target === userModal) closeUserModal();
    });

    function maskDoc(doc){
      const d = String(doc||'').replace(/\D+/g,'');
      if (d.length===11) return d.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
      if (d.length===14) return d.replace(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '$1.$2.$3/$4-$5');
      return doc || '—';
    }

    function openUserModal(u){
      try { if (typeof u === 'string') u = JSON.parse(u); } catch(e) {}
      if(!userModal || !userContainer) return;
      document.getElementById('userModalTitle').innerHTML =
        `Dados do usuário — <span class="mono">${escapeHtml((u && u.contrato) || '—')}</span>`;

      const html = `
        <div class="table-wrap" style="border-radius:10px;border:1px solid var(--border);overflow:hidden">
          <table class="docs-table" style="min-width:600px">
            <tbody>
              <tr><th style="width:220px">Nome</th><td>${escapeHtml((u && u.nome) || '')}</td></tr>
              <tr><th>E-mail</th><td>${escapeHtml((u && u.email) || '—')}</td></tr>
              <tr><th>CPF / Matrícula</th><td class="mono">${escapeHtml(maskDoc(u && u.cpf))}${u && u.matricula ? ' • ' + escapeHtml(u.matricula) : ''}</td></tr>
              <tr><th>Contrato</th><td class="mono">${escapeHtml((u && u.contrato) || '')}</td></tr>
              <tr><th>Agente</th><td>${escapeHtml((u && u.agente) || '—')}</td></tr>
              <tr><th>Órgão Público</th><td>${escapeHtml((u && u.orgao) || '—')}</td></tr>
              <tr><th>Criado em</th><td class="mono">${escapeHtml((u && u.criado_em) || '—')}</td></tr>
              <tr><th>Status Documentação</th><td><span class="pill ${String((u && u.status) || '').toLowerCase().includes('reenvio') ? 'pill-info' : 'pill-bad'}">${escapeHtml((u && u.status) || '—')}</span></td></tr>
            </tbody>
          </table>
        </div>
      `;
      userContainer.innerHTML = html;
      userModal.classList.add('open');
      userModal.setAttribute('aria-hidden','false');
    }
  </script>
</body>
</html>
