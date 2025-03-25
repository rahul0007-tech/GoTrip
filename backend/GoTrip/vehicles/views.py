from django.shortcuts import render

# Create your views here.

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from django.shortcuts import get_object_or_404
from .models import Vehicle, VehicleImage, VehicleType, FuelType
from .serializers import VehicleSerializer, VehicleImageSerializer, VehicleTypeSerializer, FuelTypeSerializer

class VehicleTypeListCreateAPIView(APIView):
    def get(self, request):
        vehicle_types = VehicleType.objects.all()
        serializer = VehicleTypeSerializer(vehicle_types, many=True)
        return Response(serializer.data)
    
    def post(self, request):
        serializer = VehicleTypeSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class VehicleTypeDetailAPIView(APIView):
    def get_object(self, pk):
        return get_object_or_404(VehicleType, pk=pk)
    
    def get(self, request, pk):
        vehicle_type = self.get_object(pk)
        serializer = VehicleTypeSerializer(vehicle_type)
        return Response(serializer.data)
    
    def put(self, request, pk):
        vehicle_type = self.get_object(pk)
        serializer = VehicleTypeSerializer(vehicle_type, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        vehicle_type = self.get_object(pk)
        vehicle_type.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class FuelTypeListCreateAPIView(APIView):
    def get(self, request):
        fuel_types = FuelType.objects.all()
        serializer = FuelTypeSerializer(fuel_types, many=True)
        return Response(serializer.data)
    
    def post(self, request):
        serializer = FuelTypeSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FuelTypeDetailAPIView(APIView):
    def get_object(self, pk):
        return get_object_or_404(FuelType, pk=pk)
    
    def get(self, request, pk):
        fuel_type = self.get_object(pk)
        serializer = FuelTypeSerializer(fuel_type)
        return Response(serializer.data)
    
    def put(self, request, pk):
        fuel_type = self.get_object(pk)
        serializer = FuelTypeSerializer(fuel_type, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        fuel_type = self.get_object(pk)
        fuel_type.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class VehicleListCreateAPIView(APIView):
    parser_classes = (MultiPartParser, FormParser, JSONParser)
    
    def get(self, request):
        vehicles = Vehicle.objects.all()
        serializer = VehicleSerializer(vehicles, many=True)
        return Response(serializer.data)
    
    def post(self, request):
        serializer = VehicleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class VehicleDetailAPIView(APIView):
    parser_classes = (MultiPartParser, FormParser, JSONParser)
    
    def get_object(self, pk):
        return get_object_or_404(Vehicle, pk=pk)
    
    def get(self, request, pk):
        vehicle = self.get_object(pk)
        serializer = VehicleSerializer(vehicle)
        return Response(serializer.data)
    
    def put(self, request, pk):
        vehicle = self.get_object(pk)
        serializer = VehicleSerializer(vehicle, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        vehicle = self.get_object(pk)
        vehicle.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class VehicleImageUploadAPIView(APIView):
    parser_classes = (MultiPartParser, FormParser)
    
    def post(self, request, pk):
        vehicle = get_object_or_404(Vehicle, pk=pk)
        files = request.FILES.getlist('images')
        
        if not files:
            return Response({'error': 'No images provided'}, status=status.HTTP_400_BAD_REQUEST)
        
        images = []
        for file in files:
            image = VehicleImage.objects.create(vehicle=vehicle, image=file)
            images.append(image)
        
        serializer = VehicleImageSerializer(images, many=True)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
