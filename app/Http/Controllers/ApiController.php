<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\AgenteCadastro;
use App\Models\PagamentoMensalidade; // <<< NOVO
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Carbon; // <<< NOVO

class ApiController extends Controller
{
    /**
     * POST /api/login
     */
    public function login(Request $request)
    {
        $data = $request->validate([
            'login'    => ['required', 'string'],
            'password' => ['required', 'string'],
        ], [], [
            'login'    => 'e-mail/CPF',
            'password' => 'senha',
        ]);

        $rawLogin = trim($data['login']);
        $password = $data['password'];
        $docLogin = preg_replace('/\D+/', '', $rawLogin);

        Log::info('[API] login: início', [
            'ip'        => $request->ip(),
            'rawLogin'  => $this->maskDocOrEmail($rawLogin),
            'isEmail'   => filter_var($rawLogin, FILTER_VALIDATE_EMAIL) ? true : false,
            'docDigits' => $docLogin,
        ]);

        // 1) localizar usuário
        $user = $this->findUserForLogin($rawLogin);
        if (!$user) {
            Log::warning('[API] login: usuário não localizado', ['rawLogin' => $this->maskDocOrEmail($rawLogin)]);
            throw ValidationException::withMessages([
                'login' => ['Usuário não encontrado para o e-mail/CPF informado.'],
            ]);
        }
        Log::info('[API] login: usuário encontrado', ['user_id' => $user->id, 'email' => $user->email]);

        // 2) validar senha
        $valid = false;

        if (!empty($user->password) && Hash::check($password, $user->password)) {
            $valid = true;
            Log::info('[API] login: Hash::check OK', ['user_id' => $user->id]);
        }

        // fallback: matrícula
        if (!$valid) {
            $matricula = $this->guessUserMatricula($user, $rawLogin);
            $pwdDigits = preg_replace('/\D+/', '', (string)$password);
            if ($matricula && $pwdDigits !== '' && hash_equals($matricula, $pwdDigits)) {
                $valid = true;
                Log::info('[API] login: fallback por matrícula OK', ['user_id' => $user->id]);
            } else {
                Log::warning('[API] login: senha inválida', [
                    'user_id'  => $user->id,
                    'hasHash'  => !empty($user->password),
                    'hasMatri' => $matricula ? true : false,
                ]);
            }
        }

        if (!$valid) {
            throw ValidationException::withMessages([
                'password' => ['As credenciais informadas são inválidas.'],
            ]);
        }

        // 3) roles
        $roles = DB::table('roles')
            ->join('role_user', 'roles.id', '=', 'role_user.role_id')
            ->where('role_user.user_id', $user->id)
            ->pluck('roles.name')
            ->values()
            ->toArray();

        Log::info('[API] login: roles', ['user_id' => $user->id, 'roles' => $roles]);

        // 4) restrição de perfil
        if (!in_array('associado', $roles, true)) {
            Log::warning('[API] login: bloqueado (não associado)', ['user_id' => $user->id, 'roles' => $roles]);
            return response()->json([
                'ok'      => false,
                'message' => 'Seu perfil não tem acesso ao aplicativo (somente associado).',
            ], 403);
        }

        // 5) token Sanctum (retorna "id|plaintext")
        $tokenName = 'flutter-' . Str::random(6);
        $token     = $user->createToken($tokenName)->plainTextToken;

        // 6) bootstrap — sempre resolvendo pelo CPF do login
        $ag = $this->resolveAgenteModel($user, $rawLogin);
        $bootstrap = $this->buildBootstrapFromAgente($ag, $user);

        Log::info('[API] login: sucesso', [
            'user_id'   => $user->id,
            'agente_id' => $ag?->id,
            'token_dbg' => $this->maskToken($token),
        ]);

        return response()->json([
            'ok'               => true,
            'message'          => 'Autenticado com sucesso.',
            'token'            => $token,
            'token_type'       => 'Bearer',
            'user'             => [
                'id'    => $user->id,
                'name'  => $user->name,
                'email' => $user->email,
            ],
            'roles'            => $roles,
            'pessoa'           => $bootstrap['pessoa'],
            'vinculo_publico'  => $bootstrap['vinculo_publico'],
            'dados_bancarios'  => $bootstrap['dados_bancarios'],
            'contratos'        => $bootstrap['contratos'],
            'resumo'           => $bootstrap['resumo'],
            'parcelas'         => [],
        ]);
    }

