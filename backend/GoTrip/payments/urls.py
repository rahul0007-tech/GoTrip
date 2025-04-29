# from django.urls import path, include
# from rest_framework.routers import DefaultRouter
# from . import views

# router = DefaultRouter()
# router.register(r'', views.PaymentViewSet, basename='payments')

# urlpatterns = [
#     path('khalti-initiate/', views.InitiateKhaltiPayment.as_view(), name="initiate-payment"),
#     path('khalti-verify/', views.VerifyKhaltiPayment.as_view(), name="verify-payment"),
#     path('', include(router.urls)),
# ]


from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'', views.PaymentViewSet, basename='payments')

urlpatterns = [
    path('khalti-initiate/', views.InitiateKhaltiPayment.as_view(), name="initiate-payment"),
    path('khalti-verify/', views.VerifyKhaltiPayment.as_view(), name="verify-payment"),
    path('partial-khalti-initiate/', views.PartialInitiateKhaltiPayment.as_view(), name="partial-initiate-payment"),
    path('partial-khalti-verify/', views.PartialVerifyKhaltiPayment.as_view(), name="partial-verify-payment"),
    path('', include(router.urls)),
]