from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.core.paginator import Paginator
from django.http import JsonResponse
from apps.accounts.decorators import admin_required
from .models import ArquivoImportacao, StatusImportacao
from .forms import ArquivoImportacaoForm
from .services import ImportadorService

@login_required
@admin_required
def upload_arquivo(request):
    if request.method == 'POST':
        form = ArquivoImportacaoForm(request.POST, request.FILES)
        if form.is_valid():
            arquivo = form.save(commit=False)
            arquivo.usuario = request.user
            arquivo.nome_arquivo = request.FILES['arquivo'].name
            arquivo.save()
            
            # Processar arquivo em background (simplificado aqui)
            try:
                ImportadorService.processar_arquivo(arquivo)
                messages.success(request, 'Arquivo processado com sucesso!')
            except Exception as e:
                messages.error(request, f'Erro ao processar arquivo: {str(e)}')
            
            return redirect('importador:listar_importacoes')
    else:
        form = ArquivoImportacaoForm()
    
    return render(request, 'importador/upload_arquivo.html', {'form': form})

@login_required
@admin_required
def listar_importacoes(request):
    importacoes = ArquivoImportacao.objects.all()
    
    status_filter = request.GET.get('status')
    if status_filter:
        importacoes = importacoes.filter(status=status_filter)
    
    competencia_filter = request.GET.get('competencia')
    if competencia_filter:
        importacoes = importacoes.filter(competencia=competencia_filter)
    
    paginator = Paginator(importacoes, 20)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'status_choices': StatusImportacao.choices,
        'current_status': status_filter,
        'current_competencia': competencia_filter,
    }
    return render(request, 'importador/listar_importacoes.html', context)

@login_required
@admin_required
def detalhe_importacao(request, importacao_id):
    importacao = get_object_or_404(ArquivoImportacao, id=importacao_id)
    return render(request, 'importador/detalhe_importacao.html', {'importacao': importacao})

@login_required
@admin_required
def reprocessar_arquivo(request, importacao_id):
    if request.method == 'POST':
        importacao = get_object_or_404(ArquivoImportacao, id=importacao_id)
        
        try:
            ImportadorService.processar_arquivo(importacao)
            messages.success(request, 'Arquivo reprocessado com sucesso!')
        except Exception as e:
            messages.error(request, f'Erro ao reprocessar arquivo: {str(e)}')
        
        return redirect('importador:detalhe_importacao', importacao_id=importacao_id)
    
    return redirect('importador:listar_importacoes')
