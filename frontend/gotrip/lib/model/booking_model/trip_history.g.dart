// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverTripHistoryResponse _$DriverTripHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    DriverTripHistoryResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => TripHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DriverTripHistoryResponseToJson(
        DriverTripHistoryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

TripHistory _$TripHistoryFromJson(Map<String, dynamic> json) => TripHistory(
      id: (json['id'] as num).toInt(),
      passenger: Passenger.fromJson(json['passenger'] as Map<String, dynamic>),
      pickupLocation: json['pickup_location'] as String,
      dropoffLocation: DropoffLocation.fromJson(
          json['dropoff_location'] as Map<String, dynamic>),
      fare: TripHistory._parseFare(json['fare']),
      bookingFor: json['booking_for'] as String,
      bookingTime: json['booking_time'] as String?,
    );

Map<String, dynamic> _$TripHistoryToJson(TripHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'passenger': instance.passenger,
      'pickup_location': instance.pickupLocation,
      'dropoff_location': instance.dropoffLocation,
      'fare': instance.fare,
      'booking_for': instance.bookingFor,
      'booking_time': instance.bookingTime,
    };

Passenger _$PassengerFromJson(Map<String, dynamic> json) => Passenger(
      name: json['name'] as String,
    );

Map<String, dynamic> _$PassengerToJson(Passenger instance) => <String, dynamic>{
      'name': instance.name,
    };

DropoffLocation _$DropoffLocationFromJson(Map<String, dynamic> json) =>
    DropoffLocation(
      name: json['name'] as String,
    );

Map<String, dynamic> _$DropoffLocationToJson(DropoffLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
