"""
URL configuration for core project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.shortcuts import redirect
from core import views_ds

def root_redirect(request):
    """Redireciona a rota raiz para o login ou dashboard conforme autenticação"""
    if request.user.is_authenticated:
        return redirect('accounts:dashboard')
    return redirect('accounts:login')

urlpatterns = [
    path('', root_redirect, name='root'),
    path('design-system/', views_ds.design_system, name='design_system'),
    path('admin/', admin.site.urls),
    path('accounts/', include(('apps.accounts.urls', 'accounts'), namespace='accounts')),
    path('cadastros/', include('apps.cadastros.urls')),
    path('analise/', include(('apps.analise.urls', 'analise'), namespace='analise')),
    path('tesouraria/', include('apps.tesouraria.urls')),
    path('relatorios/', include(('apps.relatorios.urls', 'relatorios'), namespace='relatorios')),
    path("importador/", include(("apps.importador.urls","importador"), namespace="importador")),
    path('auditoria/', include(('apps.auditoria.urls', 'auditoria'), namespace='auditoria')),
    path('notificacoes/', include(('apps.notificacoes.urls', 'notificacoes'), namespace='notificacoes')),
    path('p/', include(('apps.documentos.urls', 'documentos'), namespace='documentos')),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)