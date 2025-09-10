<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Http\UploadedFile;
use App\Models\AgenteCadastro;
use App\Models\AgenteDocIssue;
use App\Models\AgenteDocReupload;

class AgenteController extends Controller
{
    public function index()
    {
        return view('agente.dashboardagente');
    }

    /* ===================== Helpers ===================== */

    private function onlyDigits(?string $s): string
    {
        return preg_replace('/\D+/', '', (string) $s) ?? '';
    }

    private function brlToDecimal(?string $s): ?float
    {
        if ($s === null) return null;
        $s = trim($s);
        if ($s === '') return null;
        $s = str_replace(['R$', ' '], '', $s);
        $s = str_replace('.', '', $s);
        $s = str_replace(',', '.', $s);
        return is_numeric($s) ? (float) $s : null;
    }

    private function pctToDecimal(?string $s): ?float
    {
        if ($s === null) return null;
        $s = trim($s);
        $s = str_replace(['%',' '], '', $s);
        $s = str_replace('.', '', $s);
        $s = str_replace(',', '.', $s);
        if (!is_numeric($s)) return null;
        return round((float)$s, 2);
    }

    private function dateBrToIso(?string $s): ?string
    {
        if (!$s) return null;
        $s = trim($s);
        if (preg_match('~^(\d{2})/(\d{2})/(\d{4})$~', $s, $m)) return "{$m[3]}-{$m[2]}-{$m[1]}";
        if (preg_match('~^\d{4}-\d{2}-\d{2}$~', $s)) return $s;
        return null;
    }

    private function monthToDate(?string $s): ?string
    {
        if (!$s) return null;
        $s = trim($s);
        if (preg_match('~^\d{4}-\d{2}$~', $s)) return $s.'-01';
        return $this->dateBrToIso($s);
    }

    private function mapEstadoCivil(?string $val): ?string
    {
        $map = [
            'single'   => 'Solteiro(a)',
            'married'  => 'Casado(a)',
            'divorced' => 'Divorciado(a)',
            'widowed'  => 'Viúvo(a)',
        ];
        if (!$val) return null;
        $val = strtolower(trim($val));
        return $map[$val] ?? null;
    }

    /**
     * SIMULADOR — MARGEM = Líquido − (30% do Bruto)
     */
    private function calcularMargem(?float $valorBruto, ?float $liqCc, ?float $mensalidade = null, int $prazo = 3): array
    {
        $vb   = (float) ($valorBruto ?? 0);
        $liq  = (float) ($liqCc ?? 0);
        $mens = (float) ($mensalidade ?? 0);
        $pz   = max((int) $prazo, 0);

        $trintaBruto      = round($vb * 0.30, 2);
        $margem           = round($liq - $trintaBruto, 2);
        $valorAntecipacao = round($mens * $pz, 2);
        $doacaoFundo      = round($valorAntecipacao * 0.30, 2);

        return [
            'trinta_bruto'      => $trintaBruto,
            'margem'            => $margem,
            'valor_antecipacao' => $valorAntecipacao,
            'doacao_fundo'      => $doacaoFundo,
            'pode_prosseguir'   => ($margem > 0),
        ];
    }

    /**
     * Pega um status válido de "resolução" para a tabela agente_doc_issues (enum).
     * Na sua base: ENUM('incomplete','resolved') → retorna 'resolved'.
     */
    private function pickIssueResolvedStatus(\App\Models\AgenteDocIssue $issue): ?string
    {
        $table = $issue->getTable();
        if (!Schema::hasColumn($table, 'status')) return null;

        try {
            $col  = DB::selectOne("SHOW COLUMNS FROM {$table} WHERE Field = 'status'");
            $type = $col->Type ?? '';
            if (stripos($type, 'enum(') !== false) {
                preg_match_all("/'([^']+)'/", $type, $m);
                $allowed = $m[1] ?? [];
                if (in_array('resolved', $allowed, true)) return 'resolved';
                foreach (['closed','complete','completed','done','ok'] as $opt) {
                    if (in_array($opt, $allowed, true)) return $opt;
                }
                foreach ($allowed as $opt) if ($opt !== 'incomplete') return $opt;
                return $allowed[0] ?? null;
            }
            return 'resolved';
        } catch (\Throwable $e) {
            return 'resolved';
        }
    }

    /**
     * Sincroniza o campo agent_uploads_json da pendência com os reuploads daquela pendência.
     */
    private function syncIssueAgentUploads(AgenteDocIssue $issue): void
    {
        try {
            $rows = AgenteDocReupload::where('agente_doc_issue_id', $issue->id)
                ->orderByDesc('uploaded_at')->orderByDesc('id')->get();

            $issue->agent_uploads_json = $rows->map(fn($r) => [
                'id'             => $r->id,
                'file'           => $r->file_original_name,
                'stored'         => $r->file_stored_name,
                'mime'           => $r->file_mime,
                'size_bytes'     => (int) $r->file_size_bytes,
                'relative_path'  => $r->file_relative_path,
                'status'         => $r->status,
                'uploaded_at'    => optional($r->uploaded_at)->toDateTimeString(),
            ])->values()->all();

            $issue->save();
        } catch (\Throwable $e) {
            Log::warning('AgenteController@syncIssueAgentUploads: falha', [
                'issue_id' => $issue->id, 'err' => $e->getMessage()
            ]);
        }
    }

    /* ===================== Store ===================== */

