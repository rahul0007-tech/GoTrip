from rest_framework import generics, status, serializers
from .serializers import CreatePassengerSerializers, VerifyPassengerOtp, PassengerLogin, DriverSerializer, DriverLoginSerializer, BookingSerializer,BookingSerializer, AcceptBookingSerializer, SelectDriverSerializer
from .models import Passenger, Driver, Vehicle, Booking
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.tokens import RefreshToken


# from django.contrib.auth.models import User




class CreatePassenger(generics.CreateAPIView):
    permission_classes = [AllowAny]
    queryset = Passenger.objects.all()
    serializer_class = CreatePassengerSerializers


class VerifyOtpView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = VerifyPassengerOtp(data = request.data)

        if serializer.is_valid():
            serializer.save()
            return Response({'message':'Passenger verified successfully!'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class PassengerLoginView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = PassengerLogin(data = request.data)
        if serializer.is_valid():
            Passenger = serializer.validated_data
            refresh = RefreshToken.for_user(Passenger) 
            # user = User.objects.get(email=Passenger.PassengerEmail)
            # refresh = RefreshToken.for_user(Passenger.user)
            return Response({'message': 'Login successful', 'access_token':str(refresh.access_token), 'refresh_token':str(refresh)}, status=status.HTTP_200_OK )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)




    
# class LogoutView(APIView):
#     parser_classes = [IsAuthenticated]
#     def post(self, request):
#         try:
#             refresh_token = request.data.get('refresh')
#             token = RefreshToken(refresh_token)
#             token.blacklist()
#             return Response({'message':'Logout sucessfully'}, status=200)
#         except Exception as e:
#             return Response({'message':str(e)}, status=400)

class LogoutView(APIView):
    # No permission class required here since logout works with refresh tokens
    def post(self, request):
        try:
            refresh_token = request.data.get('refresh')  # Get refresh token from the request body
            token = RefreshToken(refresh_token)  # Decode the refresh token
            token.blacklist()  # If blacklisting is not enabled, this won't affect anything
            return Response({'message': 'Logout successful'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'message': str(e)}, status=status.HTTP_400_BAD_REQUEST)


class CreateDriver(generics.CreateAPIView):
    permission_classes = [AllowAny]
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer

class DriverLoginView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = DriverLoginSerializer(data = request.data)

        if serializer.is_valid():
            driver = serializer.validated_data
            refresh = RefreshToken.for_user(driver) 
            return Response({'meassage': 'Driver Login Successful','access_token':str(refresh.access_token), 'refresh_token':str(refresh)}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    




# Create Booking
# class CreateBookingView(generics.CreateAPIView):
#     permission_classes = [AllowAny]
#     serializer_class = BookingSerializer

#     def post(self, request):
#         serializer = self.get_serializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response({'message': 'Booking created successfully', 'data': serializer.data}, status=status.HTTP_201_CREATED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# class CreateBookingView(generics.CreateAPIView):
#     permission_classes = [IsAuthenticated]  # Only authenticated users can create bookings
#     serializer_class = BookingSerializer

#     def post(self, request):
#         # Ensure request.user is the passenger
#         passenger = request.user

#         # Add passenger to the request data
#         booking_data = request.data.copy()
#         booking_data['passenger'] = passenger.id

#         # Pass updated data to serializer
#         serializer = self.get_serializer(data=booking_data)

#         if serializer.is_valid():
#             serializer.save()
#             # Notify drivers logic here
#             self.notify_drivers()
#             return Response({'message': 'Booking created successfully', 'data': serializer.data}, status=status.HTTP_201_CREATED)

#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#     def notify_drivers(self):
#         # Placeholder logic for notifying all registered drivers
#         drivers = Driver.objects.all()
#         for driver in drivers:
#             print(f"Notification sent to Driver: {driver.driverEmail}")  # Replace with actual notification logic



class CreateBookingView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = BookingSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            booking = serializer.save()
            return Response({
                "message": "Booking successfully created ",
                "booking_id": booking.id,
                "fare": booking.fare
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


















































# Update Booking Status
class UpdateBookingStatusView(generics.UpdateAPIView):
    serializer_class = BookingSerializer
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        try:
            booking = Booking.objects.get(pk=pk)
        except Booking.DoesNotExist:
            return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.get_serializer(booking, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Booking status updated successfully'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# Accept Booking Request
class AcceptBookingRequestView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = AcceptBookingSerializer

    def post(self, request, pk):
        try:
            booking = Booking.objects.get(pk=pk)
        except Booking.DoesNotExist:
            return Response({'error': 'Booking not found or already processed'}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.get_serializer()
        try:
            serializer.update(booking, request.user)
            return Response({'message': 'Booking request accepted'}, status=status.HTTP_200_OK)
        except serializers.ValidationError as e:
            return Response(e.detail, status=status.HTTP_400_BAD_REQUEST)


# Select Driver for Booking
class SelectDriverView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = SelectDriverSerializer

    def get(self, request, pk):
        """Retrieve all accepted drivers for a booking."""
        try:
            booking = Booking.objects.get(pk=pk)
        except Booking.DoesNotExist:
            return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

        drivers = booking.accepted_drivers.all()
        driver_data = DriverSerializer(drivers, many=True).data
        return Response({'drivers': driver_data}, status=status.HTTP_200_OK)

    def post(self, request, pk):
        """Select a driver for the booking."""
        try:
            booking = Booking.objects.get(pk=pk)
        except Booking.DoesNotExist:
            return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.update(booking, serializer.validated_data)
            return Response({'message': 'Driver selected successfully'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)









    
class Check (generics.ListCreateAPIView):
    pass

class Check2(generics.RetrieveUpdateDestroyAPIView):
    pass








# class CreateBookingView(APIView):
#     permission_classes = [AllowAny]
#     def post(self, request):
#         serializer = BookingSerializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save()  # Create the booking
#             return Response({'message': 'Booking created successfully', 'data': serializer.data}, status=status.HTTP_201_CREATED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# class UpdateBookingStatusView(APIView):
#     def patch(self, request, pk):
#         try:
#             booking = Booking.objects.get(pk=pk)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)
        
#         status_update = request.data.get('status')
#         if status_update in ['confirmed', 'completed', 'canceled']:
#             booking.status = status_update
#             booking.save()
#             return Response({'message': 'Booking status updated successfully'}, status=status.HTTP_200_OK)
#         return Response({'error': 'Invalid status'}, status=status.HTTP_400_BAD_REQUEST)
    
# class AcceptBookingRequestView(APIView):
#     def post(self, request, pk):
#         try:
#             booking = Booking.objects.get(pk=pk, status='requested')
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found or already processed'}, status=status.HTTP_404_NOT_FOUND)
        
#         driver = request.user  # Assuming the driver is authenticated
#         booking.accepted_drivers.add(driver)
#         booking.status = 'accepted'  # Update status
#         booking.save()
#         return Response({'message': 'Booking request accepted'}, status=status.HTTP_200_OK)


# class SelectDriverView(APIView):
#     def get(self, request, pk):
#         try:
#             booking = Booking.objects.get(pk=pk)
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

#         drivers = booking.accepted_drivers.all()
#         driver_data = DriverSerializer(drivers, many=True).data
#         return Response({'drivers': driver_data}, status=status.HTTP_200_OK)

#     def post(self, request, pk):
#         try:
#             booking = Booking.objects.get(pk=pk, status='accepted')
#         except Booking.DoesNotExist:
#             return Response({'error': 'Booking not found or already processed'}, status=status.HTTP_404_NOT_FOUND)
        
#         driver_id = request.data.get('driver_id')
#         try:
#             driver = Driver.objects.get(pk=driver_id)
#         except Driver.DoesNotExist:
#             return Response({'error': 'Driver not found'}, status=status.HTTP_404_NOT_FOUND)
        
#         booking.driver = driver  # Assign the driver
#         booking.status = 'driver_selected'
#         booking.save()

#         # Notify the selected driver (pseudo-code for now)
#         # notify_driver(booking, driver)

#         return Response({'message': 'Driver selected successfully'}, status=status.HTTP_200_OK)



# class LoginView(APIView):
#     permission_classes = [AllowAny]

#     def post(self, request):
#         serializer = UniversalLoginSerializer(data=request.data)
#         if serializer.is_valid():
#             user = serializer.validated_data['user']
#             user_type = request.data['user_type']

#             # Generate JWT tokens
#             refresh = RefreshToken.for_user(user)

#             # Include custom claims (e.g., user type)
#             refresh['user_type'] = user_type
#             refresh['email'] = user.passengerEmail if user_type == 'passenger' else user.driverEmail

#             return Response({
#                 'message': f'{user_type.capitalize()} login successful',
#                 'access_token': str(refresh.access_token),
#                 'refresh_token': str(refresh),
#             }, status=status.HTTP_200_OK)

#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)