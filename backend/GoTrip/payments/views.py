# from rest_framework.views import APIView
# from rest_framework.response import Response
# from rest_framework import status
# from rest_framework.permissions import IsAuthenticated
# from django.conf import settings
# import requests
# import json

# from .serializers import KhaltiVerifySerializer, PaymentSerializer
# from .models import Payment

# class VerifyKhaltiPaymentView(APIView):
#     def post(self, request, *args, **kwargs):
#         serializer = KhaltiVerifySerializer(data=request.data)
        
#         if serializer.is_valid():
#             token = serializer.validated_data['token']
#             amount = serializer.validated_data['amount']
            
#             # Store payment attempt in database
#             payment = Payment.objects.create(
#                 user=request.user if request.user.is_authenticated else None,
#                 token=token,
#                 amount=amount
#             )
            
#             # Prepare data for Khalti verification
#             payload = {
#                 "token": token,
#                 "amount": int(float(amount) * 100)  # Convert to paisa
#             }
            
#             headers = {
#                 "Authorization": f"Key {settings.KHALTI_SECRET_KEY}",
#                 "Content-Type": "application/json"
#             }
            
#             # Make request to Khalti API
#             try:
#                 response = requests.post(
#                     settings.KHALTI_VERIFY_URL,
#                     headers=headers,
#                     data=json.dumps(payload)
#                 )
                
#                 # Update payment record with response
#                 response_data = response.json()
#                 payment.response_data = response_data
                
#                 if response.status_code == 200:
#                     # Payment successful
#                     payment.status = 'Completed'
#                     payment.transaction_id = response_data.get('idx')
#                     payment.save()
                    
#                     return Response({
#                         'status': True,
#                         'details': response_data
#                     })
#                 else:
#                     # Payment failed
#                     payment.status = 'Failed'
#                     payment.save()
                    
#                     return Response({
#                         'status': False,
#                         'details': response_data
#                     }, status=status.HTTP_400_BAD_REQUEST)
                    
#             except Exception as e:
#                 payment.status = 'Error'
#                 payment.response_data = {'error': str(e)}
#                 payment.save()
                
#                 return Response({
#                     'status': False,
#                     'details': {'error': str(e)}
#                 }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
#         return Response({
#             'status': False,
#             'details': serializer.errors
#         }, status=status.HTTP_400_BAD_REQUEST)

# class PaymentListView(APIView):
#     permission_classes = [IsAuthenticated]
    
#     def get(self, request, *args, **kwargs):
#         payments = Payment.objects.filter(user=request.user).order_by('-created_at')
#         serializer = PaymentSerializer(payments, many=True)
#         return Response(serializer.data)


# from django.shortcuts import render
# from rest_framework.viewsets import ModelViewSet
# from .models import Order
# from.serializers import *
# import os
# from dotenv import load_dotenv
# load_dotenv()
# import uuid
# import requests
# from rest_framework.response import Response
# from django.shortcuts import redirect, render
# from rest_framework.views import APIView
# from rest_framework.permissions import AllowAny
# import json
# from django.contrib.auth.models import User
# from .models import OrderStatus
# from rest_framework import status
# # Create your views here.
# class OrderViewSet(ModelViewSet):
#      serializer_class = OrderSerializer
#      queryset = Order.objects.all()

# from django.db import transaction
# from django.db.utils import IntegrityError

# class InitiateKhaltiPayment(APIView):
#     permission_classes = [AllowAny]

#     def post(self, request):
#         # Start a database transaction
#         try:
#             with transaction.atomic():
#                 serializer = KhaltiPaymentSerializer(data=request.data)
#                 if serializer.is_valid():
#                     return_url = serializer.validated_data["return_url"]
#                     website_url = serializer.validated_data["website_url"]
#                     price = serializer.validated_data["price"]
#                     quantity = serializer.validated_data["quantity"]
#                     name = serializer.validated_data["name"]
#                     image_url = serializer.validated_data.get("image_url", "")
#                     user_id = serializer.validated_data["user_id"]
#                     phone_number = serializer.validated_data["phone_number"]
#                     user = User.objects.get(id=user_id)

