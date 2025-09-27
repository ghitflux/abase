"""
Views para importação de cadastros.
"""

import json
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from django.contrib import messages
from django.urls import reverse
from django.utils import timezone

from .models import ImportBatch, ImportRow, StatusImportacao
from .forms import ImportBatchForm
from .services import import_batch


@login_required
def index(request):
    """View principal para upload e configuração da importação"""
    recent_batches = ImportBatch.objects.filter(
        usuario=request.user
    ).order_by('-created_at')[:5]
    
    # Gera o JSON do mapeamento padrão formatado
    import json
    from .services import get_default_mapping
    default_mapping_json = json.dumps(get_default_mapping(), indent=2, ensure_ascii=False)
    
    context = {
        'form': ImportBatchForm(),
        'recent_batches': recent_batches,
        'default_mapping_json': default_mapping_json,
    }
    
    return render(request, 'importar_cadastros/index.html', context)


@login_required
@require_http_methods(["GET", "POST"])
def dry_run(request, batch_id=None):
    """
    Executa um dry run da importação.
    Mostra preview dos resultados sem persistir no banco.
    """
    if request.method == 'POST':
        form = ImportBatchForm(request.POST, request.FILES)
        if form.is_valid():
            # Cria o lote
            batch = form.save(commit=False)
            batch.usuario = request.user
            batch.status = StatusImportacao.DRAFT
            batch.save()
            batch_id = batch.id
        else:
            # Se o formulário tem erros, retorna para a página inicial
            context = {
                'form': form,
                'page_title': 'Importar Cadastros - Erro',
            }
            return render(request, 'importar_cadastros/index.html', context)
    
    # Busca o lote
    if batch_id:
        batch = get_object_or_404(ImportBatch, id=batch_id, usuario=request.user)
    else:
        messages.error(request, 'Lote de importação não encontrado.')
        return redirect('importar_cadastros:index')
    
    # Executa o dry run
    try:
        results = import_batch(batch, dry_run=True)
        
        # Busca as linhas com erro para exibir detalhes
        error_rows = []
        if not results.get('success', False):
            error_rows = results.get('errors', [])
        
        context = {
            'batch': batch,
            'results': results,
            'error_rows': error_rows,
            'page_title': 'Preview da Importação',
            'breadcrumbs': [
                {'name': 'Home', 'url': '/'},
                {'name': 'Importar Cadastros', 'url': reverse('importar_cadastros:index')},
                {'name': 'Preview', 'url': None}
            ]
        }
        
        # Se for requisição HTMX, retorna apenas o fragmento
        if request.headers.get('HX-Request'):
            return render(request, 'importar_cadastros/_results.html', context)
        
        return render(request, 'importar_cadastros/dry_run.html', context)
        
    except Exception as e:
        messages.error(request, f'Erro ao processar importação: {str(e)}')
        return redirect('importar_cadastros:index')


@login_required
@require_http_methods(["POST"])
def confirm(request):
    """
    Confirma e executa a importação definitiva.
    """
    batch_id = request.POST.get('batch_id')
    if not batch_id:
        messages.error(request, 'ID do lote não fornecido.')
        return redirect('importar_cadastros:index')
    
    batch = get_object_or_404(ImportBatch, id=batch_id, usuario=request.user)
    
    # Verifica se o lote está em estado válido para confirmação
    if batch.status not in [StatusImportacao.PENDING, StatusImportacao.DRY_RUN]:
        messages.error(request, 'Este lote não pode ser confirmado.')
        return redirect('importar_cadastros:index')
    
    try:
        # Executa a importação definitiva
        results = import_batch(batch, dry_run=False)
        
        if results.get('success', False):
            messages.success(
                request, 
                f'Importação concluída com sucesso! '
                f'{results.get("linhas_sucesso", 0)} linhas processadas, '
                f'{results.get("linhas_erro", 0)} erros.'
            )
        else:
            messages.error(
                request, 
                f'Erro na importação: {results.get("error", "Erro desconhecido")}'
            )
        
        context = {
            'batch': batch,
            'results': results,
            'page_title': 'Importação Concluída',
            'breadcrumbs': [
                {'name': 'Home', 'url': '/'},
                {'name': 'Importar Cadastros', 'url': reverse('importar_cadastros:index')},
                {'name': 'Resultado', 'url': None}
            ]
        }
        
        # Se for requisição HTMX, retorna apenas o fragmento
        if request.headers.get('HX-Request'):
            return render(request, 'importar_cadastros/_results.html', context)
        
        return render(request, 'importar_cadastros/confirm.html', context)
        
    except Exception as e:
        messages.error(request, f'Erro ao confirmar importação: {str(e)}')
        return redirect('importar_cadastros:index')


