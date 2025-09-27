"""
Formulários para importação de cadastros.
"""

import json
from django import forms
from django.core.exceptions import ValidationError
from .models import ImportBatch
from .services import get_default_mapping


class ImportBatchForm(forms.ModelForm):
    """Formulário para criação de lotes de importação"""
    
    mapping_json_text = forms.CharField(
        widget=forms.Textarea(attrs={
            'rows': 15,
            'cols': 80,
            'class': 'form-control font-monospace',
            'placeholder': 'Cole aqui o JSON de mapeamento das colunas...'
        }),
        label='Mapeamento JSON',
        help_text='JSON que mapeia as colunas da planilha para os campos do modelo. '
                  'Exemplo: {"nome": "nome_completo", "cpf": "cpf"}',
        required=False
    )
    
    class Meta:
        model = ImportBatch
        fields = ['tipo', 'planilha', 'anexos_zip']
        widgets = {
            'tipo': forms.Select(attrs={
                'class': 'form-select',
                'required': True
            }),
            'planilha': forms.FileInput(attrs={
                'class': 'form-control',
                'accept': '.csv,.xlsx,.xls',
                'required': True
            }),
            'anexos_zip': forms.FileInput(attrs={
                'class': 'form-control',
                'accept': '.zip',
                'required': False
            })
        }
        labels = {
            'tipo': 'Tipo de Importação',
            'planilha': 'Arquivo da Planilha',
            'anexos_zip': 'Arquivo ZIP com Anexos (Opcional)'
        }
        help_texts = {
            'tipo': 'Selecione se está importando cadastros ou efetivados',
            'planilha': 'Arquivo CSV ou Excel (.csv, .xlsx, .xls)',
            'anexos_zip': 'Arquivo ZIP com pastas nomeadas pelo CPF (somente números) contendo os documentos'
        }
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        # Se não há dados iniciais, carrega o mapeamento padrão
        if not self.initial.get('mapping_json_text'):
            default_mapping = get_default_mapping()
            self.fields['mapping_json_text'].initial = json.dumps(
                default_mapping, 
                indent=2, 
                ensure_ascii=False
            )
        
        # Adiciona classes CSS para Bootstrap
        for field_name, field in self.fields.items():
            if 'class' not in field.widget.attrs:
                field.widget.attrs['class'] = 'form-control'
    
    def clean_planilha(self):
        """Valida o arquivo da planilha"""
        planilha = self.cleaned_data.get('planilha')
        
        if not planilha:
            return planilha
        
        # Verifica extensão do arquivo
        allowed_extensions = ['.csv', '.xlsx', '.xls']
        file_extension = planilha.name.lower().split('.')[-1]
        
        if f'.{file_extension}' not in allowed_extensions:
            raise ValidationError(
                f'Formato de arquivo não suportado. '
                f'Use: {", ".join(allowed_extensions)}'
            )
        
        # Verifica tamanho do arquivo (máximo 50MB)
        max_size = 50 * 1024 * 1024  # 50MB
        if planilha.size > max_size:
            raise ValidationError(
                f'Arquivo muito grande. Tamanho máximo: 50MB. '
                f'Tamanho atual: {planilha.size / (1024*1024):.1f}MB'
            )
        
        return planilha
    
    def clean_anexos_zip(self):
        """Valida o arquivo ZIP de anexos"""
        anexos_zip = self.cleaned_data.get('anexos_zip')
        
        if not anexos_zip:
            return anexos_zip
        
        # Verifica se é um arquivo ZIP
        if not anexos_zip.name.lower().endswith('.zip'):
            raise ValidationError('O arquivo de anexos deve ser um arquivo ZIP.')
        
        # Verifica tamanho do arquivo (máximo 500MB)
        max_size = 500 * 1024 * 1024  # 500MB
        if anexos_zip.size > max_size:
            raise ValidationError(
                f'Arquivo ZIP muito grande. Tamanho máximo: 500MB. '
                f'Tamanho atual: {anexos_zip.size / (1024*1024):.1f}MB'
            )
        
        return anexos_zip
    
    def clean_mapping_json_text(self):
        """Valida e converte o texto JSON em dicionário"""
        mapping_text = self.cleaned_data.get('mapping_json_text', '').strip()
        
        if not mapping_text:
            # Se não foi fornecido, usa o mapeamento padrão
            return get_default_mapping()
        
        try:
            mapping_dict = json.loads(mapping_text)
        except json.JSONDecodeError as e:
            raise ValidationError(f'JSON inválido: {str(e)}')
        
        # Valida se é um dicionário
        if not isinstance(mapping_dict, dict):
            raise ValidationError('O mapeamento deve ser um objeto JSON (dicionário).')
        
        # Valida se tem pelo menos um mapeamento
        if not mapping_dict:
            raise ValidationError('O mapeamento não pode estar vazio.')
        
        # Valida se as chaves e valores são strings
        for key, value in mapping_dict.items():
            if not isinstance(key, str) or not isinstance(value, str):
                raise ValidationError(
                    'Todas as chaves e valores do mapeamento devem ser strings.'
                )
        
        # Valida campos obrigatórios
        required_mappings = ['nome_completo']  # Campos que devem estar mapeados
        mapped_fields = set(mapping_dict.values())
        
        missing_required = []
        for required_field in required_mappings:
            if required_field not in mapped_fields:
                missing_required.append(required_field)
        
        if missing_required:
            raise ValidationError(
                f'Os seguintes campos obrigatórios devem estar mapeados: '
                f'{", ".join(missing_required)}'
            )
        
        return mapping_dict
    
    def clean(self):
        """Validação geral do formulário"""
        cleaned_data = super().clean()
        
        # Converte o mapping_json_text para mapping_json
        mapping_json = cleaned_data.get('mapping_json_text')
        if mapping_json:
            cleaned_data['mapping_json'] = mapping_json
        
        return cleaned_data
    
    def save(self, commit=True):
        """Salva o formulário, incluindo o mapeamento JSON"""
        instance = super().save(commit=False)
        
        # Define o mapeamento JSON
        instance.mapping_json = self.cleaned_data.get('mapping_json_text', {})
        
        if commit:
            instance.save()
        
        return instance


class MappingPreviewForm(forms.Form):
    """Formulário para preview do mapeamento de colunas"""
    
    planilha_preview = forms.FileField(
        widget=forms.FileInput(attrs={
            'class': 'form-control',
            'accept': '.csv,.xlsx,.xls'
        }),
        label='Arquivo para Preview',
        help_text='Carregue a planilha para ver as colunas disponíveis'
    )
    
    def clean_planilha_preview(self):
        """Valida o arquivo para preview"""
        planilha = self.cleaned_data.get('planilha_preview')
        
        if not planilha:
            return planilha
        
        # Verifica extensão
        allowed_extensions = ['.csv', '.xlsx', '.xls']
        file_extension = planilha.name.lower().split('.')[-1]
        
        if f'.{file_extension}' not in allowed_extensions:
            raise ValidationError(
                f'Formato não suportado. Use: {", ".join(allowed_extensions)}'
            )
        
        # Limite menor para preview (10MB)
        max_size = 10 * 1024 * 1024  # 10MB
        if planilha.size > max_size:
            raise ValidationError(
                'Arquivo muito grande para preview. Máximo: 10MB'
            )
        
        return planilha