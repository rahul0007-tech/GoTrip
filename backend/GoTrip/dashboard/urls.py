# # dashboard/urls.py
# from django.urls import path
# from . import views

# app_name = 'dashboard'

# urlpatterns = [
#     path('', views.dashboard, name='index'),
# ]

from django.urls import path
from .views import custom_admin_dashboard

app_name = 'dashboard'

urlpatterns = [
    path('', custom_admin_dashboard, name='custom_admin_dashboard'),
    # Other dashboard URLs...
]