    public function store(Request $r)
    {
        // (validação idêntica ao seu código anterior)
        $r->validate([
            'docType'                 => 'required|in:CPF,CNPJ',
            'cpfCnpj'                 => 'required',
            'rg'                      => 'required|string',
            'orgaoExpedidor'          => 'required|string',
            'fullName'                => 'required|string|min:3',
            'birthDate'               => 'required|string',
            'profession'              => 'required|string',
            'maritalStatus'           => 'required|string',

            'cep'                     => 'required|string',
            'address'                 => 'required|string',
            'addressNumber'           => 'required|string',
            'complement'              => 'required|string',
            'neighborhood'            => 'required|string',
            'city'                    => 'required|string',
            'uf'                      => 'required|string',

            'cellphone'               => 'required|string',
            'email'                   => 'required|email',
            'orgaoPublico'            => 'required|string',
            'situacaoServidor'        => 'required|string',
            'matriculaServidorPublico'=> 'required|string',

            'calc.valor_bruto'        => 'required',
            'calc.liquido_cc'         => 'required',

            'contrato.mensalidade'        => 'required',
            'contrato.dataAprovacao'      => 'required',
            'contrato.dataEnvioPrimeira'  => 'required',
            'contrato.mesAverbacao'       => 'required',
            'contrato.doacaoAssociado'    => 'required',

            'anticipations'                           => 'required|array',
            'anticipations.*.numeroMensalidade'       => 'required|integer|min:1',
            'anticipations.*.valorAuxilio'            => 'required',
            'anticipations.*.dataEnvio'               => 'required',
            'anticipations.*.observacao'              => 'required',

            'agente.responsavel'  => 'required|string',
            'observacoes'         => 'required|string',

            'auxilioAgente.taxa'      => 'required',
            'auxilioAgente.dataEnvio' => 'required',

            'bank_name'    => 'required|string|max:100',
            'bank_agency'  => 'required|string|max:40',
            'bank_account' => 'required|string|max:40',
            'account_type' => 'required|in:corrente,poupanca',
            'pix_key'      => 'required|string|max:120',

            'documents.*'  => 'nullable|file|max:10240|mimes:pdf,jpg,jpeg,png,webp',

            'cpf_frente'         => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
            'cpf_verso'          => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
            'comp_endereco'      => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
            'comp_renda'         => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
            'contracheque_atual' => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
            'termo_adesao'       => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
            'termo_antecipacao'  => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
        ]);

        try {
            Log::info('AgenteController@store: arquivos recebidos', ['keys' => array_keys($r->allFiles())]);
        } catch (\Throwable $e) {
            Log::warning('AgenteController@store: falha ao inspecionar allFiles', ['err' => $e->getMessage()]);
        }

        // Documento
        $docType = strtoupper($r->input('docType')) === 'CNPJ' ? 'CNPJ' : 'CPF';
        $cpfCnpj = $this->onlyDigits($r->input('cpfCnpj'));
        if ($docType === 'CPF' && strlen($cpfCnpj) !== 11) return back()->withErrors(['cpfCnpj' => 'CPF inválido (11 dígitos).'])->withInput();
        if ($docType === 'CNPJ' && strlen($cpfCnpj) !== 14) return back()->withErrors(['cpfCnpj' => 'CNPJ inválido (14 dígitos).'])->withInput();

        $birthDate     = $this->dateBrToIso($r->input('birthDate'));
        $maritalStatus = $this->mapEstadoCivil($r->input('maritalStatus'));

        // Contrato
        $c = (array) $r->input('contrato', []);
        $contrato_mensalidade         = $this->brlToDecimal($c['mensalidade'] ?? null);
        $contrato_data_aprovacao      = $this->dateBrToIso($c['dataAprovacao'] ?? null);
        $contrato_data_envio_primeira = $this->dateBrToIso($c['dataEnvioPrimeira'] ?? null);
        $contrato_mes_averbacao       = $this->monthToDate($c['mesAverbacao'] ?? null);
        $contrato_doacao_associado    = $this->brlToDecimal($c['doacaoAssociado'] ?? null);

        $contrato_status_contrato  = 'Pendente';
        $contrato_taxa_antecipacao = 30.00;
        $prazoFixado               = 3;
        $contrato_codigo_contrato  = strtoupper('CTR-'.now()->format('YmdHis').'-'.Str::random(5));

        $mens = (float) ($contrato_mensalidade ?? 0);
        $contrato_valor_antecipacao = round($mens * $prazoFixado, 2);
        $contrato_margem_disponivel = round($contrato_valor_antecipacao * .7, 2);

        if ($contrato_taxa_antecipacao < 0 || $contrato_taxa_antecipacao > 100) {
            return back()->withErrors(['contrato.taxaAntecipacao' => 'Informe a taxa de antecipação entre 0 e 100%.'])->withInput();
        }

        // Cálculo
        $calc = (array) $r->input('calc', []);
        $calc_valor_bruto             = $this->brlToDecimal($calc['valor_bruto'] ?? null);
        $calc_liquido_cc              = $this->brlToDecimal($calc['liquido_cc'] ?? null);
        $calc_prazo_antecipacao       = $prazoFixado;
        $calc_mensalidade_associativa = $contrato_mensalidade;

        $sim = $this->calcularMargem($calc_valor_bruto, $calc_liquido_cc, $calc_mensalidade_associativa, $calc_prazo_antecipacao);
        if (!$sim['pode_prosseguir']) {
            return back()->withErrors(['calc.liquido_cc' => 'Cadastro bloqueado: a margem precisa ser maior que zero.'])->withInput();
        }

        // Agente
        $agente_nome         = trim((string)$r->input('agente.responsavel')) ?: optional($r->user())->name;
        $agente_responsavel  = $agente_nome;
        $agente_filial       = $agente_nome;

        // Auxílio
        $auxilio_taxa   = 10.00;
        $auxilio_status = 'Pendente';
        $auxilio_data   = $contrato_data_aprovacao;

        // Antecipações
        $anticip = [];
        foreach ((array) $r->input('anticipations', []) as $row) {
            $anticip[] = [
                'numeroMensalidade' => isset($row['numeroMensalidade']) ? (int)$row['numeroMensalidade'] : null,
                'valorAuxilio'      => $this->brlToDecimal($row['valorAuxilio'] ?? null),
                'dataEnvio'         => $this->dateBrToIso($row['dataEnvio'] ?? null),
                'status'            => $row['status'] ?? null,
                'observacao'        => $row['observacao'] ?? null,
            ];
        }

        // Dados bancários
        $bank_name    = trim((string)$r->input('bank_name'));
        $bank_agency  = trim((string)$r->input('bank_agency'));
        $bank_account = trim((string)$r->input('bank_account'));
        $account_type = in_array($r->input('account_type'), ['corrente','poupanca']) ? $r->input('account_type') : null;
        $pix_key      = trim((string)$r->input('pix_key'));

        Log::info('AgenteController@store: dados bancários recebidos', [
            'bank_name'    => $bank_name,
            'bank_agency'  => $bank_agency,
            'bank_account' => $bank_account,
            'account_type' => $account_type,
            'pix_key'      => $pix_key ? '(informado)' : null,
        ]);

        if (!$bank_name && !$bank_agency && !$bank_account && !$account_type && !$pix_key) {
            Log::warning('AgenteController@store: seção de dados bancários veio vazia.');
        }

        // Cria cadastro
        $cadastro = AgenteCadastro::create([
            'doc_type'         => $docType,
            'cpf_cnpj'         => $cpfCnpj,
            'rg'               => $r->input('rg'),
            'orgao_expedidor'  => $r->input('orgaoExpedidor'),
            'full_name'        => $r->input('fullName'),
            'birth_date'       => $this->dateBrToIso($r->input('birthDate')),
            'profession'       => $r->input('profession'),
            'marital_status'   => $maritalStatus,

            'cep'            => $r->input('cep'),
            'address'        => $r->input('address'),
            'address_number' => $r->input('addressNumber'),
            'complement'     => $r->input('complement'),
            'neighborhood'   => $r->input('neighborhood'),
            'city'           => $r->input('city'),
            'uf'             => $r->input('uf'),

            'cellphone'                  => $r->input('cellphone'),
            'orgao_publico'              => $r->input('orgaoPublico'),
            'situacao_servidor'          => $r->input('situacaoServidor'),
            'matricula_servidor_publico' => $r->input('matriculaServidorPublico'),
            'email'                      => $r->input('email'),

            'bank_name'    => $bank_name,
            'bank_agency'  => $bank_agency,
            'bank_account' => $bank_account,
            'account_type' => $account_type,
            'pix_key'      => $pix_key,

            'contrato_mensalidade'         => $contrato_mensalidade,
            'contrato_prazo_meses'         => $prazoFixado,
            'contrato_taxa_antecipacao'    => $contrato_taxa_antecipacao,
            'contrato_margem_disponivel'   => $contrato_margem_disponivel,
            'contrato_data_aprovacao'      => $contrato_data_aprovacao,
            'contrato_data_envio_primeira' => $contrato_data_envio_primeira,
            'contrato_valor_antecipacao'   => $contrato_valor_antecipacao,
            'contrato_status_contrato'     => 'Pendente',
            'contrato_mes_averbacao'       => $contrato_mes_averbacao,
            'contrato_codigo_contrato'     => $contrato_codigo_contrato,
            'contrato_doacao_associado'    => $contrato_doacao_associado,

            'calc_valor_bruto'             => $calc_valor_bruto,
            'calc_liquido_cc'              => $calc_liquido_cc,
            'calc_prazo_antecipacao'       => $calc_prazo_antecipacao,
            'calc_mensalidade_associativa' => $calc_mensalidade_associativa,

            'anticipations_json' => $anticip,
            'agente_responsavel' => $agente_responsavel,
            'agente_filial'      => $agente_filial,
            'observacoes'        => $r->input('observacoes'),

            'auxilio_taxa'       => $auxilio_taxa,
            'auxilio_data_envio' => $auxilio_data,
            'auxilio_status'     => $auxilio_status,
        ]);

        // Uploads (nomeados + legado)
        $docsMeta  = [];
        $namedKeys = ['cpf_frente','cpf_verso','comp_endereco','comp_renda','contracheque_atual','termo_adesao','termo_antecipacao'];
        $files = [];

        foreach ($namedKeys as $k) {
            $f = $r->file($k);
            if ($f instanceof UploadedFile && $f->isValid()) $files[] = [$k, $f];
        }

        $filesInput = $r->file('documents');
        if ($filesInput instanceof UploadedFile) {
            $files[] = ['documents[]', $filesInput];
        } else {
            foreach ($this->flattenFilesArray($filesInput) as $f) {
                if ($f instanceof UploadedFile && $f->isValid()) $files[] = ['documents[]', $f];
            }
        }

        try {
            if (!empty($files)) {
                $baseDir = public_path('uploads/associados/' . $cadastro->id);
                if (!is_dir($baseDir)) @mkdir($baseDir, 0775, true);

                foreach ($files as [$field, $f]) {
                    $orig   = $f->getClientOriginalName();
                    $ext    = strtolower($f->getClientOriginalExtension() ?: 'bin');
                    $mime   = $f->getClientMimeType() ?: 'application/octet-stream';
                    $size   = $f->getSize();
                    $stored = now()->format('Ymd_His') . '_' . Str::random(6) . '.' . $ext;

                    $f->move($baseDir, $stored);
                    if (!$size) $size = @filesize($baseDir . DIRECTORY_SEPARATOR . $stored) ?: 0;

                    $docsMeta[] = [
                        'original_name' => $orig,
                        'stored_name'   => $stored,
                        'mime'          => $mime,
                        'size_bytes'    => (int) $size,
                        'relative_path' => 'uploads/associados/' . $cadastro->id . '/' . $stored,
                        'uploaded_at'   => now()->toDateTimeString(),
                        'field'         => $field,
                    ];
                }
            }

            if ($docsMeta) {
                $cadastro->documents_json = array_values($docsMeta);
                $cadastro->save();
                Log::info('AgenteController@store: documentos salvos', [
                    'cadastro_id' => $cadastro->id,
                    'qtd'         => count($docsMeta),
                ]);
            } else {
                Log::info('AgenteController@store: nenhum documento anexado', ['cadastro_id' => $cadastro->id]);
            }
        } catch (\Throwable $e) {
            Log::error('AgenteController@store: erro ao salvar arquivos', [
                'cadastro_id' => $cadastro->id,
                'err'         => $e->getMessage(),
            ]);
            return back()->withErrors(['documents' => 'Falha ao salvar os arquivos. Tente novamente.'])->withInput();
        }

        return back()->with('ok', 'Cadastro salvo com sucesso!');
    }

