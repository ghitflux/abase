<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use App\Models\AgenteCadastro;
use App\Models\AgenteDocIssue;
use App\Models\AgenteDocReupload;

class AnalistaController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth', 'role:analista']);
    }

    public function index(Request $r)
    {
        $perPage   = (int) $r->input('pp', 20);
        $rawSearch = trim((string) $r->input('q', ''));

        // Normaliza e extrai SOMENTE um possível "código de contrato"
        $normalized     = strtoupper($rawSearch);
        $normalized     = preg_replace('/[^A-Z0-9\-]/', '', $normalized);
        $isContractCode = $normalized !== '' && preg_match('/^[A-Z0-9]+(?:-[A-Z0-9]+)+$/', $normalized);
        $codeFilter     = $isContractCode ? $normalized : null;

        $contratos = AgenteCadastro::query()
            ->with([
                'reuploads' => function ($q) {
                    $q->select(
                        'id',
                        'agente_cadastro_id',
                        'status',
                        'uploaded_at',
                        'file_original_name',
                        'file_stored_name',
                        'file_relative_path',
                        'file_mime',
                        'file_size_bytes'
                    )->orderByDesc('uploaded_at')->orderByDesc('id');
                },
            ])
            ->withCount([
                'issues as open_issues_count'     => fn($q) => $q->where('status', 'incomplete'),
                'issues as resolved_issues_count' => fn($q) => $q->where('status', 'resolved'),
            ])
            // Filtro opcional por código do contrato
            ->when($codeFilter !== null, function ($q) use ($codeFilter) {
                $q->where('contrato_codigo_contrato', 'like', "%{$codeFilter}%");
            })
            // INCLUI na lista quem tem reupload (received/accepted/rejected),
            // mesmo que ainda exista 'incomplete'
            ->where(function ($w) {
                $w->whereDoesntHave('issues', function ($q) {
                        $q->where('status', 'incomplete');
                    })
                  ->orWhereHas('reuploads', function ($r) {
                        $r->whereIn('status', ['received', 'accepted', 'rejected']);
                    });
            })
            ->orderByDesc('id')
            ->paginate($perPage)
            ->withQueryString();

        // Lista informativa de reenvios (opcional)
        $reenviados = AgenteDocReupload::with(['cadastro', 'issue'])
            ->whereIn('status', ['received', 'accepted', 'rejected'])
            ->orderByRaw("FIELD(status, 'received','accepted','rejected')")
            ->orderByDesc('uploaded_at')
            ->orderByDesc('id')
            ->limit(200)
            ->get();

        return view('analista.dashboardanalista', [
            'contratos'     => $contratos,
            'search'        => $rawSearch,
            'perPage'       => $perPage,
            'reenviados'    => $reenviados,
            'onlyCode'      => true,
            'invalidSearch' => ($rawSearch !== '' && $codeFilter === null),
            'codeFilter'    => $codeFilter,
        ]);
    }

    public function markIncomplete(Request $request, AgenteCadastro $cadastro)
    {
        $request->validate([
            'mensagem' => 'required|string|min:5|max:5000',
        ]);

        AgenteDocIssue::create([
            'agente_cadastro_id'       => $cadastro->id,
            'cpf_cnpj'                 => $cadastro->cpf_cnpj,
            'contrato_codigo_contrato' => $cadastro->contrato_codigo_contrato,
            'analista_id'              => $request->user()->id,
            'status'                   => 'incomplete',
            'mensagem'                 => $request->input('mensagem'),
            'documents_snapshot_json'  => $cadastro->documents_json ?: null,
        ]);

        Log::info('Analista marcou documentação como incompleta', [
            'cadastro_id' => $cadastro->id,
            'no_status_change' => true,
        ]);

        return back()->with('ok', 'Marcado como documentação incompleta e notificação registrada.');
    }

    public function validateDocs(Request $request, AgenteCadastro $cadastro)
    {
        $valorMargem = $request->input('valor_margem', $cadastro->contrato_margem_disponivel);
        $auxPerc     = $cadastro->auxilio_taxa ?? 10.00;
        $auxValor    = is_null($valorMargem) ? null : round((float)$valorMargem * ($auxPerc / 100), 2);

        Log::info('Validação de documentos (analista) — sem alterar status de contrato', [
            'cadastro_id'     => $cadastro->id,
            'valor_margem'    => $valorMargem,
            'auxilio_percent' => $auxPerc,
            'auxilio_valor'   => $auxValor,
        ]);

        DB::transaction(function () use ($request, $cadastro, $valorMargem, $auxPerc, $auxValor) {
            // Resolver pendências "incomplete"
            $updated = AgenteDocIssue::where('agente_cadastro_id', $cadastro->id)
                ->where('status', 'incomplete')
                ->update([
                    'status'     => 'resolved',
                    'updated_at' => now(),
                ]);

            // Se não havia "incomplete", registra um resolved informativo
            if ($updated === 0) {
                $msg = 'Validação inicial sem pendências.';
                if (!is_null($valorMargem)) {
                    $msg .= ' Margem: R$ ' . number_format((float)$valorMargem, 2, ',', '.');
                    if (!is_null($auxValor)) {
                        $msg .= ' | Auxílio (' . $auxPerc . '%): R$ ' . number_format($auxValor, 2, ',', '.');
                    }
                }

                AgenteDocIssue::create([
                    'agente_cadastro_id'       => $cadastro->id,
                    'cpf_cnpj'                 => $cadastro->cpf_cnpj,
                    'contrato_codigo_contrato' => $cadastro->contrato_codigo_contrato,
                    'analista_id'              => $request->user()->id,
                    'status'                   => 'resolved',
                    'mensagem'                 => $msg,
                    'documents_snapshot_json'  => $cadastro->documents_json ?: null,
                ]);
            }

            // Aceita reuploads "received"
            AgenteDocReupload::where('agente_cadastro_id', $cadastro->id)
                ->where('status', 'received')
                ->update([
                    'status'     => 'accepted',
                    'updated_at' => now(),
                ]);

            // *** IMPORTANTE ***
            // O ANALISTA NÃO ALTERA O STATUS DO CONTRATO AQUI.
            // NADA de $cadastro->contrato_status_contrato ou contrato_data_aprovacao.
        });

        Log::info('Validação concluída sem alteração de contrato_status_contrato', [
            'cadastro_id' => $cadastro->id,
            'no_status_change' => true,
        ]);

        return back()->with('ok', 'Documentação validada. Status do contrato permanece pendente para decisão de níveis superiores.');
    }

    public function validateContract(Request $request, AgenteCadastro $cadastro)
    {
        // Mantemos o alias por compatibilidade, mas sem alterar status do contrato.
        return $this->validateDocs($request, $cadastro);
    }

    /** Stream/Download de reenvios */
    public function streamReupload(AgenteDocReupload $reupload)
    {
        $rel = (string) $reupload->file_relative_path;
        $rel = ltrim($rel, '/');
        $rel = preg_replace('~^(?:storage|public)/~', '', $rel);

        if ($rel === '' || !Storage::disk('public')->exists($rel)) {
            abort(404);
        }

        $path = Storage::disk('public')->path($rel);
        $mime = Storage::disk('public')->mimeType($rel) ?: 'application/octet-stream';

        if (request()->boolean('dl')) {
            return response()->download($path, basename($rel), ['Content-Type' => $mime]);
        }

        return response()->file($path, [
            'Content-Type'  => $mime,
            'Cache-Control' => 'private, max-age=31536000',
        ]);
    }
}
