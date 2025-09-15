from django import template

register = template.Library()

@register.filter
def add_class(field, css):
    """
    Anexa classes a um field form (ex.: {{ form.cpf|add_class:"input w-full" }}).
    """
    attrs = field.field.widget.attrs.copy()
    attrs["class"] = (attrs.get("class","") + " " + css).strip()
    
    # Adicionar data-money="brl" automaticamente para campos monetários
    money_fields = ['valor_bruto_total', 'valor_liquido', 'mensalidade_associativa', 'salario_bruto', 'repasse_associado', 'contribuicao', 'doacao_associado']
    if field.name in money_fields:
        attrs["data-money"] = "brl"
    
    return field.as_widget(attrs=attrs)