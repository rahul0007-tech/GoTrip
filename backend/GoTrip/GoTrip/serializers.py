from rest_framework import serializers
from . models import Passenger, Driver, Vehicle,Booking
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
        
class VerifyPassengerOtp(serializers.Serializer):
    passengerEmail = serializers.EmailField()
    passengerOtp = serializers.CharField(max_length=6)

    def validate(self, data):
        try:
            passenger = Passenger.objects.get(passengerEmail=data['passengerEmail'], passengerOtp = data['passengerOtp'])
            
            if passenger.passengerOtp != data['passengerOtp']:
                raise serializers.ValidationError('Incorrect OTP')
        except Passenger.DoesNotExist:
            raise serializers.ValidationError('Invalid Credentials')
        
        return data


    def save(self):
        passenger = Passenger.objects.get(passengerEmail=self.validated_data['passengerEmail'])
        passenger.passengerVerified=True
        passenger.passengerOtp = None
        passenger.save()
        return passenger



class PassengerLogin(serializers.Serializer):
    passengerEmail = serializers.EmailField()
    passengerPassword = serializers.CharField(write_only=True)
        

    def validate(self, data):

            try:
                passenger = Passenger.objects.get(passengerEmail=data['passengerEmail'])
            except Passenger.DoesNotExist:
                raise serializers.ValidationError("Invalid Email")
        

            if passenger and check_password(data['passengerPassword'], passenger.passengerPassword):
                if passenger.passengerVerified:
                    return passenger
                
                else:
                    raise serializers.ValidationError({"message": "Sorry, you are not verified"})
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
    


class DriverLoginSerializer(serializers.Serializer):
    driverEmail = serializers.EmailField()
    driverPassword = serializers.CharField(write_only = True)

    def validate(self, data):
        try:
            driver = Driver.objects.get(driverEmail = data['driverEmail'])
        except Driver.DoesNotExist:
            raise serializers.ValidationError("Invalid Email")        
        if driver and check_password(data['driverPassword'], driver.driverPassword):
            if driver.driverVerification:
                return(driver)
            else:
                raise serializers.ValidationError("Sorry driver is still not verified")
        else:
            raise serializers.ValidationError("Incorrect Password")
        

# class BookingSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Booking
#         fields = ['id', 'passenger', 'driver', 'pickup_location', 'dropoff_location', 'booking_time', 'status', 'fare']
#         read_only_fields = ['id', 'fare']  # Leave fare read-only; status can be updated in specific cases

#     def create(self, validated_data):
#         """Custom logic to handle booking creation."""
#         validated_data['status'] = 'requested'  # Default status on creation
#         return Booking.objects.create(**validated_data)

#     def update(self, instance, validated_data):
#         """Custom logic to update booking status."""
#         status_update = validated_data.get('status', instance.status)

#         if status_update not in ['confirmed', 'completed', 'canceled']:
#             raise serializers.ValidationError({'status': 'Invalid status value'})

#         instance.status = status_update
#         instance.save()
#         return instance


# class BookingSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Booking
#         fields = ['id', 'passenger', 'driver', 'pickup_location', 'dropoff_location', 'booking_time', 'status', 'fare']
#         read_only_fields = ['id', 'fare', 'passenger']  # Mark 'passenger' as read-only
#         extra_kwargs = {'passenger': {'required': False}}

#     def create(self, validated_data):
#         """Custom logic to handle booking creation."""
#         validated_data['status'] = 'requested'  # Default status on creation
#         return Booking.objects.create(**validated_data)

class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = ['pickup_location', 'dropoff_location']  # Restrict fields for user input

    def create(self, validated_data):
        request = self.context['request']
        passenger = request.user.id# Ensure the user is a passenger
        print(f"--------------------------------------{passenger}--------------------------------------")
        passengers = Passenger.objects.get(pk=passenger)
        print(passengers)
        booking = Booking.objects.create(
            passenger=passengers,
            pickup_location=validated_data['pickup_location'],
            dropoff_location=validated_data['dropoff_location']
        )
        return booking
    # def notify_free_drivers(self, booking):
    #     """
    #     Notify all drivers whose status is 'free' about the new booking.
    #     """
    #     # Fetch free drivers
    #     free_drivers = Driver.objects.filter(status='free')

    #     # Example: Sending email notifications to drivers
    #     for driver in free_drivers:
    #         send_mail(
    #             subject="New Booking Available",
    #             message=f"A new booking is available! Pickup: {booking.pickup_location}, Dropoff: {booking.dropoff_location}.",
    #             from_email="no-reply@gotrip.com",
    #             recipient_list=[driver.driverEmail],  # Assuming 'driverEmail' is a field in the Driver model
    #         )

    #     # Log the notifications for debugging
    #     print(f"Notifications sent to {len(free_drivers)} drivers.")




