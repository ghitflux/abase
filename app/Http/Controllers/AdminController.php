<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;
use Laravel\Fortify\Contracts\CreatesNewUsers;
use Laravel\Jetstream\Jetstream;
use Illuminate\Support\Facades\Schema;
use App\Models\User;
use App\Models\AgenteCadastro;
use App\Models\AgenteDocIssue;
use App\Models\TesourariaPagamento;
use App\Models\PagamentoMensalidade;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth', 'role:admin']);
    }

    public function index()
    {
        $storeAgenteUrl = Route::has('admin.users.storeAgente') ? route('admin.users.storeAgente') : '#';
        $cadListUrl     = Route::has('admin.cadastros.list')   ? route('admin.cadastros.list')   : '#';
        $homeUrl        = url('/');
        $logoutUrl      = Route::has('logout') ? route('logout') : '#';

        // ====== Cadastros ======
        $perPage   = 5;
        $q         = request('q', '');
        $paginator = $this->buildCadastrosQuery($q)
            ->orderByDesc('created_at')
            ->paginate($perPage, ['*'], 'cad_page');

        $cadMeta = [
            'current_page' => $paginator->currentPage(),
            'last_page'    => $paginator->lastPage(),
            'from'         => $paginator->firstItem() ?? 0,
            'to'           => $paginator->lastItem() ?? 0,
            'total'        => $paginator->total(),
            'page_name'    => 'cad_page',
        ];

        // ====== Pendências de Documentos ======
        $pendPerPage = (int) request('per_pend', 10);
        $pendPerPage = max(1, min(50, $pendPerPage));
        $pendPage    = (int) request('pend_page', 1);
        $pendQ       = trim((string) request('pend_q', ''));

        $issuesBase = AgenteDocIssue::query()
            ->select(['id','cpf_cnpj','contrato_codigo_contrato','analista_id','status','mensagem','agent_uploads_json','created_at','updated_at'])
            ->with(['analista:id,name'])
            ->withCount('reuploads')
            ->when($pendQ !== '', function ($qry) use ($pendQ) {
                $qry->where(function ($w) use ($pendQ) {
                    $w->where('cpf_cnpj', 'like', "%{$pendQ}%")
                      ->orWhere('contrato_codigo_contrato', 'like', "%{$pendQ}%")
                      ->orWhereHas('analista', fn($q2) => $q2->where('name', 'like', "%{$pendQ}%"));
                });
            });

        $docIssues = (clone $issuesBase)
            ->orderByDesc('updated_at')
            ->paginate($pendPerPage, ['*'], 'pend_page', $pendPage);

        $analistas = User::whereIn('id', $docIssues->getCollection()->pluck('analista_id')->filter()->unique())
            ->pluck('name','id')->toArray();

        // ====== Tesouraria — Pagamentos ======
        $pagQ = trim((string) request('pag_q', ''));
        $pagamentos = TesourariaPagamento::query()
            ->select([
                'id','agente_cadastro_id','created_by_user_id',
                'contrato_codigo_contrato','contrato_valor_antecipacao',
                'cpf_cnpj','full_name','agente_responsavel',
                'status','valor_pago','paid_at','forma_pagamento',
                'comprovante_path','created_at',
            ])
            ->when($pagQ !== '', function ($qry) use ($pagQ) {
                $digits = preg_replace('/\D+/', '', $pagQ);
                $qry->where(function ($w) use ($pagQ, $digits) {
                    $w->where('full_name', 'like', "%{$pagQ}%")
                      ->orWhere('contrato_codigo_contrato', 'like', "%{$pagQ}%");
                    if ($digits !== '') $w->orWhere('cpf_cnpj', 'like', "%{$digits}%");
                });
            })
            ->orderByDesc(DB::raw('COALESCE(paid_at, created_at)'))
            ->get();

        // (Opcional) snapshot do mês de mensalidades recebidas
        $mensalidadesMes = PagamentoMensalidade::query()
            ->whereMonth('referencia_month', now()->month)
            ->whereYear('referencia_month', now()->year)
            ->count();

        return view('admin.dashboardadmin', [
            'storeAgenteUrl'  => $storeAgenteUrl,
            'cadListUrl'      => $cadListUrl,
            'homeUrl'         => $homeUrl,
            'logoutUrl'       => $logoutUrl,

            'cadastros'       => $paginator,
            'cadMeta'         => $cadMeta,
            'cadSearch'       => $q,
            'cadPerPage'      => $perPage,
            'cadPageName'     => $cadMeta['page_name'],

            'docIssues'       => $docIssues,
            'analistas'       => $analistas,

            'pagamentos'      => $pagamentos,
            'mensalidadesMes' => $mensalidadesMes,
        ]);
    }

    /**
     * Lista de cadastros (AJAX) para o painel do Admin.
     */
