
from rest_framework import serializers
from .models import Vehicle, VehicleImage, VehicleType, FuelType

class VehicleTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = VehicleType
        fields = ['id', 'name', 'display_name']


class FuelTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = FuelType
        fields = ['id', 'name', 'display_name']


class VehicleImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = VehicleImage
        fields = ['id', 'image', 'created_at']
        read_only_fields = ['created_at']

class VehicleSerializer(serializers.ModelSerializer):
    images = VehicleImageSerializer(many=True, read_only=True)
    uploaded_images = serializers.ListField(
        child=serializers.ImageField(max_length=1000000, allow_empty_file=False, use_url=False),
        write_only=True,
        required=False
    )
    vehicle_type_display = serializers.StringRelatedField(source='vehicle_type', read_only=True)
    vehicle_fuel_type_display = serializers.StringRelatedField(source='vehicle_fuel_type', read_only=True)
    
    class Meta:
        model = Vehicle
        fields = ['id', 'driver', 'vehicle_color', 'vehicle_company', 'vehicle_type', 'vehicle_type_display',
                  'vehicle_fuel_type', 'vehicle_fuel_type_display', 'vehicle_number', 
                  'sitting_capacity', 'images', 'uploaded_images']
    
    def create(self, validated_data):
        uploaded_images = validated_data.pop('uploaded_images', [])
        vehicle = Vehicle.objects.create(**validated_data)
        
        for image in uploaded_images:
            VehicleImage.objects.create(vehicle=vehicle, image=image)
            
        return vehicle