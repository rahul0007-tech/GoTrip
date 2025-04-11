


from django.contrib import admin
from .models import Location, Booking


@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display = ('name', 'fare', 'is_active', 'created_at', 'updated_at')
    list_filter = ('is_active',)
    search_fields = ('name',)
    ordering = ('name',)


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id','passenger', 'dropoff_location', 'booking_for', 'pickup_location', 'fare', 'status', 'created_at', 'payment_status')
    list_filter = ('status', 'dropoff_location', 'booking_for', 'payment_status')
    search_fields = ('passenger__user__username', 'driver__user__username', 'pickup_location')
    readonly_fields = ('created_at', 'updated_at')
    raw_id_fields = ('passenger', 'driver', 'accepted_drivers')
    
    def get_readonly_fields(self, request, obj=None):
        readonly_fields = list(self.readonly_fields)
        if obj and obj.status in ['completed', 'canceled']:
            # Make most fields readonly once a booking is completed or canceled
            readonly_fields.extend(['passenger', 'dropoff_location', 'pickup_location', 'booking_for'])
        return readonly_fields

# from django.contrib import admin
# from django.utils.html import format_html
# from .models import Location, Booking


# @admin.register(Location)
# class LocationAdmin(admin.ModelAdmin):
#     list_display = ('name', 'fare', 'is_active', 'created_at', 'updated_at', 'location_image_preview')
#     list_filter = ('is_active',)
#     search_fields = ('name',)
#     ordering = ('name',)
    
#     def location_image_preview(self, obj):
#         if obj.location_image:
#             return format_html('<img src="{}" width="50" height="50" style="object-fit: cover; border-radius: 5px;" />', obj.location_image.url)
#         return "No Image"
#     location_image_preview.short_description = 'Image'


# @admin.register(Booking)
# class BookingAdmin(admin.ModelAdmin):
#     list_display = ('id', 'passenger_info', 'dropoff_location', 'booking_for', 'fare', 'status_badge', 'payment_status_badge')
#     list_filter = ('status', 'dropoff_location', 'booking_for', 'payment_status')
#     search_fields = ('passenger__name', 'passenger__email', 'driver__name', 'pickup_location')
#     readonly_fields = ('created_at', 'updated_at')
#     raw_id_fields = ('passenger', 'driver', 'accepted_drivers')
#     fieldsets = (
#         ('Booking Information', {
#             'fields': ('passenger', 'booking_for', 'pickup_location', 'dropoff_location')
#         }),
#         ('Driver Information', {
#             'fields': ('driver', 'accepted_drivers')
#         }),
#         ('Status & Payment', {
#             'fields': ('status', 'payment_status', 'fare')
#         }),
#         ('Other Information', {
#             'fields': ('created_at', 'updated_at'),
#             'classes': ('collapse',)
#         }),
#     )
    
#     def passenger_info(self, obj):
#         if obj.passenger:
#             return format_html(
#                 '<div style="display: flex; align-items: center;">'
#                 '<strong>{}</strong> - {}'
#                 '</div>',
#                 obj.passenger.name,
#                 obj.passenger.email
#             )
#         return "No passenger"
#     passenger_info.short_description = 'Passenger'
    
#     def status_badge(self, obj):
#         status_colors = {
#             'pending': '#f39c12',    # Orange
#             'confirmed': '#2ecc71',  # Green
#             'completed': '#3498db',  # Blue
#             'canceled': '#e74c3c',   # Red
#         }
#         color = status_colors.get(obj.status, '#7f8c8d')  # Default gray
        
#         return format_html(
#             '<span style="background-color: {}; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px;">{}</span>',
#             color,
#             obj.get_status_display()
#         )
#     status_badge.short_description = 'Status'
    
#     def payment_status_badge(self, obj):
#         status_colors = {
#             'pending': '#f39c12',    # Orange
#             'confirmed': '#2ecc71',  # Green
#             'canceled': '#e74c3c',   # Red
#         }
#         color = status_colors.get(obj.payment_status, '#7f8c8d')  # Default gray
        
#         return format_html(
#             '<span style="background-color: {}; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px;">{}</span>',
#             color,
#             obj.get_payment_status_display()
#         )
#     payment_status_badge.short_description = 'Payment'
    
#     # Simple actions (we'll add more complex ones once this works)
#     actions = ['mark_as_confirmed', 'mark_as_completed', 'mark_as_canceled']
    
#     def mark_as_confirmed(self, request, queryset):
#         updated = queryset.filter(status='pending').update(status='confirmed')
#         self.message_user(request, f'{updated} bookings were successfully marked as confirmed.')
#     mark_as_confirmed.short_description = "Mark selected bookings as confirmed"
    
#     def mark_as_completed(self, request, queryset):
#         updated = queryset.filter(status='confirmed').update(status='completed')
#         self.message_user(request, f'{updated} bookings were successfully marked as completed.')
#     mark_as_completed.short_description = "Mark selected bookings as completed"
    
#     def mark_as_canceled(self, request, queryset):
#         updated = queryset.filter(status__in=['pending', 'confirmed']).update(status='canceled')
#         self.message_user(request, f'{updated} bookings were successfully marked as canceled.')
#     mark_as_canceled.short_description = "Mark selected bookings as canceled"