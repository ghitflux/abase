<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\AgenteCadastro;

class AgenteCadastroSeeder extends Seeder
{
    public function run(): void
    {
        $rows = [
            [
                'doc_type'                   => 'CPF',
                'cpf_cnpj'                   => '23993596315',
                'full_name'                  => 'MARIA DE JESUS SANTANA COSTA',
                'orgao_publico'              => '002-SEC. EST. ADMIN. E PREVIDEN.',
                'matricula_servidor_publico' => '030759-9',
                'contrato_mensalidade'       => 30.00,
                'contrato_prazo_meses'       => 3,
                'contrato_taxa_antecipacao'  => 30.00,
                'contrato_valor_antecipacao' => 90.00,
                'contrato_status_contrato'   => 'Pendente',
            ],
            [
                'doc_type'                   => 'CPF',
                'cpf_cnpj'                   => '77623002368',
                'full_name'                  => 'ACHIELDER JOSE BARROS ROCHA',
                'orgao_publico'              => '009-SEC DA FAZENDA',
                'matricula_servidor_publico' => '214046-2',
                'contrato_mensalidade'       => 30.00,
                'contrato_prazo_meses'       => 3,
                'contrato_taxa_antecipacao'  => 30.00,
                'contrato_valor_antecipacao' => 90.00,
                'contrato_status_contrato'   => 'Pendente',
            ],
        ];

        foreach ($rows as $data) {
            // idempotente: se já existir pelo CPF, atualiza; senão, cria
            AgenteCadastro::updateOrCreate(
                ['cpf_cnpj' => $data['cpf_cnpj']],
                $data
            );
        }
    }
}
