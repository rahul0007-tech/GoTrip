from django.urls import path
from .views import CreateBookingView,AcceptBookingView,GetAcceptedDriversView,SelectDriverView

app_name = 'bookings'



urlpatterns = [
    path('createbooking/', CreateBookingView.as_view(), name = 'createBooking'),
    path('accept-booking/', AcceptBookingView.as_view(), name='accept-booking'),
    path('accepted-drivers/', GetAcceptedDriversView.as_view(), name='accepted-drivers'),
    path('select-driver/', SelectDriverView.as_view(), name='select-driver'),

]