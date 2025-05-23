from django.contrib import admin
from django.utils.html import format_html
from .models import Vehicle, VehicleImage, VehicleType, FuelType
from import_export.admin import ImportExportModelAdmin
from import_export import resources

class VehicleImageInline(admin.TabularInline):
    model = VehicleImage
    extra = 1
    readonly_fields = ('image_preview',)

    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="150" height="auto" />', obj.image.url)
        return "No Image"

class VehicleAdmin(admin.ModelAdmin):
    list_display = ('vehicle_company', 'vehicle_number', 'driver', 'vehicle_type', 'vehicle_fuel_type', 'sitting_capacity')
    search_fields = ('vehicle_company', 'vehicle_number', 'driver__name')
    list_filter = ('vehicle_type', 'vehicle_fuel_type')
    inlines = [VehicleImageInline]
    readonly_fields = ('created_at', 'updated_at') if hasattr(Vehicle, 'created_at') else ()

    fieldsets = (
        ('Vehicle Information', {
            'fields': ('vehicle_company', 'vehicle_number', 'vehicle_color', 'sitting_capacity')
        }),
        ('Associations', {
            'fields': ('driver', 'vehicle_type', 'vehicle_fuel_type')
        }),
    )

    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete vehicles
        return request.user.is_superuser

    def has_change_permission(self, request, obj=None):
        # Staff members can modify vehicle details
        return request.user.is_staff

    def has_add_permission(self, request):
        # Staff members can add vehicles
        return request.user.is_staff

class VehicleTypeAdmin(admin.ModelAdmin):
    list_display = ('name', 'display_name')
    search_fields = ('name', 'display_name')

    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete vehicle types
        return request.user.is_superuser

    def has_change_permission(self, request, obj=None):
        # Staff members can modify vehicle types
        return request.user.is_staff

class FuelTypeAdmin(admin.ModelAdmin):
    list_display = ('name', 'display_name')
    search_fields = ('name', 'display_name')

    def has_delete_permission(self, request, obj=None):
        # Only superusers can delete fuel types
        return request.user.is_superuser

    def has_change_permission(self, request, obj=None):
        # Staff members can modify fuel types
        return request.user.is_staff

# Models will be registered in dashboard/admin.py