// lib/models/driver_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  final int id;
  final String name;
  final int phone;
  
  // Add additional fields that might be returned from your API
  final String? email;
  final String? status; // 'busy' or 'free'
  final String? photo;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.status,
    this.photo,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => _$DriverModelFromJson(json);
  Map<String, dynamic> toJson() => _$DriverModelToJson(this);
}

@JsonSerializable()
class AcceptedDriversResponse {
  @JsonKey(name: "booking_id")
  final int bookingId;
  
  @JsonKey(name: "accepted_drivers")
  final List<DriverModel> acceptedDrivers;

  AcceptedDriversResponse({
    required this.bookingId,
    required this.acceptedDrivers,
  });

  factory AcceptedDriversResponse.fromJson(Map<String, dynamic> json) => 
      _$AcceptedDriversResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$AcceptedDriversResponseToJson(this);
}