@login_required
def batch_detail(request, batch_id):
    """
    Exibe detalhes de um lote de importação.
    """
    batch = get_object_or_404(ImportBatch, id=batch_id, usuario=request.user)
    
    # Busca as linhas do lote
    rows = ImportRow.objects.filter(batch=batch).order_by('linha_numero')
    
    # Estatísticas
    total_rows = rows.count()
    success_rows = rows.filter(sucesso=True).count()
    error_rows = rows.filter(sucesso=False).count()
    
    context = {
        'batch': batch,
        'rows': rows,
        'total_rows': total_rows,
        'success_rows': success_rows,
        'error_rows': error_rows,
        'page_title': f'Lote #{batch.id}',
        'breadcrumbs': [
            {'name': 'Home', 'url': '/'},
            {'name': 'Importar Cadastros', 'url': reverse('importar_cadastros:index')},
            {'name': f'Lote #{batch.id}', 'url': None}
        ]
    }
    
    return render(request, 'importar_cadastros/batch_detail.html', context)


@login_required
def batch_rows_json(request, batch_id):
    """
    Retorna as linhas de um lote em formato JSON para DataTables.
    """
    batch = get_object_or_404(ImportBatch, id=batch_id, usuario=request.user)
    
    # Parâmetros do DataTables
    draw = int(request.GET.get('draw', 1))
    start = int(request.GET.get('start', 0))
    length = int(request.GET.get('length', 10))
    search_value = request.GET.get('search[value]', '')
    
    # Query base
    rows = ImportRow.objects.filter(batch=batch)
    
    # Filtro de busca
    if search_value:
        rows = rows.filter(
            Q(linha_numero__icontains=search_value) |


            Q(mensagem_erro__icontains=search_value)
        )
    
    # Total de registros
    records_total = ImportRow.objects.filter(batch=batch).count()
    records_filtered = rows.count()
    
    # Paginação
    rows = rows.order_by('linha_numero')[start:start + length]
    
    # Prepara os dados
    data = []
    for row in rows:
        data.append({
            'linha_numero': row.linha_numero,
            'sucesso': 'Sim' if row.sucesso else 'Não',
            'mensagem_erro': row.mensagem_erro or '',
            'cadastro': str(row.cadastro) if row.cadastro else '',
            'dados_brutos': json.dumps(row.dados_brutos, ensure_ascii=False)[:100] + '...'
        })
    
    return JsonResponse({
        'draw': draw,
        'recordsTotal': records_total,
        'recordsFiltered': records_filtered,
        'data': data
    })


@login_required
def delete_batch(request, batch_id):
    """
    Exclui um lote de importação.
    """
    batch = get_object_or_404(ImportBatch, id=batch_id, usuario=request.user)
    
    if request.method == 'POST':
        batch_name = f"Lote #{batch.id}"
        batch.delete()
        messages.success(request, f'{batch_name} foi excluído com sucesso.')
        return redirect('importar_cadastros:index')
    
    context = {
        'batch': batch,
        'page_title': 'Excluir Lote',
        'breadcrumbs': [
            {'name': 'Home', 'url': '/'},
            {'name': 'Importar Cadastros', 'url': reverse('importar_cadastros:index')},
            {'name': 'Excluir Lote', 'url': None}
        ]
    }
    
    return render(request, 'importar_cadastros/delete_batch.html', context)