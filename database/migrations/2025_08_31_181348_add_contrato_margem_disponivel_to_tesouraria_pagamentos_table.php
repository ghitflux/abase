<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('tesouraria_pagamentos', function (Blueprint $table) {
            if (!Schema::hasColumn('tesouraria_pagamentos', 'contrato_margem_disponivel')) {
                $table->decimal('contrato_margem_disponivel', 12, 2)
                      ->nullable()
                      ->after('contrato_valor_antecipacao');
            }
        });
    }

    public function down(): void
    {
        Schema::table('tesouraria_pagamentos', function (Blueprint $table) {
            if (Schema::hasColumn('tesouraria_pagamentos', 'contrato_margem_disponivel')) {
                $table->dropColumn('contrato_margem_disponivel');
            }
        });
    }
};

