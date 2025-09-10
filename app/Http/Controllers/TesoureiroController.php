<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage; // <-- novo
use Illuminate\Support\Str;
use Carbon\Carbon;

use App\Models\AgenteCadastro;
use App\Models\AgenteDocReupload;
use App\Models\TesourariaPagamento;
use App\Models\User;

class TesoureiroController extends Controller
{
    public function __construct()
    {
        // permite que admin também visualize comprovantes se necessário
        $this->middleware(['auth', 'role:tesoureiro'])->except(['streamComprovante']);
    }

    /**
     * Dashboard do Tesoureiro
     * - Mostra SOMENTE cadastros que possuem issues "resolved"
     * - Competência: tenta contrato_mes_averbacao; se vazio, usa updated_at do issue resolved
     */
    public function index(Request $r)
    {
        $mes = $r->input('mes', now()->format('Y-m'));
        [$yy, $mm] = explode('-', $mes);
        $yy = (int) $yy;
        $mm = (int) $mm;

        $start = Carbon::createFromDate($yy, $mm, 1)->startOfMonth();
        $end   = (clone $start)->endOfMonth();

        $concluidos = AgenteCadastro::query()
            ->with([
                'issues:id,agente_cadastro_id,status,updated_at',
            ])
            ->whereHas('issues', fn($q) => $q->where('status', 'resolved'))
            ->whereDoesntHave('issues', fn($q) => $q->where('status', 'incomplete'))
            ->where(function ($q) use ($yy, $mm, $start, $end) {
                $q->whereYear('contrato_mes_averbacao', $yy)
                  ->whereMonth('contrato_mes_averbacao', $mm)
                  ->orWhereHas('issues', function ($i) use ($start, $end) {
                      $i->where('status','resolved')->whereBetween('updated_at', [$start, $end]);
                  });
            })
            ->orderByDesc('id')
            ->get();

        $metrics   = ['receitas_mes' => '—', 'despesas_mes' => '—', 'saldo' => '—', 'pendencias' => '0'];
        $reuploads = collect();
        $pendentes = collect();
        $recebidos = collect();

        return view('tesoureiro.dashboardtesoureiro', compact(
            'concluidos', 'metrics', 'reuploads', 'pendentes', 'recebidos'
        ));
    }

    /**
     * POST "Efetuar pagamento". Usa a MARGEM como valor padrão.
     */
    public function pagamentosEfetuar(Request $request, AgenteCadastro $cadastro)
    {
        $data = $request->validate([
            'valor_pago'      => ['nullable','numeric','min:0'],
            'forma_pagamento' => ['nullable','string','max:40'],
            'notes'           => ['nullable','string','max:2000'],
        ]);

        // valor padrão = margem disponível
        $valor = $data['valor_pago'] ?? $cadastro->contrato_margem_disponivel;
        $msgExtra = '';

        DB::transaction(function () use ($cadastro, $valor, $data, &$msgExtra) {
            TesourariaPagamento::updateOrCreate(
                ['agente_cadastro_id' => $cadastro->id],
                [
                    // snapshots úteis
                    'cpf_cnpj'                   => $cadastro->cpf_cnpj,
                    'full_name'                  => $cadastro->full_name,
                    'agente_responsavel'         => $cadastro->agente_responsavel,
                    'contrato_codigo_contrato'   => $cadastro->contrato_codigo_contrato,
                    'contrato_margem_disponivel' => $cadastro->contrato_margem_disponivel,

                    // dados do pagamento
                    'valor_pago'         => $valor,
                    'status'             => 'pago',
                    'paid_at'            => now(),
                    'created_by_user_id' => Auth::id(),
                    'forma_pagamento'    => $data['forma_pagamento'] ?? null,
                    'notes'              => $data['notes'] ?? null,
                ]
            );

            $result = $this->ensureAssociadoAccount($cadastro);

            if ($result['status'] === 'created') {
                $msgExtra = " Conta do associado criada. Login: CPF (somente dígitos). Senha: matrícula do servidor público.";
                if (!empty($result['generated_temp'])) {
                    $msgExtra .= " Observação: matrícula ausente; senha temporária foi gerada.";
                }
            } elseif ($result['status'] === 'attached') {
                $msgExtra = " Associado já existia; papel garantido.";
            } elseif ($result['status'] === 'missing_cpf') {
                $msgExtra = " Atenção: cadastro sem CPF/CNPJ válido — não foi possível criar a conta do associado.";
            }
        });

        return back()->with('ok', 'Pagamento marcado como concluído.' . $msgExtra);
    }

