# from django.db import models
# from django.conf import settings

# class Payment(models.Model):
#     # Using settings.AUTH_USER_MODEL to properly reference your custom User model
#     user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='payments', on_delete=models.CASCADE, null=True, blank=True)
#     token = models.CharField(max_length=255)
#     amount = models.DecimalField(max_digits=10, decimal_places=2)
#     transaction_id = models.CharField(max_length=255, null=True, blank=True)
#     status = models.CharField(max_length=20, default='Pending')
#     response_data = models.JSONField(null=True, blank=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     def __str__(self):
#         return f"Payment of {self.amount} - {self.status}"

# from django.db import models
# from django.contrib.auth.models import User
# import uuid
# class OrderStatus(models.TextChoices):
#     STARTED = 'started', 'Started'
#     INITIATED = 'initiated', 'Initiated'
#     COMPLETED = 'completed', 'Completed'
#     CANCELED = 'canceled', 'Canceled'
#     USER_CANCELED = 'user_canceled', 'User Canceled'
#     EXPIRED = 'expired', 'Expired'
#     REFUNDED = 'refunded', 'Refunded'
#     PARTIALLY_REFUNDED = 'partially_refunded', 'Partially Refunded'


# from django.db import models
# import uuid
# from bookings.models import Booking
# from users.models import Passenger

# class OrderStatus(models.TextChoices):
#     STARTED = 'started', 'Started'
#     INITIATED = 'initiated', 'Initiated'
#     COMPLETED = 'completed', 'Completed'
#     CANCELED = 'canceled', 'Canceled'
#     USER_CANCELED = 'user_canceled', 'User Canceled'
#     EXPIRED = 'expired', 'Expired'
#     REFUNDED = 'refunded', 'Refunded'
#     PARTIALLY_REFUNDED = 'partially_refunded', 'Partially Refunded'

# class Payment(models.Model):
#     id = models.UUIDField(
#         primary_key=True,
#         default=uuid.uuid4,
#     )
#     booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='payments')
#     passenger = models.ForeignKey(Passenger, on_delete=models.CASCADE, related_name='payments')
#     amount = models.DecimalField(max_digits=10, decimal_places=2)
#     status = models.CharField(max_length=20,
#         choices=OrderStatus.choices,
#         default=OrderStatus.STARTED)
#     transaction_id = models.CharField(max_length=255, null=True, blank=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     def __str__(self):
#         return f"Payment {self.id} - {self.status} - {self.amount}"

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