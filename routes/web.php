<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;

use App\Http\Controllers\AdminController;
use App\Http\Controllers\AgenteController;
use App\Http\Controllers\AnalistaController;
use App\Http\Controllers\TesoureiroController;
use App\Http\Controllers\AssociadoController;

/**
 * Fortify/Jetstream já registram:
 * - GET /login, POST /login
 * - GET /register, POST /register
 * - POST /logout
 * etc.
 * Aqui só tratamos o pós-login e as áreas internas.
 */

// Pós-login padrão do Fortify → decide o painel por papel
Route::get('/dashboard', function () {
    $u = Auth::user();
    if (!$u) {
        return redirect()->route('login');
    }

    if ($u->hasRole('admin'))      return redirect()->route('admin.dashboardadmin');
    if ($u->hasRole('analista'))   return redirect()->route('analista.dashboardanalista');
    if ($u->hasRole('tesoureiro')) return redirect()->route('tesoureiro.dashboardtesoureiro');
    if ($u->hasRole('agente'))     return redirect()->route('agente.dashboardagente');
    if ($u->hasRole('associado'))  return redirect()->route('associado.dashboardassociado');

    return redirect('/'); // fallback
})->middleware(['auth'])->name('dashboard');

/**
 * Áreas internas: grupos separados por papel
 */

// ===== ADMIN =====
Route::middleware(['auth', 'redirect.byrole', 'role:admin'])->group(function () {
    Route::get('/admin', [AdminController::class, 'index'])
        ->name('admin.dashboardadmin');

    // criação de agentes (admin)
    Route::post('/admin/users/agentes', [AdminController::class, 'storeAgente'])
        ->name('admin.users.storeAgente');

    // listagem dinâmica (AJAX) dos cadastros
    Route::get('/admin/cadastros', [AdminController::class, 'listCadastros'])
        ->name('admin.cadastros.list');

    // gerar/baixar PDF do cadastro do agente
    Route::get('/admin/cadastros/{id}/pdf', [AdminController::class, 'cadastroPdf'])
        ->name('admin.cadastros.pdf');

    // listagem dinâmica (AJAX) das pendências (agente_doc_issues)
    Route::get('/admin/pendencias', [AdminController::class, 'listDocIssues'])
        ->name('admin.pendencias.list');

    // upload do arquivo de baixa (ABASE)
    Route::post('/admin/baixa/upload', [AdminController::class, 'baixaUpload'])
        ->name('admin.baixa.upload');

    // ver/baixar o arquivo ABASE salvo (mensalidade)
    Route::get('/admin/baixas/{mensalidade}', [AdminController::class, 'streamMensalidadeFile'])
        ->name('admin.baixas.ver');
	
	// ===== EXPORTS CSV =====
Route::get('/admin/export/cadastros.csv',   [AdminController::class, 'exportCadastrosCsv'])
    ->name('admin.export.cadastros');

Route::get('/admin/export/pagamentos.csv',  [AdminController::class, 'exportPagamentosCsv'])
    ->name('admin.export.pagamentos');

Route::get('/admin/export/mensalidades.csv',[AdminController::class, 'exportMensalidadesCsv'])
    ->name('admin.export.mensalidades');

});

// ===== AGENTE =====
Route::middleware(['auth', 'redirect.byrole', 'role:agente'])->group(function () {
    Route::get('/agente', [AgenteController::class, 'index'])
        ->name('agente.dashboardagente');

    Route::post('/agente', [AgenteController::class, 'store'])
        ->name('agente.cadastro.store');

    // Pendências (busca por CPF)
    Route::get('/agente/pendencias', [AgenteController::class, 'pendenciasIndex'])
        ->name('agente.pendencias');

    // Reenvio de documentos para uma pendência específica
    Route::post('/agente/pendencias/{issue}/enviar-docs',
        [AgenteController::class, 'pendenciasUpload']
    )->name('agente.pendencias.upload');

        // >>> NOVO: visão de contratos do agente (acompanhar status e pagamentos)
    Route::get('/agente/contratos', function () {
        // usamos uma view direta para não depender de mudanças no controller agora
        return view('agente.contratos');
    })->name('agente.contratos');

        // NOVO: Meus contratos
    Route::get('/agente/contratos', [AgenteController::class, 'contratos'])
        ->name('agente.contratos');
	
	Route::post('/agente/contratos/{cadastro}/renovar', [\App\Http\Controllers\AgenteController::class,'renovarContrato'])
    ->name('agente.contratos.renovar')
    ->middleware(['auth','role:agente']); // ajuste o middleware conforme seu app

    // Editar (atualizar) cadastro completo a partir da pendência (modal)
    Route::post('/agente/pendencias/{issue}/atualizar-cadastro',
        [AgenteController::class, 'pendenciasUpdate']
    )->name('agente.pendencias.update');

});

// ===== ANALISTA =====
Route::middleware(['auth', 'redirect.byrole', 'role:analista'])->group(function () {
    Route::get('/analista', [AnalistaController::class, 'index'])
        ->name('analista.dashboardanalista');

    Route::post('/analista/contratos/{cadastro}/marcar-incompleto',
        [AnalistaController::class, 'markIncomplete']
    )->name('analista.contrato.mark_incomplete');

    // validação de contrato/documentação
    Route::post('/analista/contratos/{cadastro}/validar',
        [AnalistaController::class, 'validateContract']
    )->name('analista.contrato.validate');

    // Stream seguro do arquivo reenviado (abre inline ou baixa com ?dl=1)
    Route::get('/analista/reuploads/{reupload}',
        [AnalistaController::class, 'streamReupload']
    )->name('analista.reuploads.ver');
});

// ===== TESOUREIRO =====
Route::prefix('tesoureiro')
    ->middleware(['auth','role:tesoureiro'])
    ->name('tesoureiro.')
    ->group(function () {
        Route::get('/dashboard', [TesoureiroController::class, 'index'])
            ->name('dashboardtesoureiro');

        Route::post('/pagamentos/{cadastro}/efetivar',
            [TesoureiroController::class, 'pagamentosEfetuar']
        )->name('pagamentos.efetuar');

        Route::post('/pagamentos/{cadastro}/upload-comprovante',
            [TesoureiroController::class, 'pagamentosUploadComprovante']
        )->name('pagamentos.upload_comprovante');

        Route::post('/reuploads/{reupload}/pagar',
            [TesoureiroController::class, 'reuploadPagamentoEfetivado']
        )->name('reuploads.pagar');

        // NOVA rota: congelar contrato (não formalizar)
        Route::post('/pagamentos/{cadastro}/congelar',
            [TesoureiroController::class, 'pagamentosCongelar']
        )->name('pagamentos.congelar');   // << sem repetir "tesoureiro."
    });


Route::get('/tesouraria/comprovantes/{pagamento}',
    [TesoureiroController::class, 'streamComprovante']
)->middleware(['auth'])->name('tesouraria.comprovantes.ver');

// ===== ASSOCIADO =====
Route::middleware(['auth','role:associado'])->group(function () {
    Route::get('/associado/dashboard', [AssociadoController::class, 'index'])
        ->name('associado.dashboardassociado');

    // definir primeira senha (quando must_set_password = true ou password null)
    Route::put('/associado/definir-senha', [AssociadoController::class, 'definirSenha'])
        ->name('associado.senha.definir');

    // alterar senha normal (já tem senha definida)
    Route::put('/associado/alterar-senha', [AssociadoController::class, 'alterarSenha'])
        ->name('associado.senha.alterar');
});

// Home pública (welcome com seu CSS)
Route::get('/', function () {
    return view('welcome');
});
