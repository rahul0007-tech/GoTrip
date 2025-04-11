# from jet.dashboard import modules
# from jet.dashboard.dashboard import Dashboard

# class CustomDashboard(Dashboard):
#     columns = 3
    
#     def init_with_context(self, context):
#         # Column 1 - User Management
#         self.children.append(modules.ModelList(
#             title='User Management',
#             models=(
#                 'users.models.Passenger',
#                 'users.models.Driver',
#                 'auth.models.Group',
#             ),
#             column=0,
#             order=0
#         ))
        
#         # Column 2 - Operations
#         self.children.append(modules.ModelList(
#             title='Bookings',
#             models=(
#                 'bookings.models.Booking',
#                 'bookings.models.Location',
#             ),
#             column=1,
#             order=0
#         ))
        
#         self.children.append(modules.ModelList(
#             title='Vehicles',
#             models=(
#                 'vehicles.models.Vehicle',
#                 'vehicles.models.VehicleType',
#                 'vehicles.models.FuelType',
#             ),
#             column=1,
#             order=1
#         ))
        
#         # Column 3 - Payment & Activity
#         self.children.append(modules.ModelList(
#             title='Payments',
#             models=(
#                 'payments.models.Payment',
#             ),
#             column=2,
#             order=0
#         ))
        
#         self.children.append(modules.RecentActions(
#             title='Recent Actions',
#             limit=10,
#             column=2,
#             order=1
#         ))
        
#         # Quick access links
#         self.children.append(modules.LinkList(
#             title='Quick Actions',
#             children=[
#                 {
#                     'title': 'New Booking',
#                     'url': '/admin/bookings/booking/add/',
#                     'external': False,
#                 },
#                 {
#                     'title': 'Add New Driver',
#                     'url': '/admin/users/driver/add/',
#                     'external': False,
#                 },
#                 {
#                     'title': 'Register Vehicle',
#                     'url': '/admin/vehicles/vehicle/add/',
#                     'external': False,
#                 },
#                 {
#                     'title': 'Add Location',
#                     'url': '/admin/bookings/location/add/',
#                     'external': False,
#                 },
#             ],
#             column=0,
#             order=1
#         ))

from jet.dashboard import modules
from jet.dashboard.dashboard import Dashboard
from django.db.models import Count, Sum
from django.db.models.functions import TruncDate
from datetime import datetime, timedelta
import json

# Import your models
from bookings.models import Booking, Location
from vehicles.models import Vehicle, VehicleType, FuelType
from users.models import Passenger, Driver
from payments.models import Payment

class CustomDashboard(Dashboard):
    columns = 3
    
    def init_with_context(self, context):
        # Column 1 - User Management & Charts
        self.children.append(modules.ModelList(
            title='User Management',
            models=(
                'users.models.Passenger',
                'users.models.Driver',
                'auth.models.Group',
            ),
            column=0,
            order=0
        ))
        
        # Add a pie chart for Vehicle Types
        self.children.append(modules.DoughnutChart(
            title='Vehicle Distribution by Type',
            value_list=[
                {'value': Vehicle.objects.filter(vehicle_type__name=vt.name).count(), 'label': vt.display_name}
                for vt in VehicleType.objects.all()
            ],
            column=0,
            order=1
        ))
        
        # Key statistics
        self.children.append(modules.LinkList(
            title='Key Statistics',
            children=[
                {'title': f'Total Passengers: {Passenger.objects.count()}'},
                {'title': f'Total Drivers: {Driver.objects.count()}'},
                {'title': f'Active Bookings: {Booking.objects.filter(status="confirmed").count()}'},
                {'title': f'Completed Trips: {Booking.objects.filter(status="completed").count()}'},
                {'title': f'Total Revenue: ${Payment.objects.filter(status="completed").aggregate(Sum("amount"))["amount__sum"] or 0}'},
            ],
            column=0,
            order=2
        ))
        
        # Column 2 - Operations & Bar Chart
        self.children.append(modules.ModelList(
            title='Bookings',
            models=(
                'bookings.models.Booking',
                'bookings.models.Location',
            ),
            column=1,
            order=0
        ))
        
        # Add bar chart for booking status
        booking_status_data = Booking.objects.values('status').annotate(count=Count('id'))
        self.children.append(modules.BarChart(
            title='Bookings by Status',
            values=[
                {
                    'group': 'Status',
                    'items': [
                        {'label': status['status'].capitalize(), 'value': status['count']}
                        for status in booking_status_data
                    ]
                }
            ],
            column=1,
            order=1
        ))
        
        # Vehicle models list
        self.children.append(modules.ModelList(
            title='Vehicles',
            models=(
                'vehicles.models.Vehicle',
                'vehicles.models.VehicleType',
                'vehicles.models.FuelType',
            ),
            column=1,
            order=2
        ))
        
        # Column 3 - Line Chart & Activity
        # Line chart for bookings over time (last 30 days)
        thirty_days_ago = datetime.now() - timedelta(days=30)
        booking_trend = Booking.objects.filter(
            created_at__gte=thirty_days_ago
        ).annotate(
            date=TruncDate('created_at')
        ).values('date').annotate(
            count=Count('id')
        ).order_by('date')
        
        self.children.append(modules.LineChart(
            title='Booking Trend (Last 30 Days)',
            values=[
                {
                    'label': 'Bookings', 
                    'data': [
                        {'x': item['date'].strftime('%Y-%m-%d'), 'y': item['count']}
                        for item in booking_trend
                    ]
                }
            ],
            column=2,
            order=0
        ))
        
        # Payment models list
        self.children.append(modules.ModelList(
            title='Payments',
            models=(
                'payments.models.Payment',
            ),
            column=2,
            order=1
        ))
        
        # Recent actions
        self.children.append(modules.RecentActions(
            title='Recent Actions',
            limit=10,
            column=2,
            order=2
        ))
        
        # Quick access links
        self.children.append(modules.LinkList(
            title='Quick Actions',
            children=[
                {
                    'title': 'New Booking',
                    'url': '/admin/bookings/booking/add/',
                    'external': False,
                },
                {
                    'title': 'Add New Driver',
                    'url': '/admin/users/driver/add/',
                    'external': False,
                },
                {
                    'title': 'Register Vehicle',
                    'url': '/admin/vehicles/vehicle/add/',
                    'external': False,
                },
                {
                    'title': 'Add Location',
                    'url': '/admin/bookings/location/add/',
                    'external': False,
                },
            ],
            column=2,
            order=3
        ))