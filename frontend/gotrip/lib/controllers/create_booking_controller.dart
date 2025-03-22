

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class CreateBookingController extends GetxController {
//   // Observable fields for booking data
//   var pickupLocation = ''.obs;
//   var dropoffLocation = ''.obs;
//   var isLoading = false.obs;

//   // Store the date as a string
//   var bookingDate = ''.obs;

//   // Controller for the date text field
//   final TextEditingController dateController = TextEditingController();

//   // Setup Dio with your backend URL
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'http://10.0.2.2:8000', // Update with your backend URL
//       connectTimeout: Duration(seconds: 20),
//       receiveTimeout: Duration(seconds: 20),
//     ),
//   );

//   final box = GetStorage();

//   Future<void> createBooking() async {
//     isLoading.value = true;
//     try {
//       // Retrieve the access token from storage
//       String? accessToken = box.read('access_token');
//       if (accessToken == null) {
//         Get.snackbar(
//           'Error',
//           'No access token found. Please login again.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Set the token in the headers
//       _dio.options.headers["Authorization"] = "Bearer $accessToken";

//       // Call the booking endpoint with pickup, dropoff, and booking date
//       final response = await _dio.post('/bookings/createbooking/', data: {
//         'pickup_location': pickupLocation.value,
//         'dropoff_location': dropoffLocation.value,
//         'booking_for': bookingDate.value, // string date
//       });

//       if (response.statusCode == 201) {
//         Get.snackbar(
//           'Success',
//           response.data['message'] ?? 'Booking created successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         // Clear fields after success
//         pickupLocation.value = '';
//         dropoffLocation.value = '';
//         bookingDate.value = '';
//         dateController.clear();
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to create booking',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } on DioError catch (e) {
//       Get.snackbar(
//         'Error',
//         'An error occurred while creating the booking',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'An unexpected error occurred',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/model/booking_model/booking_model.dart';

class CreateBookingController extends GetxController {
  // Observable fields for booking data
  var pickupLocation = ''.obs;
  var isLoading = false.obs;
  var isLoadingLocations = false.obs;

  // Store the date as a string
  var bookingDate = ''.obs;

  // Store locations from the API
  var locations = <LocationModel>[].obs;

  // Store selected location
  Rx<LocationModel?> selectedLocation = Rx<LocationModel?>(null);

  // Controller for the date text field
  final TextEditingController dateController = TextEditingController();

  // Setup Dio with your backend URL
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000', // Update with your backend URL
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    ),
  );

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchLocations(); // Fetch locations when controller initializes
  }

  // Fetch locations from the backend
  Future<void> fetchLocations() async {
    isLoadingLocations.value = true;
    try {
      // Retrieve the access token from storage
      String? accessToken = box.read('access_token');
      if (accessToken == null) {
        Get.snackbar(
          'Error',
          'No access token found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      // Set the token in the headers
      _dio.options.headers["Authorization"] = "Bearer $accessToken";

      // Call the locations endpoint - make sure this matches your backend API path exactly
      print('Requesting locations from: ${_dio.options.baseUrl}/bookings/locations/');
      try {
        final response = await _dio.get('/bookings/locations/');

        if (response.statusCode == 200) {
          // Parse the response data
          List<dynamic> locationsData = response.data;
          
          print('Response data: $locationsData'); // Add this to debug
          
          locations.value = locationsData.map((data) {
            // Safely handle nullable or missing fields
            int id = data['id'] is int ? data['id'] : 0;
            String name = data['name'] is String ? data['name'] : '';
            double fare = 0.0;
            
            // Only try to parse fare if it exists and isn't null
            if (data.containsKey('fare') && data['fare'] != null) {
              // Handle different numeric types
              if (data['fare'] is int) {
                fare = (data['fare'] as int).toDouble();
              } else if (data['fare'] is double) {
                fare = data['fare'];
              } else if (data['fare'] is String) {
                fare = double.tryParse(data['fare']) ?? 0.0;
              }
            }
            
            return LocationModel(
              id: id,
              name: name,
              fare: fare,
            );
          }).toList();
        } else {
          Get.snackbar(
            'Error',
            'Failed to fetch locations (Status: ${response.statusCode})',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } catch (error) {
        print('Error calling locations API: $error');
        throw error;
      }
    } catch (e) {
      print('Full error while fetching locations: ${e.toString()}');
      
      String errorMessage = 'An error occurred while fetching locations';
      
      // Check if it's a DioError with a response
      if (e is DioError && e.response != null) {
        errorMessage += ': ${e.response?.statusCode} - ${e.response?.statusMessage}';
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        
        // If it's a 404, provide more helpful message
        if (e.response?.statusCode == 404) {
          errorMessage = 'Location endpoint not found (404). Please check your API configuration.';
        }
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // Set the selected location
  void setSelectedLocation(LocationModel? location) {
    selectedLocation.value = location;
  }

  Future<void> createBooking() async {
    if (selectedLocation.value == null) {
      Get.snackbar(
        'Error',
        'Please select a destination',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (pickupLocation.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter pickup location',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (bookingDate.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select booking date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Retrieve the access token from storage
      String? accessToken = box.read('access_token');
      if (accessToken == null) {
        Get.snackbar(
          'Error',
          'No access token found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      // Set the token in the headers
      _dio.options.headers["Authorization"] = "Bearer $accessToken";

      // According to your API, dropoff_location should be a string
      // The API expects the actual location string, not the ID
      final response = await _dio.post('/bookings/createbooking/', data: {
        'pickup_location': pickupLocation.value,
        'dropoff_location': selectedLocation.value!.name, // Send the name as a string
        'booking_for': bookingDate.value,
      });

      if (response.statusCode == 200) { // Your API returns 200 on success, not 201
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Booking created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Clear fields after success
        pickupLocation.value = '';
        selectedLocation.value = null;
        bookingDate.value = '';
        dateController.clear();
      } else {
        Get.snackbar(
          'Error',
          'Failed to create booking',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Booking error: ${e.toString()}');
      // Try to extract error message from response if possible
      String errorMsg = 'An error occurred while creating the booking';
      if (e is DioError && e.response != null) {
        errorMsg = e.response?.data?.toString() ?? errorMsg;
      }
      
      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}