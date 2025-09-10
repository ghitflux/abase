<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Associado | Dashboard</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
    :root{ --bg:#0f172a; --card:#111827; --muted:#94a3b8; --text:#e5e7eb; --accent:#22d3ee; --ok:#10b981; --warn:#f59e0b; --bad:#ef4444; --border:rgba(148,163,184,.25); }
    *{box-sizing:border-box} html,body{margin:0;padding:0;background:var(--bg);color:var(--text);font:14px/1.5 system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,'Helvetica Neue','Noto Sans',sans-serif}
    a{color:var(--accent);text-decoration:none}
    .wrap{max-width:900px;margin:24px auto;padding:0 16px}
    .header{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-bottom:16px}
    .who{font-size:13px;color:var(--muted)}
    .btn{border:1px solid var(--border);background:#0b1220;color:var(--text);padding:10px 14px;border-radius:10px;cursor:pointer}
    .btn:hover{border-color:var(--accent)}
    .card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:14px;margin-bottom:16px}
    .ok{background:rgba(16,185,129,.12);border:1px solid rgba(16,185,129,.35);color:#10b981;border-radius:10px;padding:10px 12px;margin-bottom:12px}
    .err{background:rgba(239,68,68,.12);border:1px solid rgba(239,68,68,.35);color:#ef4444;border-radius:10px;padding:10px 12px;margin-bottom:12px}
    .label{display:block;margin:8px 0 6px}
    .input{width:100%;background:#0b1220;border:1px solid var(--border);border-radius:10px;color:var(--text);padding:10px 12px}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div>
        <h1 style="margin:0">Dashboard — ASSOCIADO</h1>
        <div class="who">
          Usuário: <strong>{{ auth()->user()->name }}</strong> •
          E-mail: <strong>{{ auth()->user()->email }}</strong>
        </div>
      </div>
      <form method="POST" action="{{ route('logout') }}">
        @csrf
        <button type="submit" class="btn">Sair</button>
      </form>
    </div>

    @if (session('ok'))
      <div class="ok">{{ session('ok') }}</div>
    @endif
    @if ($errors->any())
      <div class="err">
        <ul style="margin:0 0 0 18px">
          @foreach ($errors->all() as $e) <li>{{ $e }}</li> @endforeach
        </ul>
      </div>
    @endif

    @php
      $mustSet = (bool) (auth()->user()->must_set_password ?? false);
      $hasPass = !is_null(auth()->user()->password);
    @endphp

    {{-- Se ainda não definiu senha, só mostra "Definir senha" --}}
    @if($mustSet || !$hasPass)
      <div class="card">
        <h3 style="margin:0 0 8px">Defina sua senha</h3>
        <p style="color:var(--muted);margin-top:0">Para continuar usando o painel, escolha uma senha.</p>
        <form method="POST" action="{{ route('associado.senha.definir') }}">
          @csrf
          @method('PUT')
          <label class="label">Nova senha</label>
          <input class="input" type="password" name="password" required>
          <label class="label">Confirmar nova senha</label>
          <input class="input" type="password" name="password_confirmation" required>
          <div style="margin-top:10px">
            <button class="btn" type="submit">Salvar senha</button>
          </div>
        </form>
      </div>
    @else
      {{-- Senha já definida: mostra "Alterar senha" opcional --}}
      <div class="card">
        <h3 style="margin:0 0 8px">Alterar senha</h3>
        <form method="POST" action="{{ route('associado.senha.alterar') }}">
          @csrf
          @method('PUT')
          <label class="label">Senha atual</label>
          <input class="input" type="password" name="current_password" required>
          <label class="label">Nova senha</label>
          <input class="input" type="password" name="password" required>
          <label class="label">Confirmar nova senha</label>
          <input class="input" type="password" name="password_confirmation" required>
          <div style="margin-top:10px">
            <button class="btn" type="submit">Atualizar senha</button>
          </div>
        </form>
      </div>

      {{-- Aqui você pode colocar outros cards do seu dashboard futuramente --}}
      <div class="card">
        <h3 style="margin:0">Bem-vindo(a), {{ auth()->user()->name }}!</h3>
        <p style="color:var(--muted)">Em breve você verá seus dados e funcionalidades aqui.</p>
      </div>
    @endif

    <p style="margin-top:16px"><a href="{{ url('/') }}">Voltar à Home</a></p>
  </div>
</body>
</html>
