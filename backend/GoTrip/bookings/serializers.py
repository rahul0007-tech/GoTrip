from rest_framework import serializers
from .models import Booking

class CreateBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = ['pickup_location', 'dropoff_location']