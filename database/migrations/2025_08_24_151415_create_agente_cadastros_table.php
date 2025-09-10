<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('agente_cadastros', function (Blueprint $table) {
            $table->id();

            // Dados cadastrais
            $table->string('doc_type', 10);                    // CPF | CNPJ
            $table->string('cpf_cnpj', 20)->index();           // só dígitos
            $table->string('rg', 30)->nullable();
            $table->string('orgao_expedidor', 80)->nullable();
            $table->string('full_name', 200);
            $table->date('birth_date')->nullable();
            $table->string('profession', 120)->nullable();
            $table->string('marital_status', 40)->nullable();  // Solteiro(a), etc.

            // Endereço
            $table->string('cep', 12)->nullable();
            $table->string('address', 200)->nullable();
            $table->string('address_number', 20)->nullable();
            $table->string('complement', 120)->nullable();
            $table->string('neighborhood', 120)->nullable();
            $table->string('city', 120)->nullable();
            $table->string('uf', 2)->nullable();

            // Contato e vínculo público
            $table->string('cellphone', 30)->nullable();
            $table->string('orgao_publico', 160)->nullable();
            $table->string('situacao_servidor', 60)->nullable();
            $table->string('matricula_servidor_publico', 60)->nullable();
            $table->string('email', 160)->nullable();

            // Dados bancários
            $table->string('bank_name', 120)->nullable();
            $table->string('bank_agency', 40)->nullable();
            $table->string('bank_account', 60)->nullable();
            $table->enum('account_type', ['corrente','poupanca'])->nullable();
            $table->string('pix_key', 160)->nullable();

            // Detalhes do contrato
            $table->decimal('contrato_mensalidade', 12, 2)->nullable();
            $table->integer('contrato_prazo_meses')->nullable(); // compatibilidade
            $table->decimal('contrato_taxa_antecipacao', 5, 2)->nullable(); // %
            $table->decimal('contrato_margem_disponivel', 12, 2)->nullable();
            $table->date('contrato_data_aprovacao')->nullable();
            $table->date('contrato_data_envio_primeira')->nullable();
            // REMOVIDO: $table->string('contrato_convenio', 160)->nullable();
            $table->decimal('contrato_valor_antecipacao', 12, 2)->nullable();
            $table->string('contrato_status_contrato', 60)->nullable()->default('Pendente');
            $table->date('contrato_mes_averbacao')->nullable(); // salvo como 1º dia do mês
            $table->string('contrato_codigo_contrato', 80)->nullable(); // compatibilidade
            $table->decimal('contrato_doacao_associado', 12, 2)->nullable();

            // Simulador (pré-validação)
            $table->decimal('calc_valor_bruto', 12, 2)->nullable();
            $table->decimal('calc_liquido_cc', 12, 2)->nullable();
            $table->integer('calc_prazo_antecipacao')->nullable();
            $table->decimal('calc_mensalidade_associativa', 12, 2)->nullable(); // compatibilidade

            // Antecipações (JSON)
            $table->json('anticipations_json')->nullable();

            // Agente/Filial
            $table->string('agente_responsavel', 160)->nullable();
            $table->string('agente_filial', 160)->nullable(); // compatibilidade

            // Observações
            $table->text('observacoes')->nullable();

            // Auxílio do Agente
            $table->decimal('auxilio_taxa', 5, 2)->nullable()->default(10.00); // %
            $table->date('auxilio_data_envio')->nullable();
            $table->string('auxilio_status', 80)->nullable();

            // Documentos (JSON com paths)
            $table->json('documents_json')->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('agente_cadastros');
    }
};
