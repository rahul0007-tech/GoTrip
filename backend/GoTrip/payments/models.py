

from django.db import models
from users.models import User  # Import your custom User model

class OrderStatus(models.TextChoices):
    STARTED = 'started', 'Started'
    INITIATED = 'initiated', 'Initiated'
    COMPLETED = 'completed', 'Completed'
    CANCELED = 'canceled', 'Canceled'
    USER_CANCELED = 'user_canceled', 'User Canceled'
    EXPIRED = 'expired', 'Expired'
    REFUNDED = 'refunded', 'Refunded'
    PARTIALLY_REFUNDED = 'partially_refunded', 'Partially Refunded'
    PENDING = 'pending', 'Pending'

class Payment(models.Model):
    token = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    transaction_id = models.CharField(max_length=255, null=True, blank=True)
    status = models.CharField(max_length=20,
        choices=OrderStatus.choices,
        default=OrderStatus.STARTED)
    response_data = models.JSONField(null=True, blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, related_name='payments')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Payment {self.id} - {self.status} - {self.amount}"