public function listCadastros(Request $request)
{
    $perPage  = (int) $request->input('per_page', 10);
    $perPage  = max(1, min(50, $perPage));
    $pageName = $request->input('page_name', 'cad_page');
    $page     = (int) $request->input($pageName, $request->input('page', 1));
    $q        = trim((string) $request->input('q', ''));

    $paginator = $this->buildCadastrosQuery($q)
        ->orderByDesc('created_at')
        ->paginate($perPage, ['*'], $pageName, $page);

    $items = $paginator->getCollection()->map(function (AgenteCadastro $c) {
        return [
            'id'                         => $c->id,
            'full_name'                  => $c->full_name,
            'cpf_cnpj'                   => $c->cpf_cnpj,
            'matricula_servidor_publico' => $c->matricula_servidor_publico, // <= NOVO
            'email'                      => $c->email,
            'orgao_publico'              => $c->orgao_publico,
            'situacao_servidor'          => $c->situacao_servidor,
            'contrato_codigo_contrato'   => $c->contrato_codigo_contrato,
            'contrato_prazo_meses'       => $c->contrato_prazo_meses,
            'contrato_taxa_antecipacao'  => $c->contrato_taxa_antecipacao,
            'contrato_mensalidade'       => $c->contrato_mensalidade,
            'contrato_valor_antecipacao' => $c->contrato_valor_antecipacao,
            'contrato_margem_disponivel' => $c->contrato_margem_disponivel,
            'contrato_status_contrato'   => $c->contrato_status_contrato,
            'agente_responsavel'         => $c->agente_responsavel,
            'observacoes'                => $c->observacoes,
            'status_norm'                => strtolower((string) $c->contrato_status_contrato),
        ];
    })->values();

    return response()->json([
        'data' => $items,
        'meta' => [
            'current_page' => $paginator->currentPage(),
            'last_page'    => $paginator->lastPage(),
            'from'         => $paginator->firstItem(),
            'to'           => $paginator->lastItem(),
            'total'        => $paginator->total(),
        ],
    ]);
}

    /**
     * Gera/mostra o PDF do cadastro (inline por padrão).
     * Use ?dl=1 para forçar download.
     * Se o DomPDF não estiver instalado, retorna a view HTML como fallback.
     */
    public function cadastroPdf($id)
{
    $cad = \App\Models\AgenteCadastro::findOrFail($id);

    // Antecipações em array (se vier JSON/string)
    $anticipations = [];
    $raw = $cad->anticipations_json;
    if (is_string($raw)) { $raw = json_decode($raw, true) ?: []; }
    if (is_array($raw))  { $anticipations = array_values($raw); }

    // -> tenta em ordem: admin/, pdf/, raiz
    $view = collect([
        'admin.cadastro-agente',
        'pdf.cadastro-agente',      // <-- onde seu arquivo está
        'cadastro-agente',
    ])->first(fn ($v) => view()->exists($v));

    if (!$view) {
        abort(500, 'View do PDF não encontrada. Coloque em resources/views/pdf/cadastro-agente.blade.php ou admin/cadastro-agente.blade.php');
    }

    $now       = now();
    $filename  = 'cadastro-'.\Illuminate\Support\Str::slug($cad->full_name ?: 'associado').'-'.$cad->id.'.pdf';
    $download  = request()->boolean('dl'); // ?dl=1 para forçar download

    // Preferencial: barryvdh/laravel-dompdf
    if (class_exists(\Barryvdh\DomPDF\Facade\Pdf::class)) {
        $pdf = \Barryvdh\DomPDF\Facade\Pdf::loadView($view, compact('cad','anticipations','now'))
            ->setPaper('a4');
        return $download ? $pdf->download($filename) : $pdf->stream($filename);
    }

    // Fallback: wrapper registrado no container
    if (app()->bound('dompdf.wrapper')) {
        $pdf = app('dompdf.wrapper');
        $pdf->loadView($view, compact('cad','anticipations','now'))->setPaper('a4');
        return $download ? $pdf->download($filename) : $pdf->stream($filename);
    }

    // Último recurso: retorna o HTML (útil para debug)
    return response()->view($view, compact('cad','anticipations','now'));
}


    // ===================== helpers =====================

