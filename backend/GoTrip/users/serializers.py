from rest_framework import serializers
from django.forms import ValidationError
from users.utils import Util
from .models import Passenger, Driver, User
from django.core.validators import MinLengthValidator
from django.utils.encoding import smart_str, force_bytes, DjangoUnicodeDecodeError
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from django.contrib.auth.tokens import PasswordResetTokenGenerator


class CreatePassengerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Passenger
        fields = ['name', 'phone', 'email', 'password', 'photo']
        extra_kwargs = {
            'password': {'write_only': True},
            'name': {'validators': [MinLengthValidator(2)]},
        }


    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        
        if password is not None:
            instance.set_password(password)
        instance.save()

        if password is None:
            serializers.ValidationError("Password cannot be null")
        return instance

class VerifyOTPSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6)

class PassengerLoginSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(max_length = 255)
    class Meta:
        model = Passenger
        fields = ['email', 'password']

class PassengerProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Passenger
        fields = ['id', 'email', 'name', 'phone','photo', 'Created_at', 'updated_at']
    def get_photo(self, obj):
        request = self.context.get('request')
        if obj.photo:
            return request.build_absolute_uri(obj.photo.url)
        return None

class CreateDriverSerializer(serializers.ModelSerializer):
    class Meta:
        model = Driver
        fields = ['name', 'phone','email','password','status', 'license']
        
    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        
        if password is not None:
            instance.set_password(password)
        instance.save()
        return instance
    
class DriverLoginSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(max_length = 255)
    class Meta:
        model = Driver
        fields = ['email', 'password']

class DriverProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Driver
        fields = ['id', 'email', 'name', 'phone','photo','license','status', 'Created_at', 'updated_at']
    def get_photo(self, obj):
        request = self.context.get('request')
        if obj.photo:
            return request.build_absolute_uri(obj.photo.url)
        return None
    def get_license(self, obj):
        request = self.context.get('request')
        if obj.license:
            return request.build_absolute_uri(obj.license.url)
        return None

class ChangePasswordSerilizer(serializers.Serializer):
    oldPassword = serializers.CharField(max_length = 255, style={'input_type':'password'}, write_only = True)
    password = serializers.CharField(max_length = 255, style={'input_type':'password'}, write_only = True)
    password2 = serializers.CharField(max_length = 255, style={'input_type':'password'}, write_only = True)
    class Meta:
        fields = ['password','password2']
    def validate(self, attrs):
        oldPassword = attrs.get('oldPassword')
        password = attrs.get('password')
        password2 = attrs.get('password2')
        user = self.context.get('user')
        if not user.check_password(oldPassword):
            raise serializers.ValidationError("Please Enter correct password")
        if password != password2:
            raise serializers.ValidationError("password and confirm password must be same")
        if user.check_password(password):
            raise serializers.ValidationError("New password must be different from the old password.")
        user.set_password(password)
        user.save()
        return attrs

class SendPasswordResetEmailSerializer(serializers.Serializer):
    email = serializers.EmailField()

    def validate(self, attrs):
        email = attrs.get('email')
        if not User.objects.filter(email=email).exists():
            raise serializers.ValidationError('No user found with this email')
        return attrs

class PasswordChangeSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField()
    new_password = serializers.CharField(style={'input_type': 'password'})
    confirm_password = serializers.CharField(style={'input_type': 'password'})

    def validate(self, attrs):
        if attrs['new_password'] != attrs['confirm_password']:
            raise serializers.ValidationError('Passwords do not match')
        return attrs

class DriverDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Driver
        fields = ['id', 'email', 'name', 'phone','status']








