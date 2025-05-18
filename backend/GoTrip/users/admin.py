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


# Registration moved to dashboard/admin.py
class PassengerAdmin(ImportExportModelAdmin, admin.ModelAdmin):
    list_display = ('id', 'name', 'phone', 'email', 'photo_preview', 'isVerified', 'otp', 'Created_at', 'updated_at')
    list_filter = ('isVerified', 'Created_at', 'updated_at')
    search_fields = ('email', 'name', 'id', 'phone')
    readonly_fields = ('Created_at', 'updated_at', 'photo_preview')
    ordering = ('-Created_at',)
    list_per_page = 25
    date_hierarchy = 'Created_at'
    
    fieldsets = [
        ('Passenger Credentials', {
            "fields": ["email", "password"],
            "description": "Login credentials for the passenger"
        }),
        ("Personal Information", {
            "fields": ["name", "phone", "photo", "photo_preview"],
            "description": "Personal details and profile photo"
        }),
        ("Verification", {
            "fields": ["isVerified", "otp"],
            "description": "Account verification status and OTP"
        }),
        ("System Information", {
            "fields": ["Created_at", "updated_at"],
            "classes": ("collapse",),
            "description": "System timestamps"
        })
    ]
    resource_classes = [PassengerResource]
    
    actions = ['verify_selected_passengers', 'unverify_selected_passengers']
    
    def photo_preview(self, obj):
        if obj.photo:
            return format_html('<img src="{}" width="50" height="50" style="border-radius: 50%;" />', obj.photo.url)
        return "No Photo"
    photo_preview.short_description = "Photo Preview"

    def verify_selected_passengers(self, request, queryset):
        queryset.update(isVerified=True)
    verify_selected_passengers.short_description = "Mark selected passengers as verified"
    
    def unverify_selected_passengers(self, request, queryset):
        queryset.update(isVerified=False)
    unverify_selected_passengers.short_description = "Mark selected passengers as unverified"
    
    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete passengers
        return request.user.is_superuser

    def save_model(self, request, obj, form, change):
        if not change:  # If this is a new passenger
            if not obj.password.startswith(('pbkdf2_sha256$', 'bcrypt$', 'argon2')):
                obj.set_password(obj.password)
        super().save_model(request, obj, form, change)

    def has_view_permission(self, request, obj=None):
        # All staff members can view passengers
        return request.user.is_staff

    def has_change_permission(self, request, obj=None):
        # Staff members can modify passenger details
        return request.user.is_staff

    def has_add_permission(self, request):
        # Staff members can add passengers
        return request.user.is_staff


class DriverResource(resources.ModelResource):
    class Meta:
        model = Driver
        fields = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')
        export_order = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at', 'license')

# Registration moved to dashboard/admin.py
class DriverAdmin(ImportExportModelAdmin, admin.ModelAdmin):
    list_display = ('id', 'name', 'phone', 'email', 'license_preview', 'photo_preview', 'status_badge', 'isVerified', 'Created_at', 'updated_at')
    list_filter = ('isVerified', 'status', 'Created_at', 'updated_at')
    search_fields = ('email', 'name', 'id', 'phone')
    readonly_fields = ('Created_at', 'updated_at', 'license_preview', 'photo_preview')
    ordering = ('-Created_at',)
    list_per_page = 25
    date_hierarchy = 'Created_at'
    
    fieldsets = [
        ('Driver Credentials', {
            "fields": ["email", "password"],
            "description": "Login credentials for the driver"
        }),
        ("Personal Information", {
            "fields": ["name", "phone", "photo", "photo_preview"],
            "description": "Personal details and profile photo"
        }),
        ("Driver Information", {
            "fields": ["status", "license", "license_preview"],
            "description": "Driver's license and current status"
        }),
        ("Verification", {
            "fields": ["isVerified"],
            "description": "Account verification status"
        }),
        ("System Information", {
            "fields": ["Created_at", "updated_at"],
            "classes": ("collapse",),
            "description": "System timestamps"
        })
    ]
    resource_classes = [DriverResource]
    
    actions = ['verify_selected_drivers', 'unverify_selected_drivers', 'set_status_free', 'set_status_busy']
    
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
    
    def verify_selected_drivers(self, request, queryset):
        queryset.update(isVerified=True)
    verify_selected_drivers.short_description = "Mark selected drivers as verified"
    
    def unverify_selected_drivers(self, request, queryset):
        queryset.update(isVerified=False)
    unverify_selected_drivers.short_description = "Mark selected drivers as unverified"
    
    def set_status_free(self, request, queryset):
        queryset.update(status='free')
    set_status_free.short_description = "Set selected drivers as free"
    
    def set_status_busy(self, request, queryset):
        queryset.update(status='busy')
    set_status_busy.short_description = "Set selected drivers as busy"
    
    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete drivers
        return request.user.is_superuser
    
    def save_model(self, request, obj, form, change):
        if not change:  # If this is a new driver
            if not obj.password.startswith(('pbkdf2_sha256$', 'bcrypt$', 'argon2')):
                obj.set_password(obj.password)
        super().save_model(request, obj, form, change)

    def has_view_permission(self, request, obj=None):
        # All staff members can view drivers
        return request.user.is_staff

    def has_change_permission(self, request, obj=None):
        # Staff members can modify driver details
        return request.user.is_staff

    def has_add_permission(self, request):
        # Staff members can add drivers
        return request.user.is_staff


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

# Payment admin has been moved to payments/admin.py