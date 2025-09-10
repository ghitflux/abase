<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AgenteCadastro extends Model
{
    protected $table = 'agente_cadastros';

    protected $fillable = [
        // Dados cadastrais
        'doc_type','cpf_cnpj','rg','orgao_expedidor','full_name','birth_date',
        'profession','marital_status',

        // Endereço
        'cep','address','address_number','complement','neighborhood','city','uf',

        // Contato e vínculo público
        'cellphone','orgao_publico','situacao_servidor',
        'matricula_servidor_publico','email',

        // Dados bancários
        'bank_name','bank_agency','bank_account','account_type','pix_key',

        // Detalhes do contrato
        'contrato_mensalidade','contrato_prazo_meses','contrato_taxa_antecipacao',
        'contrato_margem_disponivel','contrato_data_aprovacao','contrato_data_envio_primeira',
        'contrato_valor_antecipacao','contrato_status_contrato',
        'contrato_mes_averbacao','contrato_codigo_contrato','contrato_doacao_associado',

        // Simulador (pré-validação)
        'calc_valor_bruto','calc_liquido_cc','calc_prazo_antecipacao','calc_mensalidade_associativa',

        // Antecipações (JSON)
        'anticipations_json',

        // Agente/Filial
        'agente_responsavel','agente_filial',

        // Observações
        'observacoes',

        // Auxílio do Agente
        'auxilio_taxa','auxilio_data_envio','auxilio_status',

        // Documentos (JSON)
        'documents_json',
    ];

    protected $casts = [
        // Datas (Y-m-d)
        'birth_date'                   => 'date',
        'contrato_data_aprovacao'      => 'date',
        'contrato_data_envio_primeira' => 'date',
        'contrato_mes_averbacao'       => 'date',
        'auxilio_data_envio'           => 'date',

        // Numéricos
        'contrato_mensalidade'         => 'decimal:2',
        'contrato_taxa_antecipacao'    => 'decimal:2',
        'contrato_margem_disponivel'   => 'decimal:2',
        'contrato_valor_antecipacao'   => 'decimal:2',
        'contrato_doacao_associado'    => 'decimal:2',
        'auxilio_taxa'                 => 'decimal:2',
        'contrato_prazo_meses'         => 'integer',

        // Simulador
        'calc_valor_bruto'             => 'decimal:2',
        'calc_liquido_cc'              => 'decimal:2',
        'calc_prazo_antecipacao'       => 'integer',
        'calc_mensalidade_associativa' => 'decimal:2',

        // JSON
        'anticipations_json'           => 'array',
        'documents_json'               => 'array',
    ];

    /* ===================== Relationships ===================== */

    public function docIssues()
    {
        return $this->hasMany(\App\Models\AgenteDocIssue::class, 'agente_cadastro_id');
    }

    // Alias para compatibilidade com partes antigas do código
    public function issues()
    {
        return $this->hasMany(\App\Models\AgenteDocIssue::class, 'agente_cadastro_id');
    }

    public function pagamentoTesouraria()
    {
        return $this->hasOne(\App\Models\TesourariaPagamento::class, 'agente_cadastro_id');
    }

    public function reuploads()
    {
        return $this->hasMany(\App\Models\AgenteDocReupload::class, 'agente_cadastro_id');
    }

    /* ===================== Mutators (higienização) ===================== */

    // helper para normalizar strings -> null quando vazias
    private function clean(?string $v): ?string
    {
        if ($v === null) return null;
        $v = trim($v);
        return $v === '' ? null : $v;
    }

    public function setCpfCnpjAttribute($v): void
    {
        $digits = is_string($v) ? preg_replace('/\D+/', '', $v) : null;
        $this->attributes['cpf_cnpj'] = $digits ?: null;
    }

    public function setDocTypeAttribute($v): void
    {
        $val = strtoupper(trim((string)$v));
        $this->attributes['doc_type'] = in_array($val, ['CPF','CNPJ'], true) ? $val : 'CPF';
    }

    public function setEmailAttribute($v): void
    {
        $email = is_string($v) ? mb_strtolower(trim($v)) : null;
        $this->attributes['email'] = $this->clean($email);
    }

    public function setBankNameAttribute($v): void
    {
        $this->attributes['bank_name'] = $this->clean(is_string($v) ? $v : null);
    }

    public function setBankAgencyAttribute($v): void
    {
        $this->attributes['bank_agency'] = $this->clean(is_string($v) ? $v : null);
    }

    public function setBankAccountAttribute($v): void
    {
        $this->attributes['bank_account'] = $this->clean(is_string($v) ? $v : null);
    }

    public function setPixKeyAttribute($v): void
    {
        $this->attributes['pix_key'] = $this->clean(is_string($v) ? $v : null);
    }

    public function setAccountTypeAttribute($v): void
    {
        $val = strtolower(trim((string)$v));
        $this->attributes['account_type'] = in_array($val, ['corrente','poupanca'], true) ? $val : null;
    }
}