    private function flattenFilesArray($items): array
    {
        $out = [];
        if (!$items) return $out;
        $walker = function ($v) use (&$out, &$walker) {
            if ($v instanceof UploadedFile) $out[] = $v;
            elseif (is_array($v)) foreach ($v as $vv) $walker($vv);
        };
        $walker($items);
        return $out;
    }

    /* ===================== Pendências ===================== */

    public function pendenciasIndex(Request $r)
    {
        $q       = trim((string) $r->input('q', ''));
        $digits  = preg_replace('/\D+/', '', $q);
        $meName  = trim((string) optional($r->user())->name);

        if ($meName === '') {
            Log::warning('AgenteController@pendenciasIndex: usuário sem nome');
            return view('agente.pendencias', ['issues' => collect(), 'q' => $q]);
        }

        $rows = AgenteDocIssue::with([
                'cadastro',
                'reuploads' => function ($q) { $q->orderByDesc('uploaded_at'); },
            ])
            ->where('status', 'incomplete')
            ->whereHas('cadastro', function ($c) use ($meName) {
                $c->where(function ($w) use ($meName) {
                    $w->where('agente_responsavel', $meName)
                      ->orWhere('agente_filial', $meName);
                });
            })
            ->when($q !== '', function ($w) use ($q, $digits) {
                $w->where(function ($qq) use ($q, $digits) {
                    $qq->where('contrato_codigo_contrato', 'like', "%{$q}%")
                       ->orWhere('cpf_cnpj', 'like', "%{$digits}%")
                       ->orWhereHas('cadastro', function ($c) use ($q) {
                           $c->where('full_name', 'like', "%{$q}%");
                       });
                });
            })
            ->orderByDesc('id')
            ->get();

        $issues = $rows->unique(function ($i) {
            $contrato = (string) ($i->contrato_codigo_contrato ?? '');
            $cadId    = (string) ($i->agente_cadastro_id ?? '');
            $cpf      = (string) ($i->cpf_cnpj ?? '');
            return ($contrato ?: 'NO-CTR') . '|' . ($cadId ?: 'NO-CAD') . '|' . ($cpf ?: 'NO-CPF');
        })->values();

        return view('agente.pendencias', ['issues' => $issues, 'q' => $q]);
    }

