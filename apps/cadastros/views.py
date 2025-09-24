from decimal import Decimal
from datetime import timedelta

from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseBadRequest
from django.shortcuts import get_object_or_404, redirect, render
from django.views.decorators.http import require_http_methods
from django.utils import timezone
from django.core.paginator import Paginator
from django.db.models import Q
from django.contrib.auth import get_user_model

from apps.accounts.decorators import group_required
from apps.analise.models import HistoricoAnalise, StatusAnalise
from apps.documentos.models import Documento, DocumentoRascunho
from apps.documentos.views import ensure_draft_token

from .choices import StatusCadastro, StatusParcela
from .forms import CadastroForm
from .models import Cadastro, ParcelaAntecipacao

User = get_user_model()


# -----------------------------
# Helpers
# -----------------------------
def _pode_renovar(cadastro: Cadastro) -> bool:
    """
    True se as 3 primeiras parcelas estiverem liquidadas.
    Considera variações "PAGA/PAGO/QUITADA/LIQUIDADA".
    """
    # Ajuste o related_name se necessário (aqui assumimos cadastro.parcelas)
    parcelas_qs = getattr(cadastro, "parcelas", None)
    if not parcelas_qs:
        return False

    primeiras_tres = list(parcelas_qs.all().order_by("numero")[:3])
    if len(primeiras_tres) < 3:
        return False

    ok = {"LIQUIDADA", "LIQUIDADO", "PAGA", "PAGO", "QUITADA"}
    return all(((getattr(p, "status", "") or "").upper() in ok) for p in primeiras_tres)


def _correcao_lock_info(cadastro: Cadastro) -> tuple[int, timedelta | None]:
    """Retorna (total_devoluções, data_limite) para controle de reenvio."""
    if not cadastro or not hasattr(cadastro, "analise_processo"):
        return 0, None

    processo = getattr(cadastro, "analise_processo", None)
    if not processo:
        return 0, None

    eventos = HistoricoAnalise.objects.filter(
        processo=processo,
        status_novo=StatusAnalise.ENVIADO_PARA_CORRECAO
    ).order_by('-data_acao')

    total = eventos.count()
    if total >= 5 and eventos:
        lock_until = eventos.first().data_acao + timedelta(hours=3)
        return total, lock_until

    return total, None


# -----------------------------
# Listagem do agente
# -----------------------------
@login_required
@group_required('AGENTE')
def agente_list(request):
    """Lista todos os cadastros do agente logado"""
    cadastros = (
        Cadastro.objects.filter(agente_responsavel=request.user)
        .select_related()
        .order_by('-created_at')
    )

    cadastros_pendentes = cadastros.filter(status=StatusCadastro.PENDING_AGENT)

    context = {
        'cadastros': cadastros,
        'cadastros_pendentes': cadastros_pendentes,
        'total_cadastros': cadastros.count(),
        'total_pendentes': cadastros_pendentes.count(),
    }
    return render(request, "cadastros/agente_list.html", context)


# -----------------------------
# Detalhe do cadastro
# -----------------------------
@login_required
@group_required('AGENTE')
def agente_detail(request, cadastro_id):
    """Visualização detalhada de um cadastro do agente"""
    cadastro = get_object_or_404(
        Cadastro.objects.select_related('agente_responsavel'),
        id=cadastro_id,
        agente_responsavel=request.user
    )

    # Parcelas e documentos
    parcelas = cadastro.parcelas.all().order_by('numero')
    documentos = cadastro.documentos.all()

    # Processo de análise (se houver)
    try:
        processo_analise = cadastro.analise_processo
    except AttributeError:
        processo_analise = None

    # Elegibilidade para renovar (3 primeiras parcelas quitadas)
    pode_renovar = _pode_renovar(cadastro)

    context = {
        'cadastro': cadastro,
        'parcelas': parcelas,
        'documentos': documentos,
        'processo_analise': processo_analise,
        'pode_renovar': pode_renovar,
    }
    return render(request, "cadastros/agente_detail.html", context)