    /**
     * GET /api/me (auth:sanctum)
     */
    public function me(Request $request)
    {
        Log::info('[API] me: início', $this->authHeaderSnapshot($request));

        $user = $this->resolveAuthenticatedUser($request);
        if (!$user) {
            Log::warning('[API] me: sem autenticação (Bearer ausente ou inválido)');
            return response()->json(['ok' => false, 'message' => 'Não autenticado.'], 401);
        }

        $roles = DB::table('roles')
            ->join('role_user', 'roles.id', '=', 'role_user.role_id')
            ->where('role_user.user_id', $user->id)
            ->pluck('roles.name')
            ->values()
            ->toArray();

        if (!in_array('associado', $roles, true)) {
            Log::warning('[API] me: bloqueado (não associado)', ['user_id' => $user->id, 'roles' => $roles]);
            return response()->json([
                'ok'      => false,
                'message' => 'Acesso restrito ao perfil associado.',
            ], 403);
        }

        // resolve por CPF do associado
        $ag   = $this->resolveAgenteModel($user, null);
        $snap = $ag ? $this->minifyAgente($ag) : null;

        $bank = $ag ? $this->bankFromAgente($ag) : [
            'banco' => '', 'agencia' => '', 'conta' => '', 'tipo_conta' => '', 'chave_pix' => '',
        ];
        $vinc = $ag ? $this->vinculoPublicoFromAgente($ag) : [
            'orgao_publico' => '', 'situacao_servidor' => '', 'matricula' => '',
        ];

        Log::info('[API] me: ok', ['user_id' => $user->id, 'agente_id' => $ag?->id]);

        return response()->json([
            'ok'              => true,
            'user'            => [
                'id'    => $user->id,
                'name'  => $user->name,
                'email' => $user->email,
            ],
            'roles'           => $roles,
            'agente'          => $snap,
            'vinculo_publico' => $vinc,
            'dados_bancarios' => $bank,
        ]);
    }

    /**
     * GET /api/home (auth:sanctum)
     */
    public function home(Request $request)
    {
        Log::info('[API] home: início', $this->authHeaderSnapshot($request));

        $user = $this->resolveAuthenticatedUser($request);
        if (!$user) {
            Log::warning('[API] home: sem autenticação (Bearer ausente ou inválido)');
            return response()->json(['ok' => false, 'message' => 'Não autenticado.'], 401);
        }

        $roles = DB::table('roles')
            ->join('role_user', 'roles.id', '=', 'role_user.role_id')
            ->where('role_user.user_id', $user->id)
            ->pluck('roles.name')
            ->values()
            ->toArray();

        if (!in_array('associado', $roles, true)) {
            Log::warning('[API] home: bloqueado (não associado)', ['user_id' => $user->id, 'roles' => $roles]);
            return response()->json([
                'ok'      => false,
                'message' => 'Acesso restrito ao perfil associado.',
            ], 403);
        }

        // resolve por CPF do associado
        $ag = $this->resolveAgenteModel($user, null);
        $bootstrap = $this->buildBootstrapFromAgente($ag, $user);

        Log::info('[API] home: ok', ['user_id' => $user->id, 'agente_id' => $ag?->id]);

        return response()->json([
            'ok'              => true,
            'pessoa'          => $bootstrap['pessoa'],
            'vinculo_publico' => $bootstrap['vinculo_publico'],
            'dados_bancarios' => $bootstrap['dados_bancarios'],
            'contratos'       => $bootstrap['contratos'],
            'resumo'          => $bootstrap['resumo'],
            'parcelas'        => [],
        ]);
    }

