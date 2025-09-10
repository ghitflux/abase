<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AgenteDocReupload extends Model
{
    protected $table = 'agente_doc_reuploads';

    protected $fillable = [
        'agente_doc_issue_id',
        'agente_cadastro_id',
        'uploaded_by_user_id',
        'cpf_cnpj',
        'contrato_codigo_contrato',
        'file_original_name',
        'file_stored_name',
        'file_relative_path',
        'file_mime',
        'file_size_bytes',
        'status',            // received | accepted | rejected
        'uploaded_at',
        'notes',
        'extras',
    ];

    protected $casts = [
        'uploaded_at' => 'datetime',
        'extras'      => 'array',
        'created_at'  => 'datetime',
        'updated_at'  => 'datetime',
    ];

    public function issue()
    {
        return $this->belongsTo(\App\Models\AgenteDocIssue::class, 'agente_doc_issue_id');
    }

    public function cadastro()
    {
        return $this->belongsTo(\App\Models\AgenteCadastro::class, 'agente_cadastro_id');
    }

    public function uploader()
    {
        return $this->belongsTo(\App\Models\User::class, 'uploaded_by_user_id');
    }
}