# -----------------------------
# Criar/editar cadastro do agente
# -----------------------------
@login_required
@group_required('AGENTE')
@require_http_methods(["GET", "POST"])
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

    correcao_count = 0
    correcao_lock_until = None
    if cadastro:
        correcao_count, correcao_lock_until = _correcao_lock_info(cadastro)

    lock_active = bool(correcao_lock_until and timezone.now() < correcao_lock_until)

    if request.method == "GET":
        if cadastro:
            # Edição
            form = CadastroForm(instance=cadastro)
            existing_docs = cadastro.documentos.all()
        else:
            # Novo
            form = CadastroForm(initial={
                "tipo_pessoa": "PF",
                "prazo_antecipacao_meses": 3,
                "taxa_antecipacao_percent": "30.00",
            })
            existing_docs = []

        docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)
        if lock_active:
            lock_ts = timezone.localtime(correcao_lock_until).strftime('%d/%m/%Y %H:%M')
            messages.warning(
                request,
                f"Este processo atingiu o limite de correções e ficará bloqueado até {lock_ts}."
            )

        context = {
            "form": form,
            "draft_token": draft_token,
            "docs": docs,
            "existing_docs": existing_docs,
            "cadastro": cadastro,
            "is_edit": bool(cadastro),
            "correcao_lock_until": correcao_lock_until,
            "correcao_devolucoes": correcao_count,
            "correcao_lock_ativo": lock_active,
        }
        return render(request, "cadastros/agente_form.html", context)

    # POST
    if cadastro and lock_active and cadastro.status == StatusCadastro.PENDING_AGENT:
        lock_ts = timezone.localtime(correcao_lock_until).strftime('%d/%m/%Y %H:%M')
        messages.error(
            request,
            f"Correções bloqueadas até {lock_ts}. Aguarde o prazo para reenviar o processo."
        )
        context = {
            "form": CadastroForm(request.POST, instance=cadastro) if cadastro else CadastroForm(request.POST),
            "draft_token": draft_token,
            "docs": DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token),
            "existing_docs": cadastro.documentos.all() if cadastro else [],
            "cadastro": cadastro,
            "is_edit": bool(cadastro),
            "correcao_lock_until": correcao_lock_until,
            "correcao_devolucoes": correcao_count,
            "correcao_lock_ativo": lock_active,
        }
        return render(request, "cadastros/agente_form.html", context, status=403)

    if cadastro:
        form = CadastroForm(request.POST, instance=cadastro)
        existing_docs = cadastro.documentos.all()
    else:
        form = CadastroForm(request.POST)
        existing_docs = []

    docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)

    if not form.is_valid():
        messages.error(request, 'Erro na validação do formulário. Verifique os campos destacados.')
        context = {
            "form": form,
            "draft_token": draft_token,
            "docs": docs,
            "existing_docs": existing_docs,
            "cadastro": cadastro,
            "is_edit": bool(cadastro),
            "correcao_lock_until": correcao_lock_until,
            "correcao_devolucoes": correcao_count,
            "correcao_lock_ativo": lock_active,
        }
        return render(request, "cadastros/agente_form.html", context, status=400)

    try:
        cad: Cadastro = form.save(commit=False)

        if not cadastro:
            # Novo cadastro
            cad.agente_responsavel = request.user
            cad.status = StatusCadastro.SENT_REVIEW  # Enviar automaticamente para análise
        else:
            # Edição
            if cadastro.status == StatusCadastro.PENDING_AGENT:
                # reenvio automático após correção
                cad.status = StatusCadastro.RESUBMITTED

        cad.save()  # dispara recalc() no model

        # Atualiza vencimentos das parcelas ao editar, se aplicável
        if cadastro and cad.data_primeira_mensalidade:
            cad.atualizar_vencimento_parcelas()

    except Exception as e:
        messages.error(request, f'Erro ao salvar cadastro: {e}')
        context = {
            "form": form,
            "draft_token": draft_token,
            "docs": docs,
            "existing_docs": existing_docs,
            "cadastro": cadastro,
            "is_edit": bool(cadastro),
            "correcao_lock_until": correcao_lock_until,
            "correcao_devolucoes": correcao_count,
            "correcao_lock_ativo": lock_active,
        }
        return render(request, "cadastros/agente_form.html", context, status=500)

    # cria 3 parcelas padrão (apenas para novos)
    try:
        if not cadastro:
            # Base de cálculo segura
            base = cad.valor_total_antecipacao or cad.mensalidade_associativa or Decimal('0.00')
            valor_parcela = (Decimal(base) / 3) if base else Decimal('0.00')
            for n in (1, 2, 3):
                ParcelaAntecipacao.objects.get_or_create(
                    cadastro=cad, numero=n,
                    defaults={"valor": valor_parcela, "status": StatusParcela.PENDENTE}
                )
    except Exception as e:
        messages.warning(request, f'Cadastro salvo, mas houve erro ao criar parcelas: {e}')

    # processa arquivos enviados via form tradicional
    try:
        file_fields = [
            ('doc_frente', 'DOC_FRENTE'),
            ('doc_verso', 'DOC_VERSO'),
            ('comp_endereco', 'COMP_ENDERECO'),
            ('contracheque_atual', 'CONTRACHEQUE_ATUAL'),
            ('print_simulacao', 'PRINT_SIMULACAO'),
            ('termo_adesao', 'TERMO_ADESAO'),
            ('termo_antecipacao', 'TERMO_ANTECIPACAO'),
        ]

        for field_name, doc_type in file_fields:
            file_obj = request.FILES.get(field_name)
            if file_obj:
                Documento.objects.create(cadastro=cad, tipo=doc_type, arquivo=file_obj)
    except Exception as e:
        messages.warning(request, f'Cadastro salvo, mas houve erro ao processar arquivos: {e}')

    # promove rascunhos -> documentos
    try:
        for d in docs:
            Documento.objects.create(cadastro=cad, tipo=d.tipo, arquivo=d.arquivo)
            d.delete()
    except Exception as e:
        messages.warning(request, f'Cadastro salvo, mas houve erro ao processar documentos: {e}')

    # limpa token (opcional)
    try:
        del request.session["draft_token"]
    except KeyError:
        pass

    # Mensagem de sucesso
    if cadastro:
        if cadastro.status == StatusCadastro.PENDING_AGENT:
            messages.success(
                request,
                'Cadastro atualizado com sucesso e reenviado automaticamente para análise! O processo retornará para o analista responsável.'
            )
        else:
            messages.success(request, 'Cadastro atualizado com sucesso!')
    else:
        messages.success(request, 'Cadastro criado com sucesso e enviado para análise!')

    return redirect("cadastros:agente-list")


