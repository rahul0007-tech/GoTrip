from django.db import models
from datetime import datetime


class Passenger(models.Model):
    passengerName = models.CharField(max_length=20)
    passengerPhone = models.IntegerField()
    passengerEmail = models.EmailField(unique=True)
    passengerPassword = models.CharField(max_length=150)
    passengerPhoto = models.ImageField(upload_to='passengers', blank=True)
    passengerOtp = models.CharField(max_length=5, null=True, blank=True)
    passengerVerified = models.BooleanField(default=False)
    Created_at = models.DateTimeField(datetime.now())

    def __str__(self):
        return self.passengerName
    


class Driver (models.Model):
    status = [('busy', "busy"), ('free', "free")]
    driverName=models.CharField(max_length=50)
    driverEmail = models.EmailField()
    driverPhoneNumber = models.IntegerField()
    lisenceImage = models.ImageField(upload_to='lisence')
    driverPassword = models.CharField(max_length=150)
    driverStatus = models.CharField(max_length=5,choices=status)
    driverVerification = models.BooleanField(default=False)

    def __str__(self):
        return self.driverName


class Vehicle(models.Model):
    relation = models.OneToOneField(Driver, on_delete=models.CASCADE, related_name='vehicle')
    type = [('Suv', "Suv"), ('Sedan', "Sedan"), ('Hatchback', "Hatchback"), ('4X4', "4X4"), ('PickUp', "Pickup")]
    fuelType = [('Diesel', "Diesel"),('Petrol',"Petrol"),('Electric',"Electric")]
    vehicleColor = models.CharField(max_length=30)
    vehicleCompany = models.CharField(max_length=50) 
    vehicleType = models.CharField(max_length=20, choices=type)
    vehicleFuelType = models.CharField(max_length=20, choices=fuelType)
    vehicleNumber = models.CharField(max_length=20)

    # driverId

class Image(models.Model):
    relation = models.ForeignKey(Vehicle, on_delete=models.CASCADE, related_name='image')
    image = models.ImageField(upload_to='VehicleImages')