    /**
     * Upload do comprovante.
     * Salva apenas o caminho RELATIVO no disk('public'), ex.: "tesouraria/comprovantes/6/2025...png"
     */
    public function pagamentosUploadComprovante(Request $request, AgenteCadastro $cadastro)
    {
        $request->validate([
            'comprovante' => ['required','file','max:10240','mimes:pdf,jpg,jpeg,png,webp'],
        ]);

        $file = $request->file('comprovante');

        $dir        = 'tesouraria/comprovantes/'.$cadastro->id;
        $ext        = strtolower($file->getClientOriginalExtension() ?: 'bin');
        $storedName = now()->format('Ymd_His').'_'.\Illuminate\Support\Str::random(8).'.'.$ext;

        // caminho RELATIVO no disk('public')
        $relativePath = $file->storeAs($dir, $storedName, 'public');

        $pay = TesourariaPagamento::firstOrNew(['agente_cadastro_id' => $cadastro->id]);
        if (!$pay->exists) {
            $pay->fill([
                'cpf_cnpj'                   => $cadastro->cpf_cnpj,
                'full_name'                  => $cadastro->full_name,
                'agente_responsavel'         => $cadastro->agente_responsavel,
                'contrato_codigo_contrato'   => $cadastro->contrato_codigo_contrato,
                'contrato_margem_disponivel' => $cadastro->contrato_margem_disponivel,
                'status'                     => 'pendente',
                'created_by_user_id'         => Auth::id(),
            ]);
        }

        $pay->comprovante_path = $relativePath; // apenas relativo
        $pay->save();

        return back()->with('ok', 'Comprovante enviado com sucesso. Pagamento liberado para este contrato.');
    }

    /**
     * Exibe o comprovante lendo do disk('public').
     * Aceita registros antigos com "storage/" ou "public/" no início.
     */
    public function streamComprovante(TesourariaPagamento $pagamento)
    {
        $user = auth()->user();
        if (!($user && ($user->hasRole('admin') || $user->hasRole('tesoureiro')))) {
            abort(403);
        }

        $rel = (string) $pagamento->comprovante_path;
        if ($rel === '') abort(404);

        // normaliza prefixos legados
        $rel = preg_replace('~^/?(?:storage/|public/)~', '', $rel);

        if (!Storage::disk('public')->exists($rel)) {
            abort(404);
        }

        $path = Storage::disk('public')->path($rel);
        $mime = Storage::disk('public')->mimeType($rel) ?: 'application/octet-stream';

        return response()->file($path, [
            'Content-Type'  => $mime,
            'Cache-Control' => 'private, max-age=31536000',
        ]);
    }

    public function reuploadPagamentoEfetivado(AgenteDocReupload $reupload)
    {
        $reupload->update(['status' => 'accepted']);
        return back()->with('ok', 'Reenvio marcado como concluído.');
    }

    /** Cria/atualiza um lançamento pendente (sem marcar como pago). */
    public function pagamentosGerar(Request $request, AgenteCadastro $cadastro)
    {
        $valor = $request->input('valor_pago', $cadastro->contrato_margem_disponivel);

        TesourariaPagamento::updateOrCreate(
            ['agente_cadastro_id' => $cadastro->id],
            [
                'cpf_cnpj'                   => $cadastro->cpf_cnpj,
                'full_name'                  => $cadastro->full_name,
                'agente_responsavel'         => $cadastro->agente_responsavel,
                'contrato_codigo_contrato'   => $cadastro->contrato_codigo_contrato,
                'contrato_margem_disponivel' => $cadastro->contrato_margem_disponivel,

                'status'             => 'pendente',
                'valor_pago'         => $valor,
                'paid_at'            => null,
                'created_by_user_id' => Auth::id(),
            ]
        );

        return back()->with('ok', 'Lançamento criado com sucesso.');
    }

