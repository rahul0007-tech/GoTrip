# from django.contrib import admin
# from .models import Passenger, Driver
# from import_export.admin import ImportExportModelAdmin
# from import_export import resources


# class PassengerResource(resources.ModelResource):
#     class Meta:
#         model = Passenger
#         fields = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')
#         export_order = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')

# class PassengerAdmin(ImportExportModelAdmin,admin.ModelAdmin):
#     list_display=('id','name','phone','email','password','photo','isVerified', 'Created_at', 'updated_at')
#     list_filter=('isVerified','email','Created_at','updated_at')
#     search_fields = ('email', 'name','id')
#     fieldsets = [
#         ('Passengher Credentials', {"fields": ["email", "password"]}),
#         ("Personal info", {"fields": ["name","phone","photo"]}),
#         ("Verification",{"fields":["isVerified","otp"]})
#     ]
#     resource_classes = [PassengerResource] 
#     # ordering = ("Created_at","updated_at","id")


# class DriverAdmin(admin.ModelAdmin):
#     list_display=('id','name','phone','email','password','license','isVerified', 'Created_at', 'updated_at')
#     list_filter=('isVerified','email','Created_at','updated_at')







# admin.site.register(Passenger,PassengerAdmin)
# admin.site.register(Driver,DriverAdmin)



from django.contrib import admin
from .models import Passenger, Driver
from import_export.admin import ImportExportModelAdmin
from import_export import resources
from django.utils.html import format_html

class PassengerResource(resources.ModelResource):
    class Meta:
        model = Passenger
        fields = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')
        export_order = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')


@admin.register(Passenger)
class PassengerAdmin(ImportExportModelAdmin, admin.ModelAdmin):
    list_display = ('id', 'name', 'phone', 'email', 'photo_preview', 'isVerified', 'Created_at', 'updated_at', 'otp')
    list_filter = ('isVerified', 'Created_at', 'updated_at')
    search_fields = ('email', 'name', 'id')
    readonly_fields = ('Created_at', 'updated_at', 'photo_preview')
    fieldsets = [
        ('Passenger Credentials', {"fields": ["email", "password"]}),
        ("Personal info", {"fields": ["name", "phone", "photo", "photo_preview"]}),
        ("Verification", {"fields": ["isVerified", "otp"]})
    ]
    resource_classes = [PassengerResource]
    
    def photo_preview(self, obj):
        if obj.photo:
            return format_html('<img src="{}" width="50" height="50" style="border-radius: 50%;" />', obj.photo.url)
        return "No Photo"
    photo_preview.short_description = "Photo Preview"



class DriverResource(resources.ModelResource):
    class Meta:
        model = Driver
        fields = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')
        export_order = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at', 'license')

@admin.register(Driver)
class DriverAdmin(ImportExportModelAdmin, admin.ModelAdmin):
    list_display = ('id', 'name', 'phone', 'email', 'license_preview', 'photo_preview', 'status_badge', 'isVerified', 'Created_at', 'updated_at')
    list_filter = ('isVerified', 'status', 'Created_at', 'updated_at')
    search_fields = ('email', 'name', 'id')
    readonly_fields = ('Created_at', 'updated_at', 'license_preview', 'photo_preview')
    fieldsets = [
        ('Driver Credentials', {"fields": ["email", "password"]}),
        ("Personal info", {"fields": ["name", "phone", "photo", "photo_preview"]}),
        ("Driver info", {"fields": ["status", "license", "license_preview"]}),
        ("Verification", {"fields": ["isVerified"]})
    ]
    resource_classes = [DriverResource]
    
    def status_badge(self, obj):
        status_colors = {
            'busy': 'danger',
            'free': 'success'
        }
        color = status_colors.get(obj.status, 'secondary')
        return format_html('<span class="badge badge-{}">{}</span>', color, obj.status.title())
    status_badge.short_description = 'Status'
    
    def license_preview(self, obj):
        if obj.license:
            return format_html('<img src="{}" width="50" height="35" />', obj.license.url)
        return "No License"
    license_preview.short_description = "License Preview"
    
    def photo_preview(self, obj):
        if obj.photo:
            return format_html('<img src="{}" width="50" height="50" style="border-radius: 50%;" />', obj.photo.url)
        return "No Photo"
    photo_preview.short_description = "Photo Preview"


