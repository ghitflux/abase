<?php

// database/migrations/2025_08_24_000010_create_tesouraria_pagamentos_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('tesouraria_pagamentos', function (Blueprint $table) {
            $table->id();

            // vínculo com o contrato (agente_cadastros)
            $table->foreignId('agente_cadastro_id')
                  ->constrained('agente_cadastros')
                  ->cascadeOnDelete();

            // quem marcou o pagamento (tesoureiro logado)
            $table->foreignId('created_by_user_id')
                  ->nullable()
                  ->constrained('users')
                  ->nullOnDelete();

            // snapshot do contrato/cliente no momento do pagamento
            $table->string('contrato_codigo_contrato', 80)->nullable()->index();
            $table->decimal('contrato_valor_antecipacao', 12, 2)->nullable();
            $table->string('cpf_cnpj', 20)->index();
            $table->string('full_name', 200);
            $table->string('agente_responsavel', 160)->nullable(); // do cadastro

            // dados do pagamento
            $table->enum('status', ['pendente','pago','cancelado'])->default('pago');
            $table->decimal('valor_pago', 12, 2)->nullable();
            $table->timestamp('paid_at')->nullable();
            $table->string('forma_pagamento', 40)->nullable();
            $table->string('comprovante_path', 500)->nullable();
            $table->text('notes')->nullable();

            $table->timestamps();

            // 1 pagamento por contrato (se quiser permitir mais, remova)
            $table->unique(['agente_cadastro_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tesouraria_pagamentos');
    }
};
