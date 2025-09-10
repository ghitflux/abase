<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('agente_doc_issues', function (Blueprint $table) {
            $table->id();

            // Referências
            $table->foreignId('agente_cadastro_id')->constrained('agente_cadastros')->cascadeOnDelete();
            $table->string('cpf_cnpj', 20)->index();                 // busca por CPF/CNPJ
            $table->string('contrato_codigo_contrato', 80)->nullable();

            // Quem abriu (analista)
            $table->foreignId('analista_id')->constrained('users')->cascadeOnDelete();

            // Status da pendência
            $table->enum('status', ['incomplete','resolved'])->default('incomplete');

            // Mensagem para o agente (o que falta)
            $table->text('mensagem');

            // Snapshot dos documentos existentes no momento da análise
            $table->json('documents_snapshot_json')->nullable();

            // ⬇️ Reenvios feitos pelo agente (histórico desta pendência)
            $table->json('agent_uploads_json')->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('agente_doc_issues');
    }
};
