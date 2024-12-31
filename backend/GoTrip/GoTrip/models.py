from django.db import models
from datetime import datetime
from django.utils.timezone import now



class Passenger(models.Model):
    passengerName = models.CharField(max_length=20)
    passengerPhone = models.IntegerField()
    passengerEmail = models.EmailField(unique=True)
    passengerPassword = models.CharField(max_length=150)
    passengerPhoto = models.ImageField(upload_to='passengers', blank=True)
    passengerOtp = models.CharField(max_length=5, null=True, blank=True)
    passengerVerified = models.BooleanField(default=False)
    Created_at = models.DateTimeField(auto_now_add=True)

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

# class Booking(models.Model):
#     passenger = models.ForeignKey('Passenger', on_delete=models.CASCADE)
#     driver = models.ForeignKey('Driver', on_delete=models.CASCADE, null=True, blank=True)  # Driver can be assigned later
#     pickup_location = models.CharField(max_length=255)
#     dropoff_location = models.CharField(max_length=25, 
#                                         choices=[('Mustang','Mustang'),('Jhinu','Jhinu'),('Poon hill','Poon hill'),('Sidhing','Sidhing')])
#     booking_time = models.DateTimeField(default=now)
#     status = models.CharField(
#         max_length=20,
#         choices=[('pending', 'Pending'), ('confirmed', 'Confirmed'), ('completed', 'Completed'), ('canceled', 'Canceled')],
#         default='pending'
#     )
#     accepted_drivers = models.ManyToManyField('Driver', related_name='accepted_bookings', blank=True)

#     def __str__(self):
#         return f"{self.passenger} - {self.status}"

# from django.db import models
# from django.utils.timezone import now

# class Booking(models.Model):
#     passenger = models.ForeignKey('Passenger', on_delete=models.CASCADE)
#     driver = models.ForeignKey('Driver', on_delete=models.SET_NULL, null=True, blank=True)  # Assigned driver
#     pickup_location = models.CharField(max_length=255)
#     dropoff_location = models.CharField(max_length=255)
#     booking_time = models.DateTimeField(default=now)
#     status = models.CharField(
#         max_length=20,
#         choices=[
#             ('requested', 'Requested'),
#             ('accepted', 'Accepted'),  # When at least one driver accepts
#             ('driver_selected', 'Driver Selected'),
#             ('completed', 'Completed'),
#             ('canceled', 'Canceled')
#         ],
#         default='requested'
#     )
#     accepted_drivers = models.ManyToManyField('Driver', related_name='accepted_bookings', blank=True)

#     def __str__(self):
#         return f"Booking by {self.passenger} - {self.status}"





class Booking(models.Model):
    FARE_MAPPING = {
        'Mustang': 25000,
        'Jhinu': 7000,
        'Poon hill': 10000,
        'Sidhing': 7000,
    }

    passenger = models.ForeignKey('Passenger', on_delete=models.CASCADE)
    driver = models.ForeignKey('Driver', on_delete=models.CASCADE, null=True, blank=True)  # Driver can be assigned later
    #driver = models.ForeignKey(Driver, on_delete=models.SET_NULL, null=True, blank=True)
    pickup_location = models.CharField(max_length=255)
    dropoff_location = models.CharField(
        max_length=25, 
        choices=[
            ('Mustang', 'Mustang'),
            ('Jhinu', 'Jhinu'),
            ('Poon hill', 'Poon hill'),
            ('Sidhing', 'Sidhing')
        ]
    )
    booking_time = models.DateTimeField(default=now)
    status = models.CharField(
        max_length=20,
        choices=[
            ('pending', 'Pending'),
            ('confirmed', 'Confirmed'),
            ('completed', 'Completed'),
            ('canceled', 'Canceled')
        ],
        default='pending'
    )
    accepted_drivers = models.ManyToManyField('Driver', related_name='accepted_bookings', blank=True)
    fare = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # Fare for the booking

    def save(self, *args, **kwargs):
        # Set the fare based on dropoff_location if not already set
        if self.dropoff_location in self.FARE_MAPPING and self.fare is None:
            self.fare = self.FARE_MAPPING[self.dropoff_location]
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.passenger} - {self.status} - {self.fare or 'Fare not set'}"





