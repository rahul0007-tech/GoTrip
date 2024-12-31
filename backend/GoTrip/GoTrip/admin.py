from django.contrib import admin
from .models import Passenger, Driver, Vehicle, Image, Booking

class PassengerAdmin(admin.ModelAdmin):
    list_display=('passengerName','passengerPhone','passengerEmail','passengerPassword','passengerPhoto','passengerVerified')

class DriverAdmin(admin.ModelAdmin):
    list_display=('driverName','driverEmail','driverPhoneNumber','lisenceImage','driverPassword','driverStatus','driverVerification')

class VehicleAdmin(admin.ModelAdmin):
    list_display=('vehicleColor','vehicleCompany', 'vehicleType','vehicleFuelType','vehicleNumber')


class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'passenger', 'driver', 'pickup_location', 'dropoff_location', 'booking_time', 'status', 'fare')

    


admin.site.register(Passenger,PassengerAdmin)
admin.site.register(Driver,DriverAdmin)
admin.site.register(Vehicle, VehicleAdmin)
admin.site.register(Booking, BookingAdmin)