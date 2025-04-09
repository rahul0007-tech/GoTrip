import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../model/vehicle_model.dart';
import '../network/http_client.dart';

class VehicleController extends GetxController {
  // Observable variables
  final isLoading = true.obs;
  final vehicleTypes = <VehicleTypeModel>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicleTypes();
  }

  // Method to fetch vehicle types from API
  Future<void> fetchVehicleTypes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Assuming httpClient is defined in a separate file and imported
      final response = await httpClient.get('/vehicles/vehicle-types-for-passenger/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success' && data['data'] != null && data['data']['vehicle_type'] != null) {
          final List vehicleTypeList = data['data']['vehicle_type'];
          
          // Convert each item to VehicleTypeModel
          vehicleTypes.value = vehicleTypeList
              .map((item) => VehicleTypeModel.fromJson(item))
              .toList();
        } else {
          errorMessage.value = data['message'] ?? 'Failed to get vehicle types';
        }
      } else {
        errorMessage.value = 'Failed to load vehicle types';
      }
    } on DioException catch (e) {
      errorMessage.value = e.response?.data?['message'] ?? 'Network error occurred';
      print('DioError: ${e.message}');
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:gotrip/model/vehicle_model.dart';
// import 'package:gotrip/network/http_client.dart';

// class VehicleController extends GetxController {
//   // Observable variables
//   final isLoading = true.obs;
//   final vehicleTypes = <VehicleTypeModel>[].obs;
//   final errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchVehicleTypes();
//   }

//   // Method to fetch vehicle types from API
//   Future<void> fetchVehicleTypes() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       print('Fetching vehicle types...');
      
//       // Using the path that matches your API
//       final response = await httpClient.get('/vehicles/vehicle-types-for-passenger/');
      
//       print('Response received: ${response.statusCode}');
//       print('Response data: ${response.data}');
      
//       if (response.statusCode == 200) {
//         final data = response.data;
        
//         if (data['status'] == 'success' && data['data'] != null && data['data']['vehicle_type'] != null) {
//           final List vehicleTypeList = data['data']['vehicle_type'];
          
//           // Convert each item to VehicleTypeModel
//           vehicleTypes.value = vehicleTypeList
//               .map((item) => VehicleTypeModel.fromJson(item))
//               .toList();
          
//           print('Vehicle types loaded: ${vehicleTypes.length}');
//           // Clear any previous error
//           errorMessage.value = '';
//         } else {
//           errorMessage.value = data['message'] ?? 'Failed to get vehicle types';
//           print('API error message: ${data['message']}');
//         }
//       } else {
//         errorMessage.value = 'Failed to load vehicle types';
//         print('API returned status code: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       print('DioError: ${e.message}');
//       print('DioError type: ${e.type}');
//       print('DioError request path: ${e.requestOptions.path}');
      
//       if (e.response != null) {
//         print('DioError response: ${e.response?.data}');
//       }
      
//       errorMessage.value = e.response?.data?['message'] ?? 'Network error occurred';
//     } catch (e) {
//       print('Unexpected error: $e');
//       errorMessage.value = 'An unexpected error occurred';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }