from django.shortcuts import render, get_object_or_404
from .models import Booking
from users.models import Passenger, Driver
from .serializers import CreateBookingSerializer
import jwt
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import AuthenticationFailed
from rest_framework import status
from django.conf import settings


class CreateBookingView(APIView):
    permission_classes = [IsAuthenticated] 

    def post(self, request):
        user = request.user
        
        passenger = get_object_or_404(Passenger, id=user.id)  

        serializer = CreateBookingSerializer(data=request.data)
        if serializer.is_valid():
            booking = serializer.save(passenger=passenger)
            booking_data = CreateBookingSerializer(booking).data
            return Response({"message": "Booking created successfully", "data": booking_data}, status=201)

        return Response(serializer.errors, status=400)
    

    

class AcceptBookingView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user  # Automatically retrieved from JWT token

        driver = get_object_or_404(Driver, id=user.id)  

        booking_id = request.data.get('booking_id')
        if not booking_id:
            return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)

        booking = get_object_or_404(Booking, id=booking_id)

        if driver in booking.accepted_drivers.all():
            return Response({'message': 'You have already accepted this booking'}, status=status.HTTP_400_BAD_REQUEST)

        booking.accepted_drivers.add(driver)
        booking.save()

        return Response({"message": "Booking accepted successfully", "booking_id": booking.id}, status=status.HTTP_200_OK)

# class GetAcceptedDriversView(APIView):
#     def post(self, request):
#         token = request.headers.get('Authorization')

#         if not token or not token.startswith("Bearer "):
#             raise AuthenticationFailed('Unauthenticated')

#         token = token.split(' ')[1]
#         try:
#             payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         passenger = get_object_or_404(Passenger, id=payload['id'])
#         booking_id = request.data.get('booking_id')
#         if not booking_id:
#             return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)

#         booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)
#         drivers = booking.accepted_drivers.all()
#         driver_list = [{"id": driver.id, "name": driver.name, "phone": driver.phone} for driver in drivers]

#         return Response({"booking_id": booking.id, "accepted_drivers": driver_list}, status=status.HTTP_200_OK)

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
    def post(self, request):
        token = request.headers.get('Authorization')

        if not token or not token.startswith("Bearer "):
            raise AuthenticationFailed('Unauthenticated')

        token = token.split(' ')[1]
        try:
            payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
        except jwt.ExpiredSignatureError:
            raise AuthenticationFailed('Token has expired')
        except jwt.InvalidTokenError:
            raise AuthenticationFailed('Invalid token')

        passenger = get_object_or_404(Passenger, id=payload['id'])
        booking_id = request.data.get('booking_id')
        driver_id = request.data.get('driver_id')

        if not booking_id or not driver_id:
            return Response({'error': 'Booking ID and Driver ID are required'}, status=status.HTTP_400_BAD_REQUEST)

        booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)
        selected_driver = get_object_or_404(Driver, id=driver_id)

        if selected_driver not in booking.accepted_drivers.all():
            return Response({'error': 'This driver has not accepted the booking'}, status=status.HTTP_400_BAD_REQUEST)

        booking.driver = selected_driver
        booking.status = 'driver_selected'
        booking.save()

        return Response({"message": "Driver selected successfully", "selected_driver": {"id": selected_driver.id, "name": selected_driver.name, "phone": selected_driver.phone}}, status=status.HTTP_200_OK)

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# from django.shortcuts import render
# from .models import Booking
# from users.models import Passenger, Driver
# from .serializers import CreateBookingSerializer
# import jwt
# from rest_framework.views import APIView
# from rest_framework.response import Response
# from rest_framework.exceptions import AuthenticationFailed
# from rest_framework import status
# # Create your views here.
# class CreateBookingView(APIView):
#     def post(self, request):
#         token = request.COOKIES.get('jwt')

#         if not token:
#             raise AuthenticationFailed('Authentication token is missing')

#         try:
#             payload = jwt.decode(token, 'secret', algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         passenger = Passenger.objects.filter(id=payload['id']).first()
        
#         if passenger is None:
#             raise AuthenticationFailed('Passenger not found')

#         # Deserialize incoming data
#         serializer = CreateBookingSerializer(data=request.data)

#         if serializer.is_valid():
#             # Save the booking with the passenger ID set automatically
#             booking = serializer.save(passenger=passenger)
#             return Response({
#                 "message": "Booking created successfully",
#                 "booking_id": booking.id
#             }, status=201)

#         return Response(serializer.errors, status=400)
    
# class AcceptBookingView(APIView):
#     def post(self, request):
#         token = request.COOKIES.get('jwt')

#         if not token:
#             raise AuthenticationFailed('Authentication token is missing')

#         try:
#             payload = jwt.decode(token, 'secret', algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         driver = Driver.objects.filter(id=payload['id']).first()
#         if driver is None:
#             raise AuthenticationFailed('Driver not found')

#         booking_id = request.data.get('booking_id')
#         if not booking_id:
#             return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)

#         try:
#             booking = Booking.objects.get(id=booking_id)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

#         if driver in booking.accepted_drivers.all():
#             return Response({'message': 'You have already accepted this booking'}, status=status.HTTP_400_BAD_REQUEST)

#         booking.accepted_drivers.add(driver)
#         booking.save()

#         return Response({
#             "message": "Booking accepted successfully",
#             "booking_id": booking.id
#         }, status=status.HTTP_200_OK)


# class GetAcceptedDriversView(APIView):
#     def post(self, request):
#         token = request.COOKIES.get('jwt')

#         if not token:
#             raise AuthenticationFailed('Authentication token is missing')

