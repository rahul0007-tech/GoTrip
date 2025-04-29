from django.urls import path
from .views import (
    ChangeDriverStatusView, ChnagePasswordView, CreatePassengerView, 
     LoginPassengerView, 
    PassengerProfileView, ResendOTPView, SendPasswordEmailView, 
    VerifyOTPView, CreateDriverView, LoginDriverView, DriverProfileView
)

app_name = 'users'

urlpatterns = [
    path('passenger/', CreatePassengerView.as_view(), name='CreatePassenger'),
    path('driver/', CreateDriverView.as_view(), name='CreateDriver'),
    path('verify/', VerifyOTPView.as_view(), name='verify'),
    path('passengerLogin/', LoginPassengerView.as_view(), name='passengerLogin'),
    path('driverlogin/',LoginDriverView.as_view(), name='driverLogin'),
    path('passengerprofile/', PassengerProfileView.as_view(), name='passengerprofile'),  
    path('change-password/',ChnagePasswordView.as_view(), name='changepassengerpassword'),
    # path('forgot-password/', ForgotPasswordView.as_view(), name='forgot-password'),
    # path('reset-password/', PasswordResetView.as_view(), name='reset-password'),
    path('driverprofile/', DriverProfileView.as_view(), name='driverprofile'),
    path('driverstatus/', ChangeDriverStatusView.as_view(), name='driverstatus'),
    path('resend-otp/', ResendOTPView.as_view(), name='resend-otp'),
]
