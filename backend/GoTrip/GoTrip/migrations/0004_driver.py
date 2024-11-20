# Generated by Django 5.1.1 on 2024-10-18 09:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('goTrip', '0003_alter_passenger_passengerotp_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='Driver',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('driverName', models.CharField(max_length=50)),
                ('driverEmail', models.EmailField(max_length=254)),
                ('driverPhoneNumber', models.IntegerField()),
                ('lisenceImage', models.ImageField(upload_to='lisence')),
                ('driverPassword', models.CharField(max_length=20)),
                ('driverStatus', models.CharField(choices=[('busy', 'busy'), ('free', 'free')], max_length=5)),
            ],
        ),
    ]