from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated

from goTrip.users.models import Driver
from .serializers import AddVehicleSerializer
from django.shortcuts import get_object_or_404


# class AddVehicleView(APIView):
#     permission_classes = [IsAuthenticated]
    
#     def post(self, request):
#         serializer = AddVehicleSerializer(data=request.data)
#         if serializer.is_valid():
#             # Auto-assign driver if user is a driver
#             if hasattr(request.user, 'driver'):
#                 vehicle = serializer.save(driver=request.user.driver)
#             else:
#                 return Response(
#                     {"error": "Only drivers can add vehicles"}, 
#                     status=status.HTTP_403_FORBIDDEN
#                 )
                
#             return Response(
#                 {"id": vehicle.id, "message": "Vehicle added successfully"}, 
#                 status=status.HTTP_201_CREATED
#             )
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



    # def post(self, request):
    #     user = request.user
        
    #     passenger = get_object_or_404(Passenger, id=user.id)  

    #     serializer = CreateBookingSerializer(data=request.data)
    #     if serializer.is_valid():
    #         booking = serializer.save(passenger=passenger)
    #         booking_data = CreateBookingSerializer(booking).data
    #         return Response({"message": "Booking created successfully", "data": booking_data}, status=200)

    #     return Response(serializer.errors, status=400)


class AddVehicle(APIView):
    permission_classes=[IsAuthenticated]
    def post(self, request):
        user = request.user
        driver = get_object_or_404(Driver, id= user.id)
        serializer = AddVehicleSerializer(data = request.data)
        if serializer.is_valid():
            vehicle = serializer.save(driver=driver)
            vehicle_data = AddVehicleSerializer(vehicle).data
            return Response({"status":"success", "message":"Vahicle Added Successfully", "data":vehicle_data})