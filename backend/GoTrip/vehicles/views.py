from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from users.models import Driver, Passenger
from .serializers import AddVehicleSerializer, ShowVehicleTypeSerializer, ShowFuelTypeSerializer, DriverWithVehicleSerializer
from django.shortcuts import get_object_or_404
from .models import FuelType, VehicleImage, VehicleType, Vehicle


class AddVehicleView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self, request):
        user = request.user
        driver = get_object_or_404(Driver, id= user.id)
        serializer = AddVehicleSerializer(data = request.data)
        existing_vehicle = Vehicle.objects.filter(driver=driver).first()
        if existing_vehicle:
            return Response({"status":"failed", "message":"You already have a vehicle"}, status=status.HTTP_400_BAD_REQUEST)
        if serializer.is_valid():
            vehicle = serializer.save(driver=driver)
            vehicle_data = AddVehicleSerializer(vehicle).data
            return Response({"status":"success", "message":"Vahicle Added Successfully", "data":vehicle_data})
        
class AddVehicleImageView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self, request):
        user = request.user
        driver = get_object_or_404(Driver, id=user.id)
        
        # Check if driver has a vehicle
        try:
            vehicle = Vehicle.objects.get(driver=driver)
        except Vehicle.DoesNotExist:
            return Response({
                "status": "failed",
                "message": "You do not have a vehicle. Please add a vehicle first."
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Handle image upload
        uploaded_images = request.FILES.getlist('uploaded_images')
        for image in uploaded_images:
            VehicleImage.objects.create(vehicle=vehicle, image=image)
        
        return Response({
            "status": "success", 
            "message": "Vehicle Images Added Successfully"
        })
    
class GetVehiclesImageView(APIView):
    permission_classes=[IsAuthenticated]
    def get(self, request):
        user = request.user
        driver = get_object_or_404(Driver, id=user.id)

        if not driver:  
            return Response({'error': 'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Check if driver has a vehicle
        try:
            vehicle = Vehicle.objects.get(driver=driver)
        except Vehicle.DoesNotExist:
            return Response({
                "status": "failed",
                "message": "You do not have a vehicle. Please add a vehicle first."
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Retrieve images associated with the vehicle
        images = VehicleImage.objects.filter(vehicle=vehicle)
        
        if not images.exists():
            return Response({
                "status": "failed",
                "message": "No images found for this vehicle."
            }, status=status.HTTP_404_NOT_FOUND)
        
        image_data = [{"id": image.id, "image_url": image.image.url} for image in images]
        
        return Response({
            "status": "success", 
            "message": "Vehicle Images Fetched Successfully",
            "data": image_data
        })


# class ShowFuelTypeView(APIView):
#     permission_classes = [IsAuthenticated]

#     def get(self, request):
#         user = request.user
#         try:
#             # Change to get the driver by user field, not by ID
#             driver = Driver.objects.get(user=user)
            
#             fuel_type = FuelType.objects.all()  # Add .all() to get a QuerySet
#             if not fuel_type.exists():
#                 return Response({"status":"failed", "message":"No fuel types found"}, status=status.HTTP_404_NOT_FOUND)
            
#             serializer = ShowFuelTypeSerializer(fuel_type, many=True)
#             return Response({"status":"success", "message":"Fuel Types Fetched Successfully", "data":serializer.data})
#         except Driver.DoesNotExist:
#             return Response({'status':'failed', 'message':'Driver not found for this user'}, status=status.HTTP_404_NOT_FOUND)


class ShowFuelTypeView(APIView):

    permission_classes = [IsAuthenticated]

    def get (self, request):
        user = request.user
        passenger = get_object_or_404(Driver, id = user.id)
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        fuel_type = FuelType.objects
        if not fuel_type.exists():
            return Response({"error":"failed", "message":"No such vehicle found"})
        serializer = ShowFuelTypeSerializer(fuel_type, many=True)
        return Response({"status":"success", "message":"Vehicle Type Fetched Successfully", "data":serializer.data}) 

class ShowVehicleTypeView(APIView):
    permission_classes = [IsAuthenticated]

    def get (self, request):
        user = request.user
        passenger = get_object_or_404(Driver, id = user.id)
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        vehicle_type = VehicleType.objects
        if not vehicle_type.exists():
            return Response({"error":"failed", "message":"No such vehicle found"})
        serializer = ShowVehicleTypeSerializer(vehicle_type, many=True)
        return Response({"status":"success", "message":"Vehicle Type Fetched Successfully", "data":serializer.data})


class GetVehiclesCategoryView(APIView):
    permission_classes=[IsAuthenticated]
    def get(self,request):
        user = request.user
        passenger = get_object_or_404(Passenger, id=user.id)
        vehicle_type = VehicleType.objects
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        if not vehicle_type.exists():
            return Response({"message":"Sorry No vehicles found"})
        serializer = ShowVehicleTypeSerializer(vehicle_type, many=True)
        return Response({"status":"success", "data":{"vehicle_type":serializer.data}, "message":"vehicle Fetched Successfully"})
    

class GetDriversByVehicleTypeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):  # Use POST instead of GET
        # Retrieve vehicle_type_id from the body
        vehicle_type_id = request.data.get('vehicle_type_id')

        if not vehicle_type_id:
            return Response({"error": "Vehicle type ID is required."}, status=status.HTTP_400_BAD_REQUEST)

        # Get the authenticated user
        user = request.user

        # Fetch the passenger object associated with the user
        passenger = get_object_or_404(Passenger, id=user.id)

        if not passenger:
            return Response({'error': 'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)

        # Check if the vehicle type exists
        vehicle_type = get_object_or_404(VehicleType, id=vehicle_type_id)

        # Retrieve all vehicles that match the vehicle type
        vehicles = Vehicle.objects.filter(vehicle_type=vehicle_type)

        if not vehicles.exists():
            return Response({"message": "No drivers found for this vehicle type."}, status=status.HTTP_404_NOT_FOUND)

        # Get the drivers associated with these vehicles
        # drivers = [vehicle.driver for vehicle in vehicles]  # Retrieve the driver for each vehicle

        drivers = []

        for vehicle in vehicles:
            if vehicle.driver.status =='free':
                drivers.append(vehicle.driver)

        if not drivers:
            return Response({"message":"Sorry No matching Drivers Found"}, status=status.HTTP_404_NOT_FOUND)

        # Serialize the driver details
        serializer = DriverWithVehicleSerializer(drivers, many=True)

        return Response({
            "status": "success",
            "data": serializer.data,
            "message": "Drivers fetched successfully"
        })
        
        