from django.contrib.auth.decorators import login_required
from django.shortcuts import render

@login_required
def design_system(request):
    """Página de preview do design system"""
    return render(request, "design_system/index.html")