    /**
     * Upload de reenvio (apenas se a pendência for do agente logado).
     * Além de criar o AgenteDocReupload, sincroniza agent_uploads_json da pendência.
     */
    public function pendenciasUpload(Request $request, AgenteDocIssue $issue)
    {
        Log::info('AgenteController@pendenciasUpload: início', [
            'issue_id' => $issue->id,
            'user_id'  => optional($request->user())->id,
        ]);

        $meName = trim((string) optional($request->user())->name);
        $belongsToMe = $issue->cadastro
            && ($issue->cadastro->agente_responsavel === $meName
                || $issue->cadastro->agente_filial === $meName);

        if (!$belongsToMe) abort(403, 'Você não tem permissão para enviar documentos para esta pendência.');

        $request->validate([
            'files'   => 'required|array|min:1',
            'files.*' => 'file|max:10240|mimes:pdf,jpg,jpeg,png,webp',
        ], ['files.required' => 'Selecione pelo menos um documento.']);

        $filesReq = $request->file('files', []);
        $userId   = optional($request->user())->id;
        $dir      = 'agent-reuploads/'.$issue->id;

        foreach ($filesReq as $file) {
            if (!($file instanceof UploadedFile)) continue;

            try {
                $ext        = strtolower($file->getClientOriginalExtension() ?: 'bin');
                $storedName = now()->format('Ymd_His').'-'.Str::random(8).'.'.$ext;

                $path       = $file->storeAs($dir, $storedName, 'public'); // ex: agent-reuploads/123/xxx.pdf
                $relative   = 'storage/'.$path;                            // ex: storage/agent-reuploads/123/xxx.pdf

                $mime       = $file->getClientMimeType() ?: $file->getMimeType();
                $size       = $file->getSize();

                AgenteDocReupload::create([
                    'agente_doc_issue_id'      => $issue->id,
                    'agente_cadastro_id'       => $issue->agente_cadastro_id,
                    'uploaded_by_user_id'      => $userId,
                    'cpf_cnpj'                 => $issue->cpf_cnpj,
                    'contrato_codigo_contrato' => $issue->contrato_codigo_contrato,
                    'file_original_name'       => $file->getClientOriginalName(),
                    'file_stored_name'         => $storedName,
                    'file_relative_path'       => $relative,
                    'file_mime'                => $mime,
                    'file_size_bytes'          => $size,
                    'status'                   => 'received',
                    'uploaded_at'              => now(),
                ]);
            } catch (\Throwable $e) {
                Log::error('AgenteController@pendenciasUpload: falha ao processar arquivo', [
                    'issue_id'      => $issue->id,
                    'original_name' => $file instanceof UploadedFile ? $file->getClientOriginalName() : null,
                    'error'         => $e->getMessage(),
                ]);
            }
        }

        // Mantém histórico alinhado à sua migration
        $this->syncIssueAgentUploads($issue);

        return back()->with('ok', 'Documento(s) enviados com sucesso.');
    }

    /* ===================== Contratos (lista) ===================== */

