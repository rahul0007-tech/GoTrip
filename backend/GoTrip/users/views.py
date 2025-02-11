from .models import Passenger, Driver
from .serializers import ChangePasswordSerilizer, CreatePassengerSerializer, DriverLoginSerializer, PassengerLoginSerializer, PassengerProfileSerializer, PasswordResetSerializer, SendPasswordResetEmailSerializer, VerifyOTPSerializer, CreateDriverSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.conf import settings
import random
from rest_framework.exceptions import AuthenticationFailed
from datetime import datetime, timezone, timedelta
import jwt
from django.contrib.auth import authenticate
# from users.renderers import UserRenderer
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated

# Create your views here.
def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)

    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }


def send_otp_email(email, otp):
    try:
        subject = "Your Registration OTP"
        message = f"""
        Your OTP for registration is: {otp}
        Please use this to complete your registration.
        This OTP will expire in 10 minutes.
        """
        send_mail(subject, message, settings.EMAIL_HOST_USER, [email])
        return True
    except Exception:
        return False
    


class CreatePassengerView(APIView):
    def generate_otp(self):
        return str(random.randint(10000, 99999))

    def post(self, request):
        serializer = CreatePassengerSerializer(data=request.data)
        if serializer.is_valid():
            otp = self.generate_otp()
            passenger = serializer.save()
            passenger.otp = otp
            passenger.save()

            email_sent = send_otp_email(passenger.email, otp)
            message = 'Registration successful! Please check your email for OTP.' if email_sent else 'Registration successful but OTP email failed.'
            
            return Response({'message': message, 'data': serializer.data}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class ResendOTPView(APIView):
    def generate_otp(self):
        return str(random.randint(10000, 99999))

    def post(self, request):
        email = request.data.get('email')        
        try:
            passenger = Passenger.objects.get(email=email, isVerified=False)
            otp = self.generate_otp()
            
            # Update user with new OTP
            passenger.otp = otp
            passenger.save()
            
            # Send new OTP
            email_sent = send_otp_email(email, otp)
            
            if email_sent:
                return Response({
                    'message': 'New OTP sent successfully!'
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    'error': 'Failed to send OTP email'
                }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                
        except Passenger.DoesNotExist:
            return Response({
                'error': 'User not found or already verified'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class VerifyOTPView(APIView):
    def post(self, request):
        serializer = VerifyOTPSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            otp = serializer.validated_data['otp']
            try:
                passenger = Passenger.objects.get(email=email, otp=otp)
                passenger.isVerified = True
                passenger.otp = None  # Clear OTP after verification
                passenger.save()
                return Response({'message': 'Email verified successfully!'}, status=status.HTTP_200_OK)
            except Passenger.DoesNotExist:
                return Response({'error': 'Invalid OTP or email'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginPassengerView(APIView):
    def post(self, request):
        serializer = PassengerLoginSerializer(data = request.data)
        if serializer.is_valid(raise_exception=True):
            email = serializer.data.get('email')
            password = serializer.data.get('password')
            user = authenticate(email= email, password=password)
            if user is not None:
                token = get_tokens_for_user(user)
                return Response({'token':token,'msg':'Login success'}, status= status.HTTP_200_OK)
            else:
                return Response({'errors':{'non_field_errors':['Email or Password is not valid']}}, status=status.HTTP_404_NOT_FOUND)

        return Response({'msg':'Login success'}, status= status.HTTP_200_OK)
    

class PassengerProfileView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        serializer = PassengerProfileSerializer(request.user)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class ChnagePasswordView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        serializer = ChangePasswordSerilizer(data = request.data, context={'user':request.user})
        if serializer.is_valid(raise_exception=True):
            return Response ({'msg':'Password Changed Successfully'}, status= status.HTTP_200_OK)
        return Response (serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LogoutView(APIView):
    def post(self, request):
        return Response({'message': 'Logged out successfully'}, status=status.HTTP_200_OK)


class CreateDriverView(APIView):
    def post(self, request):
        serializer = CreateDriverSerializer(data=request.data)
        if serializer.is_valid():
            driver = serializer.save()
            return Response({'message': 'Driver registered successfully', 'driver_id': driver.id}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginDriverView(APIView):
    def post(self, request):
        serializer = DriverLoginSerializer(data = request.data)
        if serializer.is_valid(raise_exception=True):
            email = serializer.data.get('email')
            password = serializer.data.get('password')
            user = authenticate(email= email, password=password)
            if user is not None:
                token = get_tokens_for_user(user)
                return Response({'token':token,'msg':'Login success'}, status= status.HTTP_200_OK)
            else:
                return Response({'errors':{'non_field_errors':['Email or Password is not valid']}}, status=status.HTTP_404_NOT_FOUND)

        return Response({'msg':'Login success'}, status= status.HTTP_200_OK)
    

class SendPasswordEmailView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure only authenticated users can access this

    def post(self, request, format=None):
        serializer = SendPasswordResetEmailSerializer(data={}, context={'request': request})  # Pass request in context
        if serializer.is_valid(raise_exception=True):
            return Response({'msg': 'Password reset link sent. Please check your email.'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class PasswordResetView(APIView):
    def post(self, request, uid, token, format=None):
        serializer = PasswordResetSerializer(data = request.data, context={'uid':uid, 'token':token})
        if serializer.is_valid(raise_exception=True):
            return Response({'msg':'Password Reset successfully'}, status=status.HTTP_200_OK)
        return Response (serializer.errors, status=status.HTTP_400_BAD_REQUEST)


