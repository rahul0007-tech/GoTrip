from django.db import models

# Create your models here.


class Rating(models.Model):
    passenger = models.ForeignKey(
        'users.Passenger', on_delete=models.CASCADE, related_name='ratings'
    )
    driver = models.ForeignKey(
        'users.Driver', on_delete=models.CASCADE, related_name='ratings'
    )
    rating = models.IntegerField(default=0, max_length=5)
