<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        // Aumenta de 20 para 60
        DB::statement('ALTER TABLE agente_cadastros MODIFY address_number VARCHAR(60) NULL');
    }

    public function down(): void
    {
        // Reverte para 20 (caso precise rollback)
        DB::statement('ALTER TABLE agente_cadastros MODIFY address_number VARCHAR(20) NULL');
    }
};

