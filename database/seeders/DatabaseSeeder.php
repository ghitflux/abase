<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            AgenteCadastroSeeder::class,
            // php artisan db:seed --class='Database\Seeders\AgenteCadastroSeeder'

        ]);
    }
}
