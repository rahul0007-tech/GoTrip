


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

