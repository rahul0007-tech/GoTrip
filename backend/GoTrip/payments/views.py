from django.shortcuts import render

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.conf import settings
import requests
import json

from .serializers import KhaltiVerifySerializer, PaymentSerializer
from .models import Payment

class VerifyKhaltiPaymentView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = KhaltiVerifySerializer(data=request.data)
        
        if serializer.is_valid():
            token = serializer.validated_data['token']
            amount = serializer.validated_data['amount']
            
            # Store payment attempt in database
            payment = Payment.objects.create(
                user=request.user if request.user.is_authenticated else None,
                token=token,
                amount=amount
            )
            
            # Prepare data for Khalti verification
            payload = {
                "token": token,
                "amount": int(float(amount) * 100)  # Convert to paisa
            }
            
            headers = {
                "Authorization": f"Key {settings.KHALTI_SECRET_KEY}",
                "Content-Type": "application/json"
            }
            
            # Make request to Khalti API
            try:
                response = requests.post(
                    settings.KHALTI_VERIFY_URL,
                    headers=headers,
                    data=json.dumps(payload)
                )
                
                # Update payment record with response
                response_data = response.json()
                payment.response_data = response_data
                
                if response.status_code == 200:
                    # Payment successful
                    payment.status = 'Completed'
                    payment.transaction_id = response_data.get('idx')
                    payment.save()
                    
                    return Response({
                        'status': True,
                        'details': response_data
                    })
                else:
                    # Payment failed
                    payment.status = 'Failed'
                    payment.save()
                    
                    return Response({
                        'status': False,
                        'details': response_data
                    }, status=status.HTTP_400_BAD_REQUEST)
                    
            except Exception as e:
                payment.status = 'Error'
                payment.response_data = {'error': str(e)}
                payment.save()
                
                return Response({
                    'status': False,
                    'details': {'error': str(e)}
                }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        return Response({
            'status': False,
            'details': serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)

class PaymentListView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request, *args, **kwargs):
        payments = Payment.objects.filter(user=request.user).order_by('-created_at')
        serializer = PaymentSerializer(payments, many=True)
        return Response(serializer.data)
