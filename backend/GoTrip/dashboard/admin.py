from django.contrib.admin.views.decorators import staff_member_required
from django.utils import timezone
from django.db.models import Sum, Count
from django.shortcuts import render
from bookings.models import Booking
from users.models import Driver, Passenger, User
from payments.models import Payment
from datetime import timedelta

# @staff_member_required
# def admin_dashboard(request):
#     # Get current date and time
#     now = timezone.now()
    
#     # Calculate date ranges for trends
#     week_ago = now - timedelta(days=7)
#     month_ago = now - timedelta(days=30)
#     two_weeks_ago = now - timedelta(days=14)
#     two_months_ago = now - timedelta(days=60)
    
#     # Total rides
#     total_rides = Booking.objects.count()
#     rides_last_week = Booking.objects.filter(created_at__gte=week_ago).count()
#     rides_previous_week = Booking.objects.filter(
#         created_at__gte=two_weeks_ago, 
#         created_at__lt=week_ago
#     ).count()
    
#     # Calculate ride trend
#     ride_trend = 0
#     if rides_previous_week > 0:
#         ride_trend = int(((rides_last_week - rides_previous_week) / rides_previous_week) * 100)
    
#     # Active drivers
#     active_drivers = Driver.objects.filter(status='free').count()
#     drivers_this_month = Driver.objects.filter(Created_at__gte=month_ago).count()
#     drivers_last_month = Driver.objects.filter(
#         Created_at__gte=two_months_ago, 
#         Created_at__lt=month_ago
#     ).count()
    
#     # Calculate driver trend
#     driver_trend = 0
#     if drivers_last_month > 0:
#         driver_trend = int(((drivers_this_month - drivers_last_month) / drivers_last_month) * 100)
    
#     # Registered users
#     registered_users = Passenger.objects.count()
#     users_this_month = Passenger.objects.filter(Created_at__gte=month_ago).count()
#     users_last_month = Passenger.objects.filter(
#         Created_at__gte=two_months_ago, 
#         Created_at__lt=month_ago
#     ).count()
    
#     # Calculate user trend
#     user_trend = 0
#     if users_last_month > 0:
#         user_trend = int(((users_this_month - users_last_month) / users_last_month) * 100)
    
#     # Revenue
#     total_revenue = Payment.objects.filter(status='completed').aggregate(Sum('amount'))
#     revenue = total_revenue['amount__sum'] or 0
#     revenue_formatted = f"${revenue:,.2f}"
    
#     # Revenue trend
#     revenue_this_month = Payment.objects.filter(
#         status='completed', 
#         created_at__gte=month_ago
#     ).aggregate(Sum('amount'))
#     revenue_this_month = revenue_this_month['amount__sum'] or 0
    
#     revenue_last_month = Payment.objects.filter(
#         status='completed', 
#         created_at__gte=two_months_ago,
#         created_at__lt=month_ago
#     ).aggregate(Sum('amount'))
#     revenue_last_month = revenue_last_month['amount__sum'] or 0
    
#     # Calculate revenue trend
#     revenue_trend = 0
#     if revenue_last_month > 0:
#         revenue_trend = int(((revenue_this_month - revenue_last_month) / revenue_last_month) * 100)
    
#     # Create context with all the statistics
#     context = {
#         'total_rides': total_rides,
#         'active_drivers': active_drivers,
#         'registered_users': registered_users,
#         'revenue_formatted': revenue_formatted,
#         'ride_trend': ride_trend,
#         'driver_trend': driver_trend,
#         'user_trend': user_trend,
#         'revenue_trend': revenue_trend,
#     }
    
#     # Add this context to the default admin index view
#     return context

