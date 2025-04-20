import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'passenger_upcoming_booking.g.dart';

@JsonSerializable()
class PassengerUpcomingBookingsResponse {
  final String status;
  final String message;
  final List<PassengerUpcomingBooking> data;

  PassengerUpcomingBookingsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PassengerUpcomingBookingsResponse.fromJson(Map<String, dynamic> json) => _$PassengerUpcomingBookingsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PassengerUpcomingBookingsResponseToJson(this);
}

@JsonSerializable()
class PassengerUpcomingBooking {
  final int id;
  final Driver? driver;
  final String pickupLocation;
  final DropoffLocation dropoffLocation;
  final String fare;
  final String bookingFor;
  final String? bookingTime;
  final String status;
  final String paymentStatus;

  PassengerUpcomingBooking({
    required this.id,
    this.driver,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.bookingFor,
    this.bookingTime,
    required this.status,
    required this.paymentStatus,
  });

  factory PassengerUpcomingBooking.fromJson(Map<String, dynamic> json) {
    return PassengerUpcomingBooking(
      id: (json['id'] as num).toInt(),
      driver: json['driver'] == null ? null : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      pickupLocation: json['pickup_location'] as String,
      dropoffLocation: DropoffLocation.fromJson(json['dropoff_location'] as Map<String, dynamic>),
      fare: json['fare'].toString(),
      bookingFor: json['booking_for'] as String,
      bookingTime: json['booking_time'] as String?,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
    );
  }

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
class Driver {
  final int id;
  final String name;
  final Vehicle vehicle;

  Driver({
    required this.id,
    required this.name,
    required this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
  Map<String, dynamic> toJson() => _$DriverToJson(this);
}

@JsonSerializable()
class Vehicle {
  @JsonKey(name: "vehicle_color")
  final String vehicleColor;
  
  @JsonKey(name: "vehicle_company")
  final String vehicleCompany;
  
  @JsonKey(name: "vehicle_number")
  final String vehicleNumber;
  
  @JsonKey(name: "sitting_capacity")
  final int sittingCapacity;
  
  @JsonKey(name: "vehicle_type")
  final VehicleType vehicleType;
  
  @JsonKey(name: "vehicle_fuel_type")
  final VehicleFuelType vehicleFuelType;
  
  @JsonKey(name: "images")
  final List<VehicleImage> images;

  Vehicle({
    required this.vehicleColor,
    required this.vehicleCompany,
    required this.vehicleNumber,
    required this.sittingCapacity,
    required this.vehicleType,
    required this.vehicleFuelType,
    required this.images,
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