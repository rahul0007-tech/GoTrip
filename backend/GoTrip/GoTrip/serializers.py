from rest_framework import serializers
from . models import Passenger, Driver, Vehicle
from django.contrib.auth.hashers import make_password, check_password
import random
from django.core.mail import send_mail
from django.conf import settings

class  CreatePassengerSerializers(serializers.ModelSerializer):
    class Meta():
        model = Passenger
        fields = ['passengerName','passengerPhone','passengerEmail','passengerPassword','passengerPhoto']

    def create(self, validated_data):
        otp = str(random.randint(10000,99999))
        validated_data['passengerPassword'] = make_password(validated_data['passengerPassword'])

        def passengerOtpMail():
            subject = "Your OTP for GoTrip registration"
            message = f"hi {passenger.passengerName} \n\n Your OTP for the registration of GoTrip is: {passenger.passengerOtp}. Use it to verify your account"
            send_mail(subject, message, settings.EMAIL_HOST_USER, [passenger.passengerEmail])

        passenger = Passenger.objects.create(
            passengerName = validated_data['passengerName'],
            passengerPhone = validated_data['passengerPhone'],
            passengerEmail = validated_data['passengerEmail'],
            passengerPassword = validated_data['passengerPassword'],
            passengerPhoto = validated_data.get('passengerPhoto', None),
            passengerOtp = otp,
            passengerVerified = False
        )

        # passenger.sendOtp()
        passengerOtpMail()

        return passenger
        
# class VerifyPassengerOtp(serializers.Serializer):
#     passengerEmail = serializers.EmailField()
#     passengerOtp = serializers.CharField(max_length=6)

#     def validate(self, data):
#         try:
#             passenger = Passenger.objects.get(passengerEmail=data['passengerEmail'], passengerOtp = data['passengerOtp'])
            
#             if passenger.passengerOtp != data['passengerOtp']:
#                 raise serializers.ValidationError('Incorrect OTP')
#         except Passenger.DoesNotExist:
#             raise serializers.ValidationError('Invalid Credentials')
        
#         return data

class VerifyPassengerOtp(serializers.ModelSerializer):
    class Meta:
        model = Passenger
        fields = ['passengerEmail', 'passengerOtp']
    
    def validate(self, data):
        try:
            passenger = Passenger.objects.get(passengerEmail = data['passengerEmail'], passengerOtp = data['passengerOtp'])
            if passenger.passengerOtp != data['passengerOtp']:
                raise serializers.ValidationError("Incorrect Otp")
        except Passenger.DoesNotExist:
            raise serializers.ValidationError('Invalid Email')
        return data
    

    def save(self):
        passenger = Passenger.objects.get(passengerEmail=self.validated_data['passengerEmail'])
        passenger.passengerVerified=True
        passenger.passengerOtp = None
        passenger.save()
        return passenger



# class PassengerLogin(serializers.Serializer):
#     passengerEmail = serializers.EmailField()
#     passengerPassword = serializers.CharField(write_only=True)
        

#     def validate(self, data):

#             try:
#                 passenger = Passenger.objects.get(passengerEmail=data['passengerEmail'])
#             except Passenger.DoesNotExist:
#                 raise serializers.ValidationError("Invalid Email")
        

#             if passenger and check_password(data['passengerPassword'], passenger.passengerPassword):
#                 if passenger.passengerVerified:
#                     return passenger
#                 else:
#                     raise serializers.ValidationError("Sorry You are not verified")
#             raise serializers.ValidationError("Incorrect Password")
    

class PassengerLogin(serializers.ModelSerializer):
    passengerPassword = serializers.CharField(write_only = True)
    class Meta:
        model = Passenger
        fields = ['passengerEmail', 'passengerPassword']
    
    def validate(self, data):
        try:
            passenger = Passenger.objects.get(passengerEmail = data['passengerEmail'])
        except Passenger.DoesNotExist:
            raise serializers.ValidationError("Invalid Email")
        
        if passenger and check_password(data['passengerPassword'], passenger.passengerPassword):
            if passenger.passengerVerified:
                return passenger
            else:
                raise serializers.ValidationError("Sorry Passenger Is Not Verified")
        else:
            raise serializers.ValidationError("Incorrect Password")


class VehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        fields = ['vehicleColor','vehicleCompany', 'vehicleType','vehicleFuelType','vehicleNumber']

class DriverSerializer(serializers.ModelSerializer):
    # Nesting the VehicleSerializer inside the DriverSerializer
    vehicle = VehicleSerializer()

    class Meta:
        model = Driver
        fields = ['driverName', 'driverEmail', 'driverPhoneNumber', 'lisenceImage', 'driverPassword', 'driverStatus', 'vehicle']

    def create(self, validated_data):
        # Extracting vehicle data
        vehicle_data = validated_data.pop('vehicle')
        
        driverPassword = validated_data.pop('driverPassword')
        
        # Creating the driver object
        driver = Driver.objects.create(**validated_data, driverPassword=make_password(driverPassword))
        
        # Creating the associated vehicle
        vehicle=Vehicle.objects.create( **vehicle_data, relation=driver)
        
        return driver
    


# class DriverLoginSerializer(serializers.Serializer):
#     driverEmail = serializers.EmailField()
#     driverPassword = serializers.CharField(write_only = True)

#     def validate(self, data):
#         try:
#             driver = Driver.objects.get(driverEmail = data['driverEmail'])
#         except Driver.DoesNotExist:
#             raise serializers.ValidationError("Invalid Email")        
#         if driver and check_password(data['driverPassword'], driver.driverPassword):
#             if driver.driverVerification:
#                 return(driver)
#             else:
#                 raise serializers.ValidationError("Sorry driver is still not verified")
#         else:
#             raise serializers.ValidationError("Incorrect Password")


#---------------------------------------Note: serializer class maa check password maa paila models.field ani data['field'] hunxa vane meta use garda paila data['field'] ani balla models.field


class DriverLoginSerializer(serializers.ModelSerializer):
    driverPassword = serializers.CharField(write_only = True)
    class Meta:
        model = Driver
        fields = ['driverEmail', 'driverPassword']

    def validate(self, data):
        try:
            driver = Driver.objects.get(driverEmail = data['driverEmail'])
        except Driver.DoesNotExist:
            raise serializers.ValidationError("Hehe Invalid Email")

        if driver and check_password(data['driverPassword'], driver.driverPassword):
            if driver.driverVerification:
                return driver
            else:
                raise serializers.ValidationError("hehe Driver is not verified")
        else:
            raise serializers.ValidationError("hehe Incorrect Password")
            

    

class PassengerProfileSerilizer(serializers.ModelSerializer):
    class Meta:
        model = Passenger
        fields = '__all__'




