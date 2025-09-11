from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_http_methods
from django.shortcuts import render, redirect
from django.http import HttpResponseBadRequest
from apps.accounts.decorators import admin_required
from apps.documentos.models import Documento, DocumentoRascunho
from apps.documentos.views import ensure_draft_token
from .forms import CadastroForm
from .models import Cadastro, ParcelaAntecipacao
from .choices import StatusParcela, StatusCadastro

@login_required
def agente_list(request):
    return render(request, "cadastros/agente_list.html", {})

@login_required
@require_http_methods(["GET","POST"])
def agente_create(request):
    """
    Tela do Agente para criar novo cadastro:
    - exibe formulários
    - cálculos automáticos via JS e revalidados no save()
    - uploads em rascunho (persistem em caso de erro)
    - ao salvar, promove rascunhos -> Documento
    - cria 3 parcelas padrão (pendentes)
    """
    draft_token = ensure_draft_token(request)

    if request.method == "GET":
        form = CadastroForm(initial={
            "tipo_pessoa": "PF",
            "prazo_antecipacao_meses": 3,
            "taxa_antecipacao_percent": "30.00",
        })
        docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
        return render(request, "cadastros/agente_form.html", {
            "form": form, "draft_token": draft_token, "docs": docs
        })

    # POST
    form = CadastroForm(request.POST)
    docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)

    if not form.is_valid():
        # mantém anexos no rascunho e reapresenta erros
        return render(request, "cadastros/agente_form.html", {
            "form": form, "draft_token": draft_token, "docs": docs
        }, status=400)

    cad: Cadastro = form.save(commit=False)
    cad.agente_responsavel = request.user
    cad.save()  # dispara recalc() no model

    # cria 3 parcelas padrão com o valor da mensalidade
    for n in (1,2,3):
        ParcelaAntecipacao.objects.get_or_create(
            cadastro=cad, numero=n,
            defaults={"valor": cad.mensalidade_associativa, "status": StatusParcela.PENDENTE}
        )

    # promove rascunhos -> documentos definitivos
    for d in docs:
        Documento.objects.create(cadastro=cad, tipo=d.tipo, arquivo=d.arquivo)
        d.delete()

    # limpa token (opcional)
    try:
        del request.session["draft_token"]
    except KeyError:
        pass

    # redireciona para lista do agente (ou detalhe, conforme seu menu)
    return redirect("cadastros:agente-list")

@login_required
def verificar_elegibilidade_renovacao(request, cadastro_id):
    """
    Verifica se um cadastro é elegível para renovação.
    Requisitos: 3 parcelas liquidadas e status EFFECTIVATED
    """
    try:
        cadastro = Cadastro.objects.get(id=cadastro_id, agente_responsavel=request.user)
    except Cadastro.DoesNotExist:
        return HttpResponseBadRequest("Cadastro não encontrado ou acesso negado")
    
    # Verificar se já tem renovação ativa
    if hasattr(cadastro, 'renovacoes') and cadastro.renovacoes.filter(status__in=[
        StatusCadastro.DRAFT, StatusCadastro.SENT_REVIEW, StatusCadastro.PENDING_AGENT, 
        StatusCadastro.RESUBMITTED, StatusCadastro.APPROVED_REVIEW, StatusCadastro.PAYMENT_PENDING, 
        StatusCadastro.EFFECTIVATED
    ]).exists():
        return render(request, "cadastros/renovacao_info.html", {
            "cadastro": cadastro,
            "erro": "Este cadastro já possui uma renovação em andamento."
        })
    
    # Verificar status do cadastro
    if cadastro.status != StatusCadastro.EFFECTIVATED:
        return render(request, "cadastros/renovacao_info.html", {
            "cadastro": cadastro,
            "erro": "Apenas cadastros efetivados podem ser renovados."
        })
    
    # Verificar parcelas liquidadas
    parcelas_liquidadas = cadastro.parcelas.filter(status=StatusParcela.LIQUIDADA).count()
    
    if parcelas_liquidadas < 3:
        return render(request, "cadastros/renovacao_info.html", {
            "cadastro": cadastro,
            "erro": f"É necessário ter 3 parcelas liquidadas para renovar. Atualmente: {parcelas_liquidadas}/3"
        })
    
    # Elegível para renovação
    return render(request, "cadastros/renovacao_info.html", {
        "cadastro": cadastro,
        "elegivel": True,
        "parcelas_liquidadas": parcelas_liquidadas
    })

