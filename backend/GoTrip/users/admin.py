from django.contrib import admin
from .models import Passenger, Driver

class PassengerAdmin(admin.ModelAdmin):
    list_display=('id','name','phone','email','password','photo','isVerified', 'Created_at', 'updated_at')
    list_filter=('isVerified','email','Created_at','updated_at')
    search_fields = ('email', 'name','id')
    fieldsets = [
        ('Passengher Credentials', {"fields": ["email", "password"]}),
        ("Personal info", {"fields": ["name","phone","photo"]}),
        ("Verification",{"fields":["isVerified","otp"]})
    ]
    # ordering = ("Created_at","updated_at","id")


class DriverAdmin(admin.ModelAdmin):
    list_display=('id','name','phone','email','password','license','isVerified', 'Created_at', 'updated_at')
    list_filter=('isVerified','email','Created_at','updated_at')






admin.site.register(Passenger,PassengerAdmin)
admin.site.register(Driver,DriverAdmin)
