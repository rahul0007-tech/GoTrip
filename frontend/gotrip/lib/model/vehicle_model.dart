import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleTypeModel {
  final int id;
  final String name;
  
  @JsonKey(name: "display_name")
  final String displayName;

  VehicleTypeModel({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => _$VehicleTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleTypeModelToJson(this);
}

@JsonSerializable()
class FuelTypeModel {
  final int id;
  final String name;
  
  @JsonKey(name: "display_name")
  final String displayName;

  FuelTypeModel({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) => _$FuelTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$FuelTypeModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VehicleModel {
  final int? id;
  
  @JsonKey(name: "vehicle_color")
  final String vehicleColor;
  
  @JsonKey(name: "vehicle_company")
  final String vehicleCompany;
  
  @JsonKey(name: "vehicle_type")
  final int vehicleType;
  
  @JsonKey(name: "vehicle_type_display")
  final String? vehicleTypeDisplay;
  
  @JsonKey(name: "vehicle_fuel_type")
  final int vehicleFuelType;
  
  @JsonKey(name: "vehicle_fuel_type_display")
  final String? vehicleFuelTypeDisplay;
  
  @JsonKey(name: "vehicle_number")
  final String vehicleNumber;
  
  @JsonKey(name: "sitting_capacity")
  final int sittingCapacity;
  
  @JsonKey(name: "image_count")
  final int? imageCount;

  VehicleModel({
    this.id,
    required this.vehicleColor,
    required this.vehicleCompany,
    required this.vehicleType,
    this.vehicleTypeDisplay,
    required this.vehicleFuelType,
    this.vehicleFuelTypeDisplay,
    required this.vehicleNumber,
    required this.sittingCapacity,
    this.imageCount,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => _$VehicleModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}