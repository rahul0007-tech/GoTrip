# dashboard/views.py
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from users.models import User  # Adjust based on your user model
from bookings.models import Booking
from vehicles.models import Vehicle
from payments.models import Payment  # Assuming you have this model
from django.db.models import Sum, Count
import json

@login_required
def dashboard(request):
    # Get counts
    users_count = User.objects.count()
    passengers_count = User.objects.filter(user_type='passenger').count()  # Adjust based on your model
    drivers_count = User.objects.filter(user_type='driver').count()  # Adjust based on your model
    bookings_count = Booking.objects.count()
    total_earnings = Payment.objects.aggregate(Sum('amount'))['amount__sum'] or 0
    
    # Data for vehicle type pie chart
    vehicle_types = Vehicle.objects.values('vehicle_type').annotate(count=Count('id'))
    vehicle_type_labels = [item['vehicle_type'] for item in vehicle_types]
    vehicle_type_data = [item['count'] for item in vehicle_types]
    
    # Data for monthly earnings line chart
    from django.db.models.functions import TruncMonth
    monthly_earnings = Payment.objects.annotate(
        month=TruncMonth('payment_date')
    ).values('month').annotate(
        total=Sum('amount')
    ).order_by('month')
    
    months = [item['month'].strftime('%b %Y') for item in monthly_earnings]
    earnings_data = [float(item['total']) for item in monthly_earnings]
    
    # Data for user registrations bar chart
    monthly_users = User.objects.annotate(
        month=TruncMonth('date_joined')
    ).values('month').annotate(
        count=Count('id')
    ).order_by('month')
    
    user_months = [item['month'].strftime('%b %Y') for item in monthly_users]
    user_counts = [item['count'] for item in monthly_users]
    
    context = {
        'users_count': users_count,
        'passengers_count': passengers_count,
        'drivers_count': drivers_count,
        'bookings_count': bookings_count,
        'total_earnings': total_earnings,
        
        # JSON data for charts
        'vehicle_type_labels': json.dumps(vehicle_type_labels),
        'vehicle_type_data': json.dumps(vehicle_type_data),
        'months': json.dumps(months),
        'earnings_data': json.dumps(earnings_data),
        'user_months': json.dumps(user_months),
        'user_counts': json.dumps(user_counts),
    }
    
    return render(request, 'dashboard/index.html', context)