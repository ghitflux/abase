from django import forms
from .models import ArquivoImportacao

class ArquivoImportacaoForm(forms.ModelForm):
    class Meta:
        model = ArquivoImportacao
        fields = ['arquivo', 'tipo_arquivo', 'competencia']
        widgets = {
            'arquivo': forms.FileInput(attrs={
                'class': 'mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100',
                'accept': '.csv,.txt'
            }),
            'tipo_arquivo': forms.Select(attrs={
                'class': 'mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm'
            }),
            'competencia': forms.TextInput(attrs={
                'class': 'mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm',
                'placeholder': 'YYYY-MM',
                'pattern': r'\d{4}-\d{2}'
            })
        }
    
    def clean_arquivo(self):
        arquivo = self.cleaned_data['arquivo']
        if arquivo:
            if arquivo.size > 50 * 1024 * 1024:  # 50MB
                raise forms.ValidationError('Arquivo muito grande. Máximo 50MB.')
            
            nome = arquivo.name.lower()
            if not (nome.endswith('.csv') or nome.endswith('.txt')):
                raise forms.ValidationError('Apenas arquivos CSV e TXT são permitidos.')
        
        return arquivo
    
    def clean_competencia(self):
        competencia = self.cleaned_data['competencia']
        if competencia:
            import re
            if not re.match(r'^\d{4}-\d{2}$', competencia):
                raise forms.ValidationError('Formato inválido. Use YYYY-MM (ex: 2024-01)')
            
            year, month = competencia.split('-')
            if not (1 <= int(month) <= 12):
                raise forms.ValidationError('Mês inválido.')
        
        return competencia