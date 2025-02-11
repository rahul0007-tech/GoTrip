from django.urls import path
from .views import ChnagePasswordView, CreatePassengerView, LoginPassengerView, PassengerProfileView, LogoutView, PasswordResetView, SendPasswordEmailView, VerifyOTPView, CreateDriverView, LoginDriverView

app_name = 'users'

urlpatterns = [
    path('passenger/', CreatePassengerView.as_view(), name='CreatePassenger'),
    path('verify/', VerifyOTPView.as_view(), name='verify'),
    path('passengerLogin/', LoginPassengerView.as_view(), name='passengerLogin'),
    path('passengerprofile/', PassengerProfileView.as_view(), name='passengerprofile'),
    path('driver/', CreateDriverView.as_view(), name='CreateDriver'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('driverlogin/',LoginDriverView.as_view(), name='driverLogin'),
    path('change-password/',ChnagePasswordView.as_view(), name='changepassengerpassword' ),
    path('send-reset-password/', SendPasswordEmailView.as_view(), name='send-reset-password'),
    path('reset-password/<uid>/<token>/',PasswordResetView.as_view(), name='changepassengerpassword' ),
    
]