    public function contratos()
    {
        $uid    = auth()->id();
        $meName = trim((string) (auth()->user()->name ?? ''));

        $tbl = 'agente_cadastros';
        $pick = function(array $cands) use ($tbl) {
            foreach ($cands as $c) if (Schema::hasColumn($tbl, $c)) return $c;
            return null;
        };

        $COL_FULLNAME = $pick(['full_name','fullName','nome_razao_social','nome']);
        $COL_CPF      = $pick(['cpf_cnpj','cpfCnpj','documento']);
        $COL_STATUS   = $pick(['contrato_status_contrato','status_contrato','statusContrato']);
        $COL_ORGAO    = $pick(['orgao_publico','orgaoPublico']);
        $COL_MATRIC   = $pick(['matricula_servidor_publico','matriculaServidorPublico','matricula']);
        $COL_MENSAL   = $pick(['contrato_mensalidade','valor_mensalidade','mensalidade']);
        $COL_DATA_APR = $pick(['contrato_data_aprovacao','data_aprovacao','dataAprovacao']);
        $COL_DATA_1A  = $pick(['contrato_data_envio_primeira','data_envio_primeira','dataEnvioPrimeira']);
        $COL_MARGEM   = $pick(['contrato_margem_disponivel','margem_disponivel','margemDisponivel','contrato_margem']);
        $COL_AUX_TAXA = $pick(['auxilio_taxa','auxilioTaxa']);

        $pAgg = DB::table('pagamentos_mensalidades as p')
            ->select('p.agente_cadastro_id',
                DB::raw('COUNT(p.id) as pagamentos_total'),
                DB::raw("SUM(CASE WHEN p.status_code IN ('1','4') THEN 1 ELSE 0 END) as pagamentos_efetivados"))
            ->groupBy('p.agente_cadastro_id');

        $q = DB::table('agente_cadastros as c')->leftJoinSub($pAgg, 'pp', function($j){
            $j->on('pp.agente_cadastro_id','=','c.id');
        });

        $TES_TBL = 'tesouraria_pagamentos';
        if (Schema::hasTable($TES_TBL)) {
            $tLast = DB::table($TES_TBL.' as tt')
                ->select(DB::raw('MAX(tt.id) as id'), 'tt.agente_cadastro_id')
                ->groupBy('tt.agente_cadastro_id');

            $q->leftJoinSub($tLast, 't_last', function($j){
                $j->on('t_last.agente_cadastro_id','=','c.id');
            });
            $q->leftJoin($TES_TBL.' as t', 't.id', '=', 't_last.id');

            $q->addSelect(
                DB::raw('t.status as tes_status'),
                DB::raw('t.paid_at as tes_paid_at'),
                DB::raw('t.comprovante_path as tes_comprovante_path')
            );
        } else {
            $q->addSelect(DB::raw('NULL as tes_status'), DB::raw('NULL as tes_paid_at'), DB::raw('NULL as tes_comprovante_path'));
        }

        if (Schema::hasColumn($tbl, 'agente_user_id')) {
            $q->where('c.agente_user_id', $uid);
        } elseif (Schema::hasColumn($tbl, 'user_id')) {
            $q->where('c.user_id', $uid);
        } elseif (Schema::hasColumn($tbl, 'created_by_user_id')) {
            $q->where('c.created_by_user_id', $uid);
        } elseif (Schema::hasColumn($tbl, 'agente_responsavel') || Schema::hasColumn($tbl, 'agente_filial')) {
            $q->where(function($w) use ($tbl, $meName) {
                if (Schema::hasColumn($tbl, 'agente_responsavel')) $w->orWhere('c.agente_responsavel', $meName);
                if (Schema::hasColumn($tbl, 'agente_filial'))      $w->orWhere('c.agente_filial', $meName);
            });
        }

        $q->addSelect('c.id');
        $q->when($COL_FULLNAME, fn($qq) => $qq->addSelect(DB::raw("c.$COL_FULLNAME as full_name")), fn($qq) => $qq->addSelect(DB::raw('NULL as full_name')));
        $q->when($COL_CPF,      fn($qq) => $qq->addSelect(DB::raw("c.$COL_CPF as cpf_cnpj")), fn($qq) => $qq->addSelect(DB::raw('NULL as cpf_cnpj')));
        $q->when($COL_STATUS,   fn($qq) => $qq->addSelect(DB::raw("c.$COL_STATUS as status_contrato")), fn($qq) => $qq->addSelect(DB::raw('NULL as status_contrato')));
        $q->when($COL_ORGAO,    fn($qq) => $qq->addSelect(DB::raw("c.$COL_ORGAO as orgao_publico")), fn($qq) => $qq->addSelect(DB::raw('NULL as orgao_publico')));
        $q->when($COL_MATRIC,   fn($qq) => $qq->addSelect(DB::raw("c.$COL_MATRIC as matricula_servidor_publico")), fn($qq) => $qq->addSelect(DB::raw('NULL as matricula_servidor_publico')));
        $q->when($COL_MENSAL,   fn($qq) => $qq->addSelect(DB::raw("c.$COL_MENSAL as mensalidade")), fn($qq) => $qq->addSelect(DB::raw('NULL as mensalidade')));
        $q->when($COL_DATA_APR, fn($qq) => $qq->addSelect(DB::raw("c.$COL_DATA_APR as data_aprovacao")), fn($qq) => $qq->addSelect(DB::raw('NULL as data_aprovacao')));
        $q->when($COL_DATA_1A,  fn($qq) => $qq->addSelect(DB::raw("c.$COL_DATA_1A as data_envio_primeira")), fn($qq) => $qq->addSelect(DB::raw('NULL as data_envio_primeira')));
        $q->when($COL_MARGEM,   fn($qq) => $qq->addSelect(DB::raw("c.$COL_MARGEM as margem_disponivel")), fn($qq) => $qq->addSelect(DB::raw('NULL as margem_disponivel')));
        $q->when($COL_AUX_TAXA, fn($qq) => $qq->addSelect(DB::raw("c.$COL_AUX_TAXA as auxilio_taxa")), fn($qq) => $qq->addSelect(DB::raw('NULL as auxilio_taxa')));

        $q->addSelect(DB::raw('COALESCE(pp.pagamentos_total,0) as pagamentos_total'));
        $q->addSelect(DB::raw('COALESCE(pp.pagamentos_efetivados,0) as pagamentos_efetivados'));

        $q->orderByDesc('c.created_at');

        try {
            $contratos = $q->get();
        } catch (\Throwable $e) {
            return view('agente.contratos', [
                'contratos' => collect(),
                'paymentsByContrato' => collect(),
                'erroQuery' => $e->getMessage(),
            ]);
        }

        $ids = $contratos->pluck('id')->all();
        $payments = empty($ids) ? collect()
            : DB::table('pagamentos_mensalidades')
                ->whereIn('agente_cadastro_id', $ids)
                ->orderBy('referencia_month')
                ->get()
                ->groupBy('agente_cadastro_id');

        return view('agente.contratos', [
            'contratos'          => $contratos,
            'paymentsByContrato' => $payments,
        ]);
    }

