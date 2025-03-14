// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: (json['id'] as num).toInt(),
      passenger: (json['passenger'] as num).toInt(),
      pickupLocation: json['pickup_location'] as String,
      dropoffLocation: json['dropoff_location'] as String,
      fare: json['fare'] as String,
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'passenger': instance.passenger,
      'pickup_location': instance.pickupLocation,
      'dropoff_location': instance.dropoffLocation,
      'fare': instance.fare,
    };
