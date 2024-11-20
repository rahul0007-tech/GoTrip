from rest_framework import generics, status
from .serializers import CreatePassengerSerializers, VerifyPassengerOtp, PassengerLogin, DriverSerializer, PassengerProfileSerilizer, DriverLoginSerializer
from .models import Passenger, Driver, Vehicle
from rest_framework.views import APIView
from rest_framework.response import Response



class CreatePassenger(generics.CreateAPIView):
    queryset = Passenger.objects.all()
    serializer_class = CreatePassengerSerializers

class RetrivePassenger(generics.RetrieveAPIView):
    queryset = Passenger.objects.all()
    serializer_class = PassengerProfileSerilizer
    lookup_field = 'id'

class VerifyOtpView(APIView):
    def post(self, request):
        serializer = VerifyPassengerOtp(data = request.data)

        if serializer.is_valid():
            serializer.save()
            return Response({'message':'Passenger verified successfully!'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class PassengerLoginView(APIView):
    def post(self, request):
        serializer = PassengerLogin(data = request.data)
        if serializer.is_valid():
            return Response({'message': 'Login successful'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class CreateDriver(generics.CreateAPIView):
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer

class DriverLoginView(APIView):
    def post(self, request):
        serializer = DriverLoginSerializer(data = request.data)

        if serializer.is_valid():
            return Response({'meassage': 'Driver Login Successful'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)