    /**
     * POST /api/logout (auth:sanctum)
     */
    public function logout(Request $request)
    {
        Log::info('[API] logout: início', $this->authHeaderSnapshot($request));

        $user = $this->resolveAuthenticatedUser($request);
        $uid  = $user?->id;

        if ($user && method_exists($user, 'currentAccessToken') && $user->currentAccessToken()) {
            $user->currentAccessToken()->delete();
        }

        Log::info('[API] logout: token revogado', ['user_id' => $uid]);

        return response()->json([
            'ok'      => true,
            'message' => 'Sessão encerrada.',
        ]);
    }

    /* ================== helpers ================== */

    private function findUserForLogin(string $rawLogin): ?User
    {
        if (filter_var($rawLogin, FILTER_VALIDATE_EMAIL)) {
            if ($u = User::where('email', $rawLogin)->first()) {
                return $u;
            }
        }

        $doc = preg_replace('/\D+/', '', $rawLogin);
        if ($doc === '') return null;

        if (Schema::hasColumn('users', 'username')) {
            if ($u = User::where('username', $doc)->first()) {
                return $u;
            }
        }

        if ($u = User::where('email', $doc)->first()) {
            return $u;
        }

        $ag = AgenteCadastro::where('cpf_cnpj', $doc)->orderByDesc('id')->first();
        if ($ag && $ag->email) {
            if ($u = User::where('email', $ag->email)->first()) {
                return $u;
            }
        }

        return null;
    }

    private function guessUserMatricula(User $user, ?string $originalLogin = null): ?string
    {
        if ($originalLogin !== null) {
            $doc = preg_replace('/\D+/', '', $originalLogin);
            if ($doc !== '') {
                $agByDoc = AgenteCadastro::where('cpf_cnpj', $doc)->orderByDesc('id')->first();
                if ($agByDoc && $agByDoc->matricula_servidor_publico) {
                    return preg_replace('/\D+/', '', (string)$agByDoc->matricula_servidor_publico);
                }
            }
        }

        $agByEmail = AgenteCadastro::where('email', $user->email)->orderByDesc('id')->first();
        if ($agByEmail && $agByEmail->matricula_servidor_publico) {
            return preg_replace('/\D+/', '', (string)$agByEmail->matricula_servidor_publico);
        }

        return null;
    }

    /**
     * Resolve SEMPRE priorizando o CPF do associado.
     */
    private function resolveAgenteModel(User $user, ?string $originalLogin = null): ?AgenteCadastro
    {
        // 1) CPF vindo do login (quando chamado a partir do /login)
        if ($originalLogin !== null) {
            $doc = preg_replace('/\D+/', '', $originalLogin);
            if ($doc !== '') {
                if ($byDoc = AgenteCadastro::where('cpf_cnpj', $doc)->orderByDesc('id')->first()) {
                    Log::debug('[API] resolveAgenteModel: por CPF do login', ['cpf' => $this->maskDocOrEmail($doc)]);
                    return $byDoc;
                }
            }
        }

        // 2) CPF vindo do username (se existir)
        if (Schema::hasColumn('users', 'username')) {
            $uName = (string)($user->username ?? '');
            if ($uName !== '') {
                $doc = preg_replace('/\D+/', '', $uName);
                if ($doc !== '') {
                    if ($byDoc = AgenteCadastro::where('cpf_cnpj', $doc)->orderByDesc('id')->first()) {
                        Log::debug('[API] resolveAgenteModel: por CPF do username', ['cpf' => $this->maskDocOrEmail($doc)]);
                        return $byDoc;
                    }
                }
            }
        }

        // 3) CPF vindo do email do usuário (quando o email guarda o CPF em dígitos)
        if ($user->email && preg_match('/^\d+$/', $user->email)) {
            $doc = preg_replace('/\D+/', '', (string)$user->email);
            if ($doc !== '') {
                if ($byDoc = AgenteCadastro::where('cpf_cnpj', $doc)->orderByDesc('id')->first()) {
                    Log::debug('[API] resolveAgenteModel: por CPF do user.email', ['cpf' => $this->maskDocOrEmail($doc)]);
                    return $byDoc;
                }
            }
        }

        // 4) Fallback: e-mail “normal”
        if ($user->email) {
            if ($byEmail = AgenteCadastro::where('email', $user->email)->orderByDesc('id')->first()) {
                Log::debug('[API] resolveAgenteModel: por e-mail do usuário', ['email' => $user->email]);
                return $byEmail;
            }
        }

        Log::debug('[API] resolveAgenteModel: nenhum vínculo encontrado', ['user_id' => $user->id]);
        return null;
    }

