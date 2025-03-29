from django.db import models
from users.models import Driver

class VehicleType(models.Model):
    name = models.CharField(max_length=50, unique=True)
    display_name = models.CharField(max_length=50)
    
    def __str__(self):
        return self.display_name


class FuelType(models.Model):
    name = models.CharField(max_length=50, unique=True)
    display_name = models.CharField(max_length=50)
    
    def __str__(self):
        return self.display_name


class Vehicle(models.Model):
    driver = models.OneToOneField(Driver, on_delete=models.CASCADE, related_name='vehicle')
    vehicle_color = models.CharField(max_length=30)
    vehicle_company = models.CharField(max_length=50)
    vehicle_type = models.ForeignKey(VehicleType, on_delete=models.PROTECT, related_name='vehicles')
    vehicle_fuel_type = models.ForeignKey(FuelType, on_delete=models.PROTECT, related_name='vehicles')
    vehicle_number = models.CharField(max_length=20)
    sitting_capacity = models.IntegerField()

    def __str__(self):
        return f"{self.vehicle_company} - {self.vehicle_number}"
    

class VehicleImage(models.Model):
    vehicle = models.ForeignKey(Vehicle, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='vehicle_images/', null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"Image for {self.vehicle}"