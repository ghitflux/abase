from decimal import Decimal

from django import forms

from .models import Cadastro
from apps.common.normalize import phone_clean, upper
from apps.common.validators import validate_pix

class CadastroForm(forms.ModelForm):
    """
    Formulário do Agente (server-side validations).
    - Normaliza e valida CPF/CNPJ/CEP/PIX/UF/telefone.
    - Garante regras PF (CPF) e PJ (CNPJ).
    """

    CONTRIBUTION_OPTIONS = [
        Decimal("100"), Decimal("150"), Decimal("200"), Decimal("250"),
        Decimal("300"), Decimal("350"), Decimal("400"), Decimal("450"), Decimal("500")
    ]

    class Meta:
        model = Cadastro
        exclude = (
            "status","created_at","updated_at","approved_at","paid_at",
            "agente_responsavel","agente_padrao","auxilio_agente_taxa_percent","auxilio_agente_valor","cadastro_anterior",
            # Campos calculados automaticamente - não devem aparecer no form
            "trinta_porcento_bruto","margem_liquido_menos_30_bruto","taxa_antecipacao_percent",
            "disponivel","valor_total_antecipacao","doacao_associado",
        )
        widgets = {
            "data_nascimento": forms.DateInput(attrs={"type":"date", "class":"input"}),
            "data_aprovacao": forms.DateInput(attrs={"type":"date", "class":"input"}),
            "data_primeira_mensalidade": forms.DateInput(attrs={"type":"date", "class":"input"}),
            "data_envio": forms.DateInput(attrs={"type":"date", "class":"input"}),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        def format_choice(value: Decimal) -> tuple[str, str]:
            display = f"R$ {value:,.2f}".replace(",", "@").replace(".", ",").replace("@", ".")
            raw = f"{value.quantize(Decimal('1'))}" if value == value.to_integral_value() else f"{value}"
            return raw, display

        base_choices = [format_choice(amount) for amount in self.CONTRIBUTION_OPTIONS]

        # Priorizar valor da instância durante edição
        current_value = None
        if self.instance and self.instance.pk and self.instance.mensalidade_associativa:
            current_value = self.instance.mensalidade_associativa
        elif self.initial.get("mensalidade_associativa"):
            current_value = self.initial.get("mensalidade_associativa")

        current_decimal = None
        if current_value is not None:
            try:
                current_decimal = Decimal(str(current_value))
            except (ValueError, TypeError, Exception):
                current_decimal = None

        # Sempre incluir o valor atual nas opções, mesmo que não esteja na lista padrão
        if current_decimal is not None and current_decimal not in self.CONTRIBUTION_OPTIONS:
            base_choices.append(format_choice(current_decimal))
            # Ordenar as opções para manter consistência
            base_choices.sort(key=lambda x: Decimal(x[0]))

        choice_list = [("", "Selecione...")] + base_choices

        # Definir initial corretamente
        initial = ""
        if current_decimal is not None and current_decimal > Decimal("0"):
            initial = str(current_decimal.quantize(Decimal('1')) if current_decimal == current_decimal.to_integral_value() else current_decimal)

        self.fields["mensalidade_associativa"] = forms.ChoiceField(
            label="Contribuição Associativa (R$)",
            choices=choice_list,
            initial=initial,
            required=True,
            widget=forms.Select(attrs={
                "class": "w-full px-4 py-3 text-sm border border-gray-200 rounded-xl shadow-sm bg-gray-900/60 text-gray-100 focus:border-red-500 focus:ring-2 focus:ring-red-500/20 focus:outline-none hover:border-gray-300",
            }),
        )

        if "prazo_antecipacao_meses" in self.fields:
            prazo_field = self.fields["prazo_antecipacao_meses"]
            prazo_field.initial = 3
            prazo_field.disabled = True
            prazo_field.widget.attrs.update({
                "class": "w-full px-4 py-3 text-sm border border-gray-200 rounded-xl shadow-sm bg-gray-900/40 text-gray-200 cursor-not-allowed",
                "readonly": "readonly",
            })
            self.initial["prazo_antecipacao_meses"] = 3

    def clean(self):
        cleaned = super().clean()
        
        try:
            # --- Normalização básica ---
            cleaned["celular"] = phone_clean(cleaned.get("celular", ""))
            cleaned["uf"] = upper(cleaned.get("uf", ""))[:2] if cleaned.get("uf") else ""
            
            # --- Normalização de valores monetários ---
            def clean_money_field(value):
                """
                Converte string monetária para Decimal, suportando formatos:
                - "400" → 400.00
                - "400,50" → 400.50
                - "1.234,56" → 1234.56
                - "R$ 1.234,56" → 1234.56
                - "1234.56" → 1234.56 (formato americano)
                """
                if not value:
                    return None

                from decimal import Decimal, InvalidOperation

                # Remove R$ e espaços
                value_str = str(value).replace("R$", "").strip()

                # Se vazio após limpeza
                if not value_str:
                    return None

                try:
                    # Se não tem vírgula, pode ser formato americano ou apenas inteiro
                    if ',' not in value_str:
                        # Remove pontos que são separadores de milhar
                        # Mantém apenas o último ponto se for decimal (max 2 casas)
                        parts = value_str.split('.')
                        if len(parts) == 2 and len(parts[1]) <= 2:
                            # Formato americano: 1234.56
                            clean_str = value_str
                        else:
                            # Separadores de milhar: 1.234 ou 1.234.567
                            clean_str = ''.join(parts)
                    else:
                        # Formato brasileiro com vírgula decimal
                        parts = value_str.split(',')
                        if len(parts) == 2:
                            # Remove pontos da parte inteira (separadores de milhar)
                            integer_part = parts[0].replace('.', '')
                            decimal_part = parts[1]
                            clean_str = f"{integer_part}.{decimal_part}"
                        else:
                            # Múltiplas vírgulas - erro de formato
                            return None

                    return Decimal(clean_str)

                except (InvalidOperation, ValueError, IndexError):
                    return None
            
            # Limpar campos monetários
            if cleaned.get("valor_bruto_total"):
                cleaned["valor_bruto_total"] = clean_money_field(cleaned["valor_bruto_total"])
            if cleaned.get("valor_liquido"):
                cleaned["valor_liquido"] = clean_money_field(cleaned["valor_liquido"])
            if cleaned.get("mensalidade_associativa") and not isinstance(cleaned["mensalidade_associativa"], Decimal):
                cleaned["mensalidade_associativa"] = clean_money_field(cleaned["mensalidade_associativa"])

            # --- Regras PF/PJ ---
            tipo = cleaned.get("tipo_pessoa")
            if tipo == "PF":
                # PF zera CNPJ
                cleaned["cnpj"] = ""
                # Nome completo para PF obrigatório
                if not cleaned.get("nome_completo"):
                    self.add_error("nome_completo", "Nome completo é obrigatório.")
            elif tipo == "PJ":
                # PJ zera CPF
                cleaned["cpf"] = ""
                # Nome completo também obrigatório para PJ (razão social)
                if not cleaned.get("nome_completo"):
                    self.add_error("nome_completo", "Nome/Razão Social é obrigatório.")
            else:
                self.add_error("tipo_pessoa", "Tipo de documento inválido (PF/PJ).")

            # --- PIX (se preenchido) ---
            if cleaned.get("chave_pix"):
                try:
                    validate_pix(cleaned["chave_pix"])
                except Exception as e:
                    self.add_error("chave_pix", str(e))
                    
        except Exception as e:
            print(f"Unexpected error in form clean method: {e}")
            self.add_error(None, f"Erro inesperado na validação: {e}")

        return cleaned

    def clean_prazo_antecipacao_meses(self):
        return 3

    def clean_mensalidade_associativa(self):
        value = self.cleaned_data.get("mensalidade_associativa")
        if not value:
            raise forms.ValidationError("Selecione uma contribuição válida.")
        try:
            return Decimal(value)
        except Exception:
            raise forms.ValidationError("Valor de contribuição inválido.")
