from django.db.models import Model, Field
from django.db.models.fields.related import ForeignObjectRel, ForeignObject
from django.core.exceptions import FieldDoesNotExist

_TEXT_TYPES = {"CharField","TextField","EmailField","SlugField"}

def _get_field(model, name):
    try:
        return model._meta.get_field(name)
    except FieldDoesNotExist:
        return None

def is_valid_text_path(model, path):
    """
    Verifica se 'model__a__b__c' termina em campo textual.
    Evita aplicar icontains em FK/OneToOne/ManyToMany.
    """
    parts = path.split("__")
    m = model
    for i, p in enumerate(parts):
        f = _get_field(m, p)
        if not f:
            return False
        is_rel = isinstance(f, (ForeignObject, ForeignObjectRel)) or f.is_relation
        if i < len(parts)-1:
            if not is_rel:
                return False
            # segue para o modelo relacionado
            m = f.related_model if hasattr(f, "related_model") and f.related_model else getattr(f, "remote_field", None).model
            if not m:
                return False
        else:
            # último: precisa ser textual
            return getattr(f, "get_internal_type", lambda: "")() in _TEXT_TYPES
    return False
