# Generated by Django 5.1.1 on 2024-10-20 03:21

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('goTrip', '0005_driver_driververification'),
    ]

    operations = [
        migrations.RenameField(
            model_name='passenger',
            old_name='passengerpassword',
            new_name='passengerPassword',
        ),
    ]