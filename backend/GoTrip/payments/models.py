# from django.db import models

# # Create your models here.

# from django.db import models
# from django.contrib.auth.models import User

# class Payment(models.Model):
#     user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
#     token = models.CharField(max_length=255)
#     amount = models.DecimalField(max_digits=10, decimal_places=2)
#     transaction_id = models.CharField(max_length=255, null=True, blank=True)
#     status = models.CharField(max_length=20, default='Pending')
#     response_data = models.JSONField(null=True, blank=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     def __str__(self):
#         return f"Payment of {self.amount} - {self.status}"


from django.db import models
from django.contrib.auth.models import User

class Payment(models.Model):
    # Using auth.User directly with related_name to avoid clashes
    user = models.ForeignKey('auth.User', related_name='payments', on_delete=models.CASCADE, null=True, blank=True)
    token = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    transaction_id = models.CharField(max_length=255, null=True, blank=True)
    status = models.CharField(max_length=20, default='Pending')
    response_data = models.JSONField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Payment of {self.amount} - {self.status}"

# payments/serializers.py
from rest_framework import serializers
from .models import Payment