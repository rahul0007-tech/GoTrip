from django.contrib import admin

# Register your models here.


from django.contrib import admin
from .models import Vehicle, VehicleImage, VehicleType, FuelType

class VehicleImageInline(admin.TabularInline):
    model = VehicleImage
    extra = 1

@admin.register(Vehicle)
class VehicleAdmin(admin.ModelAdmin):
    list_display = ('vehicle_company', 'vehicle_number', 'driver', 'vehicle_type', 'vehicle_fuel_type')
    search_fields = ('vehicle_company', 'vehicle_number', 'driver__name')
    list_filter = ('vehicle_type', 'vehicle_fuel_type')
    inlines = [VehicleImageInline]

@admin.register(VehicleType)
class VehicleTypeAdmin(admin.ModelAdmin):
    list_display = ('name', 'display_name')
    search_fields = ('name', 'display_name')

@admin.register(FuelType)
class FuelTypeAdmin(admin.ModelAdmin):
    list_display = ('name', 'display_name')
    search_fields = ('name', 'display_name')