#                     # Create order (if any step fails, everything will be rolled back)
#                     order = Order.objects.create(
#                         user=user,
#                         name=name,
#                         price=price,
#                         quantity=quantity,
#                         image_url=image_url,
#                     )

#                     payload = json.dumps({
#                         "return_url": return_url,
#                         "website_url": website_url,
#                         "amount": float(price),
#                         "purchase_order_id": str(order.id),
#                         "purchase_order_name": order.name,
#                         "customer_info": {
#                             "name": "test",
#                             "email": 'test@gmail.com',
#                             "phone": phone_number
#                         }
#                     })

#                     # Request to Khalti API
#                     headers = {
#                         'Authorization': f"key {os.environ.get('KHALTI_SECRET_KEY')}",
#                         'Content-Type': 'application/json',
#                     }

#                     response = requests.post("https://a.khalti.com/api/v2/epayment/initiate/", headers=headers, data=payload)
#                     print("response==",response)
#                     new_res = response.json()
                    
#                     # If request is successful, return redirect URL
#                     return Response({'redirect_url': new_res['payment_url'],'order_id':order.id}, status=status.HTTP_200_OK)
#                 else:
#                     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#         except Exception as e:
#             print("internal server error",e)
#             # Handle the error and rollback
#             return Response({'error': 'An error occurred while processing the order.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

#         except Exception as e:
#             # Handle any other errors and rollback
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



# class VerifyKhalti(APIView):
#     permission_classes = [AllowAny]
#     def get(self,request,*args,**kwargs):
#         url = "https://a.khalti.com/api/v2/epayment/lookup/"
#         if request.method == 'GET':
#             headers = {
#                 'Authorization': f"key {os.environ.get('KHALTI_SECRET_KEY')}",
#                 'Content-Type': 'application/json',
#             }
#             pidx = request.GET.get('pidx')
#             purchase_order_id = kwargs.get('purchase_order_id')
#             print("cat__id=====",purchase_order_id)
#             data = json.dumps({
#                 'pidx':pidx
#             })
#             res = requests.request('POST',url,headers=headers,data=data)
#             print(res)
#             print(res.text)

#             new_res = json.loads(res.text)
#             print(new_res)

#             if new_res['status'] == 'Completed':
                
#                     order = Order.objects.get(id=self.request.GET.get('purchase_order_id'))
#                     print("order",order)
#                     if not order:
#                        return Response({'data':{'message':'Order could not be completed. Please contact administration.'}},status=status.HTTP_400_BAD_REQUEST)
#                     order.order_status = OrderStatus.COMPLETED
#                     order.save()
#                     return Response({'data':{'message':'Order Created'}},status=status.HTTP_200_OK)
                   
#             #  Update status based on khalti response and notify user      
            
#             # elif new_res['status'] == 'Pending':
#             #     try:
#             #         category = Order.objects.get(id=cat_id)
#             #         Upgrade.objects.create(user=self.request.user,category=category,payment_status=new_res['status'])
#             #     except Exception as e:
#             #         return Response({'data':{'message':'Url modified'}},status=status.HTTP_400_BAD_REQUEST)


#             # elif new_res['status'] == 'Expired':
#             #     return Response({'data':{'message':'Pidx expired'}},status=status.HTTP_400_BAD_REQUEST)
#             # elif new_res['status'] == 'Initiated':
                
#             #     return Response({'data':{'message':'Payment didnot succed.Please contace support center.'}},status=status.HTTP_400_BAD_REQUEST)
#             # elif new_res['status'] == 'Refunded':
                
#             #     return Response({'data':{'message':'Payment refunded.'}},status=status.HTTP_400_BAD_REQUEST)
#             # elif new_res['status'] == 'User canceled':
                