#         try:
#             payload = jwt.decode(token, 'secret', algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         passenger = Passenger.objects.filter(id=payload['id']).first()
#         if passenger is None:
#             raise AuthenticationFailed('Passenger not found')

#         booking_id = request.data.get('booking_id')
#         if not booking_id:
#             return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)

#         try:
#             booking = Booking.objects.get(id=booking_id, passenger=passenger)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found or does not belong to you'}, status=status.HTTP_404_NOT_FOUND)

#         drivers = booking.accepted_drivers.all()
#         driver_list = [{"id": driver.id, "name": driver.name, "phone": driver.phone} for driver in drivers]

#         return Response({
#             "booking_id": booking.id,
#             "accepted_drivers": driver_list
#         }, status=status.HTTP_200_OK)


# class SelectDriverView(APIView):
#     def post(self, request):
#         token = request.COOKIES.get('jwt')

#         if not token:
#             raise AuthenticationFailed('Authentication token is missing')

#         try:
#             payload = jwt.decode(token, 'secret', algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         passenger = Passenger.objects.filter(id=payload['id']).first()
#         if passenger is None:
#             raise AuthenticationFailed('Passenger not found')

#         booking_id = request.data.get('booking_id')
#         driver_id = request.data.get('driver_id')

#         if not booking_id or not driver_id:
#             return Response({'error': 'Booking ID and Driver ID are required'}, status=status.HTTP_400_BAD_REQUEST)

#         try:
#             booking = Booking.objects.get(id=booking_id, passenger=passenger)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found or does not belong to you'}, status=status.HTTP_404_NOT_FOUND)

#         try:
#             selected_driver = Driver.objects.get(id=driver_id)
#         except Driver.DoesNotExist:
#             return Response({'error': 'Driver not found'}, status=status.HTTP_404_NOT_FOUND)

#         if selected_driver not in booking.accepted_drivers.all():
#             return Response({'error': 'This driver has not accepted the booking'}, status=status.HTTP_400_BAD_REQUEST)

#         booking.driver = selected_driver
#         booking.status = 'driver_selected'
#         booking.save()

#         return Response({
#             "message": "Driver selected successfully",
#             "selected_driver": {
#                 "id": selected_driver.id,
#                 "name": selected_driver.name,
#                 "phone": selected_driver.phone
#             }
#         }, status=status.HTTP_200_OK)

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
# class AcceptBookingView(APIView):
#     def post(self, request, booking_id):
#         token = request.COOKIES.get('jwt')

#         if not token:
#             raise AuthenticationFailed('Authentication token is missing')

#         try:
#             payload = jwt.decode(token, 'secret', algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         driver = Driver.objects.filter(id=payload['id']).first()
#         if driver is None:
#             raise AuthenticationFailed('Driver not found')

#         try:
#             booking = Booking.objects.get(id=booking_id)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

#         if driver in booking.accepted_drivers.all():
#             return Response({'message': 'You have already accepted this booking'}, status=status.HTTP_400_BAD_REQUEST)

#         booking.accepted_drivers.add(driver)
#         booking.save()

#         return Response({
#             "message": "Booking accepted successfully",
#             "booking_id": booking.id
#         }, status=status.HTTP_200_OK)
    

# class GetAcceptedDriversView(APIView):
#     def get(self, request, booking_id):
#         token = request.COOKIES.get('jwt')

#         if not token:
#             raise AuthenticationFailed('Authentication token is missing')

#         try:
#             payload = jwt.decode(token, 'secret', algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         passenger = Passenger.objects.filter(id=payload['id']).first()
#         if passenger is None:
#             raise AuthenticationFailed('Passenger not found')

#         try:
#             booking = Booking.objects.get(id=booking_id, passenger=passenger)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found or does not belong to you'}, status=status.HTTP_404_NOT_FOUND)

#         drivers = booking.accepted_drivers.all()
#         driver_list = [{"id": driver.id, "name": driver.name, "phone": driver.phone} for driver in drivers]

#         return Response({
#             "booking_id": booking.id,
#             "accepted_drivers": driver_list
#         }, status=status.HTTP_200_OK)


# class SelectDriverView(APIView):
#     def post(self, request, booking_id):
#         token = request.COOKIES.get('jwt')

#         if not token:
#             raise AuthenticationFailed('Authentication token is missing')

#         try:
#             payload = jwt.decode(token, 'secret', algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             raise AuthenticationFailed('Token has expired')
#         except jwt.InvalidTokenError:
#             raise AuthenticationFailed('Invalid token')

#         passenger = Passenger.objects.filter(id=payload['id']).first()
#         if passenger is None:
#             raise AuthenticationFailed('Passenger not found')

#         try:
#             booking = Booking.objects.get(id=booking_id, passenger=passenger)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found or does not belong to you'}, status=status.HTTP_404_NOT_FOUND)

#         driver_id = request.data.get('driver_id')
#         try:
#             selected_driver = Driver.objects.get(id=driver_id)
#         except Driver.DoesNotExist:
#             return Response({'error': 'Driver not found'}, status=status.HTTP_404_NOT_FOUND)

#         if selected_driver not in booking.accepted_drivers.all():
#             return Response({'error': 'This driver has not accepted the booking'}, status=status.HTTP_400_BAD_REQUEST)

#         booking.selected_driver = selected_driver
#         booking.status = 'driver_selected'
#         booking.save()

#         return Response({
#             "message": "Driver selected successfully",
#             "selected_driver": {
#                 "id": selected_driver.id,
#                 "name": selected_driver.name,
#                 "phone": selected_driver.phone
#             }
#         }, status=status.HTTP_200_OK)

