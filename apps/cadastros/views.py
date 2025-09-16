from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_http_methods
from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponseBadRequest
from django.contrib import messages
from apps.accounts.decorators import group_required
from apps.documentos.models import Documento, DocumentoRascunho
from apps.documentos.views import ensure_draft_token
from .forms import CadastroForm
from .models import Cadastro, ParcelaAntecipacao
from .choices import StatusParcela, StatusCadastro

@login_required
@group_required('AGENTE')
def agente_list(request):
    """Lista todos os cadastros do agente logado"""
    cadastros = Cadastro.objects.filter(
        agente_responsavel=request.user
    ).select_related().order_by('-created_at')
    
    # Cadastros pendentes de revisão (devolvidos pelo analista)
    cadastros_pendentes = cadastros.filter(status=StatusCadastro.PENDING_AGENT)
    
    context = {
        'cadastros': cadastros,
        'cadastros_pendentes': cadastros_pendentes,
        'total_cadastros': cadastros.count(),
        'total_pendentes': cadastros_pendentes.count(),
    }
    return render(request, "cadastros/agente_list.html", context)


@login_required
@group_required('AGENTE')
def agente_detail(request, cadastro_id):
    """Visualização detalhada de um cadastro do agente"""
    cadastro = get_object_or_404(
        Cadastro.objects.select_related('agente_responsavel'),
        id=cadastro_id,
        agente_responsavel=request.user
    )
    
    # Buscar parcelas relacionadas
    parcelas = cadastro.parcelas.all().order_by('numero')
    
    # Buscar documentos relacionados
    documentos = cadastro.documentos.all()
    
    # Buscar processo de análise se existir
    try:
        processo_analise = cadastro.analise_processo
    except AttributeError:
        processo_analise = None
    
    context = {
        'cadastro': cadastro,
        'parcelas': parcelas,
        'documentos': documentos,
        'processo_analise': processo_analise,
    }
    
    return render(request, "cadastros/agente_detail.html", context)