    /**
     * Monta o pacote esperado pela Home incluindo VÍNCULO PÚBLICO e DADOS BANCÁRIOS,
     * e refletindo as parcelas já pagas (tabela pagamento_mensalidades).
     */
    private function buildBootstrapFromAgente(?AgenteCadastro $a, User $user): array
    {
        if (!$a) {
            return [
                'pessoa' => [
                    'nome_razao_social' => $user->name ?: 'Associado',
                    'documento'         => '',
                    'email'             => $user->email,
                    'celular'           => '',
                    'orgao_publico'     => '',
                    'cidade'            => '',
                    'uf'                => '',
                ],
                'vinculo_publico' => [
                    'orgao_publico'     => '',
                    'situacao_servidor' => '',
                    'matricula'         => '',
                ],
                'dados_bancarios' => [
                    'banco'       => '',
                    'agencia'     => '',
                    'conta'       => '',
                    'tipo_conta'  => '',
                    'chave_pix'   => '',
                ],
                'contratos' => [],
                'resumo'    => [
                    'prazo'               => 0,
                    'parcela_valor'       => 0.0,
                    'total_financiado'    => 0.0,
                    'status_contrato'     => 'SEM CONTRATO',
                    'parcelas_pagas'      => 0,
                    'parcelas_restantes'  => 0,
                    'atraso'              => 0,
                    'abertas_total'       => 0.0,
                    'total_pago'          => 0.0,
                    'restante'            => 0.0,
                    'percentual_pago'     => 0.0,
                    'elegivel_antecipacao'=> false,
                ],
            ];
        }

        // === blocos estáticos
        $pessoa  = $this->pessoaFromAgente($a);
        $vinculo = $this->vinculoPublicoFromAgente($a);
        $banco   = $this->bankFromAgente($a);

        // === estatísticas de pagamentos (reflete ABASE importado)
        $pay = $this->pagamentoStats($a);

        // === contrato e resumo usando estatísticas
        $contrato = $this->contratoFromAgente($a, $pay);
        $resumo   = $this->resumoFromAgente($a, $contrato, $pay);

        return [
            'pessoa'          => $pessoa,
            'vinculo_publico' => $vinculo,
            'dados_bancarios' => $banco,
            'contratos'       => [$contrato],
            'resumo'          => $resumo,
        ];
    }

    private function pessoaFromAgente(AgenteCadastro $a): array
    {
        return [
            'nome_razao_social' => (string) $a->full_name,
            'documento'         => preg_replace('/\D+/', '', (string)$a->cpf_cnpj),
            'email'             => (string) $a->email,
            'celular'           => (string) $a->cellphone,
            'orgao_publico'     => (string) $a->orgao_publico,
            'cidade'            => (string) $a->city,
            'uf'                => (string) $a->uf,
        ];
    }

