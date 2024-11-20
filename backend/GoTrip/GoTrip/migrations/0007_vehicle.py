# Generated by Django 5.1.1 on 2024-10-24 08:04

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('goTrip', '0006_rename_passengerpassword_passenger_passengerpassword'),
    ]

    operations = [
        migrations.CreateModel(
            name='Vehicle',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('relation', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='vehicle', to='goTrip.driver')),
            ],
        ),
    ]
