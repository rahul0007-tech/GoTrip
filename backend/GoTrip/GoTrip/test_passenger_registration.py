from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth.hashers import make_password
from .models import Passenger, Driver, Vehicle


class PassengerRegistrationTest(APITestCase):
    def test_register_passenger_success(self):
        data = {
            'passengerName': 'Rahul Gupta',
            'passengerPhone': '1234567890',
            'passengerEmail': 'rahul@example.com',
            'passengerPassword': 'Password123',
        }
        response = self.client.post('/passenger/', data, format='json')  
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_register_passenger_fail(self):
        data = {
            'passengerName': 'Rahul Gupta',
            'passengerPhone': '1234567890',
            # Missing email
            'passengerPassword': 'Password123',
        }
        response = self.client.post('/passenger/', data, format='json')  
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class OtpVerificationTest(APITestCase):
    def setUp(self):
        self.passenger = Passenger.objects.create(
            passengerName="Rahul Gupta",
            passengerPhone="1234567890",
            passengerEmail="rahul@example.com",
            passengerPassword=make_password("Password123"),
            passengerVerified=False,
            passengerOtp="12345"  
        )

    def test_verify_otp_success(self):
        data = {
            'passengerEmail': 'rahul@example.com',
            'passengerOtp': '12345'
        }
        response = self.client.post('/verify-otp/', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.passenger.refresh_from_db()
        self.assertTrue(self.passenger.passengerVerified)

    def test_verify_otp_fail_invalid_otp(self):
        data = {
            'passengerEmail': 'rahul@example.com',
            'passengerOtp': '99999'
        }
        response = self.client.post('/verify-otp/', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class PassengerLoginTest(APITestCase):
    def setUp(self):
        self.passenger = Passenger.objects.create(
            passengerName="Rahul Gupta",
            passengerPhone="1234567890",
            passengerEmail="rahul@example.com",
            passengerPassword=make_password("Password123"),
            passengerVerified=True
        )

    def test_login_passenger_success(self):
        data = {
            'passengerEmail': 'rahul@example.com',
            'passengerPassword': 'Password123'
        }
        response = self.client.post('/login-passenger/', data, format='json')  
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_login_passenger_fail_invalid_credentials(self):
        data = {
            'passengerEmail': 'rahul@example.com',
            'passengerPassword': 'WrongPassword'
        }
        response = self.client.post('/login-passenger/', data, format='json')  
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_login_passenger_fail_not_verified(self):
        self.passenger.passengerVerified = False
        self.passenger.save()
        data = {
            'passengerEmail': 'rahul@example.com',
            'passengerPassword': 'Password123'
        }
        response = self.client.post('/login-passenger/', data, format='json')  
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)





# --------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------



# from rest_framework.test import APITestCase
# from django.urls import reverse
# from rest_framework import status
# from .models import Passenger


# from rest_framework.test import APITestCase
# from rest_framework import status
# from django.urls import reverse
# from django.core.files.uploadedfile import SimpleUploadedFile
# from goTrip.models import Passenger

# class PassengerRegistrationTest(APITestCase):

#     def setUp(self):
#         self.registration_url = reverse('CreatePassenger')
#         self.valid_data = {
#             "passengerName": "rahul gupta",
#             "passengerPhone": "9876543210",
#             "passengerEmail": "rahul@example.com",
#             "passengerPassword": "securepassword123",
#             "passengerPhoto": SimpleUploadedFile(
#                 name="test_photo.jpg",
#                 content=b"",
#                 content_type="image/jpeg"
#             ),
#         }

#     def test_register_passenger_success(self):
#         response = self.client.post(self.registration_url, self.valid_data, format='multipart')
#         self.assertEqual(response.status_code, status.HTTP_201_CREATED)
#         self.assertEqual(Passenger.objects.count(), 1)
#         self.assertEqual(Passenger.objects.first().passengerEmail, self.valid_data['passengerEmail'])

#     def test_register_passenger_missing_fields(self):
#         invalid_data = self.valid_data.copy()
#         invalid_data.pop("passengerEmail")  # Remove a required field
#         response = self.client.post(self.registration_url, invalid_data, format='multipart')
#         self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

#     def test_register_passenger_invalid_email(self):
#         invalid_data = self.valid_data.copy()
#         invalid_data["passengerEmail"] = "invalid-email"  # Invalid email format
#         response = self.client.post(self.registration_url, invalid_data, format='multipart')
#         self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

#     def test_register_passenger_duplicate_email(self):
#         Passenger.objects.create(
#             passengerName="Jane gupta",
#             passengerPhone="9876543211",
#             passengerEmail=self.valid_data["passengerEmail"],
#             passengerPassword="securepassword456",
#             passengerPhoto=None
#         )
#         response = self.client.post(self.registration_url, self.valid_data, format='multipart')
#         self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