    /** BLOCO: Vínculo Público */
    private function vinculoPublicoFromAgente(AgenteCadastro $a): array
    {
        return [
            'orgao_publico'     => (string) ($a->orgao_publico ?? ''),
            'situacao_servidor' => (string) ($a->situacao_servidor ?? ''),
            'matricula'         => (string) ($a->matricula_servidor_publico ?? ''),
        ];
    }

    /** BLOCO: Dados Bancários */
    private function bankFromAgente(AgenteCadastro $a): array
    {
        return [
            'banco'       => (string) ($a->bank_name ?? ''),
            'agencia'     => (string) ($a->bank_agency ?? ''),
            'conta'       => (string) ($a->bank_account ?? ''),
            'tipo_conta'  => (string) ($a->account_type ?? ''), // "corrente" | "poupanca"
            'chave_pix'   => (string) ($a->pix_key ?? ''),
        ];
    }

    /**
     * Estatísticas dos pagamentos do associado (status 1 ou 4 contam como pagos).
     */
    private function pagamentoStats(AgenteCadastro $a): array
    {
        $qPago = PagamentoMensalidade::where('agente_cadastro_id', $a->id)
            ->whereIn('status_code', ['1','4']);

        $qAberto = PagamentoMensalidade::where('agente_cadastro_id', $a->id)
            ->whereNotIn('status_code', ['1','4']);

        $pagos          = (int) $qPago->count();
        $totalPago      = (float) $qPago->sum('valor');
        $abertasTotal   = (float) $qAberto->sum('valor');
        $ultimaRef      = $qPago->max('referencia_month');

        // próxima referência estimada a partir da aprovação + qtd. pagas
        $proxRef = null;
        if ($a->contrato_data_aprovacao) {
            try {
                $proxRef = Carbon::parse($a->contrato_data_aprovacao)->startOfMonth()
                    ->addMonths($pagos)
                    ->format('Y-m-01');
            } catch (\Throwable $e) { $proxRef = null; }
        }

        return [
            'pagos'        => $pagos,
            'total_pago'   => $totalPago,
            'abertas'      => $abertasTotal,
            'ultima_ref'   => $ultimaRef,
            'proxima_ref'  => $proxRef,
        ];
    }

    private function contratoFromAgente(AgenteCadastro $a, array $pay = []): array
    {
        $prazo   = (int) ($a->contrato_prazo_meses ?? 0);
        $parcela = (float) ($a->contrato_mensalidade ?? $a->calc_mensalidade_associativa ?? 0);
        $total   = ($prazo > 0 && $parcela > 0) ? round($prazo * $parcela, 2) : 0.0;

        // status efetivo: conclui quando já bateu a quantidade de parcelas pagas
        $statusEfetivo = $a->contrato_status_contrato ?: 'Plano Ativo';
        $qtdPagas = (int) ($pay['pagos'] ?? 0);
        if ($prazo > 0 && $qtdPagas >= $prazo) {
            $statusEfetivo = 'Concluído';
        }

        return [
            'codigo'           => $a->contrato_codigo_contrato,
            'status_contrato'  => $statusEfetivo,
            'prazo'            => $prazo,
            'parcela_valor'    => $parcela,
            'total_financiado' => $total,
            'data_aprovacao'   => $a->contrato_data_aprovacao,
        ];
    }