@login_required
@group_required('AGENTE')
@require_http_methods(["GET","POST"])
def agente_create(request):
    """
    Tela do Agente para criar novo cadastro ou editar existente:
    - exibe formulários
    - cálculos automáticos via JS e revalidados no save()
    - uploads em rascunho (persistem em caso de erro)
    - ao salvar, promove rascunhos -> Documento
    - cria 3 parcelas padrão (pendentes)
    """
    draft_token = ensure_draft_token(request)
    
    # Verificar se é edição
    edit_id = request.GET.get('edit') or request.POST.get('edit_id')
    cadastro = None
    if edit_id:
        cadastro = get_object_or_404(
            Cadastro.objects.prefetch_related('documentos'),
            id=edit_id,
            agente_responsavel=request.user
        )

    if request.method == "GET":
        if cadastro:
            # Carregando dados para edição
            form = CadastroForm(instance=cadastro)
            # Carregando documentos existentes como rascunhos
            existing_docs = cadastro.documentos.all()
        else:
            # Criando novo cadastro
            form = CadastroForm(initial={
                "tipo_pessoa": "PF",
                "prazo_antecipacao_meses": 3,
                "taxa_antecipacao_percent": "30.00",
            })
            existing_docs = []
            
        docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
        return render(request, "cadastros/agente_form.html", {
            "form": form, 
            "draft_token": draft_token, 
            "docs": docs,
            "existing_docs": existing_docs,
            "cadastro": cadastro,
            "is_edit": bool(cadastro)
        })

    # POST
    print(f"POST REQUEST RECEIVED for user: {request.user}")
    print(f"POST DATA: {dict(request.POST)}")
    
    if cadastro:
        # Editando cadastro existente
        print(f"EDITING existing cadastro ID: {cadastro.id}")
        form = CadastroForm(request.POST, instance=cadastro)
        existing_docs = cadastro.documentos.all()
    else:
        # Criando novo cadastro
        print("CREATING new cadastro")
        form = CadastroForm(request.POST)
        existing_docs = []
        
    docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
    print(f"Draft documents found: {docs.count()}")

    print(f"FORM VALIDATION: {form.is_valid()}")
    
    if not form.is_valid():
        print("FORM VALIDATION FAILED!")
        print(f"FORM ERRORS: {form.errors}")
        print(f"NON-FIELD ERRORS: {form.non_field_errors()}")
        
        # Adicionar mensagem de erro para o usuário
        messages.error(request, 'Erro na validação do formulário. Verifique os campos destacados.')
        # mantém anexos no rascunho e reapresenta erros
        return render(request, "cadastros/agente_form.html", {
            "form": form, 
            "draft_token": draft_token, 
            "docs": docs,
            "existing_docs": existing_docs,
            "cadastro": cadastro,
            "is_edit": bool(cadastro)
        }, status=400)

    print("FORM VALIDATION PASSED! Saving cadastro...")
    
    try:
        cad: Cadastro = form.save(commit=False)
        print(f"Form saved to object: {cad}")
        
        if not cadastro:  # Só para novos cadastros
            cad.agente_responsavel = request.user
            cad.status = StatusCadastro.SENT_REVIEW  # Enviar automaticamente para análise
            print(f"New cadastro - Agent: {request.user}, Status: {cad.status}")
        else:  # Para edições, manter status atual ou reenviar para análise se necessário
            if cadastro.status == StatusCadastro.PENDING_AGENT:
                cad.status = StatusCadastro.RESUBMITTED  # CORREÇÃO: Usar RESUBMITTED em vez de SENT_REVIEW
                print(f"Resubmitted - Status changed to: {cad.status}")
                
        cad.save()  # dispara recalc() no model
        print(f"Cadastro saved successfully with ID: {cad.id}")

        # Se é edição e tem data_primeira_mensalidade, atualizar vencimentos das parcelas
        if cadastro and cad.data_primeira_mensalidade:
            print("Updating parcela vencimentos for edited cadastro...")
            cad.atualizar_vencimento_parcelas()
        
    except Exception as e:
        print(f"ERROR saving cadastro: {e}")
        import traceback
        traceback.print_exc()
        messages.error(request, f'Erro ao salvar cadastro: {e}')
        return render(request, "cadastros/agente_form.html", {
            "form": form, 
            "draft_token": draft_token, 
            "docs": docs,
            "existing_docs": existing_docs,
            "cadastro": cadastro,
            "is_edit": bool(cadastro)
        }, status=500)

    # cria 3 parcelas padrão com o valor da mensalidade (só para novos)
    try:
        if not cadastro:
            valor_parcela = cad.valor_total_antecipacao / 3 if cad.valor_total_antecipacao else Decimal('0.00')  # noqa: F821
            for n in (1,2,3):
                ParcelaAntecipacao.objects.get_or_create(
                    cadastro=cad, numero=n,
                    defaults={"valor": valor_parcela, "status": StatusParcela.PENDENTE}
                )
    except Exception as e:
        messages.warning(request, f'Cadastro salvo mas erro ao criar parcelas: {e}')

    # promove rascunhos -> documentos definitivos
    try:
        for d in docs:
            Documento.objects.create(cadastro=cad, tipo=d.tipo, arquivo=d.arquivo)
            d.delete()
    except Exception as e:
        messages.warning(request, f'Cadastro salvo mas erro ao processar documentos: {e}')

    # limpa token (opcional)
    try:
        del request.session["draft_token"]
    except KeyError:
        pass

    # Mensagem de sucesso
    if cadastro:
        print("UPDATE SUCCESS - Redirecting...")
        if cadastro.status == StatusCadastro.PENDING_AGENT:
            messages.success(request, 'Cadastro atualizado com sucesso e reenviado automaticamente para análise! O processo retornará para o analista responsável.')
        else:
            messages.success(request, 'Cadastro atualizado com sucesso!')
    else:
        print("CREATE SUCCESS - Redirecting...")
        messages.success(request, 'Cadastro criado com sucesso e enviado para análise!')

    print("Redirecting to cadastros:agente-list")
    # redireciona para lista do agente (ou detalhe, conforme seu menu)
    return redirect("cadastros:agente-list")

# Função removida - agora o reenvio é automático quando o agente salva edições
# A mudança de status PENDING_AGENT -> RESUBMITTED acontece automaticamente
# na função agente_create() quando é uma edição de cadastro pendente

@login_required
@group_required('AGENTE')
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
@group_required('AGENTE')
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