# -----------------------------
# Elegibilidade e renovação
# -----------------------------
@login_required
@group_required('AGENTE')
def verificar_elegibilidade_renovacao(request, cadastro_id):
    """
    Verifica se um cadastro é elegível para renovação.
    Requisitos: 3 parcelas liquidadas e status EFFECTIVATED.
    """
    try:
        cadastro = Cadastro.objects.get(id=cadastro_id, agente_responsavel=request.user)
    except Cadastro.DoesNotExist:
        return HttpResponseBadRequest("Cadastro não encontrado ou acesso negado")

    # Já tem renovação em andamento?
    if hasattr(cadastro, 'renovacoes') and cadastro.renovacoes.filter(
        status__in=[
            StatusCadastro.DRAFT, StatusCadastro.SENT_REVIEW, StatusCadastro.PENDING_AGENT,
            StatusCadastro.RESUBMITTED, StatusCadastro.APPROVED_REVIEW,
            StatusCadastro.PAYMENT_PENDING, StatusCadastro.EFFECTIVATED
        ]
    ).exists():
        return render(request, "cadastros/renovacao_info.html", {
            "cadastro": cadastro,
            "erro": "Este cadastro já possui uma renovação em andamento.",
        })

    if cadastro.status != StatusCadastro.EFFECTIVATED:
        return render(request, "cadastros/renovacao_info.html", {
            "cadastro": cadastro,
            "erro": "Apenas cadastros efetivados podem ser renovados.",
        })

    parcelas_liquidadas = cadastro.parcelas.filter(status=StatusParcela.LIQUIDADA).count()
    if parcelas_liquidadas < 3:
        return render(request, "cadastros/renovacao_info.html", {
            "cadastro": cadastro,
            "erro": f"É necessário ter 3 parcelas liquidadas para renovar. Atualmente: {parcelas_liquidadas}/3",
        })

    return render(request, "cadastros/renovacao_info.html", {
        "cadastro": cadastro,
        "elegivel": True,
        "parcelas_liquidadas": parcelas_liquidadas,
    })


