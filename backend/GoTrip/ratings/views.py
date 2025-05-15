from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from users.models import Passenger, Driver
from ratings.models import Rating

# Create your views here.


class GiveRatingView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        passenger = get_object_or_404(Passenger, id=request.user.id)
        driver = get_object_or_404(Driver, id=request.data.get("driver_id"))
        rating = request.data.get("rating")
        if not rating:
            return Response({"error": "Rating is required."}, status=400)
        if rating < 1 or rating > 5:
            return Response({"error": "Rating must be between 1 and 5."}, status=400)
        
        ratings = Rating.objects.filter(driver=driver)
        
        
        return Response({"message": "Average rating calculated."})