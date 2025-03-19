from django.shortcuts import get_object_or_404
from .models import Booking
from users.models import Passenger, Driver
from .serializers import AvailableBookingSerializer, CreateBookingSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status



class CreateBookingView(APIView):
    permission_classes = [IsAuthenticated] 

    def post(self, request):
        user = request.user
        
        passenger = get_object_or_404(Passenger, id=user.id)  

        serializer = CreateBookingSerializer(data=request.data)
        if serializer.is_valid():
            booking = serializer.save(passenger=passenger)
            booking_data = CreateBookingSerializer(booking).data
            return Response({"message": "Booking created successfully", "data": booking_data}, status=200)

        return Response(serializer.errors, status=400)


# class CreateBookingView(APIView):
#     permission_classes = [IsAuthenticated] 

#     def post(self, request):
#         user = request.user
#         passenger = get_object_or_404(Passenger, id=user.id)  

#         serializer = CreateBookingSerializer(data=request.data)
#         if serializer.is_valid():
#             booking = serializer.save(passenger=passenger)
            
#             booking_data = serializer.to_representation(booking)
#             return Response({
#                 "message": "Booking created successfully", 
#                 "data": booking_data
#             }, status=200)

#         return Response(serializer.errors, status=400)
    

    

class AcceptBookingView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user  

        driver = get_object_or_404(Driver, id=user.id)  

        booking_id = request.data.get('booking_id')
        if not booking_id:
            return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)

        booking = get_object_or_404(Booking, id=booking_id)

        if booking.status != 'pending':
            return Response({'message': 'Sorry This Booking is no more available'}, status=status.HTTP_400_BAD_REQUEST)

        if driver in booking.accepted_drivers.all():
            return Response({'message': 'You have already accepted this booking'}, status=status.HTTP_400_BAD_REQUEST)

        booking.accepted_drivers.add(driver)
        booking.save()

        return Response({"message": "Booking accepted successfully", "booking_id": booking.id}, status=status.HTTP_200_OK)


class GetAcceptedDriversView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        user = request.user
        passenger = get_object_or_404(Passenger, id = user.id)
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        booking_id = request.data.get('booking_id')
        if not booking_id:
            return Response({'error':'Booking id is required'}, status=status.HTTP_400_BAD_REQUEST)
        booking = get_object_or_404(Booking, id=booking_id)
        drivers = booking.accepted_drivers.all()
        driver_list = [{"id":driver.id, "name": driver.name, "phone": driver.phone} for driver in drivers]
        return Response({"booking_id": booking.id, "accepted_drivers": driver_list}, status=status.HTTP_200_OK)





class SelectDriverView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        user = request.user
        passenger = get_object_or_404(Passenger, id = user.id)
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        booking_id = request.data.get('booking_id')
        driver_id = request.data.get('driver_id')

        if not booking_id or not driver_id:
            return Response({'error': 'Booking ID and Driver ID are required'}, status=status.HTTP_400_BAD_REQUEST)

        booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)
        selected_driver = get_object_or_404(Driver, id=driver_id)

        if selected_driver not in booking.accepted_drivers.all():
            return Response({'error': 'This driver has not accepted the booking'}, status=status.HTTP_400_BAD_REQUEST)

        booking.driver = selected_driver
        booking.status = 'confirmed'
        booking.save()

        return Response({"message": "Driver selected successfully", "selected_driver": {"id": selected_driver.id, "name": selected_driver.name, "phone": selected_driver.phone}}, status=status.HTTP_200_OK)        


class GetAvailableBookingView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user

        driver = get_object_or_404(Driver, id=user.id)
        if not driver:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        bookings = Booking.objects.filter(status='pending')
        if not bookings.exists():
            return Response({'error': 'No available bookings found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = AvailableBookingSerializer(bookings, many=True)
        return Response({
            'status': 'success',
            'message': 'Available bookings retrieved successfully',
            'data': serializer.data
        }, status=status.HTTP_200_OK)

