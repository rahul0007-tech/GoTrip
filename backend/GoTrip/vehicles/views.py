from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from users.models import Driver
from .serializers import AddVehicleSerializer, ShowVehicleTypeSerializer, ShowFuelTypeSerializer
from django.shortcuts import get_object_or_404
from .models import FuelType, VehicleType


class AddVehicleView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self, request):
        user = request.user
        driver = get_object_or_404(Driver, id= user.id)
        serializer = AddVehicleSerializer(data = request.data)
        if serializer.is_valid():
            vehicle = serializer.save(driver=driver)
            vehicle_data = AddVehicleSerializer(vehicle).data
            return Response({"status":"success", "message":"Vahicle Added Successfully", "data":vehicle_data})
        

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
    # def get(self, request):
    #     user = request.user
    #     try:
    #         driver = Driver.objects.get(user=user)  # Change this line
    #         # Instead of get_object_or_404(Driver, id=user.id)
            
    #         vehicle_type = VehicleType.objects.all()
    #         serializer = ShowVehicleTypeSerializer(vehicle_type, many=True)
    #         return Response({"status":"success", "message":"Vehicle Type Fetched Successfully", "data":serializer.data})
    #     except Driver.DoesNotExist:
    #         return Response({'error':'Driver not found for this user'}, status=status.HTTP_404_NOT_FOUND)
        


# class ShowBookingLocationView(APIView):
#     permission_classes = [IsAuthenticated]

#     def get (self, request):
#         try:
#             location = Location.objects.filter(is_active=True)
#             if not location.exists():
#                 return Response({"status":"failed", "message":"No such location found" })
#             serializer = ShowBookingLocationSerializer(location, many=True)
            
#             # Return the serialized data
#             return Response(serializer.data, status=200)

        
#         except Exception as e:
#             # Log the error for debugging
#             print(f"Error fetching locations: {str(e)}")
            
#             # Return an error response
#             return Response(
#                 {"message": f"An error occurred while fetching locations: {str(e)}"},
#                 status=500
#             )