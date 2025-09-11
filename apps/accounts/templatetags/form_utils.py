from django import template

register = template.Library()

@register.filter
def add_class(field, css):
    """
    Anexa classes a um field form (ex.: {{ form.cpf|add_class:"input w-full" }}).
    """
    attrs = field.field.widget.attrs.copy()
    attrs["class"] = (attrs.get("class","") + " " + css).strip()
    return field.as_widget(attrs=attrs)