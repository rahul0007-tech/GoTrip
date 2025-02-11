# from django.db import models


# # Create your models here.
# class Booking(models.Model):
#     FARE_MAPPING = {
#         'Mustang': 25000,
#         'Jhinu': 7000,
#         'Poon hill': 10000,
#         'Sidhing': 7000,
#     }

#     passenger = models.ForeignKey('users.Passenger', on_delete=models.CASCADE)
#     driver = models.ForeignKey('users.Driver', on_delete=models.CASCADE, null=True, blank=True)  # Driver can be assigned later
#     pickup_location = models.CharField(max_length=255)
#     dropoff_location = models.CharField(
#         max_length=25, 
#         choices=[
#             ('Mustang', 'Mustang'),
#             ('Jhinu', 'Jhinu'),
#             ('Poon hill', 'Poon hill'),
#             ('Sidhing', 'Sidhing')
#         ]
#     )
#     booking_time = models.DateTimeField(auto_now_add=True)
#     status = models.CharField(
#         max_length=20,
#         choices=[
#             ('pending', 'Pending'),
#             ('confirmed', 'Confirmed'),
#             ('completed', 'Completed'),
#             ('canceled', 'Canceled')
#         ],
#         default='pending'
#     )
#     accepted_drivers = models.ManyToManyField('users.Driver', related_name='accepted_bookings', blank=True)
#     fare = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # Fare for the booking

#     class Meta:
#         verbose_name = "Booking"
#         verbose_name_plural = "Bookings"
#         # app_label = "Bookings"

#     def save(self, *args, **kwargs):
#         # Set the fare based on dropoff_location if not already set
#         if self.dropoff_location in self.FARE_MAPPING and self.fare is None:
#             self.fare = self.FARE_MAPPING[self.dropoff_location]
#         super().save(*args, **kwargs)

#     def __str__(self):
#         return f"{self.passenger} - {self.status} - {self.fare or 'Fare not set'}"

from django.db import models
from django.utils.timezone import now


# Create your models here.
class Booking(models.Model):
    FARE_MAPPING = {
        'Mustang': 25000,
        'Jhinu': 7000,
        'Poon hill': 10000,
        'Sidhing': 7000,
    }

    passenger = models.ForeignKey('users.Passenger', on_delete=models.CASCADE)
    driver = models.ForeignKey('users.Driver', on_delete=models.CASCADE, null=True, blank=True)  # Driver can be assigned later
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
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now_add=True)
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
    accepted_drivers = models.ManyToManyField('users.Driver', related_name='accepted_bookings', blank=True)
    fare = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # Fare for the booking

    class Meta:
        verbose_name = "Booking"
        verbose_name_plural = "Bookings"
        # app_label = "Bookings"

    def save(self, *args, **kwargs):
        # Set the fare based on dropoff_location if not already set
        if self.dropoff_location in self.FARE_MAPPING and self.fare is None:
            self.fare = self.FARE_MAPPING[self.dropoff_location]
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.passenger} - {self.status} - {self.fare or 'Fare not set'}"