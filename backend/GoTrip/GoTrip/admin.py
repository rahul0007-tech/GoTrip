from django.contrib import admin
from .models import Passenger, Driver, Vehicle, Image

class PassengerAdmin(admin.ModelAdmin):
    list_display=('passengerName','passengerPhone','passengerEmail','passengerPassword','passengerPhoto','passengerVerified')

class DriverAdmin(admin.ModelAdmin):
    list_display=('driverName','driverEmail','driverPhoneNumber','lisenceImage','driverPassword','driverStatus','driverVerification')

class VehicleAdmin(admin.ModelAdmin):
    list_display=('vehicleColor','vehicleCompany', 'vehicleType','vehicleFuelType','vehicleNumber')

    


admin.site.register(Passenger,PassengerAdmin)
admin.site.register(Driver,DriverAdmin)
admin.site.register(Vehicle, VehicleAdmin)
