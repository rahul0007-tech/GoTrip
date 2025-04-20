# from rest_framework import serializers
# from datetime import datetime
# from django.utils.timezone import now
# from django.core.exceptions import ValidationError

# from users.models import Driver
# from .models import Booking, Location

from datetime import datetime
from django.utils.timezone import now, make_aware
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from vehicles.serializers import DriverWithVehicleSerializer, VehicleSerializer  # Use this instead of Django's
from .models import Booking, Location
from users.models import Driver, Passenger




class CreateBookingSerializer(serializers.ModelSerializer):
    # Use PrimaryKeyRelatedField to handle the Location foreign key
    dropoff_location = serializers.CharField(
        max_length = 255,   
        help_text="ID of the destination location"
    )
    
    class Meta:
        model = Booking
        fields = ['pickup_location', 'dropoff_location', 'booking_for', 'booking_time']

    def validate_booking_for(self, value):
        if value < now().date():
            raise ValidationError("Booking date cannot be in the past.")
        
        return value
    
    def validate(self, data):
        # Get current datetime (timezone-aware)
        current = now()
        booking_date = data.get('booking_for')
        booking_time = data.get('booking_time')
        
        # If both date and time are provided
        if booking_date and booking_time:
            # Create a naive datetime by combining date and time
            naive_booking_datetime = datetime.combine(booking_date, booking_time)
            
            # Make it timezone-aware to match now()
            booking_datetime = make_aware(naive_booking_datetime)
            
            # Check if the combined datetime is in the past
            if booking_datetime < current:
                raise ValidationError({"booking_time": "Booking time cannot be in the past."})
        
        return data

    
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
        fields = ['id','name', 'fare','location_image']

class AvailableBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = ['id','passenger', 'pickup_location', 'dropoff_location', 'fare', 'booking_for', 'booking_time']

class DriverSerializer(serializers.ModelSerializer):
    class Meta:
        model = Driver
        fields = ['id','name']


class LocationNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ['name']

class PassengerNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = Passenger
        fields = ['name']

class DriverHistorySerializer(serializers.ModelSerializer):
    dropoff_location = LocationNameSerializer()
    passenger = PassengerNameSerializer()
    
    class Meta:
        model = Booking
        fields = ['id','passenger', 'pickup_location', 'dropoff_location', 'fare', 'booking_for', 'booking_time']

class PassengerHistorySerializer(serializers.ModelSerializer):
    dropoff_location = LocationNameSerializer()
    driver = DriverWithVehicleSerializer()
    
    class Meta:
        model = Booking
        fields = ['id','driver', 'pickup_location', 'dropoff_location', 'fare', 'booking_for', 'booking_time']



