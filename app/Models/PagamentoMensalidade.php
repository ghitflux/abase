<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PagamentoMensalidade extends Model
{
    protected $table = 'pagamentos_mensalidades';

    protected $fillable = [
        'created_by_user_id','import_uuid','referencia_month',
        'status_code','matricula','orgao_pagto','nome_relatorio',
        'cpf_cnpj','agente_cadastro_id','valor','source_file_path',
    ];

    protected $casts = [
        'referencia_month' => 'date',
    ];

    public function cadastro()
    {
        return $this->belongsTo(\App\Models\AgenteCadastro::class, 'agente_cadastro_id');
    }

    public function criadoPor()
    {
        return $this->belongsTo(\App\Models\User::class, 'created_by_user_id');
    }
}
