import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../model/user_model/driver_model.dart';
import '../model/vehicle_model.dart';
import '../network/http_client.dart';

class DriverWithVehicle {
  final int id;
  final String name;
  final VehicleModel vehicle;

  DriverWithVehicle({
    required this.id,
    required this.name,
    required this.vehicle,
  });

  factory DriverWithVehicle.fromJson(Map<String, dynamic> json) {
    return DriverWithVehicle(
      id: json['id'],
      name: json['name'],
      vehicle: VehicleModel.fromJson(json['vehicle']),
    );
  }
}

class DriverController extends GetxController {
  final int vehicleTypeId;
  var isLoading = true.obs;
  var drivers = <DriverWithVehicle>[].obs;
  var errorMessage = ''.obs;

  DriverController({required this.vehicleTypeId});

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    try {
      isLoading(true);
      errorMessage('');
      
      final response = await httpClient.post(
        '/api/get-drivers-by-vehicle-type/',
        data: {
          'vehicle_type_id': vehicleTypeId,
        },
      );
      
      final data = response.data;
      if (data['status'] == 'success') {
        final driversList = data['data'] as List;
        drivers.value = driversList
            .map((item) => DriverWithVehicle.fromJson(item))
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