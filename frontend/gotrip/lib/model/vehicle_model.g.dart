// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleTypeModel _$VehicleTypeModelFromJson(Map<String, dynamic> json) =>
    VehicleTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayName: json['display_name'] as String,
    );

Map<String, dynamic> _$VehicleTypeModelToJson(VehicleTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
    };

FuelTypeModel _$FuelTypeModelFromJson(Map<String, dynamic> json) =>
    FuelTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayName: json['display_name'] as String,
    );

Map<String, dynamic> _$FuelTypeModelToJson(FuelTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
    };

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: (json['id'] as num?)?.toInt(),
      vehicleColor: json['vehicle_color'] as String,
      vehicleCompany: json['vehicle_company'] as String,
      vehicleType: (json['vehicle_type'] as num).toInt(),
      vehicleTypeDisplay: json['vehicle_type_display'] as String?,
      vehicleFuelType: (json['vehicle_fuel_type'] as num).toInt(),
      vehicleFuelTypeDisplay: json['vehicle_fuel_type_display'] as String?,
      vehicleNumber: json['vehicle_number'] as String,
      sittingCapacity: (json['sitting_capacity'] as num).toInt(),
      imageCount: (json['image_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_color': instance.vehicleColor,
      'vehicle_company': instance.vehicleCompany,
      'vehicle_type': instance.vehicleType,
      'vehicle_type_display': instance.vehicleTypeDisplay,
      'vehicle_fuel_type': instance.vehicleFuelType,
      'vehicle_fuel_type_display': instance.vehicleFuelTypeDisplay,
      'vehicle_number': instance.vehicleNumber,
      'sitting_capacity': instance.sittingCapacity,
      'image_count': instance.imageCount,
    };