class AcceptBookingSerializer(serializers.Serializer):
    """Handles the logic for accepting a booking request."""
    def update(self, instance, driver):
        if instance.status != 'requested':
            raise serializers.ValidationError({'error': 'Booking already processed or not in "requested" status'})

        instance.accepted_drivers.add(driver)
        instance.status = 'accepted'
        instance.save()
        return instance
    

class AcceptBookingSerializer(serializers.ModelSerializer):
    class Meta():
        model = Booking
    def update(self, instance, driver):
        request = self.context['request']
        driver = request.user.id# Ensure the user is a passenger
        drivers = Driver.objects.get(pk=driver)
        if instance.status != 'requested':
            raise serializers.ValidationError({'error': 'Booking already processed or not in "requested" status'})

        instance.accepted_drivers.add(drivers)
        instance.status = 'accepted'
        instance.save()
        return instance


class SelectDriverSerializer(serializers.Serializer):
    driver_id = serializers.IntegerField()

    def update(self, instance, validated_data):
        """Logic for selecting the driver."""
        driver_id = validated_data.get('driver_id')
        try:
            driver = Driver.objects.get(pk=driver_id)
        except Driver.DoesNotExist:
            raise serializers.ValidationError({'error': 'Driver not found'})

        if instance.status != 'accepted':
            raise serializers.ValidationError({'error': 'Booking is not in "accepted" status'})

        instance.driver = driver
        instance.status = 'driver_selected'
        instance.save()
        return instance

        



# class VerifyPassengerOtp(serializers.ModelSerializer):
#     class Meta:
#         model = Passenger
#         fields = ['passengerEmail', 'passengerOtp']
    
#     def validate(self, data):
#         try:
#             passenger = Passenger.objects.get(passengerEmail = data['passengerEmail'], passengerOtp = data['passengerOtp'])
#             if passenger.passengerOtp != data['passengerOtp']:
#                 raise serializers.ValidationError("Incorrect Otp")
#         except Passenger.DoesNotExist:
#             raise serializers.ValidationError('Invalid Email')
#         return data
    
    

# class PassengerLogin(serializers.ModelSerializer):
#     passengerPassword = serializers.CharField(write_only = True)
#     class Meta:
#         model = Passenger
#         fields = ['passengerEmail', 'passengerPassword']
    
#     def validate(self, data):
#         try:
#             passenger = Passenger.objects.get(passengerEmail = data['passengerEmail'])
#         except Passenger.DoesNotExist:
#             raise serializers.ValidationError("Invalid Email")
        
#         if passenger and check_password(data['passengerPassword'], passenger.passengerPassword):
#             if passenger.passengerVerified:
#                 return passenger
#             else:
#                 raise serializers.ValidationError("Sorry Passenger Is Not Verified")
#         else:
#             raise serializers.ValidationError("Incorrect Password")



#---------------------------------------Note: serializer class maa check password maa paila models.field ani data['field'] hunxa vane meta use garda paila data['field'] ani balla models.field


# class DriverLoginSerializer(serializers.ModelSerializer):
#     driverPassword = serializers.CharField(write_only = True)
#     class Meta:
#         model = Driver
#         fields = ['driverEmail', 'driverPassword']

#     def validate(self, data):
#         try:
#             driver = Driver.objects.get(driverEmail = data['driverEmail'])
#         except Driver.DoesNotExist:
#             raise serializers.ValidationError("Hehe Invalid Email")

#         if driver and check_password(data['driverPassword'], driver.driverPassword):
#             if driver.driverVerification:
#                 return driver
#             else:
#                 raise serializers.ValidationError("hehe Driver is not verified")
#         else:
#             raise serializers.ValidationError("hehe Incorrect Password")
            

    



# from rest_framework import serializers
# from .models import Passenger, Driver
# from django.contrib.auth.hashers import check_password


# class UniversalLoginSerializer(serializers.Serializer):
#     email = serializers.EmailField()
#     password = serializers.CharField(write_only=True)
#     user_type = serializers.ChoiceField(choices=[('passenger', 'Passenger'), ('driver', 'Driver')])

#     def validate(self, data):
#         email = data['email']
#         password = data['password']
#         user_type = data['user_type']

#         if user_type == 'passenger':
#             try:
#                 user = Passenger.objects.get(passengerEmail=email)
#             except Passenger.DoesNotExist:
#                 raise serializers.ValidationError("Invalid Passenger email")

#             if not check_password(password, user.passengerPassword):
#                 raise serializers.ValidationError("Incorrect password")
#             if not user.passengerVerified:
#                 raise serializers.ValidationError("Passenger is not verified")

#             data['user'] = user

#         elif user_type == 'driver':
#             try:
#                 user = Driver.objects.get(driverEmail=email)
#             except Driver.DoesNotExist:
#                 raise serializers.ValidationError("Invalid Driver email")

#             if not check_password(password, user.driverPassword):
#                 raise serializers.ValidationError("Incorrect password")
#             if not user.driverVerification:
#                 raise serializers.ValidationError("Driver is not verified")

#             data['user'] = user

#         return data








