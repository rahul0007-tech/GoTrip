from rest_framework import serializers
from .models import Vehicle, VehicleImage, FuelType, VehicleType
from users.models import Driver

class AddVehicleSerializer(serializers.ModelSerializer):
    uploaded_images = serializers.ListField(
        child=serializers.ImageField(max_length=1000000, allow_empty_file=False, use_url=False),
        write_only=True,
        required=False
    )
    
    class Meta:
        model = Vehicle
        fields = [
            'vehicle_color', 
            'vehicle_company', 
            'vehicle_type', 
            'vehicle_fuel_type',
            'vehicle_number', 
            'sitting_capacity', 
            'uploaded_images'
        ]
    
    def create(self, validated_data):
        uploaded_images = validated_data.pop('uploaded_images', [])
        
        vehicle = Vehicle.objects.create(**validated_data)
        
        for image in uploaded_images:
            VehicleImage.objects.create(vehicle=vehicle, image=image)
            
        return vehicle

class ShowFuelTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = FuelType
        fields = ['id', 'name', 'display_name']

class ShowVehicleTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = VehicleType
        fields = ['id', 'name', 'display_name']


class VehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        fields = ['vehicle_color', 'vehicle_company', 'vehicle_number', 'sitting_capacity', 'vehicle_type', 'vehicle_fuel_type']

class DriverWithVehicleSerializer(serializers.ModelSerializer):
    vehicle=VehicleSerializer()
    class Meta:
        model = Driver
        fields = ['id','name','vehicle']