    private function resumoFromAgente(AgenteCadastro $a, array $contrato, array $pay = []): array
    {
        $prazo   = (int) ($contrato['prazo'] ?? 0);
        $parcela = (float) ($contrato['parcela_valor'] ?? 0);
        $total   = (float) ($contrato['total_financiado'] ?? 0);

        $pagas         = (int)   ($pay['pagos'] ?? 0);
        $totalPago     = (float) ($pay['total_pago'] ?? ($pagas * $parcela));
        $abertasTotal  = (float) ($pay['abertas'] ?? 0);

        $restantes = max(0, $prazo - $pagas);
        $restante  = max(0, $total - $totalPago);
        $percent   = $total > 0 ? round(($totalPago * 100.0) / $total, 2) : 0.0;

        // atraso estimado: meses decorridos desde aprovação - pagas (>=0)
        $atraso = 0;
        try {
            if (!empty($a->contrato_data_aprovacao)) {
                $start = Carbon::parse($a->contrato_data_aprovacao)->startOfMonth();
                $elapsed = max(0, ($start->diffInMonths(Carbon::now()->startOfMonth())));
                $atraso = max(0, $elapsed - $pagas);
            }
        } catch (\Throwable $e) {
            $atraso = 0;
        }

        return [
            'prazo'               => $prazo,
            'parcela_valor'       => $parcela,
            'total_financiado'    => $total,
            'status_contrato'     => $contrato['status_contrato'] ?? 'Plano Ativo',
            'parcelas_pagas'      => $pagas,
            'parcelas_restantes'  => $restantes,
            'atraso'              => $atraso,
            'abertas_total'       => $abertasTotal,
            'total_pago'          => $totalPago,
            'restante'            => $restante,
            'percentual_pago'     => $percent,
            'elegivel_antecipacao'=> false,
        ];
    }

    private function minifyAgente(AgenteCadastro $a): array
    {
        return [
            'id'        => $a->id,
            'full_name' => $a->full_name,
            'cpf_cnpj'  => $a->cpf_cnpj,
            'cellphone' => $a->cellphone,
            'email'     => $a->email,
            'orgao'     => $a->orgao_publico,
            'contrato'  => [
                'codigo'         => $a->contrato_codigo_contrato,
                'mensalidade'    => $a->contrato_mensalidade ?? $a->calc_mensalidade_associativa,
                'prazo_meses'    => $a->contrato_prazo_meses,
                'status'         => $a->contrato_status_contrato,
                'data_aprovacao' => $a->contrato_data_aprovacao,
            ],
        ];
    }

    /** ===== Auth helpers ===== */

    private function resolveAuthenticatedUser(Request $request): ?User
    {
        if ($request->user()) {
            Log::debug('[API] auth: request->user() presente (middleware)');
            return $request->user();
        }

        $snap = $this->authHeaderSnapshot($request);
        Log::debug('[API] auth: snapshot headers', $snap);

        $extracted = $this->extractTokenFromRequest($request);
        if (!$extracted['token']) {
            Log::debug('[API] auth: nenhum token extraído');
            return null;
        }

        // Token "id|plaintext" ou apenas "plaintext"
        [$tokId, $plain] = $this->splitSanctumToken($extracted['token']);
        $hash = hash('sha256', $plain);

        Log::debug('[API] auth: token extraído', [
            'source' => $extracted['source'],
            'id'     => $tokId,
            'mask'   => $this->maskToken($extracted['token']),
        ]);

        if (!Schema::hasTable('personal_access_tokens')) {
            Log::warning('[API] auth: tabela personal_access_tokens inexistente');
            return null;
        }

        $q = DB::table('personal_access_tokens')->where('token', $hash);
        if ($tokId !== null) {
            $q->where('id', $tokId);
        }
        $pat = $q->first();

        if (!$pat && $tokId !== null) {
            $pat = DB::table('personal_access_tokens')->where('token', $hash)->first();
        }

        if (!$pat) {
            Log::warning('[API] auth: token não encontrado na tabela', [
                'source' => $extracted['source'],
                'id'     => $tokId,
                'hash4'  => substr($hash, 0, 4) . '...' . substr($hash, -4),
            ]);
            return null;
        }

        if ($pat->tokenable_type !== User::class) {
            Log::warning('[API] auth: tokenable_type inesperado', ['tokenable_type' => $pat->tokenable_type]);
            return null;
        }

        if (property_exists($pat, 'expires_at') && $pat->expires_at && now()->greaterThan($pat->expires_at)) {
            Log::warning('[API] auth: token expirado', ['id' => $pat->id]);
            return null;
        }

        $u = User::find($pat->tokenable_id);
        if ($u) {
            Log::debug('[API] auth: usuário resolvido via token', ['user_id' => $u->id, 'token_id' => $pat->id]);
        } else {
            Log::warning('[API] auth: token aponta para user inexistente', ['tokenable_id' => $pat->tokenable_id]);
        }

        return $u;
    }

