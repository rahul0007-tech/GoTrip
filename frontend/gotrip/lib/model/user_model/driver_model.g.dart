// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map<String, dynamic> json) => DriverModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: (json['phone'] as num).toInt(),
      email: json['email'] as String?,
      status: json['status'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'status': instance.status,
      'photo': instance.photo,
    };

AcceptedDriversResponse _$AcceptedDriversResponseFromJson(
        Map<String, dynamic> json) =>
    AcceptedDriversResponse(
      bookingId: (json['booking_id'] as num).toInt(),
      acceptedDrivers: (json['accepted_drivers'] as List<dynamic>)
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AcceptedDriversResponseToJson(
        AcceptedDriversResponse instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'accepted_drivers': instance.acceptedDrivers,
    };
