from rest_framework import serializers
from django.utils.timezone import now
from django.core.exceptions import ValidationError
from .models import Booking, Location


# class CreateBookingSerializer(serializers.ModelSerializer):
#     # Use PrimaryKeyRelatedField to handle the Location foreign key
#     dropoff_location = serializers.CharField(
#         max_length = 255,   
#         help_text="ID of the destination location"
#     )
    
#     class Meta:
#         model = Booking
#         fields = ['pickup_location', 'dropoff_location', 'booking_for']

#     def validate_booking_for(self, value):
#         if value < now().date():
#             raise ValidationError("Booking date cannot be in the past.")
#         return value
    
#     def validate_dropoff_location(self, value):
#         # Check if the location exists
#         try:
#             location = Location.objects.get(name=value, is_active=True)
#             return value
#         except Location.DoesNotExist:
#             raise ValidationError(f"Location '{value}' is not available. Please choose from the available destinations.")
    
#     def to_representation(self, instance):
#         # Customize the response to include location details
#         representation = super().to_representation(instance)
#         location = instance.dropoff_location
        
#         representation['dropoff_location'] = {
#             'id': location.id,
#             'name': location.name,
#             'fare': location.fare
#         }
        
#         return representation
    
#     def create(self, validated_data):
#         # Get the location object from the name
#         location_name = validated_data.pop('dropoff_location')
#         location = Location.objects.get(name=location_name, is_active=True)
        
#         # Create the booking with the location object
#         booking = Booking(
#             **validated_data,
#             dropoff_location=location
#         )
#         booking.save()
        
#         return booking


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
    
    # def validate_dropoff_location(self, value):
    #     # Check if the location exists
    #     try:
    #         location = Location.objects.get(name=value, is_active=True)
    #         return value
    #     except Location.DoesNotExist:
    #         raise ValidationError(f"Location '{value}' is not available. Please choose from the available destinations.")
    
    # def to_representation(self, instance):
    #     # Customize the response to include location details
    #     representation = super().to_representation(instance)
    #     location = instance.dropoff_location
        
    #     representation['dropoff_location'] = {
    #         'id': location.id,
    #         'name': location.name,
    #         'fare': location.fare
    #     }
        
    #     return representation
    
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


# class CreateBookingSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Booking
#         fields = ['pickup_location', 'dropoff_location', 'booking_for']

#     def validate_booking_for(self, value):
#         if value < now().date():
#             raise ValidationError("Booking date cannot be in the past.")
#         return value


class AvailableBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = ['id','passenger', 'pickup_location', 'dropoff_location', 'fare', 'booking_for']
