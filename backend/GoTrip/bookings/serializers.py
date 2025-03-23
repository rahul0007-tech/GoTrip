from rest_framework import serializers
from django.utils.timezone import now
from django.core.exceptions import ValidationError

from users.models import Driver
from .models import Booking, Location




class CreateBookingSerializer(serializers.ModelSerializer):
    # Use PrimaryKeyRelatedField to handle the Location foreign key
    dropoff_location = serializers.CharField(
        max_length = 255,   
        help_text="ID of the destination location"
    )
    
    class Meta:
        model = Booking
        fields = ['pickup_location', 'dropoff_location', 'booking_for']

    def validate_booking_for(self, value):
        if value < now().date():
            raise ValidationError("Booking date cannot be in the past.")
        return value
    

    
    def create(self, validated_data):
        # Get the location object from the name
        location_name = validated_data.pop('dropoff_location')
        location = Location.objects.get(name=location_name, is_active=True)
        
        # Create the booking with the location object
        booking = Booking(
            **validated_data,
            dropoff_location=location
        )
        booking.save()
        
        return booking




class ShowBookingLocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ['name', 'fare']

class AvailableBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = ['id','passenger', 'pickup_location', 'dropoff_location', 'fare', 'booking_for']

class DriverSerializer(serializers.ModelSerializer):
    class Meta:
        model = Driver
        fields = ['id','name']

