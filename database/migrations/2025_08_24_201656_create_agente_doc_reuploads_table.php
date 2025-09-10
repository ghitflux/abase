<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('agente_doc_reuploads', function (Blueprint $table) {
            $table->id();

            // vínculos
            $table->foreignId('agente_doc_issue_id')->constrained('agente_doc_issues')->cascadeOnDelete();
            $table->foreignId('agente_cadastro_id')->constrained('agente_cadastros')->cascadeOnDelete();

            // quem enviou (normalmente o agente logado)
            $table->foreignId('uploaded_by_user_id')->nullable()->constrained('users')->nullOnDelete();

            // chaves úteis para filtro
            $table->string('cpf_cnpj', 20)->index();
            $table->string('contrato_codigo_contrato', 80)->nullable()->index();

            // metadados do arquivo
            $table->string('file_original_name', 255);
            $table->string('file_stored_name', 255);
            $table->string('file_relative_path', 500)->nullable(); // ex.: storage/agent-reuploads/123/xxxx.pdf
            $table->string('file_mime', 100)->nullable();
            $table->unsignedBigInteger('file_size_bytes')->nullable();

            // status deste reenvio (pode evoluir depois)
            $table->enum('status', ['received', 'accepted', 'rejected'])->default('received');

            // campos livres
            $table->timestamp('uploaded_at')->nullable();
            $table->text('notes')->nullable();
            $table->json('extras')->nullable();

            $table->timestamps();

            // para listagens típicas
            $table->index(['agente_doc_issue_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('agente_doc_reuploads');
    }
};
