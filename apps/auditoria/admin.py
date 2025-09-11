from django.contrib import admin
from .models import SecurityLog

@admin.register(SecurityLog)
class SecurityLogAdmin(admin.ModelAdmin):
    list_display = ("created_at","event","username","ip")
    list_filter = ("event","created_at")
    search_fields = ("username","ip","user_agent")
    date_hierarchy = "created_at"