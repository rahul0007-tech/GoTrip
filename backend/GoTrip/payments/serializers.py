
# payments/serializers.py
from rest_framework import serializers
from .models import Payment

class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = ['id', 'token', 'amount', 'transaction_id', 'status', 'created_at']
        read_only_fields = ['transaction_id', 'status', 'created_at']

class KhaltiVerifySerializer(serializers.Serializer):
    token = serializers.CharField(max_length=255)
    amount = serializers.DecimalField(max_digits=10, decimal_places=2)