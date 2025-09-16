from django import forms
from .models import Cadastro
from apps.common.normalize import (
    phone_clean, upper
)
from apps.common.validators import (
    validate_pix
)

class CadastroForm(forms.ModelForm):
    """
    Formulário do Agente (server-side validations).
    - Normaliza e valida CPF/CNPJ/CEP/PIX/UF/telefone.
    - Garante regras PF (CPF) e PJ (CNPJ).
    """
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
            if cleaned.get("mensalidade_associativa"):
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