import 'package:gotrip/model/user_model/driver_model.dart';

class DriverDetailsAdapter {
  /// Creates a DriverModel from a Map, providing default values for missing fields
  static DriverModel fromMap(Map<String, dynamic> data) {
    return DriverModel(
      id: data['id'] ?? 0,
      name: data['name'] ?? 'Unknown Driver',
      phone: data['phone'] ?? 0,
      email: data['email'],
      status: data['status'],
      photo: data['photo'],
    );
  }
  
  /// Wraps the dynamic arguments in proper DriverModel
  static DriverModel fromArguments(dynamic arguments) {
    // Handle the case where arguments is already a DriverModel
    if (arguments is DriverModel) {
      return arguments;
    }
    
    // Handle the case where arguments is a Map
    if (arguments is Map<String, dynamic>) {
      return fromMap(arguments);
    }
    
    // Fallback to a default model
    return DriverModel(
      id: 0,
      name: 'Unknown Driver',
      phone: 0,
    );
  }
}