from django.urls import path
from .views import AddVehicleView, ShowFuelTypeView, ShowVehicleTypeView

app_name='vehicles'

urlpatterns = [
    path('add-vehicle/', AddVehicleView.as_view(), name = 'addVehicle'),
    path('fuel-types/', ShowFuelTypeView.as_view(), name='fuelType'),
    path('vehicle-types/', ShowVehicleTypeView.as_view(), name='vehicleType')

]
