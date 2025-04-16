import 'package:json_annotation/json_annotation.dart';

part 'trip_history.g.dart';

@JsonSerializable()
class DriverTripHistoryResponse {
  final String status;
  final String message;
  final List<TripHistory> data;

  DriverTripHistoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DriverTripHistoryResponse.fromJson(Map<String, dynamic> json) => _$DriverTripHistoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DriverTripHistoryResponseToJson(this);
}

@JsonSerializable()
class TripHistory {
  final int id;
  final Passenger passenger;
  @JsonKey(name: 'pickup_location')
  final String pickupLocation;
  @JsonKey(name: 'dropoff_location')
  final DropoffLocation dropoffLocation;
  @JsonKey(name: 'fare', fromJson: _parseFare)
  final String fare;
  @JsonKey(name: 'booking_for')
  final String bookingFor;
  @JsonKey(name: 'booking_time')
  final String? bookingTime;

  TripHistory({
    required this.id,
    required this.passenger,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.bookingFor,
    this.bookingTime,
  });

  static String _parseFare(dynamic fare) {
    if (fare is num) {
      return fare.toStringAsFixed(2);
    }
    if (fare is String) {
      return fare;
    }
    throw FormatException('Invalid fare format: $fare');
  }

  factory TripHistory.fromJson(Map<String, dynamic> json) => _$TripHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$TripHistoryToJson(this);
}

@JsonSerializable()
class Passenger {
  final String name;

  Passenger({required this.name});

  factory Passenger.fromJson(Map<String, dynamic> json) => _$PassengerFromJson(json);
  Map<String, dynamic> toJson() => _$PassengerToJson(this);
}

@JsonSerializable()
class DropoffLocation {
  final String name;

  DropoffLocation({required this.name});

  factory DropoffLocation.fromJson(Map<String, dynamic> json) => _$DropoffLocationFromJson(json);
  Map<String, dynamic> toJson() => _$DropoffLocationToJson(this);
}