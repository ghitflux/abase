<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AgenteDocIssue extends Model
{
    protected $table = 'agente_doc_issues';

    protected $fillable = [
        'agente_cadastro_id',
        'cpf_cnpj',
        'contrato_codigo_contrato',
        'analista_id',
        'status',                   // 'incomplete' | 'resolved'
        'mensagem',
        'documents_snapshot_json',  // snapshot feito pelo analista
        'agent_uploads_json',       // (legado) reenvios feitos pelo agente
    ];

    protected $casts = [
        'documents_snapshot_json' => 'array',
        'agent_uploads_json'      => 'array',
        'created_at'              => 'datetime',
        'updated_at'              => 'datetime',
    ];

    public function cadastro()
    {
        return $this->belongsTo(\App\Models\AgenteCadastro::class, 'agente_cadastro_id');
    }

    public function reuploads()
    {
        return $this->hasMany(\App\Models\AgenteDocReupload::class, 'agente_doc_issue_id');
    }

    public function analista()
    {
        return $this->belongsTo(\App\Models\User::class, 'analista_id');
    }

    // Scopes auxiliares
    public function scopeOpen($q)     { return $q->where('status', 'incomplete'); }
    public function scopeResolved($q) { return $q->where('status', 'resolved'); }
}
