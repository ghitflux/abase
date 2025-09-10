<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TesourariaPagamento extends Model
{
    protected $table = "tesouraria_pagamentos";

    protected $fillable = [
        "agente_cadastro_id",
        "created_by_user_id",
        "contrato_codigo_contrato",
        "contrato_valor_antecipacao",
        "cpf_cnpj",
        "full_name",
        "agente_responsavel",
        "status",
        "valor_pago",
        "paid_at",
        "forma_pagamento",
        "comprovante_path",
        "notes",
        'contrato_margem_disponivel',
    ];

    protected $casts = [
        "paid_at" => "datetime",
    ];

    public function cadastro()
    {
        return $this->belongsTo(\App\Models\AgenteCadastro::class, "agente_cadastro_id");
    }

    public function createdBy()
    {
        return $this->belongsTo(\App\Models\User::class, "created_by_user_id");
    }
}