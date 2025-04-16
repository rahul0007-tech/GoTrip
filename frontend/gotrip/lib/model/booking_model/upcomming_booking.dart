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
  @JsonKey(name: "id")
  final int id;
  
  @JsonKey(name: "passenger")
  final DropoffLocation passenger;
  
  @JsonKey(name: "pickup_location")
  final String pickupLocation;
  
  @JsonKey(name: "dropoff_location")
  final DropoffLocation dropoffLocation;
  
  @JsonKey(name: "fare")
  final String fare;
  
  @JsonKey(name: "booking_for")
  final String bookingFor; // Keep as String to match API response
  
  @JsonKey(name: "booking_time")
  final String? bookingTime;

  UpcomingBooking({
    required this.id,
    required this.passenger,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.bookingFor,
    this.bookingTime,
  });

  factory UpcomingBooking.fromJson(Map<String, dynamic> json) => _$UpcomingBookingFromJson(json);
  Map<String, dynamic> toJson() => _$UpcomingBookingToJson(this);
  
  // Helper getter to easily access passenger name
  String get passengerName => passenger.name;
  
  // Helper getter to easily access dropoff location name
  String get dropoffLocationName => dropoffLocation.name;
  
  // Helper method to format date for display
  String getFormattedDate() {
    // Parse YYYY-MM-DD to DateTime
    try {
      final parts = bookingFor.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        
        // Create date and format it
        final date = DateTime(year, month, day);
        final months = [
          "", "January", "February", "March", "April", "May", "June",
          "July", "August", "September", "October", "November", "December"
        ];
        
        return "${months[date.month]} ${date.day}, ${date.year}";
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    
    return bookingFor; // Return original if parsing fails
  }

  // Format time from HH:MM:SS to more readable format
  String getFormattedTime() {
    if (bookingTime == null || bookingTime!.isEmpty) {
      return 'Time not specified';
    }
    
    try {
      final parts = bookingTime!.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        
        // Convert to 12-hour format
        if (hour > 12) hour -= 12;
        if (hour == 0) hour = 12;
        
        return '$hour:$minute $period';
      }
    } catch (e) {
      print('Error parsing time: $e');
    }
    
    return bookingTime!; // Return original if parsing fails
  }
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