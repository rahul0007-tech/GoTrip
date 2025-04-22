import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'upcomming_booking.g.dart';

@JsonSerializable()
class DriverUpcomingBookingsResponse {
  final String status;
  final String message;
  final List<UpcomingBooking> data;

  DriverUpcomingBookingsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DriverUpcomingBookingsResponse.fromJson(Map<String, dynamic> json) => _$DriverUpcomingBookingsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DriverUpcomingBookingsResponseToJson(this);
}

@JsonSerializable()
class UpcomingBooking {
  final int id;
  final Passenger passenger;
  @JsonKey(name: "pickup_location")
  final String pickupLocation;
  @JsonKey(name: "dropoff_location")
  final DropoffLocation dropoffLocation;
  final String fare;
  @JsonKey(name: "booking_for")
  final String bookingFor;
  @JsonKey(name: "booking_time")
  final String? bookingTime;
  @JsonKey(defaultValue: 'pending')
  final String status;
  @JsonKey(name: 'payment_status', defaultValue: 'pending')
  final String paymentStatus;
  final Driver? driver;

  UpcomingBooking({
    required this.id,
    required this.passenger,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.bookingFor,
    this.bookingTime,
    required this.status,
    required this.paymentStatus,
    this.driver,
  });

  factory UpcomingBooking.fromJson(Map<String, dynamic> json) => _$UpcomingBookingFromJson(json);
  Map<String, dynamic> toJson() => _$UpcomingBookingToJson(this);

  String getFormattedDate() {
    try {
      final parts = bookingFor.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        
        final date = DateTime(year, month, day);
        return DateFormat('MMMM d, y').format(date);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return bookingFor;
  }

  String getFormattedTime() {
    if (bookingTime == null || bookingTime!.isEmpty) {
      return 'Time not specified';
    }
    
    try {
      return DateFormat('h:mm a').format(DateFormat('HH:mm:ss').parse(bookingTime!));
    } catch (e) {
      print('Error parsing time: $e');
      return bookingTime!;
    }
  }
}

@JsonSerializable()
class Passenger {
  final String name;

  Passenger({
    required this.name,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => _$PassengerFromJson(json);
  Map<String, dynamic> toJson() => _$PassengerToJson(this);
}

@JsonSerializable()
class Driver {
  final int id;
  final String name;
  final Vehicle? vehicle;

  Driver({
    required this.id,
    required this.name,
    this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
  Map<String, dynamic> toJson() => _$DriverToJson(this);
}

@JsonSerializable()
class Vehicle {
  @JsonKey(name: "vehicle_color")
  final String? vehicleColor;
  
  @JsonKey(name: "vehicle_company")
  final String? vehicleCompany;
  
  @JsonKey(name: "vehicle_number")
  final String? vehicleNumber;
  
  @JsonKey(name: "sitting_capacity")
  final int? sittingCapacity;
  
  @JsonKey(name: "vehicle_type")
  final VehicleType? vehicleType;
  
  @JsonKey(name: "vehicle_fuel_type")
  final VehicleFuelType? vehicleFuelType;
  
  @JsonKey(name: "images")
  final List<VehicleImage>? images;

  Vehicle({
    this.vehicleColor,
    this.vehicleCompany,
    this.vehicleNumber,
    this.sittingCapacity,
    this.vehicleType,
    this.vehicleFuelType,
    this.images,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}

@JsonSerializable()
class VehicleType {
  final int id;
  final String name;
  @JsonKey(name: "display_name")
  final String displayName;

  VehicleType({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => _$VehicleTypeFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleTypeToJson(this);
}

@JsonSerializable()
class VehicleFuelType {
  final int id;
  final String name;
  @JsonKey(name: "display_name")
  final String displayName;

  VehicleFuelType({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory VehicleFuelType.fromJson(Map<String, dynamic> json) => _$VehicleFuelTypeFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleFuelTypeToJson(this);
}

@JsonSerializable()
class VehicleImage {
  final int id;
  final String image;

  VehicleImage({
    required this.id,
    required this.image,
  });

  factory VehicleImage.fromJson(Map<String, dynamic> json) => _$VehicleImageFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleImageToJson(this);
}

@JsonSerializable()
class DropoffLocation {
  @JsonKey(name: "name")
  final String name;

  DropoffLocation({
    required this.name,
  });

  factory DropoffLocation.fromJson(Map<String, dynamic> json) => _$DropoffLocationFromJson(json);
  Map<String, dynamic> toJson() => _$DropoffLocationToJson(this);
}