from django.contrib.auth.signals import user_logged_in, user_logged_out, user_login_failed
from django.dispatch import receiver
from apps.auditoria.models import SecurityLog

def client_ip(req):
    xff = req.META.get("HTTP_X_FORWARDED_FOR")
    return xff.split(",")[0].strip() if xff else req.META.get("REMOTE_ADDR")

@receiver(user_logged_in)
def on_login(sender, user, request, **kwargs):
    SecurityLog.objects.create(
        user=user, event="LOGIN", username=user.username,
        ip=client_ip(request), user_agent=request.META.get("HTTP_USER_AGENT",""),
        session_key=getattr(getattr(request, "session", None), "session_key", "") or ""
    )

@receiver(user_logged_out)
def on_logout(sender, user, request, **kwargs):
    SecurityLog.objects.create(
        user=user, event="LOGOUT", username=getattr(user,"username",""),
        ip=client_ip(request), user_agent=request.META.get("HTTP_USER_AGENT",""),
        session_key=getattr(getattr(request, "session", None), "session_key", "") or ""
    )

@receiver(user_login_failed)
def on_login_failed(sender, credentials, request, **kwargs):
    SecurityLog.objects.create(
        user=None, event="LOGIN_FAILED", username=credentials.get("username",""),
        ip=client_ip(request), user_agent=request.META.get("HTTP_USER_AGENT",""),
        session_key=getattr(getattr(request, "session", None), "session_key", "") or ""
    )