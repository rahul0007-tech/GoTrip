// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_upcoming_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassengerUpcomingBookingsResponse _$PassengerUpcomingBookingsResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerUpcomingBookingsResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              PassengerUpcomingBooking.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PassengerUpcomingBookingsResponseToJson(
        PassengerUpcomingBookingsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

PassengerUpcomingBooking _$PassengerUpcomingBookingFromJson(
        Map<String, dynamic> json) =>
    PassengerUpcomingBooking(
      id: (json['id'] as num).toInt(),
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      pickupLocation: json['pickup_location'] as String,
      dropoffLocation: DropoffLocation.fromJson(
          json['dropoff_location'] as Map<String, dynamic>),
      fare: json['fare'] as String,
      bookingFor: json['booking_for'] as String,
      bookingTime: json['booking_time'] as String?,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
    );

Map<String, dynamic> _$PassengerUpcomingBookingToJson(
        PassengerUpcomingBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver': instance.driver,
      'pickup_location': instance.pickupLocation,
      'dropoff_location': instance.dropoffLocation,
      'fare': instance.fare,
      'booking_for': instance.bookingFor,
      'booking_time': instance.bookingTime,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
    };

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'vehicle': instance.vehicle,
    };

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      vehicleColor: json['vehicle_color'] as String,
      vehicleCompany: json['vehicle_company'] as String,
      vehicleNumber: json['vehicle_number'] as String,
      sittingCapacity: (json['sitting_capacity'] as num).toInt(),
      vehicleType:
          VehicleType.fromJson(json['vehicle_type'] as Map<String, dynamic>),
      vehicleFuelType: VehicleFuelType.fromJson(
          json['vehicle_fuel_type'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>)
          .map((e) => VehicleImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'vehicle_color': instance.vehicleColor,
      'vehicle_company': instance.vehicleCompany,
      'vehicle_number': instance.vehicleNumber,
      'sitting_capacity': instance.sittingCapacity,
      'vehicle_type': instance.vehicleType,
      'vehicle_fuel_type': instance.vehicleFuelType,
      'images': instance.images,
    };

VehicleType _$VehicleTypeFromJson(Map<String, dynamic> json) => VehicleType(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayName: json['display_name'] as String,
    );

Map<String, dynamic> _$VehicleTypeToJson(VehicleType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
    };

VehicleFuelType _$VehicleFuelTypeFromJson(Map<String, dynamic> json) =>
    VehicleFuelType(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayName: json['display_name'] as String,
    );

Map<String, dynamic> _$VehicleFuelTypeToJson(VehicleFuelType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
    };

VehicleImage _$VehicleImageFromJson(Map<String, dynamic> json) => VehicleImage(
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
    );

Map<String, dynamic> _$VehicleImageToJson(VehicleImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
    };

DropoffLocation _$DropoffLocationFromJson(Map<String, dynamic> json) =>
    DropoffLocation(
      name: json['name'] as String,
    );

Map<String, dynamic> _$DropoffLocationToJson(DropoffLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