#             #     return Response({'data':{'message':'User cancelled payment request'}},status=status.HTTP_400_BAD_REQUEST)
#             # elif new_res['status'] == 'Partially Refunded':
                
#             #     return Response({'data':{'message':'Payment partially refunded'}},status=status.HTTP_400_BAD_REQUEST)
#             else:
                
#                 return Response({'data':{'message':'Payment didnot succed.Please contace support center.'}},status=status.HTTP_400_BAD_REQUEST)

#             return redirect(os.environ.get('FRONTEND_BASE_URL'))



# from django.shortcuts import render, get_object_or_404
# from rest_framework.viewsets import ModelViewSet
# from .models import Payment, OrderStatus
# from .serializers import PaymentSerializer, KhaltiPaymentSerializer
# import os
# from decouple import config
# import uuid
# import requests
# from rest_framework.response import Response
# from django.shortcuts import redirect
# from rest_framework.views import APIView
# from rest_framework.permissions import IsAuthenticated
# import json
# from django.db import transaction
# from rest_framework import status
# from bookings.models import Booking
# from users.models import Passenger

# class PaymentViewSet(ModelViewSet):
#     serializer_class = PaymentSerializer
#     permission_classes = [IsAuthenticated]
    
#     def get_queryset(self):
#         user = self.request.user
#         if hasattr(user, 'passenger'):
#             return Payment.objects.filter(passenger=user.passenger)
#         return Payment.objects.none()

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
#                         booking=booking, 
#                         status__in=[OrderStatus.COMPLETED, OrderStatus.INITIATED]
#                     ).first()
                    
#                     if existing_payment:
#                         if existing_payment.status == OrderStatus.COMPLETED:
#                             return Response({'error': 'This booking is already paid for'}, status=status.HTTP_400_BAD_REQUEST)
#                         else:
#                             # Return the existing payment URL if payment is already initiated
#                             return Response({'redirect_url': f"https://a.khalti.com/api/v2/epayment/complete/{existing_payment.transaction_id}/"}, 
#                                           status=status.HTTP_200_OK)
                    
#                     # Create payment record
#                     payment = Payment.objects.create(
#                         booking=booking,
#                         passenger=passenger,
#                         amount=booking.fare,
#                         status=OrderStatus.INITIATED
#                     )

#                     payload = json.dumps({
#                         "return_url": f"{return_url}?payment_id={payment.id}",
#                         "website_url": website_url,
#                         "amount": float(booking.fare) * 100,  # Khalti expects amount in paisa (smallest unit)
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
#                     payment.save()
                    
#                     # Return redirect URL
#                     return Response({'redirect_url': new_res['payment_url'], 'payment_id': payment.id}, status=status.HTTP_200_OK)
#                 else:
#                     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# class VerifyKhaltiPayment(APIView):
#     permission_classes = [IsAuthenticated]
    
#     def get(self, request):
#         payment_id = request.GET.get('payment_id')
#         pidx = request.GET.get('pidx')
        
#         if not payment_id or not pidx:
#             return Response({'error': 'Missing payment_id or pidx'}, status=status.HTTP_400_BAD_REQUEST)
        
#         try:
#             payment = get_object_or_404(Payment, id=payment_id)
            
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
            
#             if response_data['status'] == 'Completed':
#                 payment.status = OrderStatus.COMPLETED
#                 payment.save()
                
#                 # Mark booking as ready for driver selection
#                 booking = payment.booking
#                 booking.save()
                
#                 return Response({'message': 'Payment completed successfully'}, status=status.HTTP_200_OK)
#             else:
#                 # Update payment status based on Khalti response
#                 status_mapping = {
#                     'Pending': OrderStatus.INITIATED,
#                     'Initiated': OrderStatus.INITIATED,
#                     'Expired': OrderStatus.EXPIRED,
#                     'Refunded': OrderStatus.REFUNDED,
#                     'User canceled': OrderStatus.USER_CANCELED,
#                     'Partially Refunded': OrderStatus.PARTIALLY_REFUNDED
#                 }
                
