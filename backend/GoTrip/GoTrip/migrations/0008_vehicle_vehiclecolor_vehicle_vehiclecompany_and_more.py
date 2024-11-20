# Generated by Django 5.1.1 on 2024-10-24 08:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('goTrip', '0007_vehicle'),
    ]

    operations = [
        migrations.AddField(
            model_name='vehicle',
            name='vehicleColor',
            field=models.CharField(default='red', max_length=30),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='vehicle',
            name='vehicleCompany',
            field=models.CharField(default='suzuki', max_length=50),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='vehicle',
            name='vehicleFuelType',
            field=models.CharField(choices=[('Diesel', 'Diesel'), ('Petrol', 'Petrol'), ('Electric', 'Electric')], default='Petrol', max_length=20),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='vehicle',
            name='vehicleNumber',
            field=models.CharField(default='Ga 21 Pa 2932', max_length=20),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='vehicle',
            name='vehicleType',
            field=models.CharField(choices=[('Suv', 'Suv'), ('Sedan', 'Sedan'), ('Hatchback', 'Hatchback'), ('4X4', '4X4'), ('PickUp', 'Pickup')], default='Suv', max_length=20),
            preserve_default=False,
        ),
    ]
