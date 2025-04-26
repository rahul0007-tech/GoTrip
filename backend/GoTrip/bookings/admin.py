


# from django.contrib import admin
# from .models import Location, Booking


# @admin.register(Location)
# class LocationAdmin(admin.ModelAdmin):
#     list_display = ('name', 'fare', 'is_active', 'created_at', 'updated_at')
#     list_filter = ('is_active',)
#     search_fields = ('name',)
#     ordering = ('name',)


# @admin.register(Booking)
# class BookingAdmin(admin.ModelAdmin):
#     list_display = ('id','passenger', 'dropoff_location', 'booking_for', 'pickup_location', 'fare', 'status', 'created_at', 'payment_status')
#     list_filter = ('status', 'dropoff_location', 'booking_for', 'payment_status')
#     search_fields = ('passenger__user__username', 'driver__user__username', 'pickup_location')
#     readonly_fields = ('created_at', 'updated_at')
#     raw_id_fields = ('passenger', 'driver', 'accepted_drivers')
    
#     def get_readonly_fields(self, request, obj=None):
#         readonly_fields = list(self.readonly_fields)
#         if obj and obj.status in ['completed', 'canceled']:
#             # Make most fields readonly once a booking is completed or canceled
#             readonly_fields.extend(['passenger', 'dropoff_location', 'pickup_location', 'booking_for'])
#         return readonly_fields


from django.contrib import admin
from .models import Location, Booking
from django.utils.html import format_html

@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display = ('name', 'fare', 'is_active', 'created_at', 'updated_at')
    list_filter = ('is_active',)
    search_fields = ('name',)
    ordering = ('name',)
    
    # Add a preview for location image if it exists
    def location_preview(self, obj):
        if obj.location_image:
            return format_html('<img src="{}" width="50" height="50" style="border-radius: 50%;" />', obj.location_image.url)
        return "No Image"
    location_preview.short_description = "Image"


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'passenger', 'dropoff_location', 'booking_for', 'pickup_location', 'fare', 'status_badge', 'created_at', 'payment_status_badge')
    list_filter = ('status', 'dropoff_location', 'booking_for', 'payment_status')
    search_fields = ('passenger__name', 'driver__name', 'pickup_location')
    readonly_fields = ('created_at', 'updated_at')
    raw_id_fields = ('passenger', 'driver', 'accepted_drivers')
    date_hierarchy = 'booking_for'
    
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
        }),
    )
    
    def status_badge(self, obj):
        status_colors = {
            'pending': 'warning',
            'confirmed': 'info',
            'completed': 'success',
            'canceled': 'danger'
        }
        color = status_colors.get(obj.status, 'secondary')
        return format_html('<span class="badge badge-{}">{}</span>', color, obj.status.title())
    status_badge.short_description = 'Status'
    
    def payment_status_badge(self, obj):
        status_colors = {
            'pending': 'warning',
            'partial': 'info',
            'confirmed': 'success',
            'canceled': 'danger'
        }
        color = status_colors.get(obj.payment_status, 'secondary')
        return format_html('<span class="badge badge-{}">{}</span>', color, obj.payment_status.title())
    payment_status_badge.short_description = 'Payment'
    
    def get_readonly_fields(self, request, obj=None):
        readonly_fields = list(self.readonly_fields)
        if obj and obj.status in ['completed', 'canceled']:
            # Make most fields readonly once a booking is completed or canceled
            readonly_fields.extend(['passenger', 'dropoff_location', 'pickup_location', 'booking_for'])
        return readonly_fields