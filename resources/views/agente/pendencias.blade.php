<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Agente | Pendências de Documentação</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="{{ asset('css/agente.css') }}?v={{ filemtime(public_path('css/agente.css')) }}">

  <style>
    :root{
      --bg:#f5f8ff; --panel:#ffffff; --field:#f8fafc; --ink:#0f172a; --muted:#64748b;
      --border:#e5e7eb; --brand:#2563eb; --brand-600:#1d4ed8; --brand-50:#eff6ff;
      --ok:#059669; --warn:#f59e0b; --bad:#ef4444;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0;background:var(--bg);color:var(--ink);font:14px/1.55 'Poppins',system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,sans-serif}
    a{color:var(--brand);text-decoration:none}
    .wrap{max-width:980px;margin:24px auto;padding:0 16px}

    .header{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:18px;padding-bottom:12px;border-bottom:1px solid var(--border)}
    .title{font-size:22px;font-weight:800;color:var(--brand);letter-spacing:.2px}
    .btn-group{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
    .header form{display:inline}
    .btn{border:1px solid var(--border);background:var(--panel);color:var(--ink);padding:10px 14px;border-radius:10px;cursor:pointer;font-weight:600;display:inline-flex;align-items:center;gap:8px;transition:.15s;box-shadow:0 1px 0 rgba(15,23,42,.03)}
    .btn:hover{border-color:var(--brand);box-shadow:0 0 0 3px var(--brand-50)}
    .btn-mini{padding:8px 10px;font-size:12px;border-radius:8px}
    .btn-primary{background:linear-gradient(#2563eb,#1d4ed8);color:#fff;border-color:#1d4ed8;box-shadow:0 6px 14px rgba(37,99,235,.18)}
    .btn-primary:hover{filter:brightness(.98)}
    .btn-outline{background:#fff;border:1px solid var(--border)}
    .user-chip{display:inline-flex;align-items:center;gap:8px;background:var(--panel);border:1px solid var(--border);padding:8px 12px;border-radius:999px;font-size:13px;color:var(--muted)}

    fieldset{border:1px solid var(--border);border-radius:14px;background:var(--panel);padding:16px;margin:0 0 14px;box-shadow:0 1px 2px rgba(15,23,42,.03)}
    legend{padding:0 8px;color:var(--muted);font-weight:700;font-size:12px;text-transform:uppercase;letter-spacing:.4px}
    label{display:flex;flex-direction:column;gap:6px;margin-bottom:10px}
    input,select,textarea{background:var(--field);border:1px solid var(--border);color:var(--ink);padding:10px 12px;border-radius:10px;font:inherit;min-height:40px;transition:border-color .15s,box-shadow .15s,background .15s}
    input:focus,select:focus,textarea:focus{outline:none;border-color:var(--brand);box-shadow:0 0 0 3px var(--brand-50);background:#fff}
    textarea{min-height:90px;resize:vertical}
    .ok-msg{background:#ecfdf5;border:1px solid #bbf7d0;color:#065f46;border-radius:10px;padding:10px 12px;margin:0 0 12px}
    .err-msg{background:#fef2f2;border:1px solid #fecaca;color:#991b1b;border-radius:10px;padding:10px 12px;margin:0 0 12px}
    .err-msg ul{margin:6px 0 0;padding-left:18px}

    .filterbar{display:grid;grid-template-columns:1fr auto auto auto;gap:10px;align-items:end}
    .filterbar a{display:inline-flex;align-items:center;gap:6px}

    /* Toolbar */
    .toolbar{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin:10px 0}
    .toolbar .input{background:var(--field);border:1px solid var(--border);padding:10px 12px;border-radius:10px;font:inherit;min-height:40px}
    .info-badge{font-size:12px;color:var(--muted)}
    .pager{display:flex;align-items:center;gap:10px;justify-content:flex-end;margin-top:10px}

    .issue{border:1px solid var(--border);border-radius:12px;background:var(--panel);padding:14px;margin-top:12px;box-shadow:0 1px 2px rgba(15,23,42,.03)}
    .issue-head{display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin:0 0 10px}
    .issue-head .mono{font-family:ui-monospace,Menlo,Consolas,monospace}
    .badge{margin-left:auto;font-size:12px;font-weight:700;padding:4px 10px;border-radius:999px;background:#fff6e5;border:1px solid #f6d58f;color:#8b6b00}
    .doc-row{display:flex;align-items:center;justify-content:space-between;border:1px dashed #e6eaf3;border-radius:10px;padding:10px;margin-top:6px;background:#fafbff}
    .doc-actions{display:flex;gap:8px}
    .doc-actions a{padding:9px 12px;border:1px solid var(--border);border-radius:10px;background:#fff;font-weight:600;color:#1f2937}
    .pill{font-size:12px;font-weight:700;padding:3px 8px;border-radius:999px;border:1px solid}
    .pill--info{background:#eef6ff;border-color:#b3d3ff;color:#0b5cab}
    .pill--success{background:#e9fbf3;border-color:#b9efd7;color:#0b8f5a}
    .pill--danger{background:#ffecec;border-color:#ffc4c4;color:#b20c0c}
    .muted{color:#6b7280}

    /* ==== Modal de Edição ==== */
    .modal{position:fixed;inset:0;display:none;align-items:flex-start;justify-content:center;background:rgba(15,23,42,.55);padding:20px;z-index:9999;overflow:auto}
    .modal.open{display:flex}
    .modal-card{background:#fff;max-width:980px;width:100%;border-radius:14px;border:1px solid var(--border);box-shadow:0 20px 60px rgba(0,0,0,.25)}
    .modal-head{padding:14px 16px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px}
    .modal-title{font-weight:800;color:var(--brand)}
    .modal-body{padding:12px 16px}
    .modal-actions{display:flex;gap:10px;justify-content:flex-end;padding:12px 16px;border-top:1px solid var(--border);background:#fafbff}
    .close-x{margin-left:auto;cursor:pointer;border:1px solid var(--border);background:#fff;border-radius:8px;padding:6px 10px}
    .seg{border:1px dashed rgba(37,99,235,.25);background:#f8fbff;border-radius:12px;padding:12px;margin:8px 0}
    .seg-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}
    .seg-1{display:grid;grid-template-columns:1fr;gap:12px}
    @media (max-width:780px){ .seg-grid{grid-template-columns:1fr} }
    .readonly{background:#eef2ff !important;color:#6b7280 !important}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div class="title">Pendências de Documentação — AGENTE</div>
      <div class="btn-group">
        <div class="user-chip">
          <i class="fas fa-user"></i>
          <span>Agente: <strong>{{ auth()->user()->name ?? 'Usuário' }}</strong></span>
        </div>

        <a href="{{ route('agente.dashboardagente') }}" class="btn btn-mini">
          <i class="fas fa-user-plus"></i> Novo cadastro
        </a>

        <a href="{{ route('agente.contratos') }}" class="btn btn-mini">
          <i class="fas fa-file-signature"></i> Meus contratos
        </a>

        <a href="{{ route('agente.pendencias') }}" class="btn btn-mini btn-primary">
          <i class="fas fa-file-circle-question"></i> Pendências de documentação
        </a>

        <form method="POST" action="{{ route('logout') }}">
          @csrf
          <button class="btn btn-mini" type="submit"><i class="fas fa-sign-out-alt"></i> Sair</button>
        </form>
      </div>
    </div>

    @if (session('ok')) <div class="ok-msg">{{ session('ok') }}</div> @endif
    @if ($errors->any())
      <div class="err-msg" role="alert">
        <strong>Erros:</strong>
        <ul>@foreach ($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul>
      </div>
    @endif

    {{-- Filtro do servidor (opcional) --}}
    <form method="GET" action="{{ route('agente.pendencias') }}">
      <fieldset>
        <legend>Filtrar (opcional)</legend>
        <div class="filterbar">
          <label>Nome / Código do contrato / CPF
            <input type="text" name="q" value="{{ $q ?? '' }}" placeholder="Ex.: Pedro, CTR-..., ou 12345678945">
          </label>
          <button type="submit" class="btn btn-primary">Filtrar</button>
          <a class="btn btn-outline" href="{{ route('agente.pendencias') }}">Limpar</a>
          <a class="btn btn-outline" href="{{ route('agente.dashboardagente') }}">← Voltar</a>
        </div>
      </fieldset>
    </form>

    {{-- Busca rápida + paginação client-side --}}
    <div class="toolbar">
      <input id="searchName" class="input" type="text" placeholder="Pesquisar por nome..." autocomplete="off" style="min-width:260px">
      <label class="info-badge" for="pageSize">Por página</label>
      <select id="pageSize" class="input" style="width:110px">
        <option value="5" selected>5</option>
        <option value="10">10</option>
        <option value="15">15</option>
      </select>
      <span class="info-badge" id="resultInfo" style="margin-left:auto">Mostrando 0–0 de 0</span>
    </div>

    <fieldset>
      <legend>Pendências abertas</legend>

      @if ($issues->isEmpty())
        <p class="muted" style="margin:6px 0 0">Nenhuma pendência aberta no momento.</p>
      @endif

      <div id="issuesWrap">
        @foreach ($issues as $i)
          @php
            $c           = $i->cadastro;
            $nome        = $c->full_name ?? '—';
            $codContrato = $i->contrato_codigo_contrato ?: ($c->contrato_codigo_contrato ?? '—');
            $docsSnap    = is_array($i->documents_snapshot_json) ? $i->documents_snapshot_json : [];
            $reuploads   = $i->reuploads ?? collect();

            $fmt_brl = function($v){ if($v===null || $v==='') return ''; $n=(float)$v; return 'R$ '.number_format($n,2,',','.'); };
            $fmt_date = function($s){ if(!$s) return ''; try { return \Carbon\Carbon::parse($s)->format('d/m/Y'); } catch(\Exception $e){ return $s; } };
            $estadoCivilCode = function($label){ $m=['Solteiro(a)'=>'single','Casado(a)'=>'married','Divorciado(a)'=>'divorced','Viúvo(a)'=>'widowed']; return $m[$label] ?? ''; };
            $mesAverb = function($s){ if(!$s) return ''; $s = (string)$s; return substr($s,0,7); };
            $ants = is_array($c->anticipations_json ?? null) ? $c->anticipations_json : [];
          @endphp

          <div class="issue js-issue" data-name="{{ strtolower($nome) }}">
            <p class="issue-head">
              <span style="font-weight:700">Cliente:</span> <span>{{ $nome }}</span>
              <span style="font-weight:700;margin-left:12px">Contrato:</span> <span class="mono">{{ $codContrato }}</span>
              <span class="badge">Incompleta</span>
            </p>

            <label style="margin:0">
              O que falta (mensagem do analista)
              <textarea readonly>{{ $i->mensagem }}</textarea>
            </label>

            <div style="display:flex;gap:10px;flex-wrap:wrap;justify-content:flex-end;margin-top:10px">
              <button class="btn btn-mini btn-primary js-open-edit" type="button" data-target="#modal-{{ $i->id }}">
                <i class="fas fa-pen-to-square"></i> Editar cadastro
              </button>
            </div>

            {{-- REMOVIDO: uploader externo. Uploads agora só no modal --}}

            <div>
              <p style="margin:10px 0 6px"><strong>Documentos recebidos (no momento da análise)</strong></p>
              @if (count($docsSnap))
                @foreach ($docsSnap as $d)
                  @php
                    $nomeArq = $d['original_name'] ?? ($d['stored_name'] ?? 'arquivo');
                    $rel     = $d['relative_path'] ?? null;
                    $mime    = $d['mime'] ?? null;
                    $size    = isset($d['size_bytes']) ? (float)$d['size_bytes'] : null;
                    $sizeKb  = $size ? number_format($size/1024, 1, ',', '.') . ' KB' : null;
                    $url     = $rel ? asset($rel) : null;
                  @endphp
                  <div class="doc-row">
                    <div>
                      <div style="font-weight:600">{{ $nomeArq }}</div>
                      <div class="muted" style="font-size:13px">
                        {{ $mime ?? '—' }} @if($sizeKb) • {{ $sizeKb }} @endif
                        @if(!empty($d['uploaded_at'])) • Enviado em {{ \Carbon\Carbon::parse($d['uploaded_at'])->format('d/m/Y') }} @endif
                      </div>
                    </div>
                    <div class="doc-actions">
                      @if($url)
                        <a href="{{ $url }}" target="_blank" rel="noopener">Visualizar</a>
                        <a href="{{ $url }}" download>Baixar</a>
                      @else
                        <span class="muted">sem arquivo</span>
                      @endif
                    </div>
                  </div>
                @endforeach
              @else
                <p class="muted" style="margin-top:6px">Nenhum arquivo listado no snapshot desta análise.</p>
              @endif
            </div>

            @if ($reuploads->count())
              <div>
                <p style="margin:12px 0 6px"><strong>Reenvios feitos por você</strong></p>
                @foreach ($reuploads as $d)
                  @php
                    $url    = $d->file_relative_path ? asset($d->file_relative_path) : null;
                    $sizeKb = $d->file_size_bytes ? number_format($d->file_size_bytes/1024, 1, ',', '.') . ' KB' : null;
                    $statusClass = 'pill--info';
                    if ($d->status === 'accepted') $statusClass = 'pill--success';
                    elseif ($d->status === 'rejected') $statusClass = 'pill--danger';
                  @endphp
                  <div class="doc-row" style="background:#fff">
                    <div>
                      <div style="font-weight:600">{{ $d->file_original_name }}</div>
                      <div class="muted" style="font-size:13px">
                        @if($sizeKb) {{ $sizeKb }} • @endif
                        {{ $d->file_mime ?? '—' }} •
                        Enviado em {{ optional($d->uploaded_at)->format('d/m/Y H:i') ?? '—' }}
                        <span class="pill {{ $statusClass }}" style="margin-left:8px">{{ ucfirst($d->status) }}</span>
                      </div>
                    </div>
                    <div class="doc-actions">
                      @if($url)
                        <a href="{{ $url }}" target="_blank" rel="noopener">Abrir</a>
                        <a href="{{ $url }}" download>Baixar</a>
                      @endif
                    </div>
                  </div>
                @endforeach
              </div>
            @endif

            <p class="muted" style="margin:8px 0 0">
              Pendência #{{ $i->id }} • criada em {{ \Carbon\Carbon::parse($i->created_at)->format('d/m/Y H:i') }}
            </p>
          </div>

          {{-- ====================== MODAL DE EDIÇÃO COMPLETA ====================== --}}
          <div class="modal js-edit-modal" id="modal-{{ $i->id }}" aria-hidden="true" data-issue="{{ $i->id }}">
            <div class="modal-card">
              <div class="modal-head">
                <div class="modal-title">Editar cadastro — {{ $nome }} <span class="mono" style="font-weight:700">({{ $codContrato }})</span></div>
                <button class="close-x js-close-edit" type="button" data-target="#modal-{{ $i->id }}">Fechar ✕</button>
              </div>

              <form id="form-edit-{{ $i->id }}" class="modal-body" method="POST" action="{{ route('agente.pendencias.update', $i->id) }}" enctype="multipart/form-data" novalidate>
                @csrf

                {{-- >>> Campo de controle: 0=salvar, 1=salvar e enviar (dar baixa) --}}
                <input type="hidden" name="finalizar" value="0">

                {{-- DADOS CADASTRAIS --}}
                <fieldset>
                  <legend>Dados Cadastrais</legend>
                  <div class="seg seg-grid">
                    <label>Tipo de Documento
                      <select name="docType" required>
                        @php $docTypeSel = strtoupper($c->doc_type ?? 'CPF'); @endphp
                        <option value="CPF"  {{ $docTypeSel==='CPF'?'selected':'' }}>CPF</option>
                        <option value="CNPJ" {{ $docTypeSel==='CNPJ'?'selected':'' }}>CNPJ</option>
                      </select>
                    </label>
                    <label>CPF/CNPJ
                      <input type="text" name="cpfCnpj" value="{{ $c->cpf_cnpj }}" required>
                    </label>
                  </div>

                  <div class="seg seg-grid">
                    <label>RG
                      <input type="text" name="rg" value="{{ $c->rg }}">
                    </label>
                    <label>Órgão Expedidor
                      <input type="text" name="orgaoExpedidor" value="{{ $c->orgao_expedidor }}">
                    </label>
                  </div>

                  <div class="seg seg-1">
                    <label>Nome/Razão Social
                      <input type="text" name="fullName" value="{{ $c->full_name }}" required>
                    </label>
                  </div>

                  <div class="seg seg-grid">
                    <label>Data de nascimento (dd/mm/aaaa)
                      <input type="text" class="js-date" name="birthDate" value="{{ $fmt_date($c->birth_date) }}" placeholder="00/00/0000" inputmode="numeric" maxlength="10">
                    </label>
                    <label>Profissão
                      <input type="text" name="profession" value="{{ $c->profession }}">
                    </label>
                  </div>

                  <div class="seg seg-1">
                    <label>Estado civil
                      @php $mc = $estadoCivilCode($c->marital_status ?? ''); @endphp
                      <select name="maritalStatus">
                        <option value="" {{ $mc===''?'selected':'' }} disabled>Selecione</option>
                        <option value="single"   {{ $mc==='single'?'selected':'' }}>Solteiro(a)</option>
                        <option value="married"  {{ $mc==='married'?'selected':'' }}>Casado(a)</option>
                        <option value="divorced" {{ $mc==='divorced'?'selected':'' }}>Divorciado(a)</option>
                        <option value="widowed"  {{ $mc==='widowed'?'selected':'' }}>Viúvo(a)</option>
                      </select>
                    </label>
                  </div>
                </fieldset>

                {{-- ENDEREÇO --}}
                <fieldset>
                  <legend>Endereço</legend>
                  <div class="seg seg-grid">
                    <label>CEP
                      <input type="text" name="cep" value="{{ $c->cep }}" placeholder="00000-000" inputmode="numeric" maxlength="9">
                    </label>
                    <label>Endereço
                      <input type="text" name="address" value="{{ $c->address }}">
                    </label>
                  </div>

                  <div class="seg seg-grid">
                    <label>Nº
                      <input type="text" name="addressNumber" value="{{ $c->address_number }}">
                    </label>
                    <label>Complemento
                      <input type="text" name="complement" value="{{ $c->complement }}">
                    </label>
                  </div>

                  <div class="seg seg-grid">
                    <label>Bairro
                      <input type="text" name="neighborhood" value="{{ $c->neighborhood }}">
                    </label>
                    <label>Cidade
                      <input type="text" name="city" value="{{ $c->city }}">
                    </label>
                  </div>

                  <div class="seg seg-1">
                    <label>UF
                      <select name="uf">
                        @php $ufs = ['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO']; @endphp
                        @foreach ($ufs as $uf)
                          <option value="{{ strtolower($uf) }}" {{ strtolower($c->uf ?? '')===strtolower($uf) ? 'selected':'' }}>{{ $uf }}</option>
                        @endforeach
                      </select>
                    </label>
                  </div>
                </fieldset>

                {{-- DADOS BANCÁRIOS --}}
                <fieldset>
                  <legend>Dados Bancários</legend>
                  <div class="seg seg-grid">
                    <label>Banco
                      <input type="text" name="bank_name" value="{{ $c->bank_name }}">
                    </label>
                    <label>Agência
                      <input type="text" name="bank_agency" value="{{ $c->bank_agency }}" inputmode="numeric">
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Conta
                      <input type="text" name="bank_account" value="{{ $c->bank_account }}" inputmode="numeric">
                    </label>
                    <label>Tipo de Conta
                      <select name="account_type">
                        <option value="" disabled {{ empty($c->account_type) ? 'selected' : '' }}>Selecione</option>
                        <option value="corrente" {{ ($c->account_type ?? '')==='corrente' ? 'selected':'' }}>Corrente</option>
                        <option value="poupanca" {{ ($c->account_type ?? '')==='poupanca' ? 'selected':'' }}>Poupança</option>
                      </select>
                    </label>
                  </div>
                  <div class="seg seg-1">
                    <label>Chave Pix
                      <input type="text" name="pix_key" value="{{ $c->pix_key }}" placeholder="CPF/CNPJ, e-mail, celular ou chave aleatória">
                    </label>
                  </div>
                </fieldset>

                {{-- CONTATO / VÍNCULO --}}
                <fieldset>
                  <legend>Contato e Vínculo Público</legend>
                  <div class="seg seg-grid">
                    <label>Celular
                      <input type="text" name="cellphone" value="{{ $c->cellphone }}">
                    </label>
                    <label>E-mail
                      <input type="email" name="email" value="{{ $c->email }}">
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Órgão Público
                      <input type="text" name="orgaoPublico" value="{{ $c->orgao_publico }}">
                    </label>
                    <label>Situação do Servidor
                      @php $sit = $c->situacao_servidor; @endphp
                      <select name="situacaoServidor">
                        @foreach (['Ativo','Aposentado','Pensionista','Comissionado','Contratado'] as $opt)
                          <option value="{{ $opt }}" {{ $sit===$opt?'selected':'' }}>{{ $opt }}</option>
                        @endforeach
                      </select>
                    </label>
                  </div>
                  <div class="seg seg-1">
                    <label>Matrícula do Servidor Público
                      <input type="text" name="matriculaServidorPublico" value="{{ $c->matricula_servidor_publico }}">
                    </label>
                  </div>
                </fieldset>

                {{-- DADOS PARA CÁLCULO --}}
                <fieldset>
                  <legend>Dados para cálculo de margem</legend>
                  <div class="seg seg-grid">
                    <label>Valor Bruto Total
                      <input class="js-money" type="text" name="calc[valor_bruto]" value="{{ $fmt_brl($c->calc_valor_bruto) }}" placeholder="R$ 0,00" autocomplete="off" inputmode="numeric">
                    </label>
                    <label>Valor Líquido (contra-cheque)
                      <input class="js-money" type="text" name="calc[liquido_cc]" value="{{ $fmt_brl($c->calc_liquido_cc) }}" placeholder="R$ 0,00" autocomplete="off" inputmode="numeric">
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Prazo de Antecipação (meses)
                      <select class="readonly" disabled aria-readonly="true">
                        <option value="3" selected>3</option>
                      </select>
                      <input type="hidden" name="calc[prazo_antecipacao]" value="3">
                    </label>
                    <label>30% do Bruto
                      <input type="text" class="readonly js-out-trinta" readonly value="">
                    </label>
                  </div>
                  <div class="seg seg-1">
                    <label>Margem (Líquido - 30% do Bruto)
                      <input type="text" class="readonly js-out-margem" readonly value="">
                    </label>
                  </div>
                </fieldset>

                {{-- DETALHES DO CONTRATO --}}
                <fieldset>
                  <legend>Detalhes do Contrato</legend>
                  <div class="seg seg-grid">
                    <label>Mensalidade Associativa (R$)
                      <input class="js-money js-mensal" type="text" name="contrato[mensalidade]" value="{{ $fmt_brl($c->contrato_mensalidade) }}" placeholder="R$ 0,00" autocomplete="off" inputmode="numeric">
                    </label>
                    <label>Taxa de Antecipação (%)
                      <input type="text" class="readonly" value="30,00" readonly>
                      <input type="hidden" name="contrato[taxaAntecipacao]" value="30,00">
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Disponível (R$)
                      <input class="readonly js-out-disp" type="text" name="contrato[margemDisponivel]" value="" readonly>
                    </label>
                    <label>Valor Total Antecipação (R$)
                      <input class="readonly js-out-total" type="text" name="contrato[valorAntecipacao]" value="" readonly>
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Data da Aprovação (dd/mm/aaaa)
                      <input type="text" class="js-date js-data-aprov" name="contrato[dataAprovacao]" value="{{ $fmt_date($c->contrato_data_aprovacao) }}" placeholder="00/00/0000" inputmode="numeric" maxlength="10">
                    </label>
                    <label>Data da primeira mensalidade (dd/mm/aaaa)
                      <input type="text" class="js-date js-primeira" name="contrato[dataEnvioPrimeira]" value="{{ $fmt_date($c->contrato_data_envio_primeira) }}" placeholder="00/00/0000" inputmode="numeric" maxlength="10">
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Status
                      <input type="text" class="readonly" value="Pendente" readonly>
                      <input type="hidden" name="contrato[statusContrato]" value="Pendente">
                    </label>
                    <label>Mês de Averbação (aaaa-mm)
                      <input type="month" name="contrato[mesAverbacao]" value="{{ $mesAverb($c->contrato_mes_averbacao) }}">
                    </label>
                  </div>
                  <div class="seg seg-1">
                    <label>Doação do Associado (R$)
                      <input class="js-money js-doacao" type="text" name="contrato[doacaoAssociado]" value="{{ $fmt_brl($c->contrato_doacao_associado) }}" placeholder="R$ 0,00" autocomplete="off" inputmode="numeric">
                    </label>
                  </div>
                </fieldset>

                {{-- ANTECIPAÇÕES (3 linhas) --}}
                <fieldset>
                  <legend>Antecipações</legend>
                  @for ($k=0; $k<3; $k++)
                    @php
                      $row = $ants[$k] ?? [];
                      $num = $row['numeroMensalidade'] ?? ($k+1);
                      $val = isset($row['valorAuxilio']) ? $fmt_brl($row['valorAuxilio']) : $fmt_brl($c->contrato_mensalidade);
                      $venc = isset($row['dataEnvio']) ? $fmt_date($row['dataEnvio']) : '';
                      $st = $row['status'] ?? 'Pendente';
                      $obs = $row['observacao'] ?? '';
                    @endphp
                    <div class="seg seg-1 ant-linha" data-index="{{ $k }}">
                      <p style="margin:0 0 8px"><strong>Linha {{ $k + 1 }}</strong></p>
                      <div class="seg-grid">
                        <label>Nº Mensalidade
                          <input type="number" min="1" name="anticipations[{{ $k }}][numeroMensalidade]" value="{{ $num }}">
                        </label>
                        <label>Valor (R$)
                          <input class="js-money js-ant-valor" type="text" name="anticipations[{{ $k }}][valorAuxilio]" value="{{ $val }}">
                        </label>
                      </div>
                      <div class="seg-grid">
                        <label>Vencimento (dd/mm/aaaa)
                          <input type="text" class="js-date js-ant-venc" name="anticipations[{{ $k }}][dataEnvio]" value="{{ $venc }}" placeholder="00/00/0000" inputmode="numeric" maxlength="10">
                        </label>
                        <label>Status
                          <input type="text" class="readonly" value="{{ $st }}" readonly>
                          <input type="hidden" name="anticipations[{{ $k }}][status]" value="{{ $st }}">
                        </label>
                      </div>
                      <div class="seg-1">
                        <label>Observação
                          <input type="text" name="anticipations[{{ $k }}][observacao]" value="{{ $obs }}">
                        </label>
                      </div>
                    </div>
                  @endfor
                </fieldset>

                {{-- AGENTE / OBSERVAÇÕES --}}
                <fieldset>
                  <legend>Agente / Observações</legend>
                  <div class="seg seg-grid">
                    <label>Agente Responsável
                      <input type="text" name="agente[responsavel]" value="{{ $c->agente_responsavel ?? (auth()->user()->name ?? '') }}">
                    </label>
                    <label>Observações
                      <input type="text" name="observacoes" value="{{ $c->observacoes }}">
                    </label>
                  </div>
                </fieldset>

                {{-- AUXÍLIO DO AGENTE --}}
                <fieldset>
                  <legend>Auxílio do Agente</legend>
                  <div class="seg seg-grid">
                    <label>Taxa (%)
                      <input type="text" class="readonly" name="auxilioAgente[taxa]" value="{{ number_format((float)($c->auxilio_taxa ?? 10),2,',','.') }}" readonly>
                    </label>
                    <label>Data do Envio (dd/mm/aaaa)
                      <input type="text" class="js-date js-aux-data" name="auxilioAgente[dataEnvio]" value="{{ $fmt_date($c->auxilio_data_envio) }}" placeholder="00/00/0000" inputmode="numeric" maxlength="10">
                    </label>
                  </div>
                  <input type="hidden" name="auxilioAgente[status]" value="{{ $c->auxilio_status ?? 'Pendente' }}">
                </fieldset>

                {{-- DOCUMENTOS OPCIONAIS (NOMEADOS) --}}
                <fieldset>
                  <legend>Documentos (opcional — imagem/PDF até 10MB)</legend>
                  <div class="seg seg-grid">
                    <label>Documento (frente)
                      <input type="file" name="cpf_frente" accept=".jpg,.jpeg,.png,.webp,.pdf">
                    </label>
                    <label>Documento (verso)
                      <input type="file" name="cpf_verso" accept=".jpg,.jpeg,.png,.webp,.pdf">
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Comprovante de endereço
                      <input type="file" name="comp_endereco" accept=".jpg,.jpeg,.png,.webp,.pdf">
                    </label>
                    <label>Comprovante de renda
                      <input type="file" name="comp_renda" accept=".jpg,.jpeg,.png,.webp,.pdf">
                    </label>
                  </div>
                  <div class="seg seg-grid">
                    <label>Contracheque atual
                      <input type="file" name="contracheque_atual" accept=".jpg,.jpeg,.png,.webp,.pdf">
                    </label>
                    <label>Termo de Adesão
                      <input type="file" name="termo_adesao" accept=".jpg,.jpeg,.png,.webp,.pdf">
                    </label>
                  </div>
                  <div class="seg seg-1">
                    <label>Termo de Antecipação
                      <input type="file" name="termo_antecipacao" accept=".jpg,.jpeg,.png,.webp,.pdf">
                    </label>
                  </div>
                </fieldset>

                <div class="modal-actions">
                  <button class="btn js-close-edit" type="button" data-target="#modal-{{ $i->id }}">Cancelar</button>
                  <button class="btn js-save-only" type="submit" data-finalizar="0">Salvar</button>
                  <button class="btn btn-primary js-finalize-submit" type="submit" data-finalizar="1">
                    <i class="fas fa-paper-plane"></i> Salvar e enviar documentação
                  </button>
                </div>
              </form>
            </div>
          </div>
          {{-- ====================== /MODAL ====================== --}}
        @endforeach
      </div>

      <p id="noResults" class="muted" style="display:none;margin-top:10px">Nenhuma pendência encontrada com esse nome.</p>
    </fieldset>

    <div class="pager">
      <button class="btn btn-mini" id="prevPage" type="button"><i class="fas fa-chevron-left"></i> Anterior</button>
      <span id="pageInfo" class="muted">Página 1 de 1</span>
      <button class="btn btn-mini" id="nextPage" type="button">Próxima <i class="fas fa-chevron-right"></i></button>
    </div>

    <form id="logout-form" method="POST" action="{{ route('logout') }}" style="display:none">@csrf</form>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <script>
    /* ==================== Busca + Paginação (client-side) ==================== */
    (function(){
      const nameInput  = document.getElementById('searchName');
      const pageSizeEl = document.getElementById('pageSize');
      const infoTop    = document.getElementById('resultInfo');
      const pageInfo   = document.getElementById('pageInfo');
      const cards      = Array.from(document.querySelectorAll('.js-issue'));
      const noResults  = document.getElementById('noResults');

      let pageSize = parseInt(pageSizeEl?.value || '5', 10);
      let currentPage = 1;

      function filtered(){
        const needle = (nameInput?.value || '').trim().toLowerCase();
        if (!needle) return cards;
        return cards.filter(c => (c.getAttribute('data-name') || '').includes(needle));
      }

      function updateInfo(start, end, total){
        if (infoTop) infoTop.textContent = `Mostrando ${total ? (start+1) : 0}–${end} de ${total}`;
        const totalPages = Math.max(1, Math.ceil(total / pageSize));
        if (pageInfo) pageInfo.textContent = `Página ${Math.min(currentPage, totalPages)} de ${totalPages}`;
        document.getElementById('prevPage').disabled = (currentPage <= 1);
        document.getElementById('nextPage').disabled = (currentPage >= totalPages);
      }

      function render(){
        cards.forEach(c => c.style.display = 'none');
        const list = filtered();
        const total = list.length;
        if (noResults) noResults.style.display = total === 0 ? '' : 'none';

        const totalPages = Math.max(1, Math.ceil(total / pageSize));
        if (currentPage > totalPages) currentPage = totalPages;

        const start = (currentPage - 1) * pageSize;
        const end   = Math.min(start + pageSize, total);
        for (let i = start; i < end; i++) list[i].style.display = '';

        updateInfo(start, end, total);
      }

      nameInput?.addEventListener('input', () => { currentPage = 1; render(); }, {passive:true});
      pageSizeEl?.addEventListener('change', () => {
        pageSize = parseInt(pageSizeEl.value || '5', 10);
        currentPage = 1; render();
      }, {passive:true});
      document.getElementById('prevPage')?.addEventListener('click', () => { if (currentPage > 1) { currentPage--; render(); } });
      document.getElementById('nextPage')?.addEventListener('click', () => {
        const total = filtered().length;
        const totalPages = Math.max(1, Math.ceil(total / pageSize));
        if (currentPage < totalPages) { currentPage++; render(); }
      });
      render();
    })();

    /* ==================== Modal: abrir/fechar ==================== */
    (function(){
      function openModal(sel){ const m=document.querySelector(sel); if(!m) return; m.classList.add('open'); m.setAttribute('aria-hidden','false'); }
      function closeModal(sel){ const m=document.querySelector(sel); if(!m) return; m.classList.remove('open'); m.setAttribute('aria-hidden','true'); }
      document.addEventListener('click',(e)=>{
        const openBtn = e.target.closest('.js-open-edit');
        const closeBtn = e.target.closest('.js-close-edit');
        if (openBtn){ openModal(openBtn.dataset.target); }
        if (closeBtn){ closeModal(closeBtn.dataset.target); }
      });
      document.querySelectorAll('.js-edit-modal').forEach(m=>{
        m.addEventListener('click',(e)=>{ if(e.target===m) m.classList.remove('open'); });
      });
    })();

    /* ==================== Utils Currency/Date ==================== */
    function _onlyDigits(s){ return (s||'').replace(/\D+/g,''); }
    function brlInputToNumber(val){
      const dg = (val||'').replace(/[^\d]/g,''); if(!dg) return 0; return parseInt(dg,10)/100;
    }
    function numberToBRL(n){
      n = Number(n||0); const neg = n<0?'-':''; n=Math.abs(n);
      const ints  = Math.trunc(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g,'.');
      const cents = Math.round((n - Math.trunc(n)) * 100).toString().padStart(2,'0');
      return `${neg}R$ ${ints},${cents}`;
    }
    function attachMoneyMask(input){
      input.addEventListener('input', ()=>{
        let v = (input.value||'').replace(/[^\d]/g,'');
        if(!v){ input.value=''; return; }
        v = v.replace(/^0+(\d)/,'$1');
        if(v.length<3) v=v.padStart(3,'0');
        const inteiro=v.slice(0,-2), dec=v.slice(-2);
        input.value = `R$ ${inteiro.replace(/\B(?=(\d{3})+(?!\d))/g,'.')},${dec}`;
      }, {passive:true});
    }
    function formatDateDigitsToBR(dg){
      dg=(dg||'').replace(/\D/g,'').slice(0,8);
      const a=dg.slice(0,2), b=dg.slice(2,4), c=dg.slice(4,8);
      return [a,b,c].filter(Boolean).join('/');
    }
    function attachDateMask(input){
      input.setAttribute('inputmode','numeric'); input.setAttribute('maxlength','10');
      input.value = formatDateDigitsToBR(input.value);
      input.addEventListener('input', ()=>{ input.value = formatDateDigitsToBR(input.value); const L=input.value.length; input.setSelectionRange(L,L); }, {passive:true});
      input.addEventListener('paste', (e)=>{ e.preventDefault(); const t=(e.clipboardData||window.clipboardData).getData('text')||''; input.value=formatDateDigitsToBR(t); }, {passive:true});
      input.addEventListener('keydown',(e)=>{ if(['Backspace','Delete','Tab','ArrowLeft','ArrowRight','Home','End','Enter'].includes(e.key)) return; if(!/^\d$/.test(e.key)) e.preventDefault(); });
    }
    function parseDateBR(s){
      const m = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec((s||'').trim());
      if(!m) return null;
      const d = new Date(+m[3], +m[2]-1, +m[1]);
      return (d && d.getFullYear()==+m[3] && d.getMonth()==(+m[2]-1) && d.getDate()==+m[1]) ? d : null;
    }
    function fmtBR(d){
      const dd=String(d.getDate()).padStart(2,'0');
      const mm=String(d.getMonth()+1).padStart(2,'0');
      const yy=d.getFullYear();
      return `${dd}/${mm}/${yy}`;
    }
    function fifthBusinessDayOfMonth(year, monthIndex){
      let d = new Date(year, monthIndex, 1), count=0;
      while(true){
        const wd=d.getDay(); if(wd!==0 && wd!==6){ count++; if(count===5) return d; }
        d = new Date(d.getFullYear(), d.getMonth(), d.getDate()+1);
      }
    }

    /* ==================== Inicialização de cada modal ==================== */
    (function initEditModals(){
      document.querySelectorAll('.js-edit-modal').forEach(modal=>{
        const form = modal.querySelector('form');
        if(!form) return;

        // Botões "Salvar" (0) e "Salvar e enviar" (1) controlam o hidden 'finalizar'
        form.addEventListener('click', (e)=>{
          const btn = e.target.closest('[data-finalizar]');
          if(!btn) return;
          const val = btn.getAttribute('data-finalizar') || '0';
          const hidden = form.querySelector('input[name="finalizar"]');
          if(hidden) hidden.value = val;
        });

        // Evita duplo envio
        form.addEventListener('submit', ()=>{
          form.querySelectorAll('button[type="submit"]').forEach(b=> b.disabled = true);
        });

        // máscaras money
        form.querySelectorAll('.js-money').forEach(attachMoneyMask);
        // máscaras date
        form.querySelectorAll('.js-date').forEach(attachDateMask);

        // recomputes
        const elBruto = form.querySelector('input[name="calc[valor_bruto]"]');
        const elLiq   = form.querySelector('input[name="calc[liquido_cc]"]');
        const out30   = form.querySelector('.js-out-trinta');
        const outMarg = form.querySelector('.js-out-margem');

        function recomputeCalc(){
          const bruto = brlInputToNumber(elBruto?.value);
          const liq   = brlInputToNumber(elLiq?.value);
          const trinta = Math.round(bruto*0.30*100)/100;
          const margem = Math.round((liq - trinta)*100)/100;
          if(out30) out30.value = bruto ? numberToBRL(trinta) : '';
          if(outMarg) outMarg.value = (bruto||liq) ? numberToBRL(margem) : '';
        }
        elBruto?.addEventListener('input', ()=>setTimeout(recomputeCalc,0), {passive:true});
        elLiq?.addEventListener('input',   ()=>setTimeout(recomputeCalc,0), {passive:true});
        recomputeCalc();

        const mensal   = form.querySelector('.js-mensal');
        const outDisp  = form.querySelector('.js-out-disp');
        const outTotal = form.querySelector('.js-out-total');
        const inpDoacao= form.querySelector('.js-doacao');
        function recalcContrato(){
          const m   = brlInputToNumber(mensal?.value);
          const tot = m*3;
          const disp= tot*0.70;
          const doa = tot*0.30;
          if(outTotal) outTotal.value = numberToBRL(tot);
          if(outDisp)  outDisp.value  = numberToBRL(disp);
          if(inpDoacao && !(inpDoacao.dataset.userEdited)) inpDoacao.value = numberToBRL(doa);
          // se valor da mensalidade não foi editado nas linhas de antecipação, atualiza valores
          form.querySelectorAll('.js-ant-valor').forEach(inp=>{
            if(!inp.dataset.userEdited) inp.value = numberToBRL(m);
          });
        }
        mensal?.addEventListener('input', recalcContrato, {passive:true});
        mensal?.addEventListener('blur',  recalcContrato, {passive:true});
        inpDoacao?.addEventListener('input', ()=> inpDoacao.dataset.userEdited='1');
        recalcContrato();

        // datas das antecipações com base na primeira
        const primeira = form.querySelector('.js-primeira');
        function setAntDatesFromBase(base){
          const baseDate = parseDateBR(base||''); if(!baseDate) return;
          form.querySelectorAll('.ant-linha').forEach(linha=>{
            const idx = parseInt(linha.getAttribute('data-index')||'0',10);
            const venc = linha.querySelector('.js-ant-venc');
            let d;
            if (idx === 0) d = baseDate;
            else d = fifthBusinessDayOfMonth(baseDate.getFullYear(), baseDate.getMonth()+idx);
            if(venc && !venc.value) venc.value = fmtBR(d);
          });
        }
        primeira?.addEventListener('change', ()=> setAntDatesFromBase(primeira.value), {passive:true});
        setAntDatesFromBase(primeira?.value||'');

        form.querySelectorAll('.js-ant-valor').forEach(inp=>{
          inp.addEventListener('input', ()=> inp.dataset.userEdited='1', {passive:true});
        });

        // sincroniza data de envio do auxílio = data de aprovação
        const dataApr = form.querySelector('.js-data-aprov');
        const auxEnv  = form.querySelector('.js-aux-data');
        function syncAux(){ if(auxEnv && dataApr) auxEnv.value = (dataApr.value||'').trim(); }
        dataApr?.addEventListener('input', syncAux, {passive:true});
        if(!(auxEnv?.value)) syncAux();

        // validar CEP simples + máscara
        const cep = form.querySelector('input[name="cep"]');
        function maskCEP(v){ v=(v||'').replace(/\D/g,'').slice(0,8); return v.length>5 ? v.slice(0,5)+'-'+v.slice(5) : v; }
        cep?.addEventListener('input', ()=>{ cep.value = maskCEP(cep.value); }, {passive:true});

        // submissão: garante recálculos finais
        form.addEventListener('submit',(e)=>{ recalcContrato(); recomputeCalc(); });
      });
    })();
  </script>
</body>
</html>
