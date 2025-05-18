from django.contrib import admin
from django.utils.html import format_html
from .models import Payment
from import_export.admin import ImportExportModelAdmin
from import_export import resources

class PaymentResource(resources.ModelResource):
    class Meta:
        model = Payment
        fields = ('id', 'booking', 'user', 'amount', 'transaction_id', 'pidx', 'status', 'created_at', 'updated_at')
        export_order = fields

# Registration moved to dashboard/admin.py
class PaymentAdmin(ImportExportModelAdmin, admin.ModelAdmin):
    list_display = ('id', 'amount', 'transaction_id', 'booking_link', 'user_link', 'status_badge', 'created_at', 'updated_at')
    list_filter = ('status', 'created_at', 'updated_at')
    search_fields = ('transaction_id', 'pidx', 'booking__id', 'user__email', 'id')
    readonly_fields = ('created_at', 'updated_at', 'amount', 'transaction_id', 'pidx')
    resource_classes = [PaymentResource]
    ordering = ('-created_at',)
    list_per_page = 25
    date_hierarchy = 'created_at'
    
    actions = ['mark_as_completed', 'mark_as_refunded']
    
    fieldsets = (
        ('Payment Details', {
            'fields': ('amount', 'transaction_id', 'pidx'),
            'description': 'Transaction details'
        }),
        ('Associations', {
            'fields': ('booking', 'user'),
            'description': 'Related booking and user information'
        }),
        ('Status', {
            'fields': ('status',),
            'description': 'Current payment status'
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',),
            'description': 'Record timestamps'
        })
    )
    
    def mark_as_completed(self, request, queryset):
        queryset.update(status='completed')
    mark_as_completed.short_description = "Mark selected payments as completed"
    
    def mark_as_refunded(self, request, queryset):
        queryset.update(status='refunded')
    mark_as_refunded.short_description = "Mark selected payments as refunded"

    def status_badge(self, obj):
        status_colors = {
            'pending': '#ffc107',
            'completed': '#28a745',
            'failed': '#dc3545',
            'refunded': '#17a2b8'
        }
        return format_html(
            '<span style="background-color: {}; color: white; padding: 3px 10px; border-radius: 10px;">{}</span>',
            status_colors.get(obj.status, '#6c757d'),
            obj.get_status_display() if hasattr(obj, 'get_status_display') else obj.status.title()
        )
    status_badge.short_description = 'Status'

    def booking_link(self, obj):
        if obj.booking:
            url = f'/admin/bookings/booking/{obj.booking.id}/change/'
            return format_html('<a href="{}">{}</a>', url, f'Booking #{obj.booking.id}')
        return "No Booking"
    booking_link.short_description = "Booking"

    def user_link(self, obj):
        if obj.user:
            if hasattr(obj.user, 'passenger'):
                url = f'/admin/users/passenger/{obj.user.passenger.id}/change/'
            elif hasattr(obj.user, 'driver'):
                url = f'/admin/users/driver/{obj.user.driver.id}/change/'
            else:
                return obj.user.email
            return format_html('<a href="{}">{}</a>', url, obj.user.email)
        return "No User"
    user_link.short_description = "User"

    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete payments
        return request.user.is_superuser

    def has_change_permission(self, request, obj=None):
        # Staff members can modify payment details
        return request.user.is_staff

    def has_view_permission(self, request, obj=None):
        # All staff members can view payments 
        return request.user.is_staff

    def has_add_permission(self, request):
        # Staff members can add payments manually if needed
        return request.user.is_staff
