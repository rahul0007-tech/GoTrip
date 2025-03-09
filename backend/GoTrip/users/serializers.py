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
        fields = ['name', 'phone','email','password','status']
        
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
    email = serializers.EmailField(max_length=255)
    class Meta:
        fields = ['email']
    def validate(self, attrs):
        email = attrs.get('email')

        if User.objects.filter(email=email).exists():
            user = User.objects.get(email=email)
            uid = urlsafe_base64_encode(force_bytes(user.id))
            token = PasswordResetTokenGenerator().make_token(user)
            link = f'http://0.0.0.0:8000/user/reset-password/{uid}/{token}'
            print(link)

            body = f'Click the following link to reset your password: {link}'
            data = {
                'subject': 'Reset Your Password',
                'body': body,
                'to_email': user.email
            }

            Util.send_email(data)
            return attrs
        else:
            raise ValidationError("You are not a registered user yet")
        
class PasswordResetSerializer(serializers.Serializer):
    oldPassword = serializers.CharField(max_length = 255, style={'input_type':'password'}, write_only = True)
    password = serializers.CharField(max_length = 255, style={'input_type':'password'}, write_only = True)
    password2 = serializers.CharField(max_length = 255, style={'input_type':'password'}, write_only = True)
    class Meta:
        fields = ['password','password2']
    def validate(self, attrs):
        oldPassword = attrs.get('oldPassword')
        password = attrs.get('password')
        password2 = attrs.get('password2')
        uid = self.context.get('uid')
        token = self.context.get('token')
        try:
            user_id = smart_str(urlsafe_base64_decode(uid))
            user = User.objects.get(id=user_id)
            if not PasswordResetTokenGenerator().check_token(user, token):
                raise ValidationError('Token is not Valid or Expired')
            if not user.check_password(oldPassword):
                raise serializers.ValidationError("Please Enter correct password")
            if password != password2:
                raise serializers.ValidationError("password and confirm password must be same")
            if user.check_password(password):
                raise serializers.ValidationError("New password must be different from the old password.")
            self.user = user
        
            user.set_password(password)
            user.save()
            return attrs
        except DjangoUnicodeDecodeError as identifier:
            PasswordResetTokenGenerator().check_token(user,token)
            raise ValidationError('Token is not Valid or Expired')


 

    



