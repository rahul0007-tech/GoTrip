from django.contrib import admin
from django.utils import timezone
from django.db.models import Sum, Count
from django.shortcuts import render
from bookings.models import Booking
from users.models import Driver, Passenger
from payments.models import Payment, OrderStatus
from datetime import timedelta
from vehicles.models import Vehicle
from django.utils.translation import gettext_lazy as _
from django.contrib.auth import get_user_model

User = get_user_model()

def admin_dashboard(request):
    # Get the current date and the start of last week/month
    today = timezone.now().date()
    week_ago = today - timedelta(days=7)
    month_ago = today - timedelta(days=30)

    # Calculate total rides and trend
    total_rides = Booking.objects.count()
    last_week_rides = Booking.objects.filter(created_at__date__gte=week_ago).count()
    prev_week_rides = Booking.objects.filter(
        created_at__date__lt=week_ago,
        created_at__date__gte=week_ago - timedelta(days=7)
    ).count()
    ride_trend = (
        ((last_week_rides - prev_week_rides) / prev_week_rides * 100)
        if prev_week_rides > 0 else 0
    )

    # Calculate active drivers and trend
    active_drivers = Driver.objects.filter(vehicle__isnull=False).count()
    new_drivers_this_month = Driver.objects.filter(Created_at__date__gte=month_ago).count()
    new_drivers_prev_month = Driver.objects.filter(
        Created_at__date__lt=month_ago,
        Created_at__date__gte=month_ago - timedelta(days=30)
    ).count()
    driver_trend = (
        ((new_drivers_this_month - new_drivers_prev_month) / new_drivers_prev_month * 100)
        if new_drivers_prev_month > 0 else 0
    )

    # Calculate registered users and trend
    registered_users = User.objects.count()
    new_users_this_month = User.objects.filter(date_joined__date__gte=month_ago).count()
    new_users_prev_month = User.objects.filter(
        date_joined__date__lt=month_ago,
        date_joined__date__gte=month_ago - timedelta(days=30)
    ).count()
    user_trend = (
        ((new_users_this_month - new_users_prev_month) / new_users_prev_month * 100)
        if new_users_prev_month > 0 else 0
    )

    # Calculate revenue and trend
    total_revenue = Payment.objects.filter(status=OrderStatus.COMPLETED).aggregate(
        total=Sum('amount')
    )['total'] or 0
    this_month_revenue = Payment.objects.filter(
        status=OrderStatus.COMPLETED,
        created_at__date__gte=month_ago
    ).aggregate(total=Sum('amount'))['total'] or 0
    prev_month_revenue = Payment.objects.filter(
        status=OrderStatus.COMPLETED,
        created_at__date__lt=month_ago,
        created_at__date__gte=month_ago - timedelta(days=30)
    ).aggregate(total=Sum('amount'))['total'] or 0
    revenue_trend = (
        ((this_month_revenue - prev_month_revenue) / prev_month_revenue * 100)
        if prev_month_revenue > 0 else 0
    )

    context = {
        'total_rides': total_rides,
        'active_drivers': active_drivers,
        'registered_users': registered_users,
        'revenue_formatted': f"${total_revenue:,.2f}",
        'ride_trend': round(ride_trend),
        'driver_trend': round(driver_trend),
        'user_trend': round(user_trend),
        'revenue_trend': round(revenue_trend),
        'title': 'Dashboard'
    }

    return context

class CustomAdminSite(admin.AdminSite):
    site_header = 'GoTrip Administration'
    site_title = 'GoTrip Admin Portal'
    index_title = 'Dashboard'

    def index(self, request, extra_context=None):
        if not request.user.is_staff:
            return self.login(request)
            
        # Get dashboard stats
        extra_context = extra_context or {}
        extra_context.update(admin_dashboard(request))
        return super().index(request, extra_context=extra_context)

# Create the admin site first
admin_site = CustomAdminSite(name='admin')

# Replace the default admin site immediately
admin.site = admin_site

# Now import all the admin classes and models
from bookings.admin import LocationAdmin, BookingAdmin
from bookings.models import Location, Booking
from users.admin import PassengerAdmin, DriverAdmin
from users.models import Passenger, Driver
from vehicles.admin import VehicleAdmin, VehicleTypeAdmin, FuelTypeAdmin
from vehicles.models import Vehicle, VehicleType, FuelType
from payments.admin import PaymentAdmin
from payments.models import Payment

# Register all models with our admin site
admin_site.register(Location, LocationAdmin)
admin_site.register(Booking, BookingAdmin)
admin_site.register(Passenger, PassengerAdmin)
admin_site.register(Driver, DriverAdmin)
admin_site.register(Vehicle, VehicleAdmin)
admin_site.register(VehicleType, VehicleTypeAdmin)
admin_site.register(FuelType, FuelTypeAdmin)
admin_site.register(Payment, PaymentAdmin)