@login_required
@require_http_methods(["GET", "POST"])
def renovar_cadastro(request, cadastro_id):
    """
    Cria uma renovação baseada em um cadastro existente.
    Copia dados básicos e permite edição antes de salvar.
    """
    try:
        cadastro_original = Cadastro.objects.get(id=cadastro_id, agente_responsavel=request.user)
    except Cadastro.DoesNotExist:
        return HttpResponseBadRequest("Cadastro não encontrado ou acesso negado")
    
    # Verificar elegibilidade
    if cadastro_original.status != StatusCadastro.EFFECTIVATED:
        return HttpResponseBadRequest("Cadastro não está efetivado")
    
    parcelas_liquidadas = cadastro_original.parcelas.filter(status=StatusParcela.LIQUIDADA).count()
    if parcelas_liquidadas < 3:
        return HttpResponseBadRequest("É necessário ter 3 parcelas liquidadas")
    
    draft_token = ensure_draft_token(request)
    
    if request.method == "GET":
        # Copiar dados do cadastro original para o formulário
        initial_data = {
            "tipo_pessoa": cadastro_original.tipo_pessoa,
            "cpf": cadastro_original.cpf,
            "cnpj": cadastro_original.cnpj,
            "rg": cadastro_original.rg,
            "orgao_expedidor": cadastro_original.orgao_expedidor,
            "nome_razao_social": cadastro_original.nome_razao_social,
            "nome_completo": cadastro_original.nome_completo,
            "data_nascimento": cadastro_original.data_nascimento,
            "profissao": cadastro_original.profissao,
            "estado_civil": cadastro_original.estado_civil,
            "cep": cadastro_original.cep,
            "endereco": cadastro_original.endereco,
            "numero": cadastro_original.numero,
            "complemento": cadastro_original.complemento,
            "bairro": cadastro_original.bairro,
            "cidade": cadastro_original.cidade,
            "uf": cadastro_original.uf,
            "banco": cadastro_original.banco,
            "agencia": cadastro_original.agencia,
            "conta": cadastro_original.conta,
            "tipo_conta": cadastro_original.tipo_conta,
            "chave_pix": cadastro_original.chave_pix,
            "celular": cadastro_original.celular,
            "email": cadastro_original.email,
            "orgao_publico": cadastro_original.orgao_publico,
            "situacao_servidor": cadastro_original.situacao_servidor,
            "matricula_servidor": cadastro_original.matricula_servidor,
            "valor_bruto_total": cadastro_original.valor_bruto_total,
            "valor_liquido": cadastro_original.valor_liquido,
            "prazo_antecipacao_meses": 3,
            "taxa_antecipacao_percent": "30.00",
            "mensalidade_associativa": cadastro_original.mensalidade_associativa,
            "auxilio_agente_taxa_percent": "10.00",
        }
        
        form = CadastroForm(initial=initial_data)
        docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
        
        return render(request, "cadastros/renovacao_form.html", {
            "form": form,
            "cadastro_original": cadastro_original,
            "draft_token": draft_token,
            "docs": docs
        })
    
    # POST - processar renovação
    form = CadastroForm(request.POST)
    docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
    
    if not form.is_valid():
        return render(request, "cadastros/renovacao_form.html", {
            "form": form,
            "cadastro_original": cadastro_original,
            "draft_token": draft_token,
            "docs": docs
        }, status=400)
    
    # Criar nova renovação
    renovacao: Cadastro = form.save(commit=False)
    renovacao.agente_responsavel = request.user
    renovacao.cadastro_anterior = cadastro_original
    renovacao.save()  # dispara recalc() no model
    
    # Criar 3 parcelas padrão
    for n in (1,2,3):
        ParcelaAntecipacao.objects.get_or_create(
            cadastro=renovacao, numero=n,
            defaults={"valor": renovacao.mensalidade_associativa, "status": StatusParcela.PENDENTE}
        )
    
    # Promover rascunhos para documentos definitivos
    for d in docs:
        Documento.objects.create(cadastro=renovacao, tipo=d.tipo, arquivo=d.arquivo)
        d.delete()
    
    # Limpar token
    try:
        del request.session["draft_token"]
    except KeyError:
        pass
    
    return redirect("cadastros:agente-list")