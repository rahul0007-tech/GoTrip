# Generated by Django 5.1.5 on 2025-04-12 16:13

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("bookings", "0004_booking_payment_status"),
    ]

    operations = [
        migrations.AddField(
            model_name="booking",
            name="bookingItime",
            field=models.TimeField(blank=True, null=True),
        ),
    ]
