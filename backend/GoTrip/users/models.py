from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
# from django.utils.translation import gettext_lazy as _
# Create your models here.

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, password2 = None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        if password:
            user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('name', 'Admin')
        extra_fields.setdefault('phone', 1234567890)
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
            
        return self.create_user(email, password, **extra_fields)

class User(AbstractUser):
    username = None
    name = models.CharField(max_length=20)
    phone = models.IntegerField()
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=150)
    isVerified = models.BooleanField(default=False)
    Created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now_add=True)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    class Meta:
        verbose_name = 'user'
        verbose_name_plural = 'users'

    def __str__(self):
        return self.email


class Passenger(User):
    photo = models.ImageField(upload_to='passengers', blank=True, null=True)
    otp = models.CharField(max_length=6, null=True, blank=True)

    class Meta:
        verbose_name = 'passenger'
        verbose_name_plural = 'passengers'

class Driver(User):
    DRIVER_STATUS_CHOICES = [
        ('busy', 'Busy'),
        ('free', 'Free')
    ]
    
    license = models.ImageField(upload_to='license',blank=True, null=True)
    photo = models.ImageField(upload_to='drivers',blank=True, null=True)
    status = models.CharField(max_length=5, choices=DRIVER_STATUS_CHOICES, default='free')

    class Meta:
        verbose_name = 'driver'
        verbose_name_plural = 'drivers'

