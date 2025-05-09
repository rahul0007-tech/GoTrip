import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

// Define a nested Location class
@JsonSerializable()
class LocationModel {
  final int id;
  final String name;
  final double fare;
  final String? locationImage;  // Add this field

  LocationModel({
    required this.id,
    required this.name,
    required this.fare,
    this.locationImage,  // Add this parameter
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      fare: (json['fare'] is int) 
          ? (json['fare'] as int).toDouble()
          : json['fare'],
      locationImage: json['location_image'] as String?,  // Add this field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fare': fare,
      'location_image': locationImage,  // Add this field
    };
  }

  @override
  String toString() => name;
}

@JsonSerializable(explicitToJson: true)
class BookingModel {
  final int id;
  final int passenger;
  
  @JsonKey(name: "pickup_location")
  final String pickupLocation;
  
  // Changed this to match the generated code's parameter name
  @JsonKey(name: "dropoff_location") 
  final dynamic dropoffLocation;
  
  final String fare;
  
  @JsonKey(name: "booking_for")
  final DateTime? bookingFor;

  BookingModel({
    required this.id,
    required this.passenger,
    required this.pickupLocation,
    required this.dropoffLocation, // Must match the field name exactly
    required this.fare,
    required this.bookingFor,
  });

  // Getter to access location name regardless of format
  String get dropoffLocationName {
    if (dropoffLocation is String) {
      return dropoffLocation;
    } else if (dropoffLocation is Map<String, dynamic>) {
      return dropoffLocation['name'] ?? '';
    }
    return '';
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
