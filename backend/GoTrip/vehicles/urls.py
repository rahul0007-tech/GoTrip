from django.urls import path
from .views import AddVehicleView, GetDriversByVehicleTypeView, ShowFuelTypeView, ShowVehicleTypeView,GetVehiclesCategoryView

app_name='vehicles'

urlpatterns = [
    path('add-vehicle/', AddVehicleView.as_view(), name = 'addVehicle'),
    path('fuel-types/', ShowFuelTypeView.as_view(), name='fuelType'),
    path('vehicle-types/', ShowVehicleTypeView.as_view(), name='vehicleType'),
    path('vehicle-types-for-passenger/', GetVehiclesCategoryView.as_view(), name='vehicleTypePassenger'),
    path('drivers-by-vehicle-type/', GetDriversByVehicleTypeView.as_view(), name='DriverDetail'),

]