#                 payment.status = status_mapping.get(response_data['status'], OrderStatus.CANCELED)
#                 payment.save()
                
#                 return Response({'error': f'Payment not completed. Status: {response_data["status"]}'}, 
#                               status=status.HTTP_400_BAD_REQUEST)
                
#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


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
from users.models import User, Passenger

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
                    phone_number = serializer.validated_data["phone_number"]
                    
                    # Get the user and booking
                    user = request.user
                    passenger = get_object_or_404(Passenger, id=user.id)
                    booking = get_object_or_404(Booking, id=booking_id, passenger=passenger)
                    
                    # Check if booking is already paid
                    existing_payment = Payment.objects.filter(
                        user=user, 
                        status__in=[OrderStatus.COMPLETED, OrderStatus.INITIATED],
                        response_data__booking_id=booking_id
                    ).first()
                    
                    if existing_payment:
                        if existing_payment.status == OrderStatus.COMPLETED:
                            return Response({'error': 'This booking is already paid for'}, status=status.HTTP_400_BAD_REQUEST)
                        else:
                            # Return the existing payment URL if payment is already initiated
                            return Response({'redirect_url': f"https://a.khalti.com/api/v2/epayment/complete/{existing_payment.transaction_id}/"}, 
                                          status=status.HTTP_200_OK)
                    
                    # Generate a unique token
                    token = str(uuid.uuid4())
                    
                    # Create payment record
                    payment = Payment.objects.create(
                        token=token,
                        user=user,
                        amount=booking.fare,
                        status=OrderStatus.INITIATED,
                        response_data={'booking_id': booking_id}  # Store booking ID in response_data
                    )

                    payload = json.dumps({
                        "return_url": f"{return_url}?payment_id={payment.id}",
                        "website_url": website_url,
                        "amount": float(booking.fare) * 100,  # Khalti expects amount in paisa
                        "purchase_order_id": str(payment.id),
                        "purchase_order_name": f"Booking to {booking.dropoff_location.name}",
                        "customer_info": {
                            "name": passenger.name,
                            "email": passenger.email,
                            "phone": phone_number
                        }
                    })

                    # Request to Khalti API
                    headers = {
                        'Authorization': f"key {config('KHALTI_SECRET_KEY')}",
                        'Content-Type': 'application/json',
                    }

                    response = requests.post("https://a.khalti.com/api/v2/epayment/initiate/", headers=headers, data=payload)
                    
                    if response.status_code != 200:
                        print(response.data.pidx)
                        payment.status = OrderStatus.CANCELED
                        payment.save()
                        return Response({'error': 'Failed to initiate payment with Khalti'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                    
                    new_res = response.json()
                    
                    
                    # Save the transaction ID
                    payment.transaction_id = new_res.get('pidx')
                    payment.save()
                    
                    # Return redirect URL
                    return Response({"status": "success","message":"payment successful" ,"data": {'payment_id': payment.id, 'pidx':payment.transaction_id, 'amount':booking.fare} })
                else:
                    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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
            booking_id = payment.response_data.get('booking_id')
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
            
            response_data = response.json()
            
            # Update the response_data field with the full response while preserving booking_id
            updated_response_data = payment.response_data or {}
            updated_response_data.update(response_data)
            payment.response_data = updated_response_data
            


            if  payment.transaction_id==pidx:
                payment.status = OrderStatus.COMPLETED
                payment.save()
                return Response({'status':'success','message': 'Payment completed successfully', 'data':payment.status}, status=status.HTTP_200_OK)
            elif response_data['status'] == 'Pending':
                payment.status = OrderStatus.PENDING  # Adjusting to handle Pending state
                payment.save()
                return Response({'message': 'Payment is pending, we will check again soon.'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


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