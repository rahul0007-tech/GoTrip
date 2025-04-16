from django.shortcuts import get_object_or_404
from .models import Booking, Location
from users.models import Passenger, Driver
from .serializers import AvailableBookingSerializer, CreateBookingSerializer, DriverHistorySerializer, ShowBookingLocationSerializer, DriverSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.utils import timezone
from payments.models import Payment, OrderStatus



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


    
class ShowBookingLocationView(APIView):
    permission_classes = [IsAuthenticated]

    def get (self, request):
        try:
            location = Location.objects.filter(is_active=True)
            if not location.exists():
                return Response({"status":"failed", "message":"No such location found" })
            serializer = ShowBookingLocationSerializer(location, many=True)
            
            # Return the serialized data
            return Response(serializer.data, status=200)

        
        except Exception as e:
            # Log the error for debugging
            print(f"Error fetching locations: {str(e)}")
            
            # Return an error response
            return Response(
                {"message": f"An error occurred while fetching locations: {str(e)}"},
                status=500
            )


class CreateInstantBooking(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        user = request.user
        passenger = get_object_or_404(Passenger, id=user.id)  

        driver = request.data.get('driver_id')
        if not driver:
            return Response({'error': 'Driver ID is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        

        # serializer = CreateBookingSerializer(data=request.data)
        # if serializer.is_valid():
        #     booking = serializer.save(passenger=passenger)
        #     booking_data = serializer.to_representation(booking)
        #     return Response({"message": "Booking created successfully", "data": booking_data}, status=200)

        # return Response(serializer.errors, status=400)


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


# class GetAcceptedDriversView(APIView):
#     permission_classes = [IsAuthenticated]
#     def post(self, request):
#         user = request.user
#         passenger = get_object_or_404(Passenger, id = user.id)
#         if not passenger:
#             return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
#         booking_id = request.data.get('booking_id')
#         if not booking_id:
#             return Response({'error':'Booking id is required'}, status=status.HTTP_400_BAD_REQUEST)
#         booking = get_object_or_404(Booking, id=booking_id)
#         # drivers = booking.accepted_drivers.all()
#         # driver_list = [{"id":driver.id, "name": driver.name, "phone": driver.phone} for driver in drivers]
#         # return Response({"booking_id": booking.id, "accepted_drivers": driver_list}, status=status.HTTP_200_OK)
#         drivers = booking.accepted_drivers.all()
#         driver_serializer = DriverSerializer(drivers, many=True)
#         return Response({
#             "booking_id": booking.id,
#             "accepted_drivers": driver_serializer.data
#         }, status=status.HTTP_200_OK)


class GetAcceptedDriversView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        user = request.user
        passenger = get_object_or_404(Passenger, id = user.id)
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        bookings = Booking.objects.filter(passenger=passenger, status= 'pending', booking_for__gte=timezone.now().date()).order_by('booking_for')
        result = []
        for booking in bookings:
            drivers = booking.accepted_drivers.all()
            if drivers.exists():  # Only include bookings that have accepted drivers
                driver_serializer = DriverSerializer(drivers, many=True)
                # pickup_location_serializer = LocationSerializer(booking.pickup_location)
                dropoff_location_serializer = ShowBookingLocationSerializer(booking.dropoff_location)
                result.append({
                    "booking_id": booking.id,
                    "pickup_location": booking.pickup_location,
                    "dropoff_location": dropoff_location_serializer.data,
                    "fare": booking.fare,
                    "booking_for": booking.booking_for,
                    "booking_time": booking.booking_time,
                    "accepted_drivers": driver_serializer.data
                    })
        response_data = {
                "status": "success",
                "message": "Accepted drivers retrieved successfully",
                "data": result
            }
            
        return Response(response_data, status=status.HTTP_200_OK)


class SelectDriverView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        user = request.user
        passenger = get_object_or_404(Passenger, id=user.id)
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        booking_id = request.data.get('booking_id')
        driver_id = request.data.get('driver_id')

        if not booking_id or not driver_id:
            return Response({'error': 'Booking ID and Driver ID are required'}, status=status.HTTP_400_BAD_REQUEST)

        booking = get_object_or_404(Booking, id=booking_id, passenger=passenger, booking_for__gte=timezone.now().date())
        
        # Check if payment is completed for this booking
        # from payments.models import Payment, OrderStatus
        # payment = Payment.objects.filter(
        #     user=user, 
        #     status=OrderStatus.COMPLETED,
        #     response_data__booking_id=booking_id
        # ).first()
        
        # if not payment:
        #     return Response({'error': 'Payment is required before selecting a driver', 'payment_required': True}, 
        #                   status=status.HTTP_400_BAD_REQUEST)
        
        selected_driver = get_object_or_404(Driver, id=driver_id)
        
        if booking.booking_for < timezone.now().date():
            return Response({'error': 'Cannot select a driver for a booking with a past date'}, 
                          status=status.HTTP_400_BAD_REQUEST)

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
        bookings = Booking.objects.filter(status='pending', booking_for__gte=timezone.now().date()).order_by('booking_for')
        if not bookings.exists():
            return Response({'error': 'No available bookings found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = AvailableBookingSerializer(bookings, many=True)
        return Response({
            'status': 'success',
            'message': 'Available bookings retrieved successfully',
            'data': serializer.data
        }, status=status.HTTP_200_OK)
    
class CancelBookingView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self, request):
        user = request.user

        passenger = get_object_or_404(Passenger, id=user.id)

        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        
        booking_id = request.data.get('booking_id')
        if not booking_id:
            return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)

        booking = get_object_or_404(Booking, id=booking_id)
        # booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)
        # booking = Booking.objects.all()
        if not booking:
            return Response({"error":"Sorry no such bboking found"}, status=status.HTTP_40ehi0_BAD_REQUEST)
        

# class GetVehiclesCategoryView(APIView):
#     permission_classes=[IsAuthenticated]
#     def get(self,request):
#         user = request.user
#         passenger = get_object_or_404(Passenger, id=user.id)
#         vehicle_type = VehicleType.objects
#         if not passenger:
#             return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
#         if not vehicle_type.exists():
#             return Response({"message":"Sorry No vehicles found"})
#         serializer = ShowVehicleTypeSerializer(vehicle_type, many=True)
#         return Response({"status":"success", "data":{"vehicle_type":serializer.data}, "message":"vehicle Fetched Successfully"})


class GetLocation(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        driver = get_object_or_404(Driver, id=user.id)
        if not driver:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        
        location = Location.objects.filter(is_active=True)
        if not location.exists():
            return Response({"status":"failed", "message":"No such location found" })
        serializer = ShowBookingLocationSerializer(location, many=True)
        
        # Return the serialized data
        return Response(serializer.data, status=200)



class GetBookingByLoacation(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        user = request.user
        driver = get_object_or_404(Driver, id=user.id)
        if not driver:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
            
        location_id = request.data.get('location_id')
        if not location_id:
            return Response({'error': 'Location ID is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Fix the space between booking_for and >=
        bookings = Booking.objects.filter(dropoff_location=location_id, status='pending', booking_for__gte=timezone.now().date()).order_by('booking_for')
        if not bookings.exists():
            return Response({'error': 'No available bookings found'}, status=status.HTTP_404_NOT_FOUND)
        
        return Response({   
            'status': 'success',
            'message': 'Available bookings retrieved successfully',
            'data': bookings.values('id', 'pickup_location', 'dropoff_location', 'fare', 'booking_for')
        }, status=status.HTTP_200_OK)
    
    
class DriverUpcommingBookingsView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        driver = get_object_or_404(Driver, id=request.user.id)

        if not driver:
            return Response({'error': 'Invalid Token or Token has expired'}, status=status.HTTP_404_NOT_FOUND)
        
        

        driver_Bookings = Booking.objects.filter(driver=driver,booking_for__gte=timezone.now().date()).order_by('booking_for')

        serializer = DriverHistorySerializer(driver_Bookings, many=True)
        if not driver_Bookings.exists():
            return Response({'status':'failed','message': 'No trip history found'}, status=status.HTTP_404_NOT_FOUND)

        return Response({'status':'success','message': 'Driver trip history fetched successfully','data': serializer.data}, status=status.HTTP_200_OK)

class ChangeBookingStatus(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        passenger = get_object_or_404(passenger, id=request.user.id)
        if not passenger:
            return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
        
        booking_id = request.data.get('booking_id')

        if not booking_id:
            return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)

        booking = get_object_or_404(Booking, id=booking_id, driver=passenger)

        if booking.status == 'confirmed':
            booking.status = 'completed'
        elif booking.status == 'completed':
            return Response({"error": "This booking is already completed"}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "This booking is not confirmed yet"}, status=status.HTTP_400_BAD_REQUEST)
        booking.save()

        return Response({"message": "Booking status updated successfully"}, status=status.HTTP_200_OK)
    

class ChangeBookingPaymentStatus(APIView):
    permission_classes=[IsAuthenticated]

    def post (self, request):
        driver = get_object_or_404(Driver, id=request.user.id)

        if not driver:
            return Response({"error":"Invalid Token or Token has expired"}, status=status.HTTP_400_BAD_REQUEST)
        
        booking_id = request.data.get('booking_id')

        if not booking_id:
            return Response({"error":"Booking ID is required"}, status=status.HTTP_400_BAD_REQUEST)
        
        booking = get_object_or_404(Booking, id=booking_id, passenger=driver)

        if booking.payment_status == 'partial':
            booking.status = 'confirmed'
        elif booking.status == 'confirmed':
            return Response({"error": "This booking is already confirmed"}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "This booking is not partially paid yet"}, status=status.HTTP_400_BAD_REQUEST)
        booking.save()

        return Response({"message": "Booking status updated successfully"}, status=status.HTTP_200_OK)
    

class DriverBookingHistory(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        driver = get_object_or_404(Driver, id=request.user.id)

        if not driver:
            return Response({'error': 'Invalid Token or Token has expired'}, status=status.HTTP_404_NOT_FOUND)

        driver_Bookings = Booking.objects.filter(driver=driver).order_by('booking_for')

        serializer = DriverHistorySerializer(driver_Bookings, many=True)
        if not driver_Bookings.exists():
            return Response({'status':'failed','message': 'No trip history found'}, status=status.HTTP_404_NOT_FOUND)

        return Response({'status':'success','message': 'Driver trip history fetched successfully','data': serializer.data}, status=status.HTTP_200_OK)
    
        
        
        
                


