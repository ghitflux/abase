<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{

    public function up(): void
    {
        Schema::create('roles', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();  
        });

        DB::table('roles')->insert([
            ['name' => 'user'],
            ['name' => 'admin'],
            ['name' => 'agente'],
            ['name' => 'analista'],
            ['name' => 'tesoureiro'],
            ['name' => 'associado']
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('roles');
    }
};
