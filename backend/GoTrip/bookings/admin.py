# from django.contrib import admin
# from .models import Booking

# Register your models here.

# class BookingAdmin(admin.ModelAdmin):
#     list_display = ('id','passenger','driver','pickup_location','dropoff_location','created_at','status','fare')
#     list_filter = ('status', 'dropoff_location','created_at','updated_at')
#     search_fields = ('passenger__email', 'driver__email')



# admin.site.register(Booking, BookingAdmin)

from django.contrib import admin
from .models import Booking

class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'passenger', 'driver', 'pickup_location', 'dropoff_location', 'created_at', 'status', 'fare', 'get_accepted_drivers')
    list_filter = ('status', 'dropoff_location', 'created_at', 'updated_at')
    search_fields = ('passenger__email', 'driver__email')
    readonly_fields = ('get_accepted_drivers',)

    def get_accepted_drivers(self, obj):
        return ", ".join([driver.email for driver in obj.accepted_drivers.all()]) if obj.accepted_drivers.exists() else "No Drivers"

    get_accepted_drivers.short_description = "Accepted Drivers"

admin.site.register(Booking, BookingAdmin)
