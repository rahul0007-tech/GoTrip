from django.contrib import admin
from .models import Passenger, Driver
from import_export.admin import ImportExportModelAdmin
from import_export import resources


class PassengerResource(resources.ModelResource):
    class Meta:
        model = Passenger
        fields = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')
        export_order = ('id', 'name', 'phone', 'email', 'password', 'photo', 'isVerified', 'Created_at', 'updated_at')

class PassengerAdmin(ImportExportModelAdmin,admin.ModelAdmin):
    list_display=('id','name','phone','email','password','photo','isVerified', 'Created_at', 'updated_at')
    list_filter=('isVerified','email','Created_at','updated_at')
    search_fields = ('email', 'name','id')
    fieldsets = [
        ('Passengher Credentials', {"fields": ["email", "password"]}),
        ("Personal info", {"fields": ["name","phone","photo"]}),
        ("Verification",{"fields":["isVerified","otp"]})
    ]
    resource_classes = [PassengerResource] 
    # ordering = ("Created_at","updated_at","id")


class DriverAdmin(admin.ModelAdmin):
    list_display=('id','name','phone','email','password','license','isVerified', 'Created_at', 'updated_at')
    list_filter=('isVerified','email','Created_at','updated_at')







admin.site.register(Passenger,PassengerAdmin)
admin.site.register(Driver,DriverAdmin)



# from django.contrib import admin
# from django.utils.html import format_html
# from .models import Passenger, Driver

# class PassengerAdmin(admin.ModelAdmin):
#     list_display = ('avatar_display', 'name', 'phone', 'email', 'verification_status', 'created_at')
#     list_filter = ('isVerified', 'Created_at')
#     search_fields = ('email', 'name', 'phone')
#     readonly_fields = ('Created_at', 'updated_at')
    
#     fieldsets = [
#         ('Personal Information', {
#             'fields': ['name', 'email', 'phone', 'photo'],
#         }),
#         ('Account Status', {
#             'fields': ['isVerified', 'is_active'],
#         }),
#         ('Authentication', {
#             'fields': ['password', 'otp'],
#             'classes': ['collapse'],
#         }),
#         ('Timestamps', {
#             'fields': ['Created_at', 'updated_at'],
#             'classes': ['collapse'],
#         }),
#     ]
    
#     def avatar_display(self, obj):
#         if obj.photo:
#             return format_html('<img src="{}" width="40" height="40" style="border-radius: 50%; object-fit: cover;" />', obj.photo.url)
#         return format_html('<div style="width: 40px; height: 40px; border-radius: 50%; background-color: #3498db; display: flex; align-items: center; justify-content: center; color: white;">{}</div>', obj.name[0].upper())
#     avatar_display.short_description = ''
    
#     def verification_status(self, obj):
#         if obj.isVerified:
#             return format_html('<span style="background-color: #2ecc71; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px;">Verified</span>')
#         return format_html('<span style="background-color: #e74c3c; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px;">Not Verified</span>')
#     verification_status.short_description = 'Verification'
    
#     def created_at(self, obj):
#         return obj.Created_at.strftime("%b %d, %Y")
#     created_at.short_description = 'Joined'
    
#     # Remove default Django admin action dropdown
#     def get_actions(self, request):
#         actions = super().get_actions(request)
#         if 'delete_selected' in actions:
#             del actions['delete_selected']
#         return actions

# class DriverAdmin(admin.ModelAdmin):
#     list_display = ('avatar_display', 'name', 'phone', 'email', 'verification_status', 'driver_status', 'created_at')
#     list_filter = ('isVerified', 'status', 'Created_at')
#     search_fields = ('email', 'name', 'phone')
#     readonly_fields = ('Created_at', 'updated_at')
    
#     fieldsets = [
#         ('Personal Information', {
#             'fields': ['name', 'email', 'phone', 'photo'],
#         }),
#         ('Driver Details', {
#             'fields': ['license', 'status'],
#         }),
#         ('Account Status', {
#             'fields': ['isVerified', 'is_active'],
#         }),
#         ('Authentication', {
#             'fields': ['password'],
#             'classes': ['collapse'],
#         }),
#         ('Timestamps', {
#             'fields': ['Created_at', 'updated_at'],
#             'classes': ['collapse'],
#         }),
#     ]
    
#     def avatar_display(self, obj):
#         if obj.photo:
#             return format_html('<img src="{}" width="40" height="40" style="border-radius: 50%; object-fit: cover;" />', obj.photo.url)
#         return format_html('<div style="width: 40px; height: 40px; border-radius: 50%; background-color: #3498db; display: flex; align-items: center; justify-content: center; color: white;">{}</div>', obj.name[0].upper())
#     avatar_display.short_description = ''
    
#     def verification_status(self, obj):
#         if obj.isVerified:
#             return format_html('<span style="background-color: #2ecc71; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px;">Verified</span>')
#         return format_html('<span style="background-color: #e74c3c; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px;">Not Verified</span>')
#     verification_status.short_description = 'Verification'
    
#     def driver_status(self, obj):
#         status_colors = {
#             'busy': '#e74c3c',  # Red
#             'free': '#2ecc71',  # Green
#         }
#         color = status_colors.get(obj.status, '#7f8c8d')  # Default gray
        
#         return format_html(
#             '<span style="background-color: {}; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px;">{}</span>',
#             color,
#             obj.get_status_display()
#         )
#     driver_status.short_description = 'Status'
    
#     def created_at(self, obj):
#         return obj.Created_at.strftime("%b %d, %Y")
#     created_at.short_description = 'Joined'
    
#     # Remove default Django admin action dropdown
#     def get_actions(self, request):
#         actions = super().get_actions(request)
#         if 'delete_selected' in actions:
#             del actions['delete_selected']
#         return actions

# # Register the models with the custom admin classes
# admin.site.register(Passenger, PassengerAdmin)
# admin.site.register(Driver, DriverAdmin)