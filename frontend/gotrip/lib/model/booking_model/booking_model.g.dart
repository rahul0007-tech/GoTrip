// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      fare: (json['fare'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fare': instance.fare,
    };

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: (json['id'] as num).toInt(),
      passenger: (json['passenger'] as num).toInt(),
      pickupLocation: json['pickup_location'] as String,
      dropoffLocation: json['dropoff_location'],
      fare: json['fare'] as String,
      bookingFor: json['booking_for'] == null
          ? null
          : DateTime.parse(json['booking_for'] as String),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'passenger': instance.passenger,
      'pickup_location': instance.pickupLocation,
      'dropoff_location': instance.dropoffLocation,
      'fare': instance.fare,
      'booking_for': instance.bookingFor?.toIso8601String(),
    };