    private function splitSanctumToken(string $raw): array
    {
        if (preg_match('/^(\d+)\|(.+)$/', $raw, $m)) {
            return [(int)$m[1], $m[2]];
        }
        return [null, $raw];
    }

    private function extractTokenFromRequest(Request $request): array
    {
        $auth = (string) $request->header('Authorization', '');
        if ($auth && preg_match('/^Bearer\s+(.+)$/i', $auth, $m)) {
            return ['source' => 'Authorization', 'token' => trim($m[1])];
        }

        $xauth = (string) $request->header('X-Authorization', '');
        if ($xauth) {
            if (preg_match('/^Bearer\s+(.+)$/i', $xauth, $m)) {
                return ['source' => 'X-Authorization', 'token' => trim($m[1])];
            }
            return ['source' => 'X-Authorization', 'token' => trim($xauth)];
        }

        $xauthtoken = (string) $request->header('X-Auth-Token', '');
        if ($xauthtoken) {
            return ['source' => 'X-Auth-Token', 'token' => trim($xauthtoken)];
        }

        if ($t = (string) $request->query('token', '')) {
            return ['source' => 'query.token', 'token' => trim($t)];
        }

        if ($t = (string) $request->input('token', '')) {
            return ['source' => 'input.token', 'token' => trim($t)];
        }

        return ['source' => null, 'token' => null];
    }

    private function authHeaderSnapshot(Request $request): array
    {
        $auth = (string) $request->header('Authorization', '');
        $x1   = (string) $request->header('X-Authorization', '');
        $x2   = (string) $request->header('X-Auth-Token', '');
        $srvA = (string) $request->server('HTTP_AUTHORIZATION', '');
        $srvB = (string) $request->server('REDIRECT_HTTP_AUTHORIZATION', '');

        return [
            'ip'                      => $request->ip(),
            'has_authorization'       => $auth !== '',
            'authorization_prefix'    => $auth ? substr($auth, 0, 10) : '',
            'has_x_authorization'     => $x1 !== '',
            'x_authorization_prefix'  => $x1 ? substr($x1, 0, 10) : '',
            'has_x_auth_token'        => $x2 !== '',
            'x_auth_token_mask'       => $x2 ? $this->maskToken($x2) : '',
            'srv_http_authorization'  => $srvA ? substr($srvA, 0, 10) : '',
            'srv_redirect_http_auth'  => $srvB ? substr($srvB, 0, 10) : '',
            'qs_has_token'            => $request->has('token'),
            'input_has_token'         => $request->filled('token'),
            'path'                    => $request->path(),
            'method'                  => $request->method(),
            'ua'                      => substr((string)$request->userAgent(), 0, 80),
        ];
    }

    private function maskToken(string $t): string
    {
        $t = trim($t);
        if ($t === '') return '';
        $len = strlen($t);
        if ($len <= 8) return str_repeat('*', max(0, $len - 2)) . substr($t, -2);
        return substr($t, 0, 4) . '...' . substr($t, -4);
    }

    private function maskDocOrEmail(string $v): string
    {
        if (filter_var($v, FILTER_VALIDATE_EMAIL)) {
            [$user, $dom] = explode('@', $v, 2);
            $userMasked = mb_substr($user, 0, 1) . str_repeat('*', max(0, mb_strlen($user) - 1));
            return $userMasked . '@' . $dom;
        }
        $d = preg_replace('/\D+/', '', $v);
        if (strlen($d) <= 4) return str_repeat('*', max(0, strlen($d) - 1)) . substr($d, -1);
        return str_repeat('*', max(0, strlen($d) - 4)) . substr($d, -4);
    }
}