@staff_member_required
def admin_dashboard(request):
    # Get current date and time
    now = timezone.now()
    
    # Calculate date ranges for trends
    week_ago = now - timedelta(days=7)
    month_ago = now - timedelta(days=30)
    two_weeks_ago = now - timedelta(days=14)
    two_months_ago = now - timedelta(days=60)
    
    # Total rides
    total_rides = Booking.objects.count()
    rides_last_week = Booking.objects.filter(created_at__gte=week_ago).count()
    rides_previous_week = Booking.objects.filter(
        created_at__gte=two_weeks_ago, 
        created_at__lt=week_ago
    ).count()
    
    # Calculate ride trend with error handling
    try:
        ride_trend = int(((rides_last_week - rides_previous_week) / rides_previous_week) * 100) if rides_previous_week > 0 else 0
    except:
        ride_trend = 0
    
    # Active drivers - fix field name if needed
    try:
        # Try both created_at and Created_at
        active_drivers = Driver.objects.filter(status='free').count()
        drivers_this_month = Driver.objects.filter(Created_at__gte=month_ago).count()
        drivers_last_month = Driver.objects.filter(
            Created_at__gte=two_months_ago, 
            Created_at__lt=month_ago
        ).count()
    except:
        try:
            # Alternative field name
            active_drivers = Driver.objects.filter(status='free').count()
            drivers_this_month = Driver.objects.filter(created_at__gte=month_ago).count()
            drivers_last_month = Driver.objects.filter(
                created_at__gte=two_months_ago, 
                created_at__lt=month_ago
            ).count()
        except:
            # Default values if queries fail
            active_drivers = 0
            drivers_this_month = 0
            drivers_last_month = 0
    
    # Calculate driver trend with error handling
    try:
        driver_trend = int(((drivers_this_month - drivers_last_month) / drivers_last_month) * 100) if drivers_last_month > 0 else 0
    except:
        driver_trend = 0
    
    # Similar fixes for registered users - check field names
    try:
        registered_users = Passenger.objects.count()
        users_this_month = Passenger.objects.filter(Created_at__gte=month_ago).count()
        users_last_month = Passenger.objects.filter(
            Created_at__gte=two_months_ago, 
            Created_at__lt=month_ago
        ).count()
    except:
        try:
            # Alternative field name
            registered_users = Passenger.objects.count()
            users_this_month = Passenger.objects.filter(created_at__gte=month_ago).count()
            users_last_month = Passenger.objects.filter(
                created_at__gte=two_months_ago, 
                created_at__lt=month_ago
            ).count()
        except:
            # Default values if queries fail
            registered_users = 0
            users_this_month = 0
            users_last_month = 0
    
    # Calculate user trend with error handling
    try:
        user_trend = int(((users_this_month - users_last_month) / users_last_month) * 100) if users_last_month > 0 else 0
    except:
        user_trend = 0
    
    # Revenue with error handling
    try:
        total_revenue = Payment.objects.filter(status='completed').aggregate(Sum('amount'))
        revenue = total_revenue['amount__sum'] or 0
    except:
        revenue = 0
        
    revenue_formatted = f"${revenue:,.2f}"
    
    # Revenue trend with error handling
    try:
        revenue_this_month = Payment.objects.filter(
            status='completed', 
            created_at__gte=month_ago
        ).aggregate(Sum('amount'))
        revenue_this_month = revenue_this_month['amount__sum'] or 0
        
        revenue_last_month = Payment.objects.filter(
            status='completed', 
            created_at__gte=two_months_ago,
            created_at__lt=month_ago
        ).aggregate(Sum('amount'))
        revenue_last_month = revenue_last_month['amount__sum'] or 0
        
        revenue_trend = int(((revenue_this_month - revenue_last_month) / revenue_last_month) * 100) if revenue_last_month > 0 else 0
    except:
        revenue_trend = 0
    
    # Print debug info - this will show in your console when the function runs
    print(f"Debug - Total rides: {total_rides}, Active drivers: {active_drivers}, Users: {registered_users}, Revenue: {revenue_formatted}")
    
    # Create context with all the statistics
    context = {
        'title': 'GoTrip Dashboard',  # Add a title for your dashboard
        'total_rides': total_rides,
        'active_drivers': active_drivers,
        'registered_users': registered_users,
        'revenue_formatted': revenue_formatted,
        'ride_trend': ride_trend,
        'driver_trend': driver_trend,
        'user_trend': user_trend,
        'revenue_trend': revenue_trend,
    }
    
    return context