protected function buildCadastrosQuery(string $q)
{
    $qb = AgenteCadastro::query()->select([
        'id','full_name','cpf_cnpj','email',
        'matricula_servidor_publico', // <= NOVO
        'orgao_publico','situacao_servidor',
        'contrato_codigo_contrato','contrato_prazo_meses','contrato_taxa_antecipacao',
        'contrato_mensalidade','contrato_valor_antecipacao','contrato_margem_disponivel',
        'contrato_status_contrato','agente_responsavel','observacoes',
        'created_at'
    ]);

    if ($q !== '') {
        $digits = preg_replace('/\D+/', '', $q);
        $qb->where(function ($w) use ($q, $digits) {
            $w->where('full_name', 'like', "%{$q}%")
              ->orWhere('email', 'like', "%{$q}%")
              ->orWhere('contrato_codigo_contrato', 'like', "%{$q}%")
              ->orWhere('matricula_servidor_publico', 'like', "%{$q}%"); // <= NOVO
            if ($digits !== '') {
                $w->orWhere('cpf_cnpj', 'like', "%{$digits}%")
                  ->orWhere('matricula_servidor_publico', 'like', "%{$digits}%"); // <= NOVO
            }
        });
    }
    return $qb;
}

    private function normalizeTxt(string $raw): string
    {
        $enc = @mb_detect_encoding($raw, ['UTF-8','Windows-1252','ISO-8859-1'], true) ?: 'UTF-8';
        $txt = $enc !== 'UTF-8' ? @mb_convert_encoding($raw, 'UTF-8', $enc) : $raw;
        $txt = str_replace("\x0C", "\n", $txt);
        $txt = str_replace(["\r\n","\r"], "\n", $txt);
        $txt = preg_replace('/[ \t\x{00A0}\x{2007}\x{202F}]+/u', ' ', $txt);
        return $txt;
    }

    public function baixaUpload(Request $r)
    {
        $r->validate([
            'abase' => ['required','file','mimetypes:text/plain,text/anytext,text/*','max:20480'],
        ], ['abase.required' => 'Selecione o arquivo ABASE.txt.']);

        $file     = $r->file('abase');
        $raw      = file_get_contents($file->getRealPath()) ?: '';
        $contents = $this->normalizeTxt($raw);

        $dir  = 'baixas';
        $name = now()->format('Ymd_His').'-'.Str::random(6).'.txt';

        // salva APENAS o caminho relativo, ex.: "baixas/20250831_xxxxxx.txt"
        $path = $file->storeAs($dir, $name, 'public');
        $publicPath = $path; // relativo; sem "storage/"

        $ref = $this->parseAbaseReferencia($contents);
        if (!$ref) {
            return back()->withErrors(['abase' => 'Não foi possível identificar a "Referência: mm/aaaa" no arquivo.']);
        }

        $linhas = $this->parseAbaseLinhas($contents);

        $importUuid = (string) Str::uuid();
        $created = 0; $dups = 0; $vinculados = 0; $concluidos = 0; $novosCad = 0;

        DB::transaction(function () use ($linhas, $ref, $publicPath, $importUuid, &$created, &$dups, &$vinculados, &$concluidos, &$novosCad) {

            foreach ($linhas as $L) {
                $cpf    = preg_replace('/\D+/', '', $L['cpf']);
                $valor  = (float) $L['valor'];
                $status = (string) $L['status'];
                $matric = $L['matricula'] ?? null;
                $orgao  = $L['orgao'] ?? null;
                $nome   = $L['nome'] ?? null;

                // Localiza cadastro existente por CPF
                $cad = AgenteCadastro::where('cpf_cnpj', 'like', "%{$cpf}%")->first();

                // upsert por (cpf, referencia)
                $pm = PagamentoMensalidade::where('cpf_cnpj', $cpf)
                    ->whereDate('referencia_month', $ref)
                    ->first();

                if ($pm) { $dups++; continue; }

                $pmData = [
                    'created_by_user_id' => auth()->id(),
                    'import_uuid'        => $importUuid,
                    'referencia_month'   => $ref,
                    'status_code'        => $status,
                    'matricula'          => $matric,
                    'orgao_pagto'        => $orgao,
                    'nome_relatorio'     => $nome,
                    'cpf_cnpj'           => $cpf,
                    'valor'              => $valor,
                    'source_file_path'   => $publicPath, // relativo
                ];
                if ($cad) {
                    $pmData['agente_cadastro_id'] = $cad->id;
                }

                PagamentoMensalidade::create($pmData);

                $created++;
                if ($cad) $vinculados++;

                if ($cad) {
                    $count = PagamentoMensalidade::where('agente_cadastro_id', $cad->id)
                        ->whereIn('status_code', ['1','4'])
                        ->count();

                    if ($count >= 3 && ($cad->contrato_status_contrato !== 'Concluído')) {
                        $cad->update(['contrato_status_contrato' => 'Concluído']);
                        $concluidos++;
                    }
                }
            }
        });

        return back()->with('ok',
            "Importação concluída: {$created} lançamentos, {$dups} duplicados ignorados, ".
            "{$vinculados} vinculados a cadastros, {$concluidos} contratos concluídos, ".
            "{$novosCad} cadastros criados (autocriação desativada)."
        );
    }

    private function parseAbaseReferencia(string $txt): ?string
    {
        if (preg_match('/Refer(?:e|ê)ncia:\s*(\d{2})\s*\/\s*(\d{4})/iu', $txt, $m)) {
            return sprintf('%04d-%02d-01', (int)$m[2], (int)$m[1]);
        }
        foreach (preg_split('/\n/', $txt) as $ln) {
            if (stripos($ln, 'Refer') !== false || stripos($ln, 'Entidade') !== false) {
                if (preg_match('/(\d{2})\s*\/\s*(\d{4})/', $ln, $m)) {
                    return sprintf('%04d-%02d-01', (int)$m[2], (int)$m[1]);
                }
            }
        }
        if (preg_match('/(\d{2})\s*\/\s*(\d{4})/', $txt, $m)) {
            return sprintf('%04d-%02d-01', (int)$m[2], (int)$m[1]);
        }
        return null;
    }

    private function parseAbaseLinhas(string $txt): array
    {
        $out = [];
        $lines = preg_split('/\R/u', $txt);

        foreach ($lines as $ln) {
            $line = rtrim($ln);

            if (!preg_match('~(\d{11})\s*$~', $line, $mCpf)) continue;
            $cpf = $mCpf[1];

            $tok = preg_split('/\s+/u', trim($line));
            if (count($tok) < 8) continue;

            $cpfTok = array_pop($tok);
            $orgao  = array_pop($tok);

            $valor = null; $valorIdx = null;
            for ($i = count($tok)-1; $i >= 0; $i--) {
                if (preg_match('~^\d+\.\d{2}$~', $tok[$i])) { $valor = (float)$tok[$i]; $valorIdx = $i; break; }
            }
            if ($valor === null) continue;

            $status    = $tok[0] ?? null;
            $matricula = $tok[1] ?? null;

            $nameEnd = max(2, ($valorIdx - 4));
            $nomeArr = array_slice($tok, 2, max(0, $nameEnd - 2));
            $nome    = trim(implode(' ', $nomeArr)) ?: null;

            $out[] = [
                'status'    => (string)$status,
                'matricula' => $matricula,
                'nome'      => $nome,
                'orgao'     => $orgao,
                'valor'     => $valor,
                'cpf'       => $cpfTok,
            ];
        }

        return $out;
    }

    /**
     * Stream do arquivo da mensalidade salvo em storage/app/public/baixas.
     * Aceita caminhos antigos iniciando por "storage/" ou "public/".
     */
    public function streamMensalidadeFile(PagamentoMensalidade $mensalidade)
    {
        $rel = (string) $mensalidade->source_file_path;
        if ($rel === '') abort(404);

        $rel = preg_replace('~^/?(?:storage/|public/)~', '', $rel);

        if (!Storage::disk('public')->exists($rel)) {
            abort(404);
        }

        $path = Storage::disk('public')->path($rel);
        $mime = Storage::disk('public')->mimeType($rel) ?: 'text/plain';

        return response()->file($path, [
            'Content-Type'  => $mime,
            'Cache-Control' => 'private, max-age=31536000',
        ]);
    }

    /**
     * Cria um usuário via Fortify e atribui o papel "agente".
     */
    public function storeAgente(Request $request, CreatesNewUsers $creator)
    {
        $input = $request->only(['name', 'email', 'password', 'password_confirmation']);

        if (Jetstream::hasTermsAndPrivacyPolicyFeature()) {
            $input['terms'] = true;
        }

        $user = null;

        DB::transaction(function () use ($creator, $input, &$user) {
            $user = $creator->create($input);

            $roleId = DB::table('roles')->where('name', 'agente')->value('id');
            if (!$roleId) {
                $roleId = DB::table('roles')->insertGetId(['name' => 'agente']);
            }

            $now = now();
            $exists = DB::table('role_user')
                ->where(['user_id' => $user->id, 'role_id' => $roleId])
                ->exists();

            if ($exists) {
                DB::table('role_user')
                    ->where(['user_id' => $user->id, 'role_id' => $roleId])
                    ->update(['updated_at' => $now]);
            } else {
                DB::table('role_user')->insert([
                    'user_id'    => $user->id,
                    'role_id'    => $roleId,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }
        });

        return back()->with('ok', 'Agente "'.$user->name.'" criado com sucesso!');
    }
	
	// ====== EXPORTS CSV ======

public function exportCadastrosCsv(Request $r)
{
    $q        = trim((string)$r->input('q',''));
    $status   = trim((string)$r->input('status',''));
    $dateFrom = $r->input('date_from');
    $dateTo   = $r->input('date_to');
    $all      = $r->boolean('all');            // quando marcado, ignora período
    $full     = $r->boolean('full', true);     // por padrão: exportar TABELA COMPLETA

    // Quando "full", não usamos o select enxuto do buildCadastrosQuery
    $qb = $full ? AgenteCadastro::query()
                : $this->buildCadastrosQuery($q);

    // Filtro de busca também no modo "full"
    if ($q !== '' && $full) {
        $digits = preg_replace('/\D+/', '', $q);
        $qb->where(function ($w) use ($q, $digits) {
            $w->where('full_name', 'like', "%{$q}%")
              ->orWhere('email', 'like', "%{$q}%")
              ->orWhere('contrato_codigo_contrato', 'like', "%{$q}%");
            if ($digits !== '') $w->orWhere('cpf_cnpj', 'like', "%{$digits}%");
        });
    }

    if ($status !== '') { $qb->where('contrato_status_contrato', $status); }

    // Ignora datas quando "Todos os registros" estiver marcado
    if (!$all && $dateFrom) { $qb->whereDate('created_at', '>=', $dateFrom); }
    if (!$all && $dateTo)   { $qb->whereDate('created_at', '<=', $dateTo); }

    // Nome do arquivo
    $file = ($full ? 'cadastros-completo-' : 'cadastros-') . now()->format('Ymd_His') . '.csv';
    $headers = [
        'Content-Type'        => 'text/csv; charset=UTF-8',
        'Content-Disposition' => 'attachment; filename="'.$file.'"',
        'Cache-Control'       => 'private, max-age=0, no-cache',
    ];

    // Colunas reais da tabela (ordem do schema)
    $columns = Schema::getColumnListing((new AgenteCadastro)->getTable());

    return response()->streamDownload(function() use ($qb, $columns){
        $out = fopen('php://output', 'w');

        // BOM UTF-8 para Excel
        echo chr(0xEF).chr(0xBB).chr(0xBF);

        // Cabeçalho
        fputcsv($out, $columns, ';');

        // Streaming sem estourar memória
        foreach ($qb->orderBy('id')->cursor() as $row) {
            $vals = [];
            foreach ($columns as $col) {
                $v = $row->{$col};

                // Normalizações simples
                if ($v instanceof \Carbon\Carbon) {
                    $v = $v->toDateTimeString();
                } elseif (is_array($v) || is_object($v)) {
                    $v = json_encode($v, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
                }

                $vals[] = $v;
            }
            fputcsv($out, $vals, ';');
        }
        fclose($out);
    }, $file, $headers);
}

public function exportPagamentosCsv(Request $r)
{
    $status   = trim((string)$r->input('status',''));     // pendente|pago|cancelado|'' (todos)
    $forma    = trim((string)$r->input('forma',''));
    $dateFrom = $r->input('date_from');
    $dateTo   = $r->input('date_to');

    $qb = TesourariaPagamento::query()->select([
        'id','full_name','cpf_cnpj','contrato_codigo_contrato',
        'status','valor_pago','contrato_valor_antecipacao',
        'paid_at','created_at','forma_pagamento','agente_responsavel'
    ]);

    if ($status !== '') { $qb->where('status', $status); }
    if ($forma  !== '') { $qb->where('forma_pagamento','like',"%{$forma}%"); }
    if ($dateFrom)      { $qb->where(DB::raw('COALESCE(paid_at, created_at)'), '>=', $dateFrom); }
    if ($dateTo)        { $qb->where(DB::raw('COALESCE(paid_at, created_at)'), '<=', $dateTo); }

    $rows = $qb->orderBy(DB::raw('COALESCE(paid_at, created_at)'))->get();

    $file = 'pagamentos-'.now()->format('Ymd_His').'.csv';
    $headers = [
        'Content-Type'        => 'text/csv; charset=UTF-8',
        'Content-Disposition' => 'attachment; filename="'.$file.'"',
    ];

    return response()->streamDownload(function() use ($rows){
        $out = fopen('php://output','w');
        echo chr(0xEF).chr(0xBB).chr(0xBF);
        fputcsv($out, [
            'ID','Nome','CPF/CNPJ','Contrato','Status',
            'Valor Pago','Valor Base (Antecip.)','Pago em','Criado em',
            'Forma','Agente Responsável'
        ], ';');

        foreach ($rows as $p) {
            fputcsv($out, [
                $p->id,
                $p->full_name,
                $p->cpf_cnpj,
                $p->contrato_codigo_contrato,
                $p->status,
                number_format((float)$p->valor_pago, 2, ',', '.'),
                number_format((float)$p->contrato_valor_antecipacao, 2, ',', '.'),
                $p->paid_at ? \Illuminate\Support\Carbon::parse($p->paid_at)->format('d/m/Y H:i') : '',
                $p->created_at ? \Illuminate\Support\Carbon::parse($p->created_at)->format('d/m/Y H:i') : '',
                $p->forma_pagamento,
                $p->agente_responsavel,
            ], ';');
        }
        fclose($out);
    }, $file, $headers);
}

public function exportMensalidadesCsv(Request $r)
{
    $status  = trim((string)$r->input('status','')); // '', 'ok', '2','3','5','6','S'
    $orgao   = trim((string)$r->input('orgao',''));
    $refFrom = $r->input('ref_from'); // YYYY-MM
    $refTo   = $r->input('ref_to');   // YYYY-MM

    $qb = PagamentoMensalidade::query()
        ->with(['cadastro:id,full_name'])
        ->select(['id','agente_cadastro_id','nome_relatorio','cpf_cnpj','referencia_month',
                  'valor','status_code','orgao_pagto','created_at']);

    if ($status === 'ok') {
        $qb->whereIn('status_code', ['1','4']);
    } elseif ($status !== '') {
        $qb->where('status_code', $status);
    }

    if ($orgao !== '') { $qb->where('orgao_pagto','like', "%{$orgao}%"); }

    if ($refFrom) {
        $qb->whereDate('referencia_month', '>=', $refFrom.'-01');
    }
    if ($refTo) {
        $qb->whereDate('referencia_month', '<=', $refTo.'-28'); // suficiente para o mês
    }

    $rows = $qb->orderBy('referencia_month')->get();

    $labels = [
        '1'=>'Efetivado','4'=>'Efetivado c/ diferença','2'=>'Sem margem (temp.)',
        '3'=>'Não lançado (outros)','5'=>'Problemas técnicos','6'=>'Com erros','S'=>'Compra dívida / Suspensão'
    ];

    $file = 'mensalidades-'.now()->format('Ymd_His').'.csv';
    $headers = [
        'Content-Type'        => 'text/csv; charset=UTF-8',
        'Content-Disposition' => 'attachment; filename="'.$file.'"',
    ];

    return response()->streamDownload(function() use ($rows, $labels){
        $out = fopen('php://output','w');
        echo chr(0xEF).chr(0xBB).chr(0xBF);
        fputcsv($out, [
            'ID','Nome','CPF/CNPJ','Referência','Valor','Status','Órgão Pagto',
            'Cadastro ID','Criado em'
        ], ';');

        foreach ($rows as $m) {
            $nome = optional($m->cadastro)->full_name ?: $m->nome_relatorio;
            $ref  = $m->referencia_month ? \Illuminate\Support\Carbon::parse($m->referencia_month)->format('m/Y') : '';
            fputcsv($out, [
                $m->id,
                $nome,
                $m->cpf_cnpj,
                $ref,
                number_format((float)$m->valor, 2, ',', '.'),
                $labels[$m->status_code] ?? $m->status_code,
                $m->orgao_pagto,
                $m->agente_cadastro_id,
                optional($m->created_at)->format('d/m/Y H:i'),
            ], ';');
        }
        fclose($out);
    }, $file, $headers);
}

}
