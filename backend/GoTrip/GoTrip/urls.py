"""
URL configuration for goTrip project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from . views import CreatePassenger, VerifyOtpView, CreateDriver, DriverLoginView, PassengerLoginView, LogoutView, CreateBookingView, UpdateBookingStatusView, AcceptBookingRequestView, SelectDriverView
from django.conf import settings
from django.conf.urls.static import static
from debug_toolbar.toolbar import debug_toolbar_urls


from rest_framework_simplejwt.views import (  #Implemanting JWT
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('passenger/', CreatePassenger.as_view(), name='CreatePassenger'),
    path('login-passenger/', PassengerLoginView.as_view(), name = 'loginpassenger'), #passengerLogin/
    path('verify-otp/', VerifyOtpView.as_view(), name='verify-otp'),
    # path('profile-passenger/<int:id>', RetrivePassenger.as_view(), name = 'profile-passenger'),
    path('driver/', CreateDriver.as_view(), name='CreateDriver'),
    path('login-driver/', DriverLoginView.as_view(), name='logindriver'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('bookings/', CreateBookingView.as_view(), name='create-booking'),
    path('bookings/<int:pk>/status/', UpdateBookingStatusView.as_view(), name='update-booking-status'),
    path('bookings/<int:pk>/accept/', AcceptBookingRequestView.as_view(), name='accept-booking'),
    path('bookings/<int:pk>/select/', SelectDriverView.as_view(), name='select-driver'),
] +  static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT) 

if settings.DEBUG:
    urlpatterns += debug_toolbar_urls()

