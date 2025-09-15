from django import forms

class ImportarTXTForm(forms.Form):
    arquivo = forms.FileField(
        label="Arquivo TXT",
        help_text="Selecione o arquivo TXT do relatório iNETConsig",
        required=True,
        widget=forms.FileInput(attrs={
            'class': 'mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100',
            'accept': '.txt'
        })
    )
    modo = forms.ChoiceField(
        label="Modo de processamento",
        choices=[
            ("preview", "Pré-visualizar"),
            ("confirm", "Importar")
        ],
        initial="preview",
        widget=forms.RadioSelect(attrs={
            'class': 'mt-1'
        })
    )
    
    def clean_arquivo(self):
        arquivo = self.cleaned_data['arquivo']
        if arquivo:
            if arquivo.size > 50 * 1024 * 1024:  # 50MB
                raise forms.ValidationError('Arquivo muito grande. Máximo 50MB.')
            
            nome = arquivo.name.lower()
            if not nome.endswith('.txt'):
                raise forms.ValidationError('Apenas arquivos TXT são permitidos.')
        
        return arquivo