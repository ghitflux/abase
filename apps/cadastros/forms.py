from django import forms
from .models import Cadastro
from apps.common.normalize import (
    cpf_clean, cnpj_clean, cep_clean, phone_clean, upper
)
from apps.common.validators import (
    validate_cpf, validate_cnpj, validate_cep, validate_pix
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
            "agente_padrao","auxilio_agente_taxa_percent","cadastro_anterior",
        )
        widgets = {
            "data_nascimento": forms.DateInput(attrs={"type":"date", "class":"input"}),
            "data_aprovacao": forms.DateInput(attrs={"type":"date", "class":"input"}),
            "data_primeira_mensalidade": forms.DateInput(attrs={"type":"date", "class":"input"}),
            "data_envio": forms.DateInput(attrs={"type":"date", "class":"input"}),
        }

    def clean(self):
        cleaned = super().clean()

        # --- Normalização básica ---
        cleaned["cpf"] = cpf_clean(cleaned.get("cpf"))
        cleaned["cnpj"] = cnpj_clean(cleaned.get("cnpj"))
        cleaned["cep"] = cep_clean(cleaned.get("cep"))
        cleaned["celular"] = phone_clean(cleaned.get("celular"))
        cleaned["uf"] = upper(cleaned.get("uf"))[:2]

        # --- Regras PF/PJ ---
        tipo = cleaned.get("tipo_pessoa")
        if tipo == "PF":
            # PF exige CPF válido; zera CNPJ
            if not cleaned.get("cpf"):
                self.add_error("cpf", "CPF é obrigatório para Pessoa Física.")
            else:
                validate_cpf(cleaned["cpf"])
            cleaned["cnpj"] = ""
            # Nome completo para PF recomendado/obrigatório
            if not cleaned.get("nome_completo"):
                self.add_error("nome_completo", "Informe o nome completo para PF.")
        elif tipo == "PJ":
            # PJ exige CNPJ válido; zera CPF
            if not cleaned.get("cnpj"):
                self.add_error("cnpj", "CNPJ é obrigatório para Pessoa Jurídica.")
            else:
                validate_cnpj(cleaned["cnpj"])
            cleaned["cpf"] = ""
        else:
            self.add_error("tipo_pessoa", "Tipo de documento inválido (PF/PJ).")

        # --- CEP (se preenchido) ---
        if cleaned.get("cep"):
            validate_cep(cleaned["cep"])

        # --- PIX (se preenchido) ---
        if cleaned.get("chave_pix"):
            validate_pix(cleaned["chave_pix"])

        return cleaned