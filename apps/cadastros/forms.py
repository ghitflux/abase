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
                if not value:
                    return None
                # Remove R$, pontos (milhares) e troca vírgula por ponto
                value_str = str(value).replace("R$", "").replace(" ", "").replace(".", "").replace(",", ".")
                try:
                    from decimal import Decimal, InvalidOperation
                    return Decimal(value_str)
                except (InvalidOperation, ValueError):
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