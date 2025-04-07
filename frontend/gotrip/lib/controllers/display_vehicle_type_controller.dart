import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../model/vehicle_model.dart';
import '../network/http_client.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/material.dart';

class VehicleTypeController extends GetxController {
  var isLoading = true.obs;
  var vehicleTypes = <VehicleTypeModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicleTypes();
  }

  // Map vehicle type names to appropriate icons
  IconData getIconForVehicleType(String typeName) {
    switch (typeName.toLowerCase()) {
      case 'suv':
        return LineAwesomeIcons.car_side_solid;
      case 'sedan':
        return LineAwesomeIcons.car_solid;
      case 'hatchback':
        return LineAwesomeIcons.car_solid;
      case 'off road':
        return LineAwesomeIcons.truck_monster_solid;
      case '4x4':
        return LineAwesomeIcons.truck_monster_solid;
      default:
        return LineAwesomeIcons.car_side_solid;
    }
  }

  Future<void> fetchVehicleTypes() async {
    try {
      isLoading(true);
      errorMessage('');
      
      final response = await httpClient.get('/api/get-vehicle-categories/');
      
      final data = response.data;
      if (data['status'] == 'success') {
        final vehicleTypeList = data['data']['vehicle_type'] as List;
        vehicleTypes.value = vehicleTypeList
            .map((item) => VehicleTypeModel.fromJson(item))
            .toList();
      } else {
        errorMessage.value = data['message'] ?? 'Unknown error';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        errorMessage.value = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
      } else {
        errorMessage.value = 'Network error: ${e.message}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}