    /* ===================== Renovação ===================== */

    public function renovarContrato(Request $request, AgenteCadastro $cadastro)
    {
        $meName = trim((string) optional($request->user())->name);
        $can = false;

        if (Schema::hasColumn('agente_cadastros','agente_responsavel') && $cadastro->agente_responsavel === $meName) $can = true;
        if (Schema::hasColumn('agente_cadastros','agente_filial')      && $cadastro->agente_filial === $meName)      $can = true;
        if (Schema::hasColumn('agente_cadastros','agente_user_id')     && (int)$cadastro->agente_user_id === (int)$request->user()->id) $can = true;
        if (Schema::hasColumn('agente_cadastros','created_by_user_id') && (int)$cadastro->created_by_user_id === (int)$request->user()->id) $can = true;

        if (!$can) abort(403, 'Você não tem permissão para renovar este contrato.');

        $status = $cadastro->contrato_status_contrato ?? $cadastro->status_contrato ?? null;
        if ($status !== 'Concluído') {
            return back()->withErrors(['renovar' => 'Renovação disponível apenas após o contrato ser Concluído.']);
        }

        $novo = $cadastro->replicate();

        $novo->contrato_codigo_contrato   = strtoupper('CTR-'.now()->format('YmdHis').'-'.Str::random(5));
        $novo->contrato_status_contrato   = 'Pendente';
        if (Schema::hasColumn('agente_cadastros','status_contrato')) $novo->status_contrato = 'Pendente';
        if (Schema::hasColumn('agente_cadastros','auxilio_status'))  $novo->auxilio_status  = 'Pendente';

        foreach (['contrato_data_aprovacao','contrato_data_envio_primeira','contrato_mes_averbacao'] as $col) {
            if (Schema::hasColumn('agente_cadastros',$col)) $novo->{$col} = null;
        }

        if (Schema::hasColumn('agente_cadastros','documents_json')) $novo->documents_json = null;

        if (Schema::hasColumn('agente_cadastros','created_by_user_id')) $novo->created_by_user_id = $request->user()->id;
        if (Schema::hasColumn('agente_cadastros','agente_user_id'))     $novo->agente_user_id     = $request->user()->id;

        $novo->created_at = now();
        $novo->updated_at = now();
        $novo->save();

        return back()->with('ok', 'Contrato renovado com sucesso! Novo código: '.$novo->contrato_codigo_contrato);
    }

