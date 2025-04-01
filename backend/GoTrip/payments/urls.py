from django.urls import path
from .views import VerifyKhaltiPaymentView, PaymentListView

urlpatterns = [
    path('verify-payment/', VerifyKhaltiPaymentView.as_view(), name='verify_payment'),
    path('history/', PaymentListView.as_view(), name='payment_history'),
]