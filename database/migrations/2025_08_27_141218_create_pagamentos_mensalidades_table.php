<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('pagamentos_mensalidades', function (Blueprint $t) {
            $t->id();

            // quem importou
            $t->foreignId('created_by_user_id')->nullable()->constrained('users')->nullOnDelete();

            // agrupador simples de importação
            $t->uuid('import_uuid')->index();

            // referência do arquivo
            $t->date('referencia_month')->index(); // salvo como 1º dia do mês

            // linha do relatório
            $t->string('status_code', 2)->nullable();      // 1,2,3,4,S...
            $t->string('matricula', 40)->nullable();
            $t->string('orgao_pagto', 40)->nullable();
            $t->string('nome_relatorio', 200)->nullable();

            // identificação
            $t->string('cpf_cnpj', 20)->index();

            // vínculo ao cadastro (se existir)
            $t->foreignId('agente_cadastro_id')->nullable()->constrained('agente_cadastros')->nullOnDelete();

            // valores
            $t->decimal('valor', 12, 2)->nullable();

            // auditoria do arquivo armazenado
            $t->string('source_file_path', 500)->nullable();

            $t->timestamps();

            // evita duplicidade por mês
            $t->unique(['cpf_cnpj', 'referencia_month']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pagamentos_mensalidades');
    }
};
