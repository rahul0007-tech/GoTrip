# from django.contrib import admin
# from django.db.models import Sum, Count
# from django.db.models.functions import TruncMonth
# import json
# from django.utils import timezone
# from users.models import User, Passenger, Driver
# from bookings.models import Booking, Location
# from vehicles.models import Vehicle, VehicleType, FuelType
# from payments.models import Payment

# class CustomAdminSite(admin.AdminSite):
#     site_header = 'GoTrip Administration'
#     site_title = 'GoTrip Admin Portal'
#     index_title = 'Dashboard'
    
#     def index(self, request, extra_context=None):
#         # Add stats to context
#         extra_context = extra_context or {}
        
#         # Basic stats
#         extra_context['users_count'] = User.objects.count()
#         extra_context['passengers_count'] = Passenger.objects.count()
#         extra_context['drivers_count'] = Driver.objects.count()
#         extra_context['bookings_count'] = Booking.objects.count()
        
#         # Payment stats
#         total_earnings = Payment.objects.filter(status='completed').aggregate(Sum('amount'))['amount__sum']
#         extra_context['total_earnings'] = total_earnings or 0
        
#         # Recent bookings
#         extra_context['recent_bookings'] = Booking.objects.all().order_by('-created_at')[:5]
        
#         # Monthly earnings data
#         monthly_earnings = Payment.objects.filter(status='completed').annotate(
#             month=TruncMonth('created_at')
#         ).values('month').annotate(
#             total=Sum('amount')
#         ).order_by('month')
        
#         months = [item['month'].strftime('%b %Y') if item['month'] else '' for item in monthly_earnings]
#         earnings_data = [float(item['total']) if item['total'] else 0 for item in monthly_earnings]
        
#         extra_context['months'] = json.dumps(months)
#         extra_context['earnings_data'] = json.dumps(earnings_data)
        
#         # User registrations data
#         monthly_users = User.objects.annotate(
#             month=TruncMonth('date_joined')
#         ).values('month').annotate(
#             count=Count('id')
#         ).order_by('month')
        
#         user_months = [item['month'].strftime('%b %Y') if item['month'] else '' for item in monthly_users]
#         user_counts = [item['count'] for item in monthly_users]
        
#         extra_context['user_months'] = json.dumps(user_months)
#         extra_context['user_counts'] = json.dumps(user_counts)
        
#         # Vehicle type data
#         vehicle_types = Vehicle.objects.values('vehicle_type__name').annotate(count=Count('id'))
#         vehicle_type_labels = [item['vehicle_type__name'] for item in vehicle_types]
#         vehicle_type_data = [item['count'] for item in vehicle_types]
        
#         extra_context['vehicle_type_labels'] = json.dumps(vehicle_type_labels)
#         extra_context['vehicle_type_data'] = json.dumps(vehicle_type_data)
        
#         return super().index(request, extra_context)

# # Create a custom admin site instance
# admin_site = CustomAdminSite(name='admin')

# # Import the admin classes from your apps
# from users.admin import PassengerAdmin, DriverAdmin, VehicleAdmin, VehicleTypeAdmin, FuelTypeAdmin, PaymentAdmin
# from bookings.admin import BookingAdmin, LocationAdmin
# # from vehicles.admin import VehicleAdmin, VehicleTypeAdmin, FuelTypeAdmin
# # from payments.admin import PaymentAdmin

# # Register with the custom admin site
# admin_site.register(Passenger, PassengerAdmin)
# admin_site.register(Driver, DriverAdmin)
# admin_site.register(Location, LocationAdmin)
# admin_site.register(Booking, BookingAdmin)
# admin_site.register(Vehicle, VehicleAdmin)
# admin_site.register(VehicleType, VehicleTypeAdmin)
# admin_site.register(FuelType, FuelTypeAdmin)
# admin_site.register(Payment, PaymentAdmin)


# from django.contrib.admin.views.decorators import staff_member_required
# from django.template.response import TemplateResponse
# from django.contrib import admin
# from users.models import User, Passenger, Driver
# from bookings.models import Booking
# from vehicles.models import Vehicle, VehicleType
# from payments.models import Payment
# from django.db.models import Sum, Count
# import json
# from django.utils import timezone
# from datetime import timedelta
# from django.db.models.functions import TruncMonth

# class CustomAdminSite(admin.AdminSite):
#     site_header = 'GoTrip Administration'
#     site_title = 'GoTrip Admin Portal'
#     index_title = 'Dashboard'
    
#     def index(self, request, extra_context=None):
#         # Add all the stats data here similar to dashboard view
#         extra_context = extra_context or {}
        
#         # User stats
#         extra_context['users_count'] = User.objects.count()
#         extra_context['passengers_count'] = Passenger.objects.count()
#         extra_context['drivers_count'] = Driver.objects.count()
        
#         # Booking stats
#         extra_context['bookings_count'] = Booking.objects.count()
        
#         # Payment stats
#         total_earnings = Payment.objects.filter(status='completed').aggregate(Sum('amount'))['amount__sum']
#         extra_context['total_earnings'] = total_earnings or 0
        
#         # Vehicle type data
#         vehicle_types = Vehicle.objects.values('vehicle_type__name').annotate(count=Count('id'))
#         vehicle_type_labels = [item['vehicle_type__name'] for item in vehicle_types]
#         vehicle_type_data = [item['count'] for item in vehicle_types]
        
#         # Convert to JSON for template
#         extra_context['vehicle_type_labels'] = json.dumps(vehicle_type_labels)
#         extra_context['vehicle_type_data'] = json.dumps(vehicle_type_data)
        
#         # Monthly earnings data
#         monthly_earnings = Payment.objects.filter(status='completed').annotate(
#             month=TruncMonth('created_at')
#         ).values('month').annotate(
#             total=Sum('amount')
#         ).order_by('month')
        
#         months = [item['month'].strftime('%b %Y') if item['month'] else '' for item in monthly_earnings]
#         earnings_data = [float(item['total']) if item['total'] else 0 for item in monthly_earnings]
        
#         extra_context['months'] = json.dumps(months)
#         extra_context['earnings_data'] = json.dumps(earnings_data)
        
#         # User registrations data
#         monthly_users = User.objects.annotate(
#             month=TruncMonth('date_joined')
#         ).values('month').annotate(
#             count=Count('id')
#         ).order_by('month')
        
#         user_months = [item['month'].strftime('%b %Y') if item['month'] else '' for item in monthly_users]
#         user_counts = [item['count'] for item in monthly_users]
        
#         extra_context['user_months'] = json.dumps(user_months)
#         extra_context['user_counts'] = json.dumps(user_counts)
        
#         # Add recent bookings
#         extra_context['recent_bookings'] = Booking.objects.all().order_by('-created_at')[:10]
        
#         return super().index(request, extra_context)
    
#     def each_context(self, request):
#         context = super().each_context(request)
#         context['has_permission'] = request.user.is_active and request.user.is_staff
#         return context

# # Replace the default admin site
# admin_site = CustomAdminSite(name='admin')



