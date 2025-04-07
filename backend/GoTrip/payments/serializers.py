# from rest_framework import serializers
# from .models import Payment

# class PaymentSerializer(serializers.ModelSerializer):
#     # Add user email field to show user information
#     user_email = serializers.SerializerMethodField()
    
#     class Meta:
#         model = Payment
#         fields = ['id', 'user_email', 'token', 'amount', 'transaction_id', 'status', 'created_at']
#         read_only_fields = ['transaction_id', 'status', 'created_at', 'user_email']
    
#     def get_user_email(self, obj):
#         if obj.user:
#             return obj.user.email
#         return None

# from rest_framework import serializers
# from .models import Payment

# class PaymentSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Payment
#         fields = ['id', 'booking', 'passenger', 'amount', 'status', 'transaction_id', 'created_at', 'updated_at']
#         read_only_fields = ['id', 'created_at', 'updated_at', 'transaction_id']

# class KhaltiPaymentSerializer(serializers.Serializer):
#     return_url = serializers.URLField(required=True)
#     website_url = serializers.URLField(required=True)
#     booking_id = serializers.IntegerField(required=True)
#     phone_number = serializers.CharField(required=True)

from rest_framework import serializers
from .models import Payment

class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = ['id', 'user', 'amount', 'status', 'transaction_id', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at', 'transaction_id']

class KhaltiPaymentSerializer(serializers.Serializer):
    return_url = serializers.URLField(required=True)
    website_url = serializers.URLField(required=True)
    booking_id = serializers.IntegerField(required=True)
    phone_number = serializers.CharField(required=True)