{{-- resources/views/pdf/cadastro-agente.blade.php --}}
@php
  use Illuminate\Support\Carbon;

  $money = function($v){
    return ($v === '' || $v === null) ? '—' : 'R$ '.number_format((float)$v, 2, ',', '.');
  };

  $date = function($v, $fmt = 'd/m/Y'){
    try { return $v ? Carbon::parse($v)->format($fmt) : '—'; }
    catch (\Throwable $e) { return '—'; }
  };

  $month = fn($v) => $date($v, 'm/Y');

  $logoPath = public_path('images/logo.png');
  $hasLogo  = file_exists($logoPath);
@endphp
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>Cadastro do Associado</title>
<style>
  /* --------- Página / tipografia --------- */
  @page{ margin: 24mm 16mm 20mm; }
  html, body{ font-family: DejaVu Sans, Arial, Helvetica, sans-serif; color:#0f172a; }
  body{ font-size:12px; }

  h1{ font-size:18px; margin:0; }
  h2{ font-size:13.5px; margin:0 0 8px; color:#111827; }
  .muted{ color:#64748b; }
  .small{ font-size:10px; }

  /* --------- Header / footer (DomPDF-friendly) --------- */
  .header{
    position: fixed; top: -18mm; left: 0; right: 0; height: 18mm;
    border-bottom: 1px solid #e5e7eb;
    display: table; width: 100%;
  }
  .header .left{ display: table-cell; vertical-align: middle; width: 60%; }
  .header .right{ display: table-cell; vertical-align: middle; text-align: right; width: 40%; }
  .brand{ font-weight:700; font-size:16px; letter-spacing:.3px; }
  .brand-sub{ margin-top:2px; }

  .footer{
    position: fixed; bottom: -14mm; left: 0; right: 0; height: 14mm;
    border-top: 1px solid #e5e7eb; color:#64748b; font-size:10px;
    display: table; width: 100%;
  }
  .footer .left{ display: table-cell; vertical-align: middle; }
  .footer .right{ display: table-cell; vertical-align: middle; text-align:right; }
  .pagenum:before{ content: counter(page) " / " counter(pages); }

  /* --------- Cards / tabelas --------- */
  .card{
    border:1px solid #e5e7eb; border-radius:8px; padding:10px; margin:10px 0 8px;
    page-break-inside: avoid;
  }
  .kv{ width:100%; border-collapse: collapse; }
  .kv tr{ vertical-align: top; }
  .kv th{ width: 180px; color:#64748b; padding:5px 6px; text-align:left; font-weight: normal; }
  .kv td{ padding:5px 6px; font-weight:600; }

  /* Duas colunas robustas para DomPDF: tabela com duas células */
  .cols{ width:100%; border-collapse: separate; border-spacing: 0 8px; }
  .cols td{ vertical-align: top; width:50%; }
  .box{ border:1px solid #e5e7eb; border-radius:8px; padding:10px; }

  /* Tabela de antecipações */
  table.table{ width:100%; border-collapse: collapse; margin-top:6px; }
  .table th, .table td{ border:1px solid #e5e7eb; padding:6px; font-size:11px; }
  .table th{ background:#f8fafc; text-align:left; }

  /* Quebras gentis */
  .pb-avoid{ page-break-inside: avoid; }
</style>
</head>
<body>

  {{-- HEADER --}}
  <div class="header">
    <div class="left">
      @if($hasLogo)
        <img src="{{ $logoPath }}" alt="Logo" style="height:24px; vertical-align:middle; margin-right:8px">
      @endif
      <span class="brand">Cadastro do Associado</span>
      <div class="brand-sub small muted">Emitido em {{ $now->format('d/m/Y H:i') }}</div>
    </div>
    <div class="right small muted">
      ID do cadastro: <b>{{ $cad->id }}</b>
    </div>
  </div>

  {{-- FOOTER --}}
  <div class="footer">
    <div class="left small">Documento gerado automaticamente pelo sistema.</div>
    <div class="right small">Página <span class="pagenum"></span></div>
  </div>

  {{-- CONTEÚDO --}}
  <main>

    {{-- Dados cadastrais --}}
    <div class="card">
      <h2>Dados Cadastrais</h2>
      <table class="kv">
        <tr><th>Nome/Razão:</th><td>{{ $cad->full_name ?: '—' }}</td></tr>
        <tr><th>Doc. ({{ $cad->doc_type ?? 'CPF' }}):</th><td>{{ $cad->cpf_cnpj ?: '—' }}</td></tr>
        <tr><th>RG / Órgão:</th><td>{{ $cad->rg ?? '—' }}{{ $cad->orgao_expedidor ? ' / '.$cad->orgao_expedidor : '' }}</td></tr>
        <tr><th>Nascimento:</th><td>{{ $date($cad->birth_date) }}</td></tr>
        <tr><th>Profissão:</th><td>{{ $cad->profession ?? '—' }}</td></tr>
        <tr><th>Estado civil:</th><td>{{ $cad->marital_status ?? '—' }}</td></tr>
      </table>
    </div>

    {{-- Endereço --}}
    <div class="card">
      <h2>Endereço</h2>
      <table class="kv">
        <tr><th>CEP:</th><td>{{ $cad->cep ?? '—' }}</td></tr>
        <tr>
          <th>Endereço:</th>
          <td>
            {{ $cad->address ?? '—' }}
            @if($cad->address_number) , Nº {{ $cad->address_number }} @endif
            @if($cad->complement) — {{ $cad->complement }} @endif
          </td>
        </tr>
        <tr><th>Bairro:</th><td>{{ $cad->neighborhood ?? '—' }}</td></tr>
        <tr><th>Cidade/UF:</th><td>{{ $cad->city ?? '—' }} / {{ strtoupper($cad->uf ?? '—') }}</td></tr>
      </table>
    </div>

    {{-- Contato & Bancário (duas colunas) --}}
    <table class="cols">
      <tr>
        <td>
          <div class="box">
            <h2>Contato e Vínculo</h2>
            <table class="kv">
              <tr><th>Celular:</th><td>{{ $cad->cellphone ?? '—' }}</td></tr>
              <tr><th>E-mail:</th><td>{{ $cad->email ?? '—' }}</td></tr>
              <tr><th>Órgão Público:</th><td>{{ $cad->orgao_publico ?? '—' }}</td></tr>
              <tr><th>Situação Servidor:</th><td>{{ $cad->situacao_servidor ?? '—' }}</td></tr>
              <tr><th>Matrícula:</th><td>{{ $cad->matricula_servidor_publico ?? '—' }}</td></tr>
            </table>
          </div>
        </td>
        <td>
          <div class="box">
            <h2>Dados Bancários</h2>
            <table class="kv">
              <tr><th>Banco:</th><td>{{ $cad->bank_name ?? '—' }}</td></tr>
              <tr><th>Agência:</th><td>{{ $cad->bank_agency ?? '—' }}</td></tr>
              <tr><th>Conta:</th><td>{{ $cad->bank_account ?? '—' }}</td></tr>
              <tr><th>Tipo:</th><td>{{ $cad->account_type ?? '—' }}</td></tr>
              <tr><th>Chave Pix:</th><td>{{ $cad->pix_key ?? '—' }}</td></tr>
            </table>
          </div>
        </td>
      </tr>
    </table>

    {{-- Contrato --}}
    <div class="card">
      <h2>Contrato</h2>
      <table class="cols">
        <tr>
          <td>
            <table class="kv">
              <tr><th>Código:</th><td>{{ $cad->contrato_codigo_contrato ?? '—' }}</td></tr>
              <tr><th>Mensalidade:</th><td>{{ $money($cad->contrato_mensalidade) }}</td></tr>
              <tr><th>Valor Antecipação:</th><td>{{ $money($cad->contrato_valor_antecipacao) }}</td></tr>
            </table>
          </td>
          <td>
            <table class="kv">
              <tr><th>Margem disponível:</th><td>{{ $money($cad->contrato_margem_disponivel) }}</td></tr>
              <tr><th>Prazo (meses):</th><td>{{ $cad->contrato_prazo_meses ?? '—' }}</td></tr>
              <tr><th>Taxa antecipação (%):</th><td>{{ $cad->contrato_taxa_antecipacao ?? '—' }}</td></tr>
            </table>
          </td>
        </tr>
      </table>
      <table class="kv">
        <tr><th>Data aprovação:</th><td>{{ $date($cad->contrato_data_aprovacao) }}</td></tr>
        <tr><th>1ª mensalidade:</th><td>{{ $date($cad->contrato_data_envio_primeira) }}</td></tr>
        <tr><th>Mês averb.:</th><td>{{ $month($cad->contrato_mes_averbacao) }}</td></tr>
        <tr><th>Status:</th><td>{{ $cad->contrato_status_contrato ?? '—' }}</td></tr>
        <tr><th>Doação do associado:</th><td>{{ $money($cad->contrato_doacao_associado) }}</td></tr>
      </table>
    </div>

    {{-- Antecipações --}}
    <div class="card">
      <h2>Antecipações</h2>
      @if(!empty($anticipations))
        <table class="table">
          <thead>
            <tr>
              <th>#</th>
              <th>Vencimento</th>
              <th>Valor</th>
              <th>Status</th>
              <th>Observação</th>
            </tr>
          </thead>
          <tbody>
          @foreach($anticipations as $a)
            @php
              $num = $a['numeroMensalidade'] ?? '—';
              $ven = $a['dataEnvio'] ?? '—';
              $raw = (string)($a['valorAuxilio'] ?? '');
              $val = preg_replace('/[^\d,\.]/','', $raw);
              $val = $val ? (str_contains($val,'R$') ? $val : 'R$ '.$val) : '—';
              $sts = $a['status'] ?? '—';
              $obs = $a['observacao'] ?? '—';
            @endphp
            <tr>
              <td>{{ $num }}</td>
              <td>{{ $ven }}</td>
              <td>{{ $val }}</td>
              <td>{{ $sts }}</td>
              <td>{{ $obs }}</td>
            </tr>
          @endforeach
          </tbody>
        </table>
      @else
        <div class="muted">Sem linhas de antecipação.</div>
      @endif
    </div>

    {{-- Observações --}}
    <div class="card pb-avoid">
      <h2>Observações</h2>
      <div>{{ $cad->observacoes ?: '—' }}</div>
    </div>

    {{-- Auxílio do Agente --}}
    <div class="card">
      <h2>Auxílio do Agente</h2>
      <table class="kv">
        <tr><th>Taxa (%):</th><td>{{ $cad->auxilio_taxa ?? '—' }}</td></tr>
        <tr><th>Data do envio:</th><td>{{ $date($cad->auxilio_data_envio) }}</td></tr>
        <tr><th>Status:</th><td>{{ $cad->auxilio_status ?? '—' }}</td></tr>
      </table>
    </div>

  </main>
</body>
</html>
