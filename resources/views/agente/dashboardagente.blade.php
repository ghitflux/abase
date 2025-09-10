<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Agente | Cadastro de Associado</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="{{ asset('css/agente.css') }}?v={{ filemtime(public_path('css/agente.css')) }}">

  <!-- ======== VISUAL (AZUL) ======== -->
  <style>
    :root{
      /* Paleta azul clara do projeto */
      --bg:#f5f8ff;
      --panel:#ffffff;
      --field:#f8fafc;
      --ink:#0f172a;
      --muted:#64748b;
      --border:#e5e7eb;
      --brand:#2563eb;
      --brand-600:#1d4ed8;
      --brand-50:#eff6ff;
      --ok:#059669; --warn:#f59e0b; --bad:#ef4444;
    }

    *{box-sizing:border-box}
    html,body{
      margin:0; padding:0;
      background:var(--bg);
      color:var(--ink);
      font:14px/1.55 'Poppins',system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,sans-serif;
    }

    a{color:var(--brand); text-decoration:none}
    .wrap{max-width:980px;margin:24px auto; padding:0 16px}

    /* ===== Header ===== */
    .header{
      display:flex; align-items:center; justify-content:space-between; gap:16px;
      margin-bottom:18px; padding-bottom:12px; border-bottom:1px solid var(--border);
    }
    .title{font-size:22px;font-weight:800;color:var(--brand);letter-spacing:.2px}
    .btn-group{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
    .header form{display:inline}

    .btn{
      border:1px solid var(--border);
      background:var(--panel);
      color:var(--ink);
      padding:10px 14px; border-radius:10px;
      cursor:pointer; font-weight:600;
      display:inline-flex; align-items:center; gap:8px;
      transition: all .15s ease;
      box-shadow:0 1px 0 rgba(15,23,42,.03);
    }
    .btn:hover{border-color:var(--brand); box-shadow:0 0 0 3px var(--brand-50)}
    .btn-mini{padding:8px 10px; font-size:12px; border-radius:8px}
    .btn-primary{
      background:linear-gradient(#2563eb,#1d4ed8);
      color:#fff; border-color:#1d4ed8;
      box-shadow:0 6px 14px rgba(37,99,235,.18);
    }
    .btn-primary:hover{filter:brightness(.98)}
    .user-chip{
      display:inline-flex; align-items:center; gap:8px;
      background:var(--panel); border:1px solid var(--border);
      padding:8px 12px; border-radius:999px; font-size:13px; color:var(--muted)
    }
    .user-chip i{color:var(--brand)}

    /* ===== Cards / Fieldsets ===== */
    fieldset{
      border:1px solid var(--border);
      border-radius:14px;
      background:var(--panel);
      padding:16px;
      margin:0 0 14px;
      box-shadow:0 1px 2px rgba(15,23,42,.03);
    }
    legend{
      padding:0 8px; color:var(--muted); font-weight:700; font-size:12px;
      text-transform:uppercase; letter-spacing:.4px
    }
    label{display:flex;flex-direction:column;gap:6px;margin-bottom:10px}

    input,select,textarea{
      background:var(--field);
      border:1px solid var(--border);
      color:var(--ink);
      padding:10px 12px; border-radius:10px; font:inherit; min-height:40px;
      transition:border-color .15s ease, box-shadow .15s ease, background .15s ease;
    }
    input:focus,select:focus,textarea:focus{
      outline:none; border-color:var(--brand);
      box-shadow:0 0 0 3px var(--brand-50);
      background:#fff;
    }
    textarea{min-height:90px; resize:vertical}

    /* Mensagens */
    .ok-msg{background:#ecfdf5;border:1px solid #bbf7d0;color:#065f46;border-radius:10px;padding:10px 12px;margin:0 0 12px}
    .err-msg{background:#fef2f2;border:1px solid #fecaca;color:#991b1b;border-radius:10px;padding:10px 12px;margin:0 0 12px}
    .err-msg ul{margin:6px 0 0;padding-left:18px}

    /* Utilidades */
    .inline-date{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
    .inline-date input[type="date"]{padding:6px 8px}
    .w-180{width:180px}

    /* Aparência readonly */
    .readonly{
      background:#eef2ff !important;
      color:#6b7280 !important;
      cursor:not-allowed !important;
    }
    #statusContrato.readonly, #prazoAntecipacaoSel.readonly{pointer-events:none;touch-action:none}

    /* CEP shimmer */
    input[name="cep"].is-loading{
      background-image:linear-gradient(90deg,#f3f4f6 25%,#e5e7eb 37%,#f3f4f6 63%);
      background-size:400% 100%; animation:s 1.4s ease infinite;
    }
    @keyframes s{0%{background-position:100% 50%}100%{background-position:0 50%}}

    .form-actions-top .btn{min-width:140px}
    .form-actions-bottom{display:flex;justify-content:flex-end;gap:10px;margin-top:16px}
    .form-actions-bottom .btn{min-width:160px}
    .hint{font-size:12px;color:var(--muted)}

    /* ========= NOVO: segmentação interna ========= */
    .seg{
      border:1px dashed rgba(37,99,235,.25);
      background:#f8fbff;
      border-radius:12px;
      padding:12px;
      margin:8px 0;
    }
    .seg-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}
    .seg-1{display:grid;grid-template-columns:1fr;gap:12px}
    @media (max-width:780px){ .seg-grid{grid-template-columns:1fr} }

    /* ========= Uploader ========= */
    .docs-actions{display:flex;align-items:center;gap:10px;margin-bottom:10px}
    .docs-list{list-style:none;margin:0;padding:0;display:grid;grid-template-columns:1fr;gap:8px}
    .docs-item{
      display:flex;align-items:center;justify-content:space-between;gap:12px;
      padding:10px 12px;border:1px dashed var(--border);border-radius:10px;background:var(--field)
    }
    .docs-item .info{display:flex;align-items:center;gap:10px;min-width:0}
    .docs-item .info i{color:var(--brand)}
    .docs-item .meta{font-size:12px;color:var(--muted)}
    .docs-item .name{font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:42vw}

    .docs-remove{
      border:1px solid rgba(239,68,68,.45);
      background:#fff;
      color:var(--bad);
      border-radius:8px;
      padding:6px 10px;
      cursor:pointer;
      font-weight:700;
      display:inline-flex;
      align-items:center;
      gap:8px;
    }
    .docs-remove i{color:var(--bad)}
    .docs-remove:hover{border-color:var(--bad);box-shadow:0 0 0 3px rgba(239,68,68,.12)}
    .docs-remove:focus{outline:3px solid rgba(239,68,68,.25)}
    .docs-summary{font-size:12px;color:var(--muted)}
  </style>
</head>
<body>
  <div class="wrap">
    <!-- ===== Cabeçalho com usuário + botões ===== -->
    <div class="header">
      <div class="title">Cadastro de Associado — AGENTE</div>

      <div class="btn-group form-actions-top">
        <div class="user-chip" title="Usuário logado">
          <i class="fas fa-user"></i>
          <span>Agente: <strong>{{ auth()->user()->name ?? 'Usuário' }}</strong></span>
        </div>

        <a href="{{ route('agente.contratos') }}" class="btn btn-mini {{ request()->routeIs('agente.contratos') ? 'btn-primary' : '' }}">
          <i class="fas fa-file-signature"></i> Meus contratos
        </a>

        <a href="{{ route('agente.pendencias') }}" class="btn btn-mini">
          <i class="fas fa-file-circle-question"></i> Pendências de documentação
        </a>

        <!-- Evita que validação do formulário principal bloqueie o logout -->
        <form method="POST" action="{{ route('logout') }}" novalidate>
          @csrf
          <button class="btn btn-mini" type="submit" formnovalidate>
            <i class="fas fa-sign-out-alt"></i> Sair
          </button>
        </form>
      </div>
    </div>

    @if (session('ok'))
      <div class="ok-msg">{{ session('ok') }}</div>
    @endif

    @if ($errors->any())
      <div class="err-msg" role="alert">
        <strong>Erros:</strong>
        <ul>
          @foreach ($errors->all() as $e)
            <li>{{ $e }}</li>
          @endforeach
        </ul>
      </div>
    @endif

    <!-- ===== FORM ===== -->
    <form id="formAgente" method="POST" action="{{ route('agente.cadastro.store') }}" enctype="multipart/form-data" novalidate>
      @csrf

      <!-- ===== Dados Cadastrais ===== -->
      <fieldset>
        <legend>Dados Cadastrais</legend>

        <div class="seg seg-grid">
          <label>Tipo de Documento
            <select name="docType" id="docType" required aria-required="true">
              <option value="CPF" {{ old('docType')==='CPF'?'selected':'' }}>CPF</option>
              <option value="CNPJ" {{ old('docType')==='CNPJ'?'selected':'' }}>CNPJ</option>
            </select>
          </label>

          <label>CPF/CNPJ
            <input
              type="text"
              class="w-180"
              id="cpfCnpj"
              name="cpfCnpj"
              inputmode="numeric"
              autocomplete="off"
              value="{{ old('cpfCnpj') }}"
              placeholder="___.___.___-__"
              required
              aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>RG
            <input type="text" name="rg" value="{{ old('rg') }}" required aria-required="true">
          </label>

          <label>Órgão Expedidor
            <input type="text" name="orgaoExpedidor" value="{{ old('orgaoExpedidor') }}" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-1">
          <label>Nome/Razão Social
            <input type="text" name="fullName" value="{{ old('fullName') }}" placeholder="Nome completo" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-1">
          <div class="inline-date">
            <label style="margin:0">Data de nascimento (dd/mm/aaaa)
              <input type="text" id="birthDateText" name="birthDate" class="w-180" inputmode="numeric" autocomplete="off"
                     value="{{ old('birthDate') }}" placeholder="dd/mm/aaaa" maxlength="10" required aria-required="true">
            </label>
          </div>
        </div>

        <div class="seg seg-grid">
          <label>Profissão
            <input type="text" name="profession" value="{{ old('profession') }}" required aria-required="true">
          </label>

          <label>Estado civil
            <select name="maritalStatus" required aria-required="true">
              <option value="" disabled {{ old('maritalStatus') ? '' : 'selected' }}>Selecione</option>
              <option value="single"   {{ old('maritalStatus')==='single'?'selected':'' }}>Solteiro(a)</option>
              <option value="married"  {{ old('maritalStatus')==='married'?'selected':'' }}>Casado(a)</option>
              <option value="divorced" {{ old('maritalStatus')==='divorced'?'selected':'' }}>Divorciado(a)</option>
              <option value="widowed"  {{ old('maritalStatus')==='widowed'?'selected':'' }}>Viúvo(a)</option>
            </select>
          </label>
        </div>
      </fieldset>

      <!-- ===== Endereço ===== -->
      <fieldset>
        <legend>Endereço</legend>

        <div class="seg seg-grid">
          <label>CEP
            <input type="text" name="cep" value="{{ old('cep') }}" placeholder="00000-000" inputmode="numeric" maxlength="9" required aria-required="true">
          </label>

          <label>Endereço
            <input type="text" name="address" value="{{ old('address') }}" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Nº
            <input type="text" name="addressNumber" value="{{ old('addressNumber') }}" required aria-required="true">
          </label>

          <label>Complemento
            <input type="text" name="complement" value="{{ old('complement') }}" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Bairro
            <input type="text" name="neighborhood" value="{{ old('neighborhood') }}" required aria-required="true">
          </label>

          <label>Cidade
            <input type="text" name="city" value="{{ old('city') }}" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-1">
          <label>UF
            <select name="uf" required aria-required="true">
              <option value="" disabled {{ old('uf') ? '' : 'selected' }}>Selecione</option>
              @php $ufs = ['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO']; @endphp
              @foreach ($ufs as $uf)
                <option value="{{ strtolower($uf) }}" {{ old('uf')===strtolower($uf)?'selected':'' }}>{{ $uf }}</option>
              @endforeach
            </select>
          </label>
        </div>
      </fieldset>

      <!-- ===== DADOS BANCÁRIOS (NOVO) ===== -->
      <fieldset>
        <legend>Dados Bancários</legend>

        <div class="seg seg-grid">
          <label>Banco
            <input type="text" name="bank_name" value="{{ old('bank_name') }}" placeholder="Ex.: Banco do Brasil" required aria-required="true">
          </label>

          <label>Agência
            <input type="text" name="bank_agency" value="{{ old('bank_agency') }}" placeholder="Ex.: 0001-9" inputmode="numeric" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Conta
            <input type="text" name="bank_account" value="{{ old('bank_account') }}" placeholder="Ex.: 123456-7" inputmode="numeric" required aria-required="true">
          </label>

          <label>Tipo de Conta
            <select name="account_type" required aria-required="true">
              <option value="" disabled {{ old('account_type') ? '' : 'selected' }}>Selecione</option>
              <option value="corrente" {{ old('account_type')==='corrente'?'selected':'' }}>Corrente</option>
              <option value="poupanca" {{ old('account_type')==='poupanca'?'selected':'' }}>Poupança</option>
            </select>
          </label>
        </div>

        <div class="seg seg-1">
          <label>Chave Pix
            <input type="text" name="pix_key" value="{{ old('pix_key') }}" placeholder="CPF/CNPJ, e-mail, celular ou chave aleatória" required aria-required="true">
            <span class="hint">Use a chave PIX principal do associado para futuros pagamentos.</span>
          </label>
        </div>
      </fieldset>

      <!-- ===== Contato / Vínculo Público ===== -->
      <fieldset>
        <legend>Contato e Vínculo Público</legend>

        <div class="seg seg-grid">
          <label>Celular
            <input type="text" name="cellphone" value="{{ old('cellphone') }}" required aria-required="true">
          </label>
          <label>E-mail
            <input type="email" name="email" value="{{ old('email') }}" placeholder="email@dominio.com" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Órgão Público
            <input type="text" name="orgaoPublico" value="{{ old('orgaoPublico') }}" required aria-required="true">
          </label>

          <label>Situação do Servidor
            <select name="situacaoServidor" required aria-required="true">
              <option value="" disabled {{ old('situacaoServidor') ? '' : 'selected' }}>Selecione</option>
              @foreach (['Ativo','Aposentado','Pensionista','Comissionado','Contratado'] as $opt)
                <option value="{{ $opt }}" {{ old('situacaoServidor')===$opt?'selected':'' }}>{{ $opt }}</option>
              @endforeach
            </select>
          </label>
        </div>

        <div class="seg seg-1">
          <label>Matrícula do Servidor Público
            <input
              type="text"
              name="matriculaServidorPublico"
              value="{{ old('matriculaServidorPublico') }}"
              required
              aria-required="true">
          </label>
        </div>
      </fieldset>

      <!-- ===== Dados para cálculo (pré-validação) ===== -->
      <fieldset>
        <legend>Dados para cálculo de margem (pré-validação)</legend>

        <div class="seg seg-grid">
          <label>Valor Bruto Total
            <input class="js-money" type="text" id="calcValorBruto" name="calc[valor_bruto]"
                   value="{{ old('calc.valor_bruto') }}" placeholder="R$ 5.000,00"
                   autocomplete="off" inputmode="numeric" required aria-required="true">
          </label>

          <label>Valor Líquido (contra-cheque)
            <input class="js-money" type="text" id="calcLiquidoCc" name="calc[liquido_cc]"
                   value="{{ old('calc.liquido_cc') }}" placeholder="R$ 2.500,00"
                   autocomplete="off" inputmode="numeric" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Prazo de Antecipação (meses)
            <select id="prazoAntecipacaoSel" class="readonly" disabled aria-readonly="true" style="-webkit-appearance:none;-moz-appearance:none;appearance:none;background-image:none;padding-right:0;">
              <option value="3" selected>3</option>
            </select>
            <input type="hidden" name="calc[prazo_antecipacao]" id="prazoAntecipacaoHidden" value="3">
          </label>

          <label>30% do Bruto
            <input type="text" id="calcTrintaBruto" class="readonly" readonly
                   value="{{ old('calc.trinta_bruto') }}">
          </label>
        </div>

        <div class="seg seg-1">
          <label>Margem (Líquido - 30% do Bruto)
            <input type="text" id="calcMargem" class="readonly" readonly
                   value="{{ old('calc.margem') }}">
          </label>
        </div>
      </fieldset>

      <script>
        // Converte um input BRL (com máscara) para número
        function brlInputToNumber(el) {
          if (!el) return 0;
          const digits = (el.value || '').replace(/\D/g, '');
          if (!digits) return 0;
          return parseInt(digits, 10) / 100;
        }
        function numberToBRL(n) {
          n = Number(n || 0);
          const neg = n < 0 ? '-' : '';
          n = Math.abs(n);
          const ints  = Math.trunc(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
          const cents = Math.round((n - Math.trunc(n)) * 100).toString().padStart(2, '0');
          return `${neg}R$ ${ints},${cents}`;
        }
        const elBruto  = document.getElementById('calcValorBruto');
        const elLiq    = document.getElementById('calcLiquidoCc');
        const el30B    = document.getElementById('calcTrintaBruto');
        const elMargem = document.getElementById('calcMargem');
        function recompute() {
          const bruto = brlInputToNumber(elBruto);
          const liq   = brlInputToNumber(elLiq);
          const trinta = Math.round(bruto * 0.30 * 100) / 100;
          const margem = Math.round((liq - trinta) * 100) / 100;
          el30B.value    = bruto ? numberToBRL(trinta) : '';
          elMargem.value = (bruto || liq) ? numberToBRL(margem) : '';
        }
        function afterMaskRecompute() { setTimeout(recompute, 0); }
        if (elBruto) {
          elBruto.addEventListener('input', afterMaskRecompute, {passive:true});
          elBruto.addEventListener('change', recompute, {passive:true});
          elBruto.addEventListener('blur', recompute, {passive:true});
        }
        if (elLiq) {
          elLiq.addEventListener('input', afterMaskRecompute, {passive:true});
          elLiq.addEventListener('change', recompute, {passive:true});
          elLiq.addEventListener('blur', recompute, {passive:true});
        }
        recompute();
      </script>

      <!-- ===== Detalhes do Contrato ===== -->
      <fieldset>
        <legend>Detalhes do Contrato</legend>

        <div class="seg seg-grid">
          <label>Mensalidade Associativa (R$)
            <input class="js-money" type="text" id="contratoMensalidade" name="contrato[mensalidade]"
                   value="{{ old('contrato.mensalidade') }}" placeholder="R$ 0,00" autocomplete="off" inputmode="numeric" required aria-required="true">
          </label>

          <label>Taxa de Antecipação (%)
            <input type="text" id="taxaAntecipacaoVis"
                   value="{{ old('contrato.taxaAntecipacao','30,00') }}"
                   class="readonly" readonly aria-readonly="true" placeholder="30,00">
            <input type="hidden" name="contrato[taxaAntecipacao]" id="taxaAntecipacaoHidden" value="30,00">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Disponível (R$)
            <input class="js-money readonly" type="text" id="contratoMargemDisponivel" name="contrato[margemDisponivel]"
                   value="{{ old('contrato.margemDisponivel') }}" placeholder="R$ 0,00" readonly aria-readonly="true" required aria-required="true">
          </label>

          <label>Valor Total Antecipação (R$)
            <input class="js-money readonly" type="text" id="contratoValorAntecipacao" name="contrato[valorAntecipacao]"
                   value="{{ old('contrato.valorAntecipacao') }}" placeholder="R$ 0,00" readonly aria-readonly="true" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Data da Aprovação (dd/mm/aaaa)
            <input type="text" name="contrato[dataAprovacao]" class="js-date-br"
                   value="{{ old('contrato.dataAprovacao') }}" placeholder="00/00/0000"
                   inputmode="numeric" maxlength="10" pattern="\d{2}/\d{2}/\d{4}" required aria-required="true">
          </label>

          <label>Data da primeira mensalidade (dd/mm/aaaa)
            <input type="text" name="contrato[dataEnvioPrimeira]" id="dataPrimeiraMensalidade" class="js-date-br"
                   value="{{ old('contrato.dataEnvioPrimeira') }}" placeholder="00/00/0000"
                   inputmode="numeric" maxlength="10" pattern="\d{2}/\d{2}/\d{4}" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-grid">
          <label>Status
            <input type="text" id="statusContratoView" value="Pendente" class="readonly" readonly aria-readonly="true">
            <input type="hidden" name="contrato[statusContrato]" id="statusContratoHidden" value="Pendente">
          </label>

          <label>Mês de Averbação (aaaa-mm)
            <input type="month" name="contrato[mesAverbacao]" value="{{ old('contrato.mesAverbacao') }}" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-1">
          <label>Doação do Associado (R$)
            <input class="js-money" type="text" id="contratoDoacaoAssociado" name="contrato[doacaoAssociado]"
                   value="{{ old('contrato.doacaoAssociado') }}" placeholder="R$ 0,00" autocomplete="off" inputmode="numeric" required aria-required="true">
          </label>
        </div>
      </fieldset>

      <!-- ===== ANTECIPAÇÕES ===== -->
      <fieldset>
        <legend>Antecipações (até 3 linhas para teste)</legend>

        @for ($i = 0; $i < 3; $i++)
          <div class="seg seg-1 ant-linha" data-index="{{ $i }}">
            <p style="margin:0 0 8px"><strong>Linha {{ $i + 1 }}</strong></p>

            <div class="seg-grid">
              <label>Nº Mensalidade
                <input type="number" min="1" id="ant{{ $i }}_num"
                       name="anticipations[{{ $i }}][numeroMensalidade]"
                       value="{{ old("anticipations.$i.numeroMensalidade") }}" required aria-required="true">
              </label>

              <label>Valor (R$)
                <input class="js-money" type="text" id="ant{{ $i }}_valor"
                       name="anticipations[{{ $i }}][valorAuxilio]"
                       value="{{ old("anticipations.$i.valorAuxilio") }}" required aria-required="true">
              </label>
            </div>

            <div class="seg-grid">
              <label>Vencimento (dd/mm/aaaa)
                <input type="text" class="js-date-br" id="ant{{ $i }}_venc"
                       name="anticipations[{{ $i }}][dataEnvio]"
                       value="{{ old("anticipations.$i.dataEnvio") }}"
                       placeholder="00/00/0000" inputmode="numeric" maxlength="10" pattern="\d{2}/\d{2}/\d{4}" required aria-required="true">
              </label>

              <label>Status
                <input type="text" id="ant{{ $i }}_status_view" value="Pendente" class="readonly" readonly aria-readonly="true">
                <input type="hidden" name="anticipations[{{ $i }}][status]" id="ant{{ $i }}_status" value="Pendente">
              </label>
            </div>

            <div class="seg-1">
              <label>Observação
                <input type="text" id="ant{{ $i }}_obs"
                       name="anticipations[{{ $i }}][observacao]"
                       value="{{ old("anticipations.$i.observacao") }}" required aria-required="true">
              </label>
            </div>
          </div>
        @endfor
      </fieldset>

      <script>
        /* ===================== utils BRL ===================== */
        function moneyToNumberBR(str){ const dg=(str||'').replace(/[^\d]/g,''); return dg? (parseInt(dg,10)/100) : 0; }
        function numberToMoneyBR(v){
          const cents=Math.round((v||0)*100);
          let s=String(cents).padStart(3,'0');
          const int=s.slice(0,-2).replace(/\B(?=(\d{3})+(?!\d))/g,'.'), dec=s.slice(-2);
          return `R$ ${int},${dec}`;
        }
        const mensalidadeInp = document.getElementById('contratoMensalidade');
        const totalInp       = document.getElementById('contratoValorAntecipacao');
        const dispInp        = document.getElementById('contratoMargemDisponivel');
        const doacaoInp      = document.getElementById('contratoDoacaoAssociado');
        function recalcContratoValores(){
          const mensalidade = moneyToNumberBR(mensalidadeInp && mensalidadeInp.value);
          const total       = mensalidade * 3;
          const disponivel  = total * 0.70;
          const doacao      = total * 0.30;
          if (totalInp) totalInp.value = numberToMoneyBR(total);
          if (dispInp)  dispInp.value  = numberToMoneyBR(disponivel);
          if (doacaoInp && !doacaoInp.dataset.userEdited) doacaoInp.value = numberToMoneyBR(doacao);
          syncAntValoresComMensalidade(mensalidade);
        }
        mensalidadeInp?.addEventListener('input', recalcContratoValores, {passive:true});
        mensalidadeInp?.addEventListener('blur',  recalcContratoValores, {passive:true});
        doacaoInp?.addEventListener('input', ()=> doacaoInp.dataset.userEdited = '1');
        recalcContratoValores();
        document.getElementById('formAgente')?.addEventListener('submit', recalcContratoValores);

        /* ===================== máscara de data dd/mm/aaaa ===================== */
        function formatDateBRFromDigits(dg){
          dg=(dg||'').replace(/\D/g,'').slice(0,8);
          const p1=dg.slice(0,2), p2=dg.slice(2,4), p3=dg.slice(4,8);
          let out=''; if(p1) out=p1; if(p2) out+=(out?'/':'')+p2; if(p3) out+=(out?'/':'')+p3; return out;
        }
        function attachDateMask(el){
          if(!el) return;
          el.setAttribute('inputmode','numeric'); el.setAttribute('maxlength','10');
          el.value = formatDateBRFromDigits(el.value);
          el.addEventListener('input', ()=>{
            el.value = formatDateBRFromDigits(el.value);
            const len=el.value.length; el.setSelectionRange(len,len);
          }, {passive:true});
          el.addEventListener('paste',(e)=>{
            e.preventDefault();
            const t=(e.clipboardData||window.clipboardData).getData('text')||'';
            el.value = formatDateBRFromDigits(t);
          });
          el.addEventListener('keydown',(e)=>{
            if(['Backspace','Delete','Tab','ArrowLeft','ArrowRight','Home','End','Enter'].includes(e.key)) return;
            if(!/^\d$/.test(e.key)) e.preventDefault();
          });
        }
        document.querySelectorAll('.js-date-br').forEach(attachDateMask);

        /* ===================== helpers de data ===================== */
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
          let d = new Date(year, monthIndex, 1);
          let count = 0;
          while (true){
            const wd = d.getDay(); // 0=Dom, 6=Sáb
            if (wd !== 0 && wd !== 6) {
              count++;
              if (count === 5) return d;
            }
            d = new Date(d.getFullYear(), d.getMonth(), d.getDate()+1);
          }
        }

        /* ===================== ANTECIPAÇÕES: datas, status e valores ===================== */
        const primeiraDataInp = document.getElementById('dataPrimeiraMensalidade');

        for (let i=0;i<3;i++){
          const v = document.getElementById(`ant${i}_valor`);
          v?.addEventListener('input', () => v.dataset.userEdited = '1');
        }

        function syncAntValoresComMensalidade(mensalidadeNumero){
          for (let i=0;i<3;i++){
            const v = document.getElementById(`ant${i}_valor`);
            if (v && !v.dataset.userEdited) v.value = numberToMoneyBR(mensalidadeNumero || 0);
          }
        }

        function setAntDatesFromBase(base){
          for(let i=0;i<3;i++){
            const venc = document.getElementById(`ant${i}_venc`);
            if (!venc) continue;
            let d;
            if (i === 0) {
              d = new Date(base.getFullYear(), base.getMonth(), base.getDate());
            } else {
              d = fifthBusinessDayOfMonth(base.getFullYear(), base.getMonth() + i);
            }
            venc.value = fmtBR(d);
          }
        }

        function seedAnticipations(){
          const base = parseDateBR(primeiraDataInp?.value);
          if(base){
            for(let i=0;i<3;i++){
              const venc = document.getElementById(`ant${i}_venc`);
              if (venc && !venc.value){
                let d;
                if (i === 0) d = base;
                else d = fifthBusinessDayOfMonth(base.getFullYear(), base.getMonth() + i);
                venc.value = fmtBR(d);
              }
            }
          }
          for(let i=0;i<3;i++){
            const num = document.getElementById(`ant${i}_num`);
            if (num && !num.value) num.value = i+1;
          }
          syncAntValoresComMensalidade(moneyToNumberBR(mensalidadeInp?.value));
        }

        seedAnticipations();
        primeiraDataInp?.addEventListener('change', ()=>{
          const base = parseDateBR(primeiraDataInp.value);
          if(!base) return;
          setAntDatesFromBase(base);
        });
      </script>

      <!-- ===== Agente / Filial ===== -->
      <fieldset>
        <legend>Agente / Filial</legend>
        <div class="seg seg-1">
          <label>Agente Responsável
            <input type="text" name="agente[responsavel]" value="{{ old('agente.responsavel', Auth::user()->name) }}" class="readonly" readonly
                   placeholder="Deixe em branco para usar seu nome" aria-readonly="true" required aria-required="true">
          </label>
        </div>
      </fieldset>

      <!-- ===== Observações ===== -->
      <fieldset>
        <legend>Observações</legend>
        <div class="seg seg-1">
          <textarea name="observacoes" rows="4" required aria-required="true">{{ old('observacoes') }}</textarea>
        </div>
      </fieldset>

      <!-- ===== Auxílio do Agente ===== -->
      <fieldset>
        <legend>Auxílio do Agente</legend>

        <div class="seg seg-grid">
          <label>Taxa (%)
            <input type="text" id="auxTaxa" name="auxilioAgente[taxa]" value="10,00"
                   class="readonly" readonly aria-readonly="true" placeholder="ex.: 10,00" required aria-required="true">
          </label>

          <label>Data do Envio (dd/mm/aaaa)
            <input type="text" id="auxDataEnvio" name="auxilioAgente[dataEnvio]"
                   value="{{ old('auxilioAgente.dataEnvio') }}" placeholder="00/00/0000"
                   class="js-date-br" inputmode="numeric" maxlength="10"
                   pattern="\d{2}/\d{2}/\d{4}" required aria-required="true">
          </label>
        </div>

        <div class="seg seg-1">
          <label>Status
            <input type="text" id="auxStatus" value="Pendente" class="readonly" readonly aria-readonly="true">
            <input type="hidden" name="auxilioAgente[status]" value="Pendente">
          </label>
        </div>
      </fieldset>

      <script>
        /* === Máscara + Validação para "Data do Envio" (dd/mm/aaaa) === */
        (function(){
          const el = document.getElementById('auxDataEnvio');
          if (!el) return;

          function _formatDateBR(dg){
            dg = (dg || '').replace(/\D/g,'').slice(0,8);
            const a = dg.slice(0,2), b = dg.slice(2,4), c = dg.slice(4,8);
            return [a,b,c].filter(Boolean).join('/');
          }
          function _attachMask(input){
            input.setAttribute('inputmode','numeric');
            input.setAttribute('maxlength','10');
            input.value = _formatDateBR(input.value);
            input.addEventListener('input', () => {
              input.value = _formatDateBR(input.value);
              const L = input.value.length; input.setSelectionRange(L, L);
            }, {passive:true});
            input.addEventListener('paste', (e) => {
              e.preventDefault();
              const t = (e.clipboardData || window.clipboardData).getData('text') || '';
              input.value = _formatDateBR(t);
            });
            input.addEventListener('keydown', (e) => {
              if (['Backspace','Delete','Tab','ArrowLeft','ArrowRight','Home','End','Enter'].includes(e.key)) return;
              if (!/^\d$/.test(e.key)) e.preventDefault();
            });
          }
          function parseDateBR(s){
            const m = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec((s||'').trim());
            if (!m) return null;
            const d = new Date(+m[3], +m[2]-1, +m[1]);
            return (d && d.getFullYear()==+m[3] && d.getMonth()==(+m[2]-1) && d.getDate()==+m[1]) ? d : null;
          }
          function validate(){
            const ok = !!parseDateBR(el.value); // agora obrigatório
            el.setCustomValidity(ok ? '' : 'Informe uma data válida no formato dd/mm/aaaa.');
            if (!ok) el.reportValidity?.();
            return ok;
          }

          if (typeof attachDateMask === 'function') attachDateMask(el); else _attachMask(el);
          el.addEventListener('blur', validate, {passive:true});
          document.getElementById('formAgente')?.addEventListener('submit', (e) => {
            if (!validate()) e.preventDefault();
          });
        })();
      </script>

      <!-- ===== DOCUMENTOS ===== -->
      <fieldset id="docs-section">
        <legend>Documentos (imagem ou PDF — até 10MB cada)</legend>

        <div class="doc-grid">
          <div class="doc-item">
            <label for="cpf_frente">Documento (frente)</label>
            <input
              type="file"
              id="cpf_frente"
              name="cpf_frente"
              accept=".jpg,.jpeg,.png,.webp,.pdf"
              required
              aria-required="true"
            />
            <div class="doc-preview" data-for="cpf_frente"></div>
          </div>

          <div class="doc-item">
            <label for="cpf_verso">Documento (verso)</label>
            <input
              type="file"
              id="cpf_verso"
              name="cpf_verso"
              accept=".jpg,.jpeg,.png,.webp,.pdf"
              required
              aria-required="true"
            />
            <div class="doc-preview" data-for="cpf_verso"></div>
          </div>

          <div class="doc-item">
            <label for="comp_endereco">Comprovante de endereço</label>
            <input
              type="file"
              id="comp_endereco"
              name="comp_endereco"
              accept=".jpg,.jpeg,.png,.webp,.pdf"
              required
              aria-required="true"
            />
            <div class="doc-preview" data-for="comp_endereco"></div>
          </div>

          <div class="doc-item">
            <label for="comp_renda">Comprovante de renda</label>
            <input
              type="file"
              id="comp_renda"
              name="comp_renda"
              accept=".jpg,.jpeg,.png,.webp,.pdf"
              required
              aria-required="true"
            />
            <div class="doc-preview" data-for="comp_renda"></div>
          </div>

          <div class="doc-item">
            <label for="contracheque_atual">Contracheque atual</label>
            <input
              type="file"
              id="contracheque_atual"
              name="contracheque_atual"
              accept=".jpg,.jpeg,.png,.webp,.pdf"
              required
              aria-required="true"
            />
            <div class="doc-preview" data-for="contracheque_atual"></div>
          </div>

          <div class="doc-item">
            <label for="termo_adesao">Termo de Adesão</label>
            <input
              type="file"
              id="termo_adesao"
              name="termo_adesao"
              accept=".jpg,.jpeg,.png,.webp,.pdf"
              required
              aria-required="true"
            />
            <div class="doc-preview" data-for="termo_adesao"></div>
          </div>

          <div class="doc-item">
            <label for="termo_antecipacao">Termo de Antecipação</label>
            <input
              type="file"
              id="termo_antecipacao"
              name="termo_antecipacao"
              accept=".jpg,.jpeg,.png,.webp,.pdf"
              required
              aria-required="true"
            />
            <div class="doc-preview" data-for="termo_antecipacao"></div>
          </div>
        </div>

        <noscript>
          <p>Selecione uma imagem ou PDF (máx. 10MB).</p>
        </noscript>
      </fieldset>

      <style>
        #docs-section legend { font-weight: 700; }
        .doc-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
          gap: 12px;
        }
        .doc-item {
          background: var(--panel);
          border: 1px solid var(--border);
          border-radius: 10px;
          padding: 10px;
        }
        .doc-item label {
          display: block;
          margin-bottom: 8px;
          font-weight: 600;
          color: var(--ink);
        }
        .doc-item input[type="file"] {
          width: 100%;
          padding: 8px;
          border-radius: 8px;
          background: var(--field);
          color: var(--ink);
          border: 1px solid var(--border);
        }
        .doc-preview { margin-top: 8px; }
        .doc-preview .thumb {
          display: flex;
          align-items: center;
          gap: 10px;
          border: 1px dashed var(--border);
          background: var(--field);
          border-radius: 10px;
          padding: 8px;
        }
        .doc-preview img {
          width: 56px;
          height: 56px;
          object-fit: cover;
          border-radius: 8px;
        }
        .doc-preview .pdf {
          width: 56px;
          height: 56px;
          display: flex;
          align-items: center;
          justify-content: center;
          border-radius: 8px;
          border: 1px solid var(--border);
          background: var(--brand-50);
          color: var(--brand-600);
          font-weight: 800;
          letter-spacing: .5px;
        }
        .doc-preview .meta { font-size: 12px; color: var(--muted); }
        .doc-preview .name { color: var(--ink); font-weight: 600; font-size: 13px; }
        .doc-preview .clear {
          margin-left: auto;
          border: 1px solid var(--border);
          background: var(--panel);
          color: var(--ink);
          padding: 6px 10px;
          border-radius: 8px;
          cursor: pointer;
          font-weight: 600;
        }
        .doc-preview .clear:hover {
          border-color: var(--brand);
          box-shadow: 0 0 0 3px var(--brand-50);
        }
        .err-doc-msg {
          color: #b91c1c;
          background: #fee2e2;
          border: 1px solid #fecaca;
          padding: 8px 10px;
          border-radius: 8px;
          font-size: 12px;
        }
      </style>

      <script>
        (function () {
          const MAX = 10 * 1024 * 1024; // 10MB
          const ALLOWED = ["image/jpeg", "image/png", "image/webp", "application/pdf"];
          const REQUIRED_IDS = [
            "cpf_frente",
            "cpf_verso",
            "comp_endereco",
            "comp_renda",
            "contracheque_atual",
            "termo_adesao",
            "termo_antecipacao",
          ];

          function showError(preview, msg) {
            if (!preview) return;
            preview.innerHTML = `<div class="err-doc-msg">${msg}</div>`;
          }

          function clearError(preview) {
            if (!preview) return;
            const err = preview.querySelector(".err-doc-msg");
            if (err) err.remove();
          }

          function setupSingleImageInput(id) {
            const input = document.getElementById(id);
            const preview = document.querySelector(`.doc-preview[data-for="${id}"]`);
            if (!input || !preview) return;

            input.addEventListener("change", () => {
              preview.innerHTML = "";
              const f = input.files && input.files[0];
              if (!f) {
                input.setCustomValidity("Selecione um arquivo (imagem ou PDF).");
                showError(preview, "Campo obrigatório. Selecione um arquivo (imagem ou PDF).");
                return;
              }

              if (!ALLOWED.includes(f.type)) {
                input.value = "";
                input.setCustomValidity("Tipo inválido. Envie JPG, PNG, WEBP ou PDF.");
                showError(preview, "Tipo inválido. Envie JPG, PNG, WEBP ou PDF.");
                return;
              }

              if (f.size > MAX) {
                input.value = "";
                input.setCustomValidity("Arquivo maior que 10MB.");
                showError(preview, "Arquivo maior que 10MB.");
                return;
              }

              input.setCustomValidity("");
              const sizeKB = (f.size / 1024).toFixed(1).replace(".", ",");

              let mediaThumb = "";
              if (f.type === "application/pdf") {
                mediaThumb = `<div class="pdf">PDF</div>`;
              } else {
                const url = URL.createObjectURL(f);
                mediaThumb = `<img src="${url}" alt="Pré-visualização" />`;
              }

              preview.innerHTML = `
                <div class="thumb">
                  ${mediaThumb}
                  <div class="meta">
                    <div class="name">${f.name}</div>
                    <div class="size">${sizeKB} KB • ${f.type || "desconhecido"}</div>
                  </div>
                  <button type="button" class="clear" data-target="${id}">Remover</button>
                </div>
              `;
            });
          }

          REQUIRED_IDS.forEach(setupSingleImageInput);

          // Remover arquivo escolhido
          document.addEventListener("click", (e) => {
            const btn = e.target.closest(".clear");
            if (!btn) return;
            const id = btn.getAttribute("data-target");
            const input = document.getElementById(id);
            const preview = document.querySelector(`.doc-preview[data-for="${id}"]`);
            if (input) {
              input.value = "";
              input.setCustomValidity("Selecione um arquivo (imagem ou PDF).");
            }
            if (preview) {
              showError(preview, "Campo obrigatório. Selecione um arquivo (imagem ou PDF).");
            }
          });

          // Validação no submit
          const form = document.getElementById("formAgente") || document.querySelector("form");

          if (form) {
            form.addEventListener("submit", (e) => {
              let firstInvalid = null;

              REQUIRED_IDS.forEach((id) => {
                const input = document.getElementById(id);
                const preview = document.querySelector(`.doc-preview[data-for="${id}"]`);
                if (!input) return;

                if (!input.files || !input.files.length) {
                  input.setCustomValidity("Selecione um arquivo (imagem ou PDF).");
                  showError(preview, "Campo obrigatório. Selecione um arquivo (imagem ou PDF).");
                  if (!firstInvalid) firstInvalid = input;
                } else {
                  clearError(preview);
                  const f = input.files[0];
                  if (!ALLOWED.includes(f.type)) {
                    input.setCustomValidity("Tipo inválido. Envie JPG, PNG, WEBP ou PDF.");
                    showError(preview, "Tipo inválido. Envie JPG, PNG, WEBP ou PDF.");
                    if (!firstInvalid) firstInvalid = input;
                  } else if (f.size > MAX) {
                    input.setCustomValidity("Arquivo maior que 10MB.");
                    showError(preview, "Arquivo maior que 10MB.");
                    if (!firstInvalid) firstInvalid = input;
                  } else {
                    input.setCustomValidity("");
                  }
                }
              });

              if (firstInvalid) {
                e.preventDefault();
                firstInvalid.reportValidity?.();
                firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
              }
            });
          }
        })();
      </script>

      <!-- ===== Ações finais do formulário ===== -->
      <div class="form-actions-bottom">
        <button class="btn btn-primary" type="submit">
          <i class="fas fa-paper-plane"></i> Enviar Cadastro
        </button>
      </div>
    </form>

    <form id="logout-form" method="POST" action="{{ route('logout') }}" style="display:none" novalidate>@csrf</form>

    <script>
      /* ===== Utils ===== */
      const onlyDigits = (s) => (s||'').replace(/\D+/g,'');
      const pad2 = (n) => (n+'').padStart(2,'0');

      /* ===== CPF/CNPJ mask ===== */
      const docTypeSel = document.getElementById('docType');
      const cpfCnpjInp = document.getElementById('cpfCnpj');
      function maskCPF(v){
        v = onlyDigits(v).slice(0,11);
        v = v.replace(/^(\d{3})(\d)/, '$1.$2');
        v = v.replace(/^(\d{3})\.(\d{3})(\d)/, '$1.$2.$3');
        v = v.replace(/^(\d{3})\.(\d{3})\.(\d{3})(\d)/, '$1.$2.$3-$4');
        return v;
      }
      function maskCNPJ(v){
        v = onlyDigits(v).slice(0,14);
        v = v.replace(/^(\d{2})(\d)/, '$1.$2');
        v = v.replace(/^(\d{2})\.(\d{3})(\d)/, '$1.$2.$3');
        v = v.replace(/^(\d{2})\.(\d{3})\.(\d{3})(\d)/, '$1.$2.$3/$4');
        v = v.replace(/^(\d{2})\.(\d{3})\.(\d{3})\/(\d{4})(\d)/, '$1.$2.$3/$4-$5');
        return v;
      }
      function applyDocMask(){
        const type = (docTypeSel.value || 'CPF').toUpperCase();
        const raw = cpfCnpjInp.value;
        cpfCnpjInp.value = (type === 'CNPJ') ? maskCNPJ(raw) : maskCPF(raw);
        cpfCnpjInp.placeholder = (type === 'CNPJ') ? '__.___.___/____-__' : '___.___.___-__';
        cpfCnpjInp.maxLength = (type === 'CNPJ') ? 18 : 14;
      }
      docTypeSel.addEventListener('change', applyDocMask, {passive:true});
      cpfCnpjInp.addEventListener('input', applyDocMask, {passive:true});
      applyDocMask();

      /* ===== Birthdate: mask dd/mm/aaaa ===== */
      const bdText = document.getElementById('birthDateText');
      function maskDate(v){
        v = onlyDigits(v).slice(0,8);
        if (v.length >= 5) return v.replace(/^(\d{2})(\d{2})(\d{1,4}).*/, '$1/$2/$3');
        if (v.length >= 3) return v.replace(/^(\d{2})(\d{1,2}).*/, '$1/$2');
        return v;
      }
      bdText?.addEventListener('input', () => { bdText.value = maskDate(bdText.value); }, {passive:true});

      /* ===== Dinheiro ===== */
      document.querySelectorAll('.js-money').forEach(inp=>{
        inp.addEventListener('input', e=>{
          let v = (inp.value || '').replace(/[^\d]/g,'');
          if (!v) { inp.value=''; return; }
          v = v.replace(/^0+(\d)/,'$1');
          if (v.length < 3) v = v.padStart(3,'0');
          const inteiro = v.slice(0, -2);
          const dec = v.slice(-2);
          const intFmt = inteiro.replace(/\B(?=(\d{3})+(?!\d))/g,'.');
          inp.value = `R$ ${intFmt},${dec}`;
        }, {passive:true});
      });

      /* ===== Travar STATUS/PRAZO ===== */
      const selStatus = document.getElementById('statusContrato');
      const hiddenStatus = document.getElementById('statusContratoHidden');
      function lockStatus() {
        if (selStatus) {
          selStatus.value = 'Pendente';
          selStatus.setAttribute('aria-readonly','true');
          selStatus.classList.add('readonly');
        }
        if (hiddenStatus) hiddenStatus.value = 'Pendente';
      }
      lockStatus();

      const prazoSel = document.getElementById('prazoAntecipacaoSel');
      const prazoHidden = document.getElementById('prazoAntecipacaoHidden');
      function lockPrazo3() {
        if (prazoSel) {
          prazoSel.value = '3';
          prazoSel.setAttribute('aria-readonly','true');
          prazoSel.classList.add('readonly');
        }
        if (prazoHidden) prazoHidden.value = '3';
      }
      lockPrazo3();

      /* ===== Auxílio fixo 10% + Data do Envio = Data da Aprovação ===== */
      const auxTaxa = document.getElementById('auxTaxa');
      const auxDataEnvio = document.getElementById('auxDataEnvio');
      const inpDataAprov = document.querySelector('input[name="contrato[dataAprovacao]"]');
      function setAux10(){ if (auxTaxa) auxTaxa.value = '10,00'; }
      setAux10();
      function syncEnvioFromAprov() {
        if (!inpDataAprov || !auxDataEnvio) return;
        auxDataEnvio.value = (inpDataAprov.value || '').trim();
      }
      if (inpDataAprov) {
        inpDataAprov.addEventListener('input', syncEnvioFromAprov, {passive:true});
        syncEnvioFromAprov();
      }

      /* ===== Google Places: Autocomplete ===== */
      function fillIf(inputSelector, value) {
        const el = document.querySelector(inputSelector);
        if (el && value) el.value = value;
      }
      function initPlaces(){
        const addressInput = document.querySelector('input[name="address"]');
        if (!addressInput || !window.google || !google.maps || !google.maps.places) return;
        const autocomplete = new google.maps.places.Autocomplete(addressInput, {
          types: ['address'],
          componentRestrictions: { country: 'br' },
          fields: ['address_components','formatted_address','geometry']
        });
        autocomplete.addListener('place_changed', () => {
          const place = autocomplete.getPlace();
          if (!place || !place.address_components) return;
          let cep='', rua='', numero='', bairro='', cidade='', uf='';
          place.address_components.forEach(c=>{
            const types = c.types || [];
            if (types.includes('postal_code')) cep = c.long_name;
            if (types.includes('route')) rua = c.long_name;
            if (types.includes('street_number')) numero = c.long_name;
            if (types.includes('sublocality') || types.includes('sublocality_level_1') || types.includes('neighborhood')) bairro = c.long_name;
            if (types.includes('locality')) cidade = c.long_name;
            if (types.includes('administrative_area_level_2') && !cidade) cidade = c.long_name;
            if (types.includes('administrative_area_level_1')) uf = (c.short_name || '').toLowerCase();
          });
          fillIf('input[name="cep"]', cep);
          if (rua) addressInput.value = rua;
          fillIf('input[name="addressNumber"]', numero);
          fillIf('input[name="neighborhood"]', bairro);
          fillIf('input[name="city"]', cidade);
          const ufSel = document.querySelector('select[name="uf"]');
          if (ufSel && uf) ufSel.value = uf;
          const cepEl = document.querySelector('input[name="cep"]');
          if (cepEl && cep) {
            const dg = (cep || '').replace(/\D/g,'');
            if (dg.length === 8) cepEl.value = dg.slice(0,5)+'-'+dg.slice(5);
            cepEl.dispatchEvent(new Event('input'));
          }
        });
      }

      /* ===== CEP + ViaCEP ===== */
      (function(){
        const cep     = document.querySelector('input[name="cep"]');
        const addr    = document.querySelector('input[name="address"]');
        const bairro  = document.querySelector('input[name="neighborhood"]');
        const cidade  = document.querySelector('input[name="city"]');
        const ufSel   = document.querySelector('select[name="uf"]');
        const compl   = document.querySelector('input[name="complement"]');
        if (!cep) return;
        function maskCEP(v){
          v = (v||'').replace(/\D/g,'').slice(0,8);
          return v.length > 5 ? v.slice(0,5)+'-'+v.slice(5) : v;
        }
        function setLoading(on){ cep.classList.toggle('is-loading', !!on); }
        async function lookupViaCEP(){
          const digits = (cep.value||'').replace(/\D/g,'');
          if (digits.length !== 8) return;
          setLoading(true);
          try{
            const res  = await fetch(`https://viacep.com.br/ws/${digits}/json/`);
            const data = await res.json();
            if (!data || data.erro) return;
            if (addr    && !addr.value)    addr.value    = data.logradouro || '';
            if (bairro  && !bairro.value)  bairro.value  = data.bairro     || '';
            if (cidade  && !cidade.value)  cidade.value  = data.localidade || '';
            if (compl   && !compl.value)   compl.value   = data.complemento|| '';
            if (ufSel   && data.uf)        ufSel.value   = (data.uf||'').toLowerCase();
          } catch(e){ console.warn('Falha no ViaCEP', e); }
          finally { setLoading(false); }
        }
        cep.maxLength = 9;
        if (cep.value) {
          cep.value = maskCEP(cep.value);
          if ((cep.value||'').replace(/\D/g,'').length === 8) lookupViaCEP();
        }
        cep.addEventListener('input', () => {
          const m = maskCEP(cep.value);
          if (cep.value !== m) cep.value = m;
          if ((m||'').replace(/\D/g,'').length === 8) lookupViaCEP();
        }, {passive:true});
        cep.addEventListener('blur', lookupViaCEP, {passive:true});
      })();

      // ======= Validações obrigatórias (CPF/CNPJ e Matrícula) =======
      const matriculaInp = document.querySelector('input[name="matriculaServidorPublico"]');
      function validateCpfCnpj(){
        const type = (docTypeSel.value || 'CPF').toUpperCase();
        const digits = onlyDigits(cpfCnpjInp.value);
        const ok = (type === 'CNPJ') ? (digits.length === 14) : (digits.length === 11);
        if (!ok) {
          cpfCnpjInp.setCustomValidity(type === 'CNPJ'
            ? 'Informe um CNPJ válido (14 dígitos).'
            : 'Informe um CPF válido (11 dígitos).');
        } else {
          cpfCnpjInp.setCustomValidity('');
        }
        return ok;
      }
      function validateMatricula(){
        const val = (matriculaInp?.value || '').trim();
        const ok = val.length > 0;
        if (!ok) {
          matriculaInp?.setCustomValidity('Preencha a matrícula do servidor público.');
        } else {
          matriculaInp?.setCustomValidity('');
        }
        return ok;
      }

      // Regras no submit
      const form = document.getElementById('formAgente');
      form.addEventListener('submit', (e) => {
        // travas e sincronizações já existentes
        lockStatus();
        lockPrazo3();
        setAux10();
        (function(){
          const inpDataAprov = document.querySelector('input[name="contrato[dataAprovacao]"]');
          const auxDataEnvio = document.getElementById('auxDataEnvio');
          if (!inpDataAprov || !auxDataEnvio) return;
          auxDataEnvio.value = (inpDataAprov.value || '').trim();
        })();

        // validações obrigatórias específicas
        let firstInvalid = null;
        if (!validateCpfCnpj()) firstInvalid = cpfCnpjInp;
        if (!validateMatricula()) { if (!firstInvalid) firstInvalid = matriculaInp; }

        if (firstInvalid) {
          e.preventDefault();
          firstInvalid.reportValidity?.();
          firstInvalid.scrollIntoView({behavior:'smooth', block:'center'});
        }
      });

      // feedback imediato
      docTypeSel.addEventListener('change', () => validateCpfCnpj(), {passive:true});
      cpfCnpjInp.addEventListener('blur', () => validateCpfCnpj(), {passive:true});

      window.initPlaces = initPlaces;
    </script>

    <!-- ===== Uploader de Documentos (legado, auto-desativa se não encontrar elementos) ===== -->
    <script>
    (function(){
      const btnAdd   = document.getElementById('btnAddDocs');
      const list     = document.getElementById('docs-list');
      const inputsBox= document.getElementById('docs-inputs');
      const summary  = document.getElementById('docs-summary');
      const errBox   = document.getElementById('docs-errors');
      const form     = document.getElementById('formAgente');

      if (!btnAdd || !list || !inputsBox) return;

      const MAX_MB   = 10;
      const MAX_BYTES= MAX_MB * 1024 * 1024;
      const ALLOWED  = ['application/pdf','image/jpeg','image/jpg','image/png','image/webp'];

      const state = { batches: [], totalBytes: 0, totalCount: 0 };

      function humanSize(b){
        if (b >= 1024*1024) return (b/1024/1024).toFixed(2).replace('.',',') + ' MB';
        if (b >= 1024) return (b/1024).toFixed(1).replace('.',',') + ' KB';
        return b + ' B';
      }

      function clearErrors(){ if (!errBox) return; errBox.style.display = 'none'; errBox.innerHTML = ''; }
      function addError(msg){
        if (!errBox) return;
        const ul = errBox.querySelector('ul') || (function(){
          errBox.innerHTML = '<strong>Erros nos arquivos:</strong><ul style="margin:6px 0 0;padding-left:18px"></ul>';
          errBox.style.display = 'block';
          return errBox.querySelector('ul');
        })();
        const li = document.createElement('li'); li.textContent = msg; ul.appendChild(li);
      }
      function updateSummary(){
        summary.textContent = state.totalCount
          ? `${state.totalCount} arquivo(s), ${humanSize(state.totalBytes)}`
          : 'Nenhum arquivo selecionado';
      }
      function rebuildInputFiles(batch){
        const dt = new DataTransfer();
        batch.files.forEach(f => dt.items.add(f));
        batch.inputEl.files = dt.files;
      }
      function removeItem(batchId, fileIndex){
        const b = state.batches.find(x => x.id === batchId);
        if (!b) return;
        const file = b.files[fileIndex];
        if (!file) return;
        state.totalBytes -= file.size; state.totalCount -= 1;
        b.files.splice(fileIndex, 1); rebuildInputFiles(b);
        const li = list.querySelector(`li.docs-item[data-batch="${batchId}"][data-index="${fileIndex}"]`); li && li.remove();
        if (b.files.length === 0) { b.inputEl.remove(); state.batches = state.batches.filter(x => x.id !== batchId); }
        else { const items = list.querySelectorAll(`li.docs-item[data-batch="${batchId}"]`); items.forEach((el, idx) => el.setAttribute('data-index', String(idx))); }
        updateSummary();
      }
      function addPreviewItem(batchId, file, index){
        const li = document.createElement('li');
        li.className = 'docs-item';
        li.setAttribute('data-batch', String(batchId));
        li.setAttribute('data-index', String(index));
        li.innerHTML = `
          <div class="info">
            <i class="fas fa-file"></i>
            <div style="min-width:0">
              <div class="name" title="\${file.name}">\${file.name}</div>
              <div class="meta">\${file.type || 'desconhecido'} • \${humanSize(file.size)}</div>
            </div>
          </div>
          <button type="button" class="docs-remove" title="Remover este arquivo">
            <i class="fas fa-trash-can"></i> Remover
          </button>
        `;
        li.querySelector('.docs-remove').addEventListener('click', (ev) => {
          const host = ev.currentTarget.closest('li.docs-item'); if (!host) return;
          const bId = Number(host.getAttribute('data-batch')); const idx = Number(host.getAttribute('data-index'));
          removeItem(bId, idx);
        }, {passive:true});
        list.appendChild(li);
      }
      function validateClientFile(file){
        const typeOk = ALLOWED.includes((file.type || '').toLowerCase());
        const sizeOk = file.size <= MAX_BYTES;
        return { typeOk, sizeOk };
      }
      function handleNewFiles(inputEl){
        clearErrors();
        const raw = Array.from(inputEl.files || []);
        if (!raw.length) { inputEl.remove(); return; }
        const accepted = [];
        raw.forEach(f => {
          const { typeOk, sizeOk } = validateClientFile(f);
          if (!typeOk) addError(`Tipo não permitido para "\${f.name}". Formatos aceitos: PDF, JPG, JPEG, PNG, WEBP.`);
          else if (!sizeOk) addError(`"\${f.name}" excede ${MAX_MB} MB (\${humanSize(f.size)}).`);
          else accepted.push(f);
        });
        if (!accepted.length) { inputEl.remove(); return; }
        const batch = { id: Date.now() + Math.random(), inputEl, files: accepted.slice() };
        const dt = new DataTransfer(); batch.files.forEach(f => dt.items.add(f)); inputEl.files = dt.files;
        batch.files.forEach((f) => { state.totalBytes += f.size; state.totalCount += 1; });
        state.batches.push(batch); updateSummary();
        batch.files.forEach((f, idx) => addPreviewItem(batch.id, f, idx));
      }
      function createHiddenInputAndClick(){
        const inp = document.createElement('input');
        inp.type = 'file'; inp.name = 'documents[]';
        inp.accept = '.pdf,.jpg,.jpeg,.png,.webp'; inp.multiple = true; inp.style.display = 'none';
        inputsBox.appendChild(inp);
        inp.addEventListener('change', () => handleNewFiles(inp), {passive:true});
        inp.click();
      }
      btnAdd.addEventListener('click', createHiddenInputAndClick);

      // validação final no submit
      form.addEventListener('submit', (e) => {
        clearErrors();
        if (errBox && errBox.style.display !== 'none') {
          e.preventDefault();
          errBox.scrollIntoView({behavior:'smooth',block:'center'});
          return;
        }
      });
    })();
    </script>

    {{-- Google Maps JS (Places) --}}
    <script
      src="https://maps.googleapis.com/maps/api/js?key={{ config('services.google.maps.key') ?? env('GOOGLE_MAPS_API_KEY') }}&libraries=places&language=pt-BR&region=BR&callback=initPlaces"
      async defer></script>
  </div>

  <!-- Ícones -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</body>
</html>
