import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:gotrip/network/http_client.dart';

class DriverController extends GetxController {
  // Observable variables
  final isLoading = true.obs;
  final drivers = <dynamic>[].obs;  // Keep as dynamic to match API response structure
  final errorMessage = ''.obs;
  final selectedVehicleTypeId = 0.obs;
  final selectedVehicleTypeName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    if (Get.arguments != null) {
      if (Get.arguments['vehicleTypeId'] != null) {
        selectedVehicleTypeId.value = Get.arguments['vehicleTypeId'];
      }
      
      if (Get.arguments['vehicleTypeName'] != null) {
        selectedVehicleTypeName.value = Get.arguments['vehicleTypeName'];
      }
      
      // Fetch drivers based on selected vehicle type
      if (selectedVehicleTypeId.value > 0) {
        fetchDriversByVehicleType(selectedVehicleTypeId.value);
      }
    }
  }

  // Method to fetch drivers by vehicle type from API
  Future<void> fetchDriversByVehicleType(int vehicleTypeId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('Fetching drivers for vehicle type ID: $vehicleTypeId');
      
      // Using the exact endpoint path as seen in Postman
      final response = await httpClient.get(
        '/vehicles/drivers-by-vehicle-type/',
        data: {
          'vehicle_type_id': vehicleTypeId
        }
      );
      
      print('Response received: ${response.statusCode}');
      print('Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success' && data['data'] != null) {
          // Store the raw driver data as provided by the API
          drivers.value = data['data'];
          print('Drivers loaded successfully: ${drivers.length}');
          // Clear any previous error message
          errorMessage.value = '';
        } else {
          errorMessage.value = data['message'] ?? 'Failed to get drivers';
          print('API error message: ${data['message']}');
        }
      } else {
        errorMessage.value = 'Failed to load drivers';
        print('API returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      print('DioError type: ${e.type}');
      print('DioError request path: ${e.requestOptions.path}');
      print('DioError request data: ${e.requestOptions.data}');
      
      if (e.response != null) {
        print('DioError response: ${e.response?.data}');
      }
      
      errorMessage.value = e.response?.data?['message'] ?? 'Network error occurred';
    } catch (e) {
      print('Unexpected error: $e');
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // Method to retry loading data
  void retryLoading() {
    if (selectedVehicleTypeId.value > 0) {
      fetchDriversByVehicleType(selectedVehicleTypeId.value);
    }
  }
}