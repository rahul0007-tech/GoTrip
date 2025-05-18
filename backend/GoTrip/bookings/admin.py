from django.contrib import admin
from django.utils.html import format_html
from .models import Location, Booking
from django.urls import reverse
from django.db.models import Sum
from import_export.admin import ImportExportModelAdmin
from import_export import resources

class LocationResource(resources.ModelResource):
    class Meta:
        model = Location
        fields = ('id', 'name', 'fare', 'is_active', 'created_at', 'updated_at')
        export_order = fields

class BookingResource(resources.ModelResource):
    class Meta:
        model = Booking
        fields = ('id', 'passenger', 'driver', 'pickup_location', 'dropoff_location', 'fare', 
                 'status', 'payment_status', 'booking_for', 'booking_time', 'created_at', 'updated_at')
        export_order = fields

# Registration moved to dashboard/admin.py
class LocationAdmin(ImportExportModelAdmin, admin.ModelAdmin):
    list_display = ('name', 'fare', 'location_preview', 'is_active', 'created_at', 'updated_at')
    list_filter = ('is_active', 'created_at', 'updated_at')
    search_fields = ('name',)
    ordering = ('name',)
    readonly_fields = ('created_at', 'updated_at', 'location_preview')
    list_per_page = 20
    resource_classes = [LocationResource]
    actions = ['activate_locations', 'deactivate_locations']
    
    fieldsets = (
        ('Location Details', {
            'fields': ('name', 'fare', 'is_active'),
            'description': 'Basic information about the location'
        }),
        ('Media', {
            'fields': ('location_image', 'location_preview'),
            'description': 'Location images and previews'
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',),
            'description': 'Record timestamps'
        })
    )
    
    def location_preview(self, obj):
        if obj.location_image:
            return format_html('<img src="{}" width="100" height="100" style="object-fit: cover; border-radius: 8px;" />', obj.location_image.url)
        return "No Image"
    location_preview.short_description = "Preview"

    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete locations
        return request.user.is_superuser

    def has_change_permission(self, request, obj=None):
        # Staff members can modify locations
        return request.user.is_staff

    def activate_locations(self, request, queryset):
        queryset.update(is_active=True)
    activate_locations.short_description = "Mark selected locations as active"
    
    def deactivate_locations(self, request, queryset):
        queryset.update(is_active=False)
    deactivate_locations.short_description = "Mark selected locations as inactive"

    def has_view_permission(self, request, obj=None):
        return request.user.is_staff

    def has_add_permission(self, request):
        return request.user.is_staff


# Registration moved to dashboard/admin.py
class BookingAdmin(ImportExportModelAdmin, admin.ModelAdmin):
    list_display = ('id', 'passenger', 'driver', 'pickup_location', 'dropoff_location', 'fare', 'status_badge', 'payment_status_badge', 'booking_for', 'created_at')
    list_filter = ('status', 'payment_status', 'booking_for', 'created_at', 'updated_at')
    search_fields = ('passenger__name', 'driver__name', 'pickup_location', 'dropoff_location', 'id')
    readonly_fields = ('created_at', 'updated_at')
    raw_id_fields = ('passenger', 'driver', 'accepted_drivers')
    date_hierarchy = 'booking_for'
    list_per_page = 25
    ordering = ('-created_at',)
    resource_classes = [BookingResource]
    actions = ['mark_as_confirmed', 'mark_as_completed', 'mark_as_canceled']
    
    fieldsets = (
        ('Customer Information', {
            'fields': ('passenger', 'driver', 'accepted_drivers'),
            'description': 'Information about the customer and driver'
        }),
        ('Booking Details', {
            'fields': ('pickup_location', 'dropoff_location', 'fare', 'booking_for', 'booking_time'),
            'description': 'Details of the booking'
        }),
        ('Status Information', {
            'fields': ('status', 'payment_status'),
            'description': 'Current status of booking and payment'
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',),
            'description': 'Record timestamps'
        })
    )
    
    fieldsets = (
        ('Booking Information', {
            'fields': ('passenger', 'driver', 'pickup_location', 'dropoff_location', 'fare')
        }),
        ('Scheduling', {
            'fields': ('booking_for', 'booking_time')
        }),
        ('Status', {
            'fields': ('status', 'payment_status', 'accepted_drivers')
        }),
        ('System Fields', {
            'classes': ('collapse',),
            'fields': ('created_at', 'updated_at')
        })
    )

    def status_badge(self, obj):
        status_colors = {
            'pending': '#ffc107',
            'confirmed': '#28a745',
            'completed': '#17a2b8',
            'canceled': '#dc3545'
        }
        return format_html(
            '<span style="background-color: {}; color: white; padding: 3px 10px; border-radius: 10px;">{}</span>',
            status_colors.get(obj.status, '#6c757d'),
            obj.get_status_display() if hasattr(obj, 'get_status_display') else obj.status.title()
        )
    status_badge.short_description = 'Status'

    def payment_status_badge(self, obj):
        status_colors = {
            'pending': '#ffc107',
            'partial': '#17a2b8',
            'confirmed': '#28a745',
            'canceled': '#dc3545'
        }
        return format_html(
            '<span style="background-color: {}; color: white; padding: 3px 10px; border-radius: 10px;">{}</span>',
            status_colors.get(obj.payment_status, '#6c757d'),
            obj.get_payment_status_display() if hasattr(obj, 'get_payment_status_display') else obj.payment_status.title()
        )
    payment_status_badge.short_description = 'Payment Status'

    def mark_as_confirmed(self, request, queryset):
        queryset.update(status='confirmed')
    mark_as_confirmed.short_description = "Mark selected bookings as confirmed"
    
    def mark_as_completed(self, request, queryset):
        queryset.update(status='completed')
    mark_as_completed.short_description = "Mark selected bookings as completed"
    
    def mark_as_canceled(self, request, queryset):
        queryset.update(status='canceled')
    mark_as_canceled.short_description = "Mark selected bookings as canceled"

    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete bookings
        return request.user.is_superuser

    def has_change_permission(self, request, obj=None):
        # Staff members can modify bookings
        return request.user.is_staff

    def has_view_permission(self, request, obj=None):
        # All staff members can view bookings
        return request.user.is_staff

    def has_add_permission(self, request):
        # Staff members can add bookings
        return request.user.is_staff