    /**
     * Atualiza cadastro dentro de uma pendência. Se "finalizar" = 1, resolve a pendência
     * (status = 'resolved') para o registro voltar à view do analista.
     * >>> Correção: ao finalizar pelo agente, os campos de aprovação são ignorados/zerados
     *     e o status do contrato permanece "Pendente", garantindo o retorno ao ANALISTA.
     */
public function pendenciasUpdate(Request $r, AgenteDocIssue $issue)
{
    $meName = trim((string) optional($r->user())->name);
    $belongsToMe = $issue->cadastro
        && ($issue->cadastro->agente_responsavel === $meName
            || $issue->cadastro->agente_filial === $meName);
    if (!$belongsToMe) abort(403, 'Você não tem permissão para editar este cadastro.');

    $r->validate([
        'docType'                   => 'required|in:CPF,CNPJ',
        'cpfCnpj'                   => 'required',
        'rg'                        => 'required|string',
        'orgaoExpedidor'            => 'required|string',
        'fullName'                  => 'required|string|min:3',
        'birthDate'                 => 'nullable|string',
        'profession'                => 'required|string',
        'maritalStatus'             => 'nullable|string',

        'cep'                       => 'nullable|string',
        'address'                   => 'nullable|string',
        'addressNumber'             => 'nullable|string',
        'complement'                => 'nullable|string',
        'neighborhood'              => 'nullable|string',
        'city'                      => 'nullable|string',
        'uf'                        => 'nullable|string',

        'cellphone'                 => 'required|string',
        'email'                     => 'required|email',
        'orgaoPublico'              => 'required|string',
        'situacaoServidor'          => 'required|string',
        'matriculaServidorPublico'  => 'required|string',

        'calc.valor_bruto'          => 'required',
        'calc.liquido_cc'           => 'required',

        'contrato.mensalidade'        => 'required',
        'contrato.dataAprovacao'      => 'nullable',
        'contrato.dataEnvioPrimeira'  => 'nullable',
        'contrato.mesAverbacao'       => 'nullable',
        'contrato.doacaoAssociado'    => 'nullable',

        'anticipations'                           => 'nullable|array',
        'anticipations.*.numeroMensalidade'       => 'nullable|integer|min:1',
        'anticipations.*.valorAuxilio'            => 'nullable',
        'anticipations.*.dataEnvio'               => 'nullable',
        'anticipations.*.observacao'              => 'nullable',

        'agente.responsavel'  => 'required|string',
        'observacoes'         => 'nullable|string',

        'auxilioAgente.taxa'      => 'nullable',
        'auxilioAgente.dataEnvio' => 'nullable',

        'bank_name'    => 'nullable|string|max:100',
        'bank_agency'  => 'nullable|string|max:40',
        'bank_account' => 'nullable|string|max:40',
        'account_type' => 'nullable|in:corrente,poupanca',
        'pix_key'      => 'nullable|string|max:120',

        'cpf_frente'         => 'nullable|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
        'cpf_verso'          => 'nullable|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
        'comp_endereco'      => 'nullable|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
        'comp_renda'         => 'nullable|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
        'contracheque_atual' => 'nullable|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
        'termo_adesao'       => 'nullable|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
        'termo_antecipacao'  => 'nullable|file|max:10240|mimes:jpg,jpeg,png,webp,pdf',
    ]);

    $docType = strtoupper($r->input('docType')) === 'CNPJ' ? 'CNPJ' : 'CPF';
    $cpfCnpj = $this->onlyDigits($r->input('cpfCnpj'));
    if ($docType === 'CPF' && strlen($cpfCnpj) !== 11) return back()->withErrors(['cpfCnpj' => 'CPF inválido (11 dígitos).']);
    if ($docType === 'CNPJ' && strlen($cpfCnpj) !== 14) return back()->withErrors(['cpfCnpj' => 'CNPJ inválido (14 dígitos).']);

    $birthDate     = $this->dateBrToIso($r->input('birthDate'));
    $maritalStatus = $this->mapEstadoCivil($r->input('maritalStatus'));

    $c = (array) $r->input('contrato', []);
    $contrato_mensalidade         = $this->brlToDecimal($c['mensalidade'] ?? null);
    $contrato_data_aprovacao      = $this->dateBrToIso($c['dataAprovacao'] ?? null);
    $contrato_data_envio_primeira = $this->dateBrToIso($c['dataEnvioPrimeira'] ?? null);
    $contrato_mes_averbacao       = $this->monthToDate($c['mesAverbacao'] ?? null);
    $contrato_doacao_associado    = $this->brlToDecimal($c['doacaoAssociado'] ?? null);

    $prazoFixado               = 3;
    $contrato_taxa_antecipacao = 30.00;

    $mens = (float) ($contrato_mensalidade ?? 0);
    $contrato_valor_antecipacao = round($mens * $prazoFixado, 2);
    $contrato_margem_disponivel = round($contrato_valor_antecipacao * .7, 2);

    $calc = (array) $r->input('calc', []);
    $calc_valor_bruto             = $this->brlToDecimal($calc['valor_bruto'] ?? null);
    $calc_liquido_cc              = $this->brlToDecimal($calc['liquido_cc'] ?? null);
    $calc_prazo_antecipacao       = $prazoFixado;
    $calc_mensalidade_associativa = $contrato_mensalidade;

    $sim = $this->calcularMargem($calc_valor_bruto, $calc_liquido_cc, $calc_mensalidade_associativa, $calc_prazo_antecipacao);
    if (!$sim['pode_prosseguir']) {
        return back()->withErrors(['calc.liquido_cc' => 'Atualização bloqueada: a margem precisa ser maior que zero.']);
    }

    $agente_nome        = trim((string)$r->input('agente.responsavel')) ?: optional($r->user())->name;
    $auxilio_taxa       = 10.00;
    $auxilio_data_envio = $this->dateBrToIso($r->input('auxilioAgente.dataEnvio'));

    $anticip = [];
    foreach ((array) $r->input('anticipations', []) as $row) {
        $anticip[] = [
            'numeroMensalidade' => isset($row['numeroMensalidade']) ? (int)$row['numeroMensalidade'] : null,
            'valorAuxilio'      => $this->brlToDecimal($row['valorAuxilio'] ?? null),
            'dataEnvio'         => $this->dateBrToIso($row['dataEnvio'] ?? null),
            'status'            => $row['status'] ?? 'Pendente',
            'observacao'        => $row['observacao'] ?? null,
        ];
    }

    $bank_name    = trim((string)$r->input('bank_name'));
    $bank_agency  = trim((string)$r->input('bank_agency'));
    $bank_account = trim((string)$r->input('bank_account'));
    $account_type = in_array($r->input('account_type'), ['corrente','poupanca']) ? $r->input('account_type') : null;
    $pix_key      = trim((string)$r->input('pix_key'));

    $cadastro = $issue->cadastro;
    if (!$cadastro) return back()->withErrors(['cadastro' => 'Cadastro não encontrado para esta pendência.']);

    // Se for finalizar, zera datas de aprovação/envios para manter o contrato no funil correto (ANALISTA primeiro).
    $finalizar = $r->boolean('finalizar');
    if ($finalizar) {
        $contrato_data_aprovacao      = null;
        $contrato_data_envio_primeira = null;
        $contrato_mes_averbacao       = null;
    }

    $cadastro->fill([
        'doc_type'         => $docType,
        'cpf_cnpj'         => $cpfCnpj,
        'rg'               => $r->input('rg'),
        'orgao_expedidor'  => $r->input('orgaoExpedidor'),
        'full_name'        => $r->input('fullName'),
        'birth_date'       => $birthDate,
        'profession'       => $r->input('profession'),
        'marital_status'   => $maritalStatus,

        'cep'            => $r->input('cep'),
        'address'        => $r->input('address'),
        'address_number' => $r->input('addressNumber'),
        'complement'     => $r->input('complement'),
        'neighborhood'   => $r->input('neighborhood'),
        'city'           => $r->input('city'),
        'uf'             => $r->input('uf'),

        'cellphone'                  => $r->input('cellphone'),
        'orgao_publico'              => $r->input('orgaoPublico'),
        'situacao_servidor'          => $r->input('situacaoServidor'),
        'matricula_servidor_publico' => $r->input('matriculaServidorPublico'),
        'email'                      => $r->input('email'),

        'bank_name'    => $bank_name,
        'bank_agency'  => $bank_agency,
        'bank_account' => $bank_account,
        'account_type' => $account_type,
        'pix_key'      => $pix_key,

        'contrato_mensalidade'         => $contrato_mensalidade,
        'contrato_prazo_meses'         => $prazoFixado,
        'contrato_taxa_antecipacao'    => $contrato_taxa_antecipacao,
        'contrato_margem_disponivel'   => $contrato_margem_disponivel,
        'contrato_data_aprovacao'      => $contrato_data_aprovacao,
        'contrato_data_envio_primeira' => $contrato_data_envio_primeira,
        'contrato_valor_antecipacao'   => $contrato_valor_antecipacao,
        'contrato_status_contrato'     => 'Pendente',
        'contrato_mes_averbacao'       => $contrato_mes_averbacao,

        'calc_valor_bruto'             => $calc_valor_bruto,
        'calc_liquido_cc'              => $calc_liquido_cc,
        'calc_prazo_antecipacao'       => $calc_prazo_antecipacao,
        'calc_mensalidade_associativa' => $calc_mensalidade_associativa,

        'anticipations_json' => $anticip,
        'agente_responsavel' => $agente_nome,
        'agente_filial'      => $cadastro->agente_filial ?? $agente_nome,
        'observacoes'        => $r->input('observacoes'),

        'auxilio_taxa'       => $auxilio_taxa,
        'auxilio_data_envio' => $auxilio_data_envio,
        'auxilio_status'     => 'Pendente',
    ])->save();

    // ===== Uploads nomeados -> salvar em documents_json E CRIAR REUPLOADS PARA O ANALISTA =====
    $namedKeys = ['cpf_frente','cpf_verso','comp_endereco','comp_renda','contracheque_atual','termo_adesao','termo_antecipacao'];
    $docsMeta  = [];
    $baseDir   = public_path('uploads/associados/' . $cadastro->id);
    if (!is_dir($baseDir)) @mkdir($baseDir, 0775, true);

    foreach ($namedKeys as $k) {
        $f = $r->file($k);
        if ($f instanceof UploadedFile && $f->isValid()) {
            $orig   = $f->getClientOriginalName();
            $ext    = strtolower($f->getClientOriginalExtension() ?: 'bin');
            $mime   = $f->getClientMimeType() ?: 'application/octet-stream';
            $size   = $f->getSize();
            $stored = now()->format('Ymd_His') . '_' . Str::random(6) . '.' . $ext;

            $f->move($baseDir, $stored);
            if (!$size) { $path = $baseDir.DIRECTORY_SEPARATOR.$stored; $size = @filesize($path) ?: 0; }

            $docsMeta[] = [
                'original_name' => $orig,
                'stored_name'   => $stored,
                'mime'          => $mime,
                'size_bytes'    => (int) $size,
                'relative_path' => 'uploads/associados/' . $cadastro->id . '/' . $stored,
                'uploaded_at'   => now()->toDateTimeString(),
                'field'         => $k,
            ];
        }
    }

    if (!empty($docsMeta)) {
        $existing = is_array($cadastro->documents_json ?? null) ? $cadastro->documents_json : [];
        $cadastro->documents_json = array_values(array_merge($existing, $docsMeta));
        $cadastro->save();

        // **AQUI ESTÁ O PULO DO GATO** → gera entradas em agente_doc_reuploads
        $this->createReuploadsForIssueFromDocsMeta($issue, $cadastro, $docsMeta, optional($r->user())->id);
    }

    // ===== Finalização: enviar ao ANALISTA (mantendo status INCOMPLETE) =====
    if ($finalizar) {
        $updatesIssue = [];

        if (Schema::hasColumn($issue->getTable(), 'status')) {
            // mantém/força 'incomplete' para ficar na fila do analista
            $updatesIssue['status'] = 'incomplete';
        }
        if (Schema::hasColumn($issue->getTable(), 'mensagem')) {
            $carimbo = 'Reenvio do agente em ' . now()->format('d/m/Y H:i');
            $updatesIssue['mensagem'] = trim(($issue->mensagem ? ($issue->mensagem."\n\n") : '') . $carimbo);
        }
        // se existirem colunas de "resolved_*", deixamos limpas
        if (Schema::hasColumn($issue->getTable(), 'resolved_at')) $updatesIssue['resolved_at'] = null;
        if (Schema::hasColumn($issue->getTable(), 'closed_at'))   $updatesIssue['closed_at']   = null;
        if (Schema::hasColumn($issue->getTable(), 'resolved_by')) $updatesIssue['resolved_by'] = null;

        if (!empty($updatesIssue)) $issue->fill($updatesIssue)->save();

        // já sincronizado acima; garantimos aqui também
        $this->syncIssueAgentUploads($issue);

        return redirect()
            ->route('agente.pendencias')
            ->with('ok', 'Cadastro atualizado e documentação reenviada ao ANALISTA.');
    }

    return back()->with('ok', 'Cadastro atualizado com sucesso.');
}

