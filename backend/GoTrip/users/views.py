from django.shortcuts import get_object_or_404
from .models import Driver, Passenger
from .serializers import ChangePasswordSerilizer, CreatePassengerSerializer, DriverLoginSerializer, DriverProfileSerializer, PassengerLoginSerializer, PassengerProfileSerializer, VerifyOTPSerializer, CreateDriverSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.conf import settings
import random
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated, AllowAny
from datetime import datetime, timedelta
from rest_framework.parsers import MultiPartParser, FormParser

from bookings.models import Booking

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
    
def send_password_reset_email(email, otp):
    try:
        subject = "Your Password Reset OTP"
        message = f"""
        Your OTP for password reset is: {otp}
        Please use this to complete your password reset.
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
            passenger.otp_created_at = datetime.now()  # Store OTP generation time
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
            
            # Update user with new OTP and timestamp
            passenger.otp = otp
            passenger.otp_created_at = datetime.now()  # Update OTP generation time
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
                # Check if OTP is expired
                # if datetime.now() > passenger.otp_created_at + timedelta(minutes=5):
                #     return Response({'error': 'OTP has expired'}, status=status.HTTP_400_BAD_REQUEST)
                
                passenger.isVerified = True
                passenger.otp = None  # Clear OTP after verification
                passenger.otp_created_at = None  # Clear OTP timestamp
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
                passenger = get_object_or_404(Passenger, id = user.id)
                if not passenger:
                    return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
                if passenger.isVerified == False:
                    return Response({'error':'Sorry you are still not verified please verify your email first'})
                token = get_tokens_for_user(user)
                return Response({'token':token,'msg':'Login success'}, status= status.HTTP_200_OK)
            else:
                return Response({'errors':{'non_field_errors':['Email or Password is not valid']}}, status=status.HTTP_404_NOT_FOUND)
        return Response(serializer.errors, status= status.HTTP_400_BAD_REQUEST)
    

class PassengerProfileView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        try:
            passenger = Passenger.objects.get(pk=request.user.pk)
        except Passenger.DoesNotExist:
            return Response(
                {"detail": "Passenger profile not found."},
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = PassengerProfileSerializer(passenger,context={'request':request})
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class ChnagePasswordView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        serializer = ChangePasswordSerilizer(data = request.data, context={'user':request.user})
        if serializer.is_valid(raise_exception=True):
            return Response ({'msg':'Password Changed Successfully'}, status= status.HTTP_200_OK)
        return Response (serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
# class ForgotPasswordView(APIView):
#     def generate_otp(self):
#         return str(random.randint(10000, 99999))

#     def post(self, request):
#         serializer = SendPasswordResetEmailSerializer(data=request.data)
#         if serializer.is_valid():
#             email = serializer.validated_data['email']
#             try:
#                 user = User.objects.get(email=email)
#                 otp = self.generate_otp()
                
#                 # Save OTP and its timestamp
#                 user.otp = otp
#                 user.otp_created_at = datetime.now()
#                 user.save()
                
#                 # Send OTP email
#                 email_sent = send_password_reset_email(email, otp)
                
#                 if email_sent:
#                     return Response({
#                         'message': 'Password reset OTP has been sent to your email'
#                     }, status=status.HTTP_200_OK)
#                 else:
#                     return Response({
#                         'error': 'Failed to send OTP email'
#                     }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                    
#             except User.DoesNotExist:
#                 return Response({
#                     'error': 'No user found with this email'
#                 }, status=status.HTTP_404_NOT_FOUND)
                
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# class PasswordResetView(APIView):
#     def post(self, request):
#         serializer = PasswordChangeSerializer(data=request.data)
#         if serializer.is_valid():
#             email = serializer.validated_data['email']
#             otp = serializer.validated_data['otp']
#             new_password = serializer.validated_data['new_password']
            
#             try:
#                 user = User.objects.get(email=email, otp=otp)
                
#                 # Check if OTP is expired (5 minutes validity)
#                 if datetime.now() > user.otp_created_at + timedelta(minutes=5):
#                     return Response({
#                         'error': 'OTP has expired'
#                     }, status=status.HTTP_400_BAD_REQUEST)
                
#                 # Reset password
#                 user.set_password(new_password)
#                 user.otp = None  # Clear OTP
#                 user.otp_created_at = None  # Clear OTP timestamp
#                 user.save()
                
#                 return Response({
#                     'message': 'Password reset successful'
#                 }, status=status.HTTP_200_OK)
                
#             except User.DoesNotExist:
#                 return Response({
#                     'error': 'Invalid OTP or email'
#                 }, status=status.HTTP_400_BAD_REQUEST)
                
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# class LogoutView(APIView):
#     def post(self, request):
#         try:
#             refresh_token = request.data.get('refresh_token')
#             token = RefreshToken(refresh_token)
#             # logout the user by expire the refresh token
#             token.blacklist()
        
#         except Exception as e:
#             return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)
#         return Response({'message': 'Logged out successfully'}, status=status.HTTP_200_OK)


class CreateDriverView(APIView):
    parser_classes = (MultiPartParser, FormParser)
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
                driver = get_object_or_404(Driver, id = user.id)
                if driver.isVerified == False:
                    return Response({'error':'Sorry you are still not verified please hold till admin verifies you'})
                if not driver:
                    return Response({'error':'Invalid token or token has expired'}, status=status.HTTP_400_BAD_REQUEST)
                token = get_tokens_for_user(user)
                return Response({'token':token,'msg':'Login success'}, status= status.HTTP_200_OK)
            else:
                return Response({'errors':{'non_field_errors':['Email or Password is not valid']}}, status=status.HTTP_404_NOT_FOUND)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    

class SendPasswordEmailView(APIView): 
    def post(self, request, format=None):
        serializer = SendPasswordResetEmailSerializer(data=request.data)  # Pass request in context
        if serializer.is_valid(raise_exception=True):
            return Response({'msg': 'Password reset link sent. Please check your email.'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
# class PasswordResetView(APIView):
#     def post(self, request, uid, token, format=None):
#         serializer = PasswordResetSerializer(data = request.data, context={'uid':uid, 'token':token})
#         if serializer.is_valid(raise_exception=True):
#             return Response({'msg':'Password Reset successfully'}, status=status.HTTP_200_OK)
#         return Response (serializer.errors, status=status.HTTP_400_BAD_REQUEST)




class DriverProfileView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        try:
            driver = Driver.objects.get(pk=request.user.pk)
        except Driver.DoesNotExist:
            return Response(
                {"detail": "Driver profile not found."},
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = DriverProfileSerializer(driver,context={'request':request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class ChangeDriverStatusView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        driver = get_object_or_404(Driver, id=request.user.id)
        if driver.status == 'busy':
            driver.status = 'free'
        else:
            driver.status = 'busy'
        driver.save()
        return Response({'status':'success','message': 'Driver status updated successfully','data': driver.status}, status=status.HTTP_200_OK)



