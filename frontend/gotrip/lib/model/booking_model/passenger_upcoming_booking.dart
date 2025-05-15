// import 'package:json_annotation/json_annotation.dart';
// import 'package:intl/intl.dart';

// part 'passenger_upcoming_booking.g.dart';

// @JsonSerializable()
// class PassengerUpcomingBookingsResponse {
//   final String status;
//   final String message;
//   final List<PassengerUpcomingBooking> data;

//   PassengerUpcomingBookingsResponse({
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory PassengerUpcomingBookingsResponse.fromJson(Map<String, dynamic> json) {
//     return PassengerUpcomingBookingsResponse(
//       status: json['status'] as String,
//       message: json['message'] as String,
//       data: (json['data'] as List<dynamic>)
//           .map((e) => PassengerUpcomingBooking.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'message': message,
//     'data': data.map((e) => e.toJson()).toList(),
//   };
// }

// @JsonSerializable()
// class PassengerUpcomingBooking {
//   @JsonKey(name: 'id')
//   final int id;
//   @JsonKey(name: 'driver')
//   final Driver? driver;
//   @JsonKey(name: 'pickup_location')
//   final String pickupLocation;
//   @JsonKey(name: 'dropoff_location')
//   final DropoffLocation dropoffLocation;
//   @JsonKey(name: 'fare')
//   final String fare;
//   @JsonKey(name: 'booking_for')
//   final String bookingFor;
//   @JsonKey(name: 'booking_time')
//   final String? bookingTime;
//   @JsonKey(name: 'status')
//   final String status;
//   @JsonKey(name: 'payment_status')
//   final String paymentStatus;

//   PassengerUpcomingBooking({
//     required this.id,
//     this.driver,
//     required this.pickupLocation,
//     required this.dropoffLocation,
//     required this.fare,
//     required this.bookingFor,
//     this.bookingTime,
//     required this.status,
//     required this.paymentStatus,
//   });

//   factory PassengerUpcomingBooking.fromJson(Map<String, dynamic> json) {
//     return PassengerUpcomingBooking(
//       id: (json['id'] as num).toInt(),
//       driver: json['driver'] == null ? null : Driver.fromJson(json['driver'] as Map<String, dynamic>),
//       pickupLocation: json['pickup_location'] as String,
//       dropoffLocation: DropoffLocation.fromJson(json['dropoff_location'] as Map<String, dynamic>),
//       fare: json['fare'].toString(),
//       bookingFor: json['booking_for'] as String,
//       bookingTime: json['booking_time'] as String?,
//       status: json['status'] as String? ?? 'pending',
//       paymentStatus: json['payment_status'] as String? ?? 'pending',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'driver': driver?.toJson(),
//     'pickup_location': pickupLocation,
//     'dropoff_location': dropoffLocation.toJson(),
//     'fare': fare,
//     'booking_for': bookingFor,
//     'booking_time': bookingTime,
//     'status': status,
//     'payment_status': paymentStatus,
//   };

//   String getFormattedDate() {
//     try {
//       final parts = bookingFor.split('-');
//       if (parts.length == 3) {
//         final year = int.parse(parts[0]);
//         final month = int.parse(parts[1]);
//         final day = int.parse(parts[2]);
        
//         final date = DateTime(year, month, day);
//         return DateFormat('MMMM d, y').format(date);
//       }
//     } catch (e) {
//       print('Error parsing date: $e');
//     }
//     return bookingFor;
//   }

//   String getFormattedTime() {
//     if (bookingTime == null || bookingTime!.isEmpty) {
//       return 'Time not specified';
//     }
    
//     try {
//       return DateFormat('h:mm a').format(DateFormat('HH:mm:ss').parse(bookingTime!));
//     } catch (e) {
//       print('Error parsing time: $e');
//       return bookingTime!;
//     }
//   }
// }

// @JsonSerializable()
// class Driver {
//   final int id;
//   final String name;
//   final Vehicle? vehicle;

//   Driver({
//     required this.id,
//     required this.name,
//     this.vehicle,
//   });

//   factory Driver.fromJson(Map<String, dynamic> json) {
//     return Driver(
//       id: (json['id'] as num).toInt(),
//       name: json['name'] as String,
//       vehicle: json['vehicle'] == null ? null : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'vehicle': vehicle?.toJson(),
//   };
// }

// @JsonSerializable()
// class Vehicle {
//   @JsonKey(name: "vehicle_color")
//   final String vehicleColor;
  
//   @JsonKey(name: "vehicle_company")
//   final String vehicleCompany;
  
//   @JsonKey(name: "vehicle_number")
//   final String vehicleNumber;
  
//   @JsonKey(name: "sitting_capacity")
//   final int sittingCapacity;
  
//   @JsonKey(name: "vehicle_type")
//   final VehicleType vehicleType;
  
//   @JsonKey(name: "vehicle_fuel_type")
//   final VehicleFuelType vehicleFuelType;
  
//   @JsonKey(name: "images")
//   final List<VehicleImage> images;

//   Vehicle({
//     required this.vehicleColor,
//     required this.vehicleCompany,
//     required this.vehicleNumber,
//     required this.sittingCapacity,
//     required this.vehicleType,
//     required this.vehicleFuelType,
//     required this.images,
//   });

//   factory Vehicle.fromJson(Map<String, dynamic> json) {
//     return Vehicle(
//       vehicleColor: json['vehicle_color'] as String,
//       vehicleCompany: json['vehicle_company'] as String,
//       vehicleNumber: json['vehicle_number'] as String,
//       sittingCapacity: (json['sitting_capacity'] as num).toInt(),
//       vehicleType: VehicleType.fromJson(json['vehicle_type'] as Map<String, dynamic>),
//       vehicleFuelType: VehicleFuelType.fromJson(json['vehicle_fuel_type'] as Map<String, dynamic>),
//       images: (json['images'] as List<dynamic>)
//           .map((e) => VehicleImage.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'vehicle_color': vehicleColor,
//     'vehicle_company': vehicleCompany,
//     'vehicle_number': vehicleNumber,
//     'sitting_capacity': sittingCapacity,
//     'vehicle_type': vehicleType.toJson(),
//     'vehicle_fuel_type': vehicleFuelType.toJson(),
//     'images': images.map((e) => e.toJson()).toList(),
//   };
// }

// @JsonSerializable()
// class VehicleType {
//   final int id;
//   final String name;
//   @JsonKey(name: "display_name")
//   final String displayName;

//   VehicleType({
//     required this.id,
//     required this.name,
//     required this.displayName,
//   });

//   factory VehicleType.fromJson(Map<String, dynamic> json) {
//     return VehicleType(
//       id: (json['id'] as num).toInt(),
//       name: json['name'] as String,
//       displayName: json['display_name'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'display_name': displayName,
//   };
// }

// @JsonSerializable()
// class VehicleFuelType {
//   final int id;
//   final String name;
//   @JsonKey(name: "display_name")
//   final String displayName;

//   VehicleFuelType({
//     required this.id,
//     required this.name,
//     required this.displayName,
//   });

//   factory VehicleFuelType.fromJson(Map<String, dynamic> json) {
//     return VehicleFuelType(
//       id: (json['id'] as num).toInt(),
//       name: json['name'] as String,
//       displayName: json['display_name'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'display_name': displayName,
//   };
// }

// @JsonSerializable()
// class VehicleImage {
//   final int id;
//   final String image;

//   VehicleImage({
//     required this.id,
//     required this.image,
//   });

//   factory VehicleImage.fromJson(Map<String, dynamic> json) {
//     return VehicleImage(
//       id: (json['id'] as num).toInt(),
//       image: json['image'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'image': image,
//   };
// }

// @JsonSerializable()
// class DropoffLocation {
//   @JsonKey(name: "name")
//   final String name;

//   DropoffLocation({
//     required this.name,
//   });

//   factory DropoffLocation.fromJson(Map<String, dynamic> json) {
//     return DropoffLocation(
//       name: json['name'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'name': name,
//   };
// }

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

  factory PassengerUpcomingBookingsResponse.fromJson(Map<String, dynamic> json) {
    return PassengerUpcomingBookingsResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => PassengerUpcomingBooking.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

@JsonSerializable()
class PassengerUpcomingBooking {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'driver')
  final Driver? driver;
  @JsonKey(name: 'pickup_location')
  final String pickupLocation;
  @JsonKey(name: 'dropoff_location')
  final DropoffLocation dropoffLocation;
  @JsonKey(name: 'fare')
  final String fare;
  @JsonKey(name: 'booking_for')
  final String bookingFor;
  @JsonKey(name: 'booking_time')
  final String? bookingTime;
  
  // Add status and payment_status fields with default values
  // since they're not in the sample data but in your model
  @JsonKey(defaultValue: 'pending')
  final String status;
  @JsonKey(defaultValue: 'pending')
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
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'driver': driver?.toJson(),
    'pickup_location': pickupLocation,
    'dropoff_location': dropoffLocation.toJson(),
    'fare': fare,
    'booking_for': bookingFor,
    'booking_time': bookingTime,
    'status': status,
    'payment_status': paymentStatus,
  };

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
  final Vehicle? vehicle;

  Driver({
    required this.id,
    required this.name,
    this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      vehicle: json['vehicle'] == null ? null : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'vehicle': vehicle?.toJson(),
  };
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

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleColor: json['vehicle_color'] as String,
      vehicleCompany: json['vehicle_company'] as String,
      vehicleNumber: json['vehicle_number'] as String,
      sittingCapacity: (json['sitting_capacity'] as num).toInt(),
      vehicleType: VehicleType.fromJson(json['vehicle_type'] as Map<String, dynamic>),
      vehicleFuelType: VehicleFuelType.fromJson(json['vehicle_fuel_type'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>)
          .map((e) => VehicleImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'vehicle_color': vehicleColor,
    'vehicle_company': vehicleCompany,
    'vehicle_number': vehicleNumber,
    'sitting_capacity': sittingCapacity,
    'vehicle_type': vehicleType.toJson(),
    'vehicle_fuel_type': vehicleFuelType.toJson(),
    'images': images.map((e) => e.toJson()).toList(),
  };
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

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayName: json['display_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'display_name': displayName,
  };
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

  factory VehicleFuelType.fromJson(Map<String, dynamic> json) {
    return VehicleFuelType(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayName: json['display_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'display_name': displayName,
  };
}

@JsonSerializable()
class VehicleImage {
  final int id;
  final String image;

  VehicleImage({
    required this.id,
    required this.image,
  });

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
  };
}

@JsonSerializable()
class DropoffLocation {
  @JsonKey(name: "name")
  final String name;

  DropoffLocation({
    required this.name,
  });

  factory DropoffLocation.fromJson(Map<String, dynamic> json) {
    return DropoffLocation(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}