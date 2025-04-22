
from django.utils import timezone
from django.shortcuts import render, get_object_or_404
from rest_framework.viewsets import ModelViewSet
from .models import Payment, OrderStatus
from .serializers import PaymentSerializer, KhaltiPaymentSerializer
from decouple import config
import uuid
import requests
from rest_framework.response import Response
from django.shortcuts import redirect
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
import json
from django.db import transaction
from rest_framework import status
from bookings.models import Booking
from users.models import Driver, User, Passenger

class PaymentViewSet(ModelViewSet):
    serializer_class = PaymentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        return Payment.objects.filter(user=user)
    
class InitiateKhaltiPayment(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            with transaction.atomic():
                serializer = KhaltiPaymentSerializer(data=request.data)
                if serializer.is_valid():
                    return_url = serializer.validated_data["return_url"]
                    website_url = serializer.validated_data["website_url"]
                    booking_id = serializer.validated_data["booking_id"]
                    driver_id = serializer.validated_data["driver_id"]
                    # Get the user and booking
                    user = request.user
                    passenger = get_object_or_404(Passenger, id=user.id)
                    if not booking_id:
                        return Response({'error': 'Booking ID is required'}, status=status.HTTP_400_BAD_REQUEST)
                    booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)

                    
                    
                    # Check if booking is already paid (COMPLETED status)
                    completed_payment = Payment.objects.filter(
                        user=user, 
                        status=OrderStatus.COMPLETED,
                        booking=booking
                    ).first()
                    
                    if completed_payment:
                        return Response({'error': 'This booking is already paid for'}, status=status.HTTP_400_BAD_REQUEST)
                    
                    # Find any existing INITIATED payments for this booking and cancel them
                    existing_initiated_payments = Payment.objects.filter(
                        user=user, 
                        status=OrderStatus.INITIATED,
                        booking=booking
                    )
                    
                    # Update all existing initiated payments to CANCELED
                    for payment in existing_initiated_payments:
                        payment.status = OrderStatus.CANCELED
                        payment.save()
                    
                    
                    # Create new payment record
                    payment = Payment.objects.create(
                        user=user,
                        amount=booking.fare,
                        status=OrderStatus.INITIATED,
                        booking=booking  # Store booking ID in response_data
                    )

                    payload = json.dumps({
                        "return_url": f"{return_url}?payment_id={payment.id}",
                        "website_url": website_url,
                        "amount": float(booking.fare) * 100,  # Khalti expects amount in paisa
                        "purchase_order_id": str(payment.id),
                        "purchase_order_name": f"Booking to {booking.dropoff_location.name}",
                        "customer_info": {
                            "name": passenger.name,
                            "email": passenger.email
                        }
                    })

                    # Request to Khalti API
                    headers = {
                        'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
                        'Content-Type': 'application/json',
                    }

                    response = requests.post("https://a.khalti.com/api/v2/epayment/initiate/", headers=headers, data=payload)
                    
                    if response.status_code != 200:
                        payment.status = OrderStatus.CANCELED
                        payment.save()
                        return Response({'error': 'Failed to initiate payment with Khalti'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                    
                    new_res = response.json()

                    selected_driver = get_object_or_404(Driver, id=driver_id)
        
                    if booking.booking_for < timezone.now().date():
                        return Response({'error': 'Cannot select a driver for a booking with a past date'}, 
                                    status=status.HTTP_400_BAD_REQUEST)

                    if selected_driver not in booking.accepted_drivers.all():
                        return Response({'error': 'This driver has not accepted the booking'}, status=status.HTTP_400_BAD_REQUEST)

                    booking.status = "confirmed"
                    booking.driver = selected_driver
                    booking.save()
                    
                    # Save the transaction ID
                    payment.transaction_id = new_res.get('pidx')
                    payment.pidx = new_res.get('pidx')
                    payment.save()
                    print("payment===",'pidx',payment.pidx)

                    
                    # Return redirect URL
                    return Response({
                        "status": "success",
                        "message": "payment initiated successfully",
                        "data": {
                            'payment_id': payment.id, 
                            'pidx': payment.pidx, 
                            'amount': booking.fare
                        }
                    })
                else:
                    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    
# class InitiateKhaltiPayment(APIView):
#     permission_classes = [IsAuthenticated]

#     def post(self, request):
#         try:
#             with transaction.atomic():
#                 serializer = KhaltiPaymentSerializer(data=request.data)
#                 if serializer.is_valid():
#                     return_url = serializer.validated_data["return_url"]
#                     website_url = serializer.validated_data["website_url"]
#                     booking_id = serializer.validated_data["booking_id"]
#                     phone_number = serializer.validated_data["phone_number"]
                    
#                     # Get the user and booking
#                     user = request.user
#                     passenger = get_object_or_404(Passenger, id=user.id)
#                     booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)
                    
#                     # Check if booking is already paid (COMPLETED status)
#                     completed_payment = Payment.objects.filter(
#                         user=user, 
#                         status=OrderStatus.COMPLETED,
#                         response_data__booking_id=booking_id
#                     ).first()
                    
#                     if completed_payment:
#                         return Response({'error': 'This booking is already paid for'}, status=status.HTTP_400_BAD_REQUEST)
                    
#                     # Find any existing INITIATED payments for this booking and cancel them
#                     existing_initiated_payments = Payment.objects.filter(
#                         user=user, 
#                         status=OrderStatus.INITIATED,
#                         response_data__booking_id=booking_id
#                     )
                    
#                     # Update all existing initiated payments to CANCELED
#                     for payment in existing_initiated_payments:
#                         payment.status = OrderStatus.CANCELED
#                         payment.save()
                    
#                     # Generate a unique token
#                     token = str(uuid.uuid4())
                    
#                     # Create new payment record
#                     payment = Payment.objects.create(
#                         token=token,
#                         user=user,
#                         amount=booking.fare,
#                         status=OrderStatus.INITIATED,
#                         response_data={'booking_id': booking_id},
#                         booking=booking  # Store booking ID in response_data
#                     )

#                     payload = json.dumps({
#                         "return_url": f"{return_url}?payment_id={payment.id}",
#                         "website_url": website_url,
#                         "amount": float(booking.fare) * 100,  # Khalti expects amount in paisa
#                         "purchase_order_id": str(payment.id),
#                         "purchase_order_name": f"Booking to {booking.dropoff_location.name}",
#                         "customer_info": {
#                             "name": passenger.name,
#                             "email": passenger.email,
#                             "phone": phone_number
#                         }
#                     })

#                     # Request to Khalti API
#                     headers = {
#                         'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
#                         'Content-Type': 'application/json',
#                     }

#                     response = requests.post("https://a.khalti.com/api/v2/epayment/initiate/", headers=headers, data=payload)
                    
#                     if response.status_code != 200:
#                         payment.status = OrderStatus.CANCELED
#                         payment.save()
#                         return Response({'error': 'Failed to initiate payment with Khalti'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                    
#                     new_res = response.json()
                    
#                     # Save the transaction ID
#                     payment.transaction_id = new_res.get('pidx')
#                     payment.pidx = new_res.get('pidx')
#                     payment.save()
#                     print("payment===",'pidx',payment.pidx)
                    
#                     # Return redirect URL
#                     return Response({
#                         "status": "success",
#                         "message": "payment initiated successfully",
#                         "data": {
#                             'payment_id': payment.id, 
#                             'pidx': payment.pidx, 
#                             'amount': booking.fare
#                         }
#                     })
#                 else:
#                     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# class InitiateKhaltiPayment(APIView):
#     permission_classes = [IsAuthenticated]

#     def post(self, request):
#         try:
#             with transaction.atomic():
#                 serializer = KhaltiPaymentSerializer(data=request.data)
#                 if serializer.is_valid():
#                     return_url = serializer.validated_data["return_url"]
#                     website_url = serializer.validated_data["website_url"]
#                     booking_id = serializer.validated_data["booking_id"]
#                     phone_number = serializer.validated_data["phone_number"]
                    
#                     # Get the user and booking
#                     user = request.user
#                     passenger = get_object_or_404(Passenger, id=user.id)
#                     booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)
                    
#                     # Check if booking is already paid
#                     existing_payment = Payment.objects.filter(
#                         user=user, 
#                         status__in=[OrderStatus.COMPLETED, OrderStatus.INITIATED],
#                         response_data__booking_id=booking_id
#                     ).first()
                    
#                     if existing_payment:
#                         if existing_payment.status == OrderStatus.COMPLETED:
#                             return Response({'error': 'This booking is already paid for'}, status=status.HTTP_400_BAD_REQUEST)
#                         else:
#                             # Return the existing payment URL if payment is already initiated
#                             return Response({'redirect_url': f"https://a.khalti.com/api/v2/epayment/complete/{existing_payment.transaction_id}/"}, 
#                                           status=status.HTTP_200_OK)
                    
#                     # Generate a unique token
#                     token = str(uuid.uuid4())
                    
#                     # Create payment record
#                     payment = Payment.objects.create(
#                         token=token,
#                         user=user,
#                         amount=booking.fare,
#                         status=OrderStatus.INITIATED,
#                         response_data={'booking_id': booking_id}  # Store booking ID in response_data
#                     )

#                     payload = json.dumps({
#                         "return_url": f"{return_url}?payment_id={payment.id}",
#                         "website_url": website_url,
#                         "amount": float(booking.fare) * 100,  # Khalti expects amount in paisa
#                         "purchase_order_id": str(payment.id),
#                         "purchase_order_name": f"Booking to {booking.dropoff_location.name}",
#                         "customer_info": {
#                             "name": passenger.name,
#                             "email": passenger.email,
#                             "phone": phone_number
#                         }
#                     })

#                     # Request to Khalti API
#                     headers = {
#                         'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
#                         'Content-Type': 'application/json',
#                     }

#                     response = requests.post("https://a.khalti.com/api/v2/epayment/initiate/", headers=headers, data=payload)
                    
#                     if response.status_code != 200:
#                         print(response.data.pidx)
#                         payment.status = OrderStatus.CANCELED
#                         payment.save()
#                         return Response({'error': 'Failed to initiate payment with Khalti'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                    
#                     new_res = response.json()
                    
                    
#                     # Save the transaction ID
#                     payment.transaction_id = new_res.get('pidx')
#                     payment.save()
                    
#                     # Return redirect URL
#                     return Response({"status": "success","message":"payment successful" ,"data": {'payment_id': payment.id, 'pidx':payment.transaction_id, 'amount':booking.fare} })
#                 else:
#                     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


#----------------------------------------According to copiot-----------------------------------


# class VerifyKhaltiPayment(APIView):
#     permission_classes = [IsAuthenticated]
    
#     def post(self, request):
#         payment_id = request.data.get('payment_id')
#         pidx = request.data.get('pidx')
        
#         if not payment_id or not pidx:
#             return Response({
#                 'status': 'error',
#                 'message': 'Missing payment_id or pidx'
#             }, status=status.HTTP_400_BAD_REQUEST)
        
#         try:
#             payment = get_object_or_404(Payment, id=payment_id)
#             booking = get_object_or_404(Booking, id=payment.booking.id)
            
#             # Verify payment with Khalti
#             headers = {
#                 'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
#                 'Content-Type': 'application/json',
#             }
            
#             data = json.dumps({'pidx': pidx})
#             response = requests.post(
#                 "https://a.khalti.com/api/v2/epayment/lookup/", 
#                 headers=headers, 
#                 data=data
#             )
            
#             if response.status_code != 200:
#                 return Response({
#                     'status': 'error',
#                     'message': 'Failed to verify payment with Khalti',
#                     'needs_payment_confirmation': True
#                 }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
#             response_data = response.json()
            
#             # Update payment status based on Khalti response
#             status_mapping = {
#                 'Completed': OrderStatus.COMPLETED,
#                 'Pending': OrderStatus.PENDING,
#                 'Initiated': OrderStatus.INITIATED,
#                 'Expired': OrderStatus.EXPIRED, 
#                 'Refunded': OrderStatus.REFUNDED,
#                 'User canceled': OrderStatus.USER_CANCELED,
#                 'Partially Refunded': OrderStatus.PARTIALLY_REFUNDED
#             }
            
#             payment.status = status_mapping.get(response_data['status'], OrderStatus.CANCELED)
            
#             if response_data['status'] == 'Completed':
#                 booking.status = "confirmed"
#                 booking.save()
#                 payment.save()
                
#                 return Response({
#                     'status': 'success',
#                     'message': 'Payment completed successfully',
#                     'data': {
#                         'payment_status': payment.status,
#                         'transaction_id': payment.transaction_id,
#                         'amount': payment.amount
#                     }
#                 }, status=status.HTTP_200_OK)
                
#             elif response_data['status'] == 'Pending':
#                 payment.save()
#                 return Response({
#                     'status': 'pending',
#                     'message': 'Payment is pending verification',
#                     'needs_payment_confirmation': True
#                 }, status=status.HTTP_202_ACCEPTED)
                
#             else:
#                 payment.save()
#                 return Response({
#                     'status': 'failed',
#                     'message': f"Payment failed. Status: {response_data['status']}",
#                     'needs_payment_confirmation': False
#                 }, status=status.HTTP_400_BAD_REQUEST)
                
#         except Exception as e:
#             return Response({
#                 'status': 'error', 
#                 'message': str(e),
#                 'needs_payment_confirmation': True
#             }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


#----------------------------------------Edited code-----------------------------------

# class VerifyKhaltiPayment(APIView):
#     permission_classes = [IsAuthenticated]
    
#     def post(self, request):
                
#         payment_id = request.data.get('payment_id')
#         pidx = request.data.get('pidx')
        
#         if not payment_id or not pidx:
#             return Response({'error': 'Missing payment_id or pidx'}, status=status.HTTP_400_BAD_REQUEST)
        
#         try:
#             payment = get_object_or_404(Payment, id=payment_id)
            
#             # Extract booking_id from response_data
#             booking_id = payment.booking.id
#             booking = get_object_or_404(Booking, id=booking_id)
        
            
#             # Verify payment with Khalti
#             headers = {
#                 'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
#                 'Content-Type': 'application/json',
#             }
            
#             data = json.dumps({
#                 'pidx': pidx
#             })
            
#             response = requests.post("https://a.khalti.com/api/v2/epayment/lookup/", headers=headers, data=data)
            
#             if response.status_code != 200:
#                 return Response({'error': 'Failed to verify payment with Khalti'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
#             if  payment.transaction_id==pidx:
#                 payment.status = OrderStatus.COMPLETED
#                 booking.status = "confirmed"
#                 booking.save()
#                 payment.save()
#                 return Response({'status':'success','message': 'Payment completed successfully', 'data':payment.status}, status=status.HTTP_200_OK)
#             elif payment.status == 'Pending':
#                 payment.status = OrderStatus.PENDING  # Adjusting to handle Pending state
#                 payment.save()
#                 return Response({'message': 'Payment is pending, we will check again soon.'}, status=status.HTTP_200_OK)
#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


#----------------------------------------About to implement-----------------------------------

# class VerifyKhaltiPayment(APIView):
#     permission_classes = [IsAuthenticated]
    
#     def post(self, request):
                
#         payment_id = request.data.get('payment_id')
#         pidx = request.data.get('pidx')
        
#         if not payment_id or not pidx:
#             return Response({'error': 'Missing payment_id or pidx'}, status=status.HTTP_400_BAD_REQUEST)
        
#         try:
#             payment = get_object_or_404(Payment, id=payment_id)
            
#             # Extract booking_id from response_data
#             booking_id = payment.response_data.get('booking_id')
#             booking = get_object_or_404(Booking, id=booking_id)
            
#             # Verify payment with Khalti
#             headers = {
#                 'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
#                 'Content-Type': 'application/json',
#             }
            
#             data = json.dumps({
#                 'pidx': pidx
#             })
            
#             response = requests.post("https://a.khalti.com/api/v2/epayment/lookup/", headers=headers, data=data)
            
#             if response.status_code != 200:
#                 return Response({'error': 'Failed to verify payment with Khalti'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
#             response_data = response.json()
            
#             # Update the response_data field with the full response while preserving booking_id
#             updated_response_data = payment.response_data or {}
#             updated_response_data.update(response_data)
#             payment.response_data = updated_response_data
            


#             if  payment.transaction_id==pidx:
#                 payment.status = OrderStatus.COMPLETED
#                 payment.save()
#                 return Response({'status':'success','message': 'Payment completed successfully', 'data':payment.status}, status=status.HTTP_200_OK)
#             elif response_data['status'] == 'Pending':
#                 payment.status = OrderStatus.PENDING  # Adjusting to handle Pending state
#                 payment.save()
#                 return Response({'message': 'Payment is pending, we will check again soon.'}, status=status.HTTP_200_OK)
#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


        #     if response_data['status'] == 'Completed':
        #         payment.status = OrderStatus.COMPLETED
        #         payment.save()
                
        #         # Mark booking as ready for driver selection
        #         booking.save()
                
        #         return Response({'message': 'Payment completed successfully'}, status=status.HTTP_200_OK)
        #     else:
        #         # Update payment status based on Khalti response
        #         status_mapping = {
        #             'Pending': OrderStatus.INITIATED,
        #             'Initiated': OrderStatus.INITIATED,
        #             'Expired': OrderStatus.EXPIRED,
        #             'Refunded': OrderStatus.REFUNDED,
        #             'User canceled': OrderStatus.USER_CANCELED,
        #             'Partially Refunded': OrderStatus.PARTIALLY_REFUNDED
        #         }
                
        #         payment.status = status_mapping.get(response_data['status'], OrderStatus.CANCELED)
        #         payment.save()
                
        #         return Response({'error': f'Payment not completed. Status: {response_data["status"]}'}, 
        #                       status=status.HTTP_400_BAD_REQUEST)
                
        # except Exception as e:
        #     return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class VerifyKhaltiPayment(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
                
        payment_id = request.data.get('payment_id')
        pidx = request.data.get('pidx')
        
        
        if not payment_id or not pidx:
            return Response({'error': 'Missing payment_id or pidx'}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            payment = get_object_or_404(Payment, id=payment_id)
            
            # Extract booking_id from response_data
            booking_id = payment.booking.id
            booking = get_object_or_404(Booking, id=booking_id)
        
            
            # Verify payment with Khalti
            headers = {
                'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
                'Content-Type': 'application/json',
            }
            
            data = json.dumps({
                'pidx': pidx
            })
            
            response = requests.post("https://a.khalti.com/api/v2/epayment/lookup/", headers=headers, data=data)
            
            if response.status_code != 200:
                return Response({'error': 'Failed to verify payment with Khalti'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
            if  payment.transaction_id==pidx:
                payment.status = OrderStatus.COMPLETED
                payment.save()
                return Response({'status':'success','message': 'Payment completed successfully', 'data':payment.status}, status=status.HTTP_200_OK)
            elif payment.status == 'Pending':
                payment.status = OrderStatus.PENDING  # Adjusting to handle Pending state
                payment.save()
                return Response({'message': 'Payment is pending, we will check again soon.'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)