	/**
 * Cria registros em agente_doc_reuploads com base nos uploads nomeados
 * salvos em documents_json, para que o ANALISTA veja os reenvios.
 */
private function createReuploadsForIssueFromDocsMeta(AgenteDocIssue $issue, AgenteCadastro $cadastro, array $docsMeta, ?int $uploaderId = null): void
{
    foreach ($docsMeta as $d) {
        try {
            AgenteDocReupload::create([
                'agente_doc_issue_id'      => $issue->id,
                'agente_cadastro_id'       => $cadastro->id,
                'uploaded_by_user_id'      => $uploaderId,
                'cpf_cnpj'                 => $cadastro->cpf_cnpj,
                'contrato_codigo_contrato' => $issue->contrato_codigo_contrato ?: ($cadastro->contrato_codigo_contrato ?? null),

                'file_original_name' => $d['original_name'] ?? ($d['stored_name'] ?? 'arquivo'),
                'file_stored_name'   => $d['stored_name']   ?? null,
                'file_relative_path' => $d['relative_path'] ?? null,
                'file_mime'          => $d['mime']          ?? null,
                'file_size_bytes'    => isset($d['size_bytes']) ? (int)$d['size_bytes'] : null,

                'status'      => 'received',
                'uploaded_at' => now(),
            ]);
        } catch (\Throwable $e) {
            Log::warning('AgenteController@createReuploadsForIssueFromDocsMeta: falha ao criar reupload', [
                'issue_id' => $issue->id,
                'file'     => $d['original_name'] ?? $d['stored_name'] ?? null,
                'err'      => $e->getMessage(),
            ]);
        }
    }

    // Mantém agent_uploads_json da pendência alinhado à tabela de reuploads.
    $this->syncIssueAgentUploads($issue);
}

}
