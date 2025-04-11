# from django.contrib import admin
# from django.contrib.admin.views.decorators import staff_member_required
# from django.template.response import TemplateResponse
# from django.db.models import Count, Q

# from bookings.models import Booking
# from users.models import Driver, Passenger

# class CustomAdminSite(admin.AdminSite):
#     site_header = 'GoTrip Administration'
#     site_title = 'GoTrip Admin'
#     index_title = 'Dashboard'
    
#     def get_app_list(self, request):
#         """
#         Return a sorted list of all the installed apps that have been
#         registered in this site.
#         """
#         app_list = super().get_app_list(request)
        
#         # Custom ordering of apps
#         app_dict = {app['app_label']: app for app in app_list}
        
#         # Define the order you want
#         custom_order = ['bookings', 'users', 'vehicles', 'payments', 'auth']
        
#         # Create new list based on custom order
#         ordered_app_list = []
#         for app_label in custom_order:
#             if app_label in app_dict:
#                 ordered_app_list.append(app_dict[app_label])
        
#         # Add any remaining apps not in the custom order
#         for app in app_list:
#             if app['app_label'] not in custom_order:
#                 ordered_app_list.append(app)
        
#         return ordered_app_list
    
#     @staff_member_required
#     def index(self, request, extra_context=None):
#         """
#         Override the default index to include custom stats
#         """
#         # Get booking statistics
#         pending_bookings = Booking.objects.filter(status='pending').count()
#         confirmed_bookings = Booking.objects.filter(status='confirmed').count()
        
#         # Get driver statistics
#         active_drivers = Driver.objects.filter(is_active=True).count()
        
#         # Get passenger statistics
#         total_passengers = Passenger.objects.count()
        
#         # Combine with any existing context
#         context = {
#             'pending_bookings': pending_bookings,
#             'confirmed_bookings': confirmed_bookings,
#             'active_drivers': active_drivers,
#             'total_passengers': total_passengers,
#         }
        
#         if extra_context:
#             context.update(extra_context)
        
#         return super().index(request, context)

# # Create an instance of the custom admin site
# custom_admin_site = CustomAdminSite(name='custom_admin')

# # Register your models with the custom admin site
# # You'll need to import all your model admins
# from django.contrib.auth.models import Group
# from django.contrib.auth.admin import GroupAdmin
# from bookings.admin import LocationAdmin, BookingAdmin
# from bookings.models import Location
# from users.admin import PassengerAdmin, DriverAdmin
# from vehicles.admin import VehicleAdmin, VehicleTypeAdmin, FuelTypeAdmin
# from vehicles.models import Vehicle, VehicleType, FuelType
# from payments.models import Payment

# # Register with custom admin site
# custom_admin_site.register(Group, GroupAdmin)
# custom_admin_site.register(Location, LocationAdmin)
# custom_admin_site.register(Booking, BookingAdmin)
# custom_admin_site.register(Passenger, PassengerAdmin)
# custom_admin_site.register(Driver, DriverAdmin)
# custom_admin_site.register(Vehicle, VehicleAdmin)
# custom_admin_site.register(VehicleType, VehicleTypeAdmin)
# custom_admin_site.register(FuelType, FuelTypeAdmin)