@login_required
@group_required('AGENTE')
def renovar_contrato(request, cadastro_id):
    """
    Ação do botão 'Renovar Contrato'.
    - Valida elegibilidade (3 primeiras parcelas quitadas).
    - Se elegível, redireciona para o fluxo de renovação (renovar_cadastro - GET).
      * Garanta no urls.py o name 'renovar_cadastro' para a view abaixo.
    """
    cadastro = get_object_or_404(
        Cadastro, id=cadastro_id, agente_responsavel=request.user
    )

    if not _pode_renovar(cadastro):
        messages.error(request, "Você só pode renovar após quitar as 3 mensalidades.")
        return redirect("cadastros:agente-detail", cadastro_id=cadastro_id)

    # elegível -> redireciona para a tela de renovação (form)
    return redirect("cadastros:renovar_cadastro", cadastro_id=cadastro_id)


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

    # Elegibilidade mínima
    if cadastro_original.status != StatusCadastro.EFFECTIVATED:
        return HttpResponseBadRequest("Cadastro não está efetivado")

    parcelas_liquidadas = cadastro_original.parcelas.filter(status=StatusParcela.LIQUIDADA).count()
    if parcelas_liquidadas < 3:
        return HttpResponseBadRequest("É necessário ter 3 parcelas liquidadas")

    draft_token = ensure_draft_token(request)

    if request.method == "GET":
        # Copia dados para o formulário
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
            "docs": docs,
        })

    # POST - processa a renovação
    form = CadastroForm(request.POST)
    docs = DocumentoRascunho.objects.filter(user=request.user, draft_token=draft_token)

    if not form.is_valid():
        return render(request, "cadastros/renovacao_form.html", {
            "form": form,
            "cadastro_original": cadastro_original,
            "draft_token": draft_token,
            "docs": docs,
        }, status=400)

    renovacao: Cadastro = form.save(commit=False)
    renovacao.agente_responsavel = request.user
    renovacao.cadastro_anterior = cadastro_original
    renovacao.save()  # dispara recalc() no model

    # 3 parcelas padrão da renovação
    for n in (1, 2, 3):
        ParcelaAntecipacao.objects.get_or_create(
            cadastro=renovacao, numero=n,
            defaults={"valor": renovacao.mensalidade_associativa, "status": StatusParcela.PENDENTE}
        )

    # Promove rascunhos para documentos definitivos
    for d in docs:
        Documento.objects.create(cadastro=renovacao, tipo=d.tipo, arquivo=d.arquivo)
        d.delete()

    try:
        del request.session["draft_token"]
    except KeyError:
        pass

    messages.success(request, "Renovação iniciada. Revise os dados e envie para análise.")
    return redirect("cadastros:agente-list")


# -----------------------------
# Todos os Associados (Admin/Tesouraria/Analista)
# -----------------------------
@login_required
@group_required(['ADMIN', 'TESOURARIA', 'ANALISTA'])
def todos_associados(request):
    """
    Lista todos os associados cadastrados no sistema com filtros.
    Acessível para administradores, tesoureiros e analistas.
    """
    # Base queryset
    cadastros = Cadastro.objects.select_related('agente_responsavel').order_by('-created_at')
    
    # Aplicar filtros
    status_filter = request.GET.get('status')
    if status_filter:
        cadastros = cadastros.filter(status=status_filter)
    
    agente_filter = request.GET.get('agente')
    if agente_filter:
        cadastros = cadastros.filter(agente_responsavel_id=agente_filter)
    
    data_inicio = request.GET.get('data_inicio')
    if data_inicio:
        cadastros = cadastros.filter(created_at__date__gte=data_inicio)
    
    data_fim = request.GET.get('data_fim')
    if data_fim:
        cadastros = cadastros.filter(created_at__date__lte=data_fim)
    
    search = request.GET.get('search')
    if search:
        cadastros = cadastros.filter(
            Q(nome_completo__icontains=search) |
            Q(cpf__icontains=search) |
            Q(cnpj__icontains=search)
        )
    
    # Calcular KPIs
    total_cadastros = Cadastro.objects.count()
    kpis = {
        'rascunhos': {'valor': Cadastro.objects.filter(status=StatusCadastro.DRAFT).count()},
        'em_analise': {'valor': Cadastro.objects.filter(status=StatusCadastro.SENT_REVIEW).count()},
        'aprovados': {'valor': Cadastro.objects.filter(status=StatusCadastro.APPROVED_REVIEW).count()},
        'efetivados': {'valor': Cadastro.objects.filter(status=StatusCadastro.EFFECTIVATED).count()},
        'pendentes': {'valor': Cadastro.objects.filter(status__in=[StatusCadastro.PENDING_AGENT, StatusCadastro.PAYMENT_PENDING]).count()},
        'cancelados': {'valor': Cadastro.objects.filter(status=StatusCadastro.CANCELLED).count()},
    }
    
    # Paginação
    paginator = Paginator(cadastros, 25)  # 25 cadastros por página
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    # Lista de usuários para o filtro
    users = User.objects.filter(groups__name='AGENTE').order_by('first_name', 'last_name', 'username')
    
    context = {
        'cadastros': page_obj,
        'users': users,
        'count_total': total_cadastros,
        'kpis': kpis,
        'page_obj': page_obj,
        'paginator': paginator,
        'is_paginated': page_obj.has_other_pages(),
    }
    
    # Se for requisição HTMX, retornar apenas a lista
    if request.headers.get('HX-Request') == 'true':
        return render(request, "cadastros/partials/_associados_list.html", context)
    
    return render(request, "cadastros/todos_associados.html", context)
