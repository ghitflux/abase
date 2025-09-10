<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{ config('app.name', 'ABASE') }} — Cadastro</title>

  <link rel="stylesheet" href="{{ asset('css/register.css') }}?v={{ filemtime(public_path('css/register.css')) }}">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
</head>
<body>

  <main class="card">
    {{-- Lado esquerdo (foto + marca + headline) --}}
    <section class="media" aria-label="Painel institucional">
      <img class="photo" src="{{ asset('img/fundo.jpg') }}" alt="Foto institucional">
      <div class="media-inner">
        <div>
          <img class="brand-mark" src="{{ asset('img/Frame.png') }}" alt="ABASE asas">
          <h2 class="headline">Unindo forças<br> em prol de quem serve.</h2>
        </div>
      </div>
    </section>

    {{-- Lado direito (form de cadastro) --}}
    <section class="login" aria-label="Cadastro no sistema">
      <div class="login-wrap">
        <img class="logo" src="{{ asset('img/logo.png') }}" alt="ABASE — logo completa">

        {{-- Erros do Fortify/Validator --}}
        @if ($errors->any())
          <div class="alert" role="alert">
            {{ $errors->first() }}
          </div>
        @endif

        <form class="form" method="POST" action="{{ route('register') }}" autocomplete="on">
          @csrf

          <div class="field">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
              <circle cx="12" cy="8" r="4"></circle>
              <path d="M6 20c0-3.314 2.686-6 6-6s6 2.686 6 6"></path>
            </svg>
            <input class="input" type="text" name="name" placeholder="Nome completo" required autofocus value="{{ old('name') }}">
          </div>

          <div class="field">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
              <path d="M4 4h16v16H4z"></path>
              <path d="m22 6-10 7L2 6"></path>
            </svg>
            <input class="input" type="email" name="email" placeholder="E-mail" inputmode="email" required value="{{ old('email') }}">
          </div>

          <div class="field">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
              <rect x="3" y="11" width="18" height="10" rx="2"></rect>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
            <input id="pwd" class="input" type="password" name="password" placeholder="Senha (mín. 6)" required autocomplete="new-password">
            <button type="button" id="togglePwd" class="toggle" aria-label="Mostrar/ocultar senha" title="Mostrar/ocultar senha">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7Z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </button>
          </div>

          <div class="field">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
              <rect x="3" y="11" width="18" height="10" rx="2"></rect>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
            <input id="pwd2" class="input" type="password" name="password_confirmation" placeholder="Confirmar senha" required autocomplete="new-password">
            <button type="button" id="togglePwd2" class="toggle" aria-label="Mostrar/ocultar senha" title="Mostrar/ocultar senha">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7Z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </button>
          </div>

          <div class="hint">
            Já tem conta?
            <!-- AGORA vai para o WELCOME (sua tela de login) -->
            <a href="{{ url('/') }}">Entrar</a>
            {{-- Se preferir rota nomeada: <a href="{{ route('welcome') }}">Entrar</a> --}}
          </div>

          {{-- (Opcional) Termos do Jetstream, se estiver ativo --}}
          @if (Laravel\Jetstream\Jetstream::hasTermsAndPrivacyPolicyFeature())
            <label class="terms">
              <input type="checkbox" name="terms" required>
              <span>
                Concordo com os
                <a target="_blank" href="{{ route('terms.show') }}">Termos de Serviço</a>
                e a
                <a target="_blank" href="{{ route('policy.show') }}">Política de Privacidade</a>.
              </span>
            </label>
          @endif

          <button class="btn" type="submit">Criar conta</button>
        </form>
      </div>
    </section>
  </main>

  <script>
    const toggleBtn = (inputId, btnId) => {
      const input = document.getElementById(inputId);
      const btn   = document.getElementById(btnId);
      let visible = false;
      btn.addEventListener('click', () => {
        visible = !visible;
        input.type = visible ? 'text' : 'password';
        btn.innerHTML = visible
          ? `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
               <path d="M17.94 17.94A10.94 10.94 0 0 1 12 20C5 20 1 12 1 12a21.78 21.78 0 0 1 5.06-6.94M10.59 10.59A3 3 0 0 0 12 15a3 3 0 0 0 2.12-.88M9.88 4.12A10.94 10.94 0 0 1 12 4c7 0 11 8 11 8a21.76 21.76 0 0 1-3.35 4.88"></path>
               <line x1="1" y1="1" x2="23" y2="23"></line>
             </svg>`
          : `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
               <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7Z"></path>
               <circle cx="12" cy="12" r="3"></circle>
             </svg>`;
      });
    };
    toggleBtn('pwd', 'togglePwd');
    toggleBtn('pwd2', 'togglePwd2');
  </script>
</body>
</html>
