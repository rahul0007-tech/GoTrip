from django.urls import path
from .views import ChangeBookingStatus, CreateBookingView,AcceptBookingView, DriverTotalEarningsView, DriverUpcommingBookingsView,GetAcceptedDriversView, GetBookingByLoacation, GetLocation, PassengerBookingHistory, PassengerUpcommingBookingsView,SelectDriverView,GetAvailableBookingView, ShowBookingLocationView, DriverBookingHistory

app_name = 'bookings'



urlpatterns = [
    path('createbooking/', CreateBookingView.as_view(), name = 'createBooking'),
    path('accept-booking/', AcceptBookingView.as_view(), name='accept-booking'),
    path('accepted-drivers/', GetAcceptedDriversView.as_view(), name='accepted-drivers'),
    path('select-driver/', SelectDriverView.as_view(), name='select-driver'),
    path('available-booking/', GetAvailableBookingView.as_view(), name='available-booking'),
    path('locations/', ShowBookingLocationView.as_view(), name='booking-locations'),
    path('search-location/', GetLocation.as_view(), name='booking-location-detail'),
    path('booking-by-location/', GetBookingByLoacation.as_view(), name='booking-by-location-detail'),
    path('driverupcommingbooking/', DriverUpcommingBookingsView.as_view(), name='driverupcommingbooking'),
    path('changebookingstatus/', ChangeBookingStatus.as_view(), name='changebookingtatus' ),
    path('driverbookinghistory/', DriverBookingHistory.as_view(), name='driverbookinghistory'),
    path('passengerupcomingbookings/', PassengerUpcommingBookingsView.as_view(), name='passengerupcomingbookings'),
    path('passengerbookinghistory/', PassengerBookingHistory.as_view(), name='passengerbookinghistory'),
    path('drivertotalearnings/', DriverTotalEarningsView.as_view(), name='drivertotalearnings'),


]