### Enhanced Vehicle Admin

from django.contrib import admin
from vehicles.models import Vehicle, VehicleImage, VehicleType, FuelType



class VehicleImageInline(admin.TabularInline):
    model = VehicleImage
    extra = 1
    readonly_fields = ('image_preview',)
    
    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="100" height="75" />', obj.image.url)
        return "No Image"

@admin.register(Vehicle)
class VehicleAdmin(admin.ModelAdmin):
    list_display = ('id', 'vehicle_company', 'vehicle_number', 'driver', 'vehicle_type', 'vehicle_fuel_type', 'vehicle_color', 'sitting_capacity')
    search_fields = ('vehicle_company', 'vehicle_number', 'driver__name')
    list_filter = ('vehicle_type', 'vehicle_fuel_type', 'vehicle_color')
    inlines = [VehicleImageInline]
    fieldsets = (
        ('Owner Information', {
            'fields': ('driver',)
        }),
        ('Vehicle Details', {
            'fields': ('vehicle_company', 'vehicle_number', 'vehicle_color', 'sitting_capacity')
        }),
        ('Specifications', {
            'fields': ('vehicle_type', 'vehicle_fuel_type')
        }),
    )

@admin.register(VehicleType)
class VehicleTypeAdmin(admin.ModelAdmin):
    list_display = ('name', 'display_name')
    search_fields = ('name', 'display_name')

@admin.register(FuelType)
class FuelTypeAdmin(admin.ModelAdmin):
    list_display = ('name', 'display_name')
    search_fields = ('name', 'display_name')


### Enhanced Payment Admin

from django.contrib import admin
from payments.models import Payment

class PaymentResource(resources.ModelResource):
    class Meta:
        model = Payment
        fields = ('id', 'amount', 'transaction_id', 'pidx', 'created_at', 'status', 'user')
        export_order = ('id', 'amount', 'transaction_id', 'pidx', 'created_at', 'status', 'user')


@admin.register(Payment)
class PaymentAdmin(ImportExportModelAdmin,admin.ModelAdmin):
    list_display = ('id', 'amount', 'transaction_id', 'pidx', 'created_at', 'status_badge', 'booking_link', 'user_link')
    list_filter = ('status', 'created_at')
    search_fields = ('transaction_id', 'pidx', 'booking__id', 'user__email')
    readonly_fields = ('created_at', 'updated_at')

    resource_classes = [PaymentResource]
    
    def status_badge(self, obj):
        status_colors = {
            'started': 'info',
            'initiated': 'primary',
            'completed': 'success',
            'canceled': 'danger',
            'user_canceled': 'warning',
            'expired': 'secondary',
            'refunded': 'light',
            'partially_refunded': 'dark',
            'pending': 'warning'
        }
        color = status_colors.get(obj.status, 'secondary')
        return format_html('<span class="badge badge-{}">{}</span>', color, obj.status.title())
    status_badge.short_description = 'Status'
    
    def booking_link(self, obj):
        if obj.booking:
            return format_html('<a href="{}">{}</a>', 
                               f'/admin/bookings/booking/{obj.booking.id}/change/', 
                               f'Booking #{obj.booking.id}')
        return "No Booking"
    booking_link.short_description = "Booking"
    
    def user_link(self, obj):
        if obj.user:
            if hasattr(obj.user, 'passenger'):
                return format_html('<a href="{}">{}</a>', 
                                  f'/admin/users/passenger/{obj.user.passenger.id}/change/', 
                                  obj.user.email)
            elif hasattr(obj.user, 'driver'):
                return format_html('<a href="{}">{}</a>', 
                                  f'/admin/users/driver/{obj.user.driver.id}/change/', 
                                  obj.user.email)
            return obj.user.email
        return "No User"
    user_link.short_description = "User"