    /**
     * Garante que exista uma conta de usuário para o associado.
     */
    protected function ensureAssociadoAccount(AgenteCadastro $cadastro): array
    {
        $cpf = preg_replace('/\D+/', '', (string)($cadastro->cpf_cnpj ?? ''));
        if ($cpf === '') {
            return ['status' => 'missing_cpf'];
        }

        $matriculaDigits = preg_replace('/\D+/', '', (string)($cadastro->matricula_servidor_publico ?? ''));
        $generatedTemp   = false;

        if ($matriculaDigits === '') {
            $matriculaDigits = Str::random(10);
            $generatedTemp = true;
        }

        $emailFromCadastro = trim((string)($cadastro->email ?? ''));
        $emailFromCadastro = $emailFromCadastro !== '' ? $emailFromCadastro : null;

        $user = null;
        if (Schema::hasColumn('users', 'username')) {
            $user = User::where('username', $cpf)->first();
        }
        if (!$user && Schema::hasColumn('users', 'email')) {
            $emailsProbe = array_values(array_unique(array_filter([
                $emailFromCadastro,
                $cpf, // legado
            ])));
            if (!empty($emailsProbe)) {
                $user = User::whereIn('email', $emailsProbe)->first();
            }
        }

        if ($user) {
            $this->attachAssociadoRole($user);
            return ['status' => 'attached', 'user' => $user];
        }

        $payload = [
            'name'     => $cadastro->full_name ?: 'Associado',
            'password' => Hash::make($matriculaDigits),
        ];

        if (Schema::hasColumn('users', 'email')) {
            $payload['email'] = $emailFromCadastro ?: $cpf;
        }
        if (Schema::hasColumn('users', 'username')) {
            $payload['username'] = $cpf;
        }
        if (Schema::hasColumn('users', 'must_set_password')) {
            $payload['must_set_password'] = false;
        }

        $user = new User();
        $user->forceFill($payload)->save();

        $this->attachAssociadoRole($user);

        return [
            'status'         => 'created',
            'user'           => $user,
            'generated_temp' => $generatedTemp,
        ];
    }

    protected function attachAssociadoRole(User $user): void
    {
        $roleName = 'associado';

        if (method_exists($user, 'assignRole') && class_exists(\Spatie\Permission\Models\Role::class)) {
            \Spatie\Permission\Models\Role::findOrCreate($roleName, 'web');
            if (!$user->hasRole($roleName)) {
                $user->assignRole($roleName);
            }
            return;
        }

        if (Schema::hasTable('role_user') && Schema::hasTable('roles')) {
            $roleId = DB::table('roles')->where('name', $roleName)->value('id');
            if (!$roleId) {
                $roleId = DB::table('roles')->insertGetId([
                    'name'       => $roleName,
                    'guard_name' => 'web',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }

            DB::table('role_user')->updateOrInsert(
                ['role_id' => $roleId, 'user_id' => $user->id],
                ['created_at' => now(), 'updated_at' => now()]
            );
        }
    }
	
	public function pagamentosCongelar(Request $request, AgenteCadastro $cadastro)
{
    // Usa a margem como valor-base registrado, mas sem pagar
    TesourariaPagamento::updateOrCreate(
        ['agente_cadastro_id' => $cadastro->id],
        [
            'cpf_cnpj'                   => $cadastro->cpf_cnpj,
            'full_name'                  => $cadastro->full_name,
            'agente_responsavel'         => $cadastro->agente_responsavel,
            'contrato_codigo_contrato'   => $cadastro->contrato_codigo_contrato,
            'contrato_margem_disponivel' => $cadastro->contrato_margem_disponivel,

            'status'             => 'cancelado',   // <<< congela / não formaliza
            'valor_pago'         => $cadastro->contrato_margem_disponivel,
            'paid_at'            => null,
            'created_by_user_id' => Auth::id(),
        ]
    );

    return back()->with('ok', 'Contrato congelado. Você ainda pode enviar o comprovante e efetivar o pagamento quando quiser.');
}

}
