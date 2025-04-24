# from jet.dashboard import modules
# from jet.dashboard.dashboard import Dashboard, AppIndexDashboard
# from django.db.models import Count, Sum
# from django.db.models.functions import TruncDate, TruncMonth
# from datetime import datetime, timedelta
# import json

# # Import your models
# from bookings.models import Booking, Location
# from vehicles.models import Vehicle, VehicleType, FuelType
# from users.models import Passenger, Driver
# from payments.models import Payment

# class CustomDashboard(Dashboard):
#     def __init__(self, context=None, **kwargs):
#         super().__init__(context=context, **kwargs)
#         self.children = []  # Initialize empty children list

#     def init_with_context(self, context):
#         # Column 1 - Key Statistics
#         total_earnings = Payment.objects.filter(status="completed").aggregate(Sum("amount"))["amount__sum"] or 0
#         active_bookings = Booking.objects.filter(status="confirmed").count()
#         completed_bookings = Booking.objects.filter(status="completed").count()
        
#         self.children.append(modules.LinkList(
#             title='Key Statistics',
#             children=[
#                 {'title': f'Total Passengers: {Passenger.objects.count()}'},
#                 {'title': f'Total Drivers: {Driver.objects.count()}'},
#                 {'title': f'Total Locations: {Location.objects.count()}'},
#                 {'title': f'Active Bookings: {active_bookings}'},
#                 {'title': f'Completed Trips: {completed_bookings}'},
#                 {'title': f'Total Revenue: Rs.{total_earnings:,.2f}'},
#             ],
#             column=0,
#             order=0
#         ))
        
#         # Vehicle distribution stats
#         vehicle_stats = []
#         for vt in VehicleType.objects.all():
#             count = Vehicle.objects.filter(vehicle_type__name=vt.name).count()
#             vehicle_stats.append({'title': f'{vt.display_name}: {count} vehicles'})

#         self.children.append(modules.LinkList(
#             title='Vehicle Distribution by Type',
#             children=vehicle_stats,
#             column=0,
#             order=1
#         ))
        
#         # Column 2 - Recent Bookings
#         self.children.append(modules.RecentActions(
#             title='Recent Bookings',
#             limit=10,
#             include_list=['bookings.booking'],
#             column=1,
#             order=0
#         ))
        
#         # Column 2 - Recent Passenger Registrations
#         self.children.append(modules.RecentActions(
#             title='Recent Passenger Registrations',
#             limit=10,
#             include_list=['users.passenger'],
#             column=1,
#             order=1
#         ))
        
#         # Column 3 - Recent Driver Registrations
#         self.children.append(modules.RecentActions(
#             title='Recent Driver Registrations',
#             limit=10,
#             include_list=['users.driver'],
#             column=2,
#             order=0
#         ))
        
#         # Column 3 - Recent Payments
#         self.children.append(modules.RecentActions(
#             title='Recent Payments',
#             limit=10,
#             include_list=['payments.payment'],
#             column=2,
#             order=1
#         ))


# from jet.dashboard import modules
# from jet.dashboard.dashboard import Dashboard
# from django.db.models import Count, Sum
# from django.db.models.functions import TruncDate, TruncMonth
# from datetime import datetime, timedelta

# from bookings.models import Booking, Location
# from vehicles.models import Vehicle, VehicleType, FuelType
# from users.models import Passenger, Driver
# from payments.models import Payment

# class CustomDashboard(Dashboard):
#     columns = 3
    
#     def __init__(self, context=None, **kwargs):
#         super().__init__(context=context, **kwargs)
#         self.children = []  # Initialize empty children list
    
#     def init_with_context(self, context):
#         # Calculate key stats
#         passengers_count = Passenger.objects.count()
#         drivers_count = Driver.objects.count()
#         locations_count = Location.objects.count()
#         active_bookings = Booking.objects.filter(status="confirmed").count()
#         completed_bookings = Booking.objects.filter(status="completed").count()
#         total_earnings = Payment.objects.filter(status="completed").aggregate(Sum("amount"))["amount__sum"] or 0
        
#         # Add to context so we can access directly in template
#         context['dashboard_stats'] = {
#             'passengers_count': passengers_count,
#             'drivers_count': drivers_count,
#             'locations_count': locations_count,
#             'active_bookings': active_bookings,
#             'completed_bookings': completed_bookings,
#             'total_earnings': total_earnings,
#         }
        
#         # Vehicle distribution stats
#         vehicle_stats = []
#         for vt in VehicleType.objects.all():
#             count = Vehicle.objects.filter(vehicle_type__name=vt.name).count()
#             vehicle_stats.append({
#                 'type': vt.display_name,
#                 'count': count
#             })
#         context['vehicle_stats'] = vehicle_stats
        
#         # Still define modules for completeness
#         self.children.append(modules.LinkList(
#             title='Key Statistics',
#             children=[
#                 {'title': f'Total Passengers: {passengers_count}', 'url': '/admin/users/passenger/'},
#                 {'title': f'Total Drivers: {drivers_count}', 'url': '/admin/users/driver/'},
#                 {'title': f'Total Locations: {locations_count}', 'url': '/admin/bookings/location/'},
#                 {'title': f'Active Bookings: {active_bookings}', 'url': '/admin/bookings/booking/'},
#                 {'title': f'Completed Trips: {completed_bookings}', 'url': '/admin/bookings/booking/'},
#                 {'title': f'Total Revenue: Rs.{total_earnings:,.2f}', 'url': '/admin/payments/payment/'},
#             ],
#             column=0,
#             order=0
#         ))