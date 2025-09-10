<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        // Adiciona o flag de onboarding
        Schema::table('users', function (Blueprint $table) {
            $table->boolean('must_set_password')->default(true)->after('password');
        });

        // Torna a coluna password nullable (sem exigir doctrine/dbal)
        DB::statement('ALTER TABLE users MODIFY password VARCHAR(255) NULL');
    }

    public function down(): void
    {
        // Reverte password pra NOT NULL (ajuste se necessário ao seu ambiente)
        DB::statement('ALTER TABLE users MODIFY password VARCHAR(255) NOT NULL');

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('must_set_password');
        });
    }
};
