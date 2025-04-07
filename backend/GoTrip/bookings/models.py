from django.core.exceptions import ValidationError
from django.db import models
from django.utils.timezone import now


class Location(models.Model):
    """Model to store locations and their respective fares that can be managed by admin"""
    name = models.CharField(max_length=255, unique=True)
    fare = models.DecimalField(max_digits=10, decimal_places=2)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    location_image = models.ImageField(null=True, blank=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Location"
        verbose_name_plural = "Locations"


class Booking(models.Model):
    passenger = models.ForeignKey('users.Passenger', on_delete=models.CASCADE)
    driver = models.ForeignKey('users.Driver', on_delete=models.CASCADE, null=True, blank=True)
    pickup_location = models.CharField(max_length=255)
    dropoff_location = models.ForeignKey(
        Location, 
        on_delete=models.PROTECT,  # Prevent deletion of locations that are used in bookings
        related_name='bookings'
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)  # Changed from auto_now_add to auto_now
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
    payment_status = models.CharField(
        max_length=20,
        choices=[
            ('pending', 'Pending'),
            ('confirmed', 'Confirmed'),
            ('canceled', 'Canceled')
        ],
        default='pending'
    )
    accepted_drivers = models.ManyToManyField('users.Driver', related_name='accepted_bookings', blank=True)
    fare = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # Actual fare for this booking
    booking_for = models.DateField()

    class Meta:
        verbose_name = "Booking"
        verbose_name_plural = "Bookings"

    def save(self, *args, **kwargs):
        if self.booking_for < now().date():
            raise ValidationError('Booking date cannot be in the past.')
        
        # Set the fare based on dropoff_location if not already set
        if self.fare is None and self.dropoff_location_id is not None:
            self.fare = self.dropoff_location.fare
            
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.passenger} - {self.status} - {self.fare or 'Fare not set'}"