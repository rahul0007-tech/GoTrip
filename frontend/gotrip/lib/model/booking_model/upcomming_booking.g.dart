// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcomming_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverUpcomingBookingsResponse _$DriverUpcomingBookingsResponseFromJson(
        Map<String, dynamic> json) =>
    DriverUpcomingBookingsResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => UpcomingBooking.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DriverUpcomingBookingsResponseToJson(
        DriverUpcomingBookingsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

UpcomingBooking _$UpcomingBookingFromJson(Map<String, dynamic> json) =>
    UpcomingBooking(
      id: (json['id'] as num).toInt(),
      passenger:
          DropoffLocation.fromJson(json['passenger'] as Map<String, dynamic>),
      pickupLocation: json['pickup_location'] as String,
      dropoffLocation: DropoffLocation.fromJson(
          json['dropoff_location'] as Map<String, dynamic>),
      fare: json['fare'] as String,
      bookingFor: json['booking_for'] as String,
      bookingTime: json['booking_time'] as String?,
    );

Map<String, dynamic> _$UpcomingBookingToJson(UpcomingBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'passenger': instance.passenger,
      'pickup_location': instance.pickupLocation,
      'dropoff_location': instance.dropoffLocation,
      'fare': instance.fare,
      'booking_for': instance.bookingFor,
      'booking_time': instance.bookingTime,
    };

DropoffLocation _$DropoffLocationFromJson(Map<String, dynamic> json) =>
    DropoffLocation(
      name: json['name'] as String,
    );

Map<String, dynamic> _$DropoffLocationToJson(DropoffLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
