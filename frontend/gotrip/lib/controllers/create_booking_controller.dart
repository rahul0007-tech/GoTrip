// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class CreateBookingController extends GetxController {
//   // Observable fields for booking data
//   var pickupLocation = ''.obs;
//   var dropoffLocation = ''.obs;
//   var isLoading = false.obs;
//   var bookingDate = ''.obs;

//   // Setup Dio with your backend URL
//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: 'http://10.0.2.2:8000', // Update with your backend URL
//     connectTimeout: Duration(seconds: 20),
//     receiveTimeout: Duration(seconds: 20),
//   ));

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

//       // Call the booking endpoint with pickup and dropoff locations
//       final response = await _dio.post('/bookings/createbooking/', data: {
//         'pickup_location': pickupLocation.value,
//         'dropoff_location': dropoffLocation.value,
//         'booking_for': bookingDate.value
//       });
//       print("Booking Response Data: ${response.data}");

//       if (response.statusCode == 201) {
//         Get.snackbar(
//           'Success',
//           response.data['message'] ?? 'Booking created successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         // Optionally, clear the fields after success
//         pickupLocation.value = '';
//         dropoffLocation.value = '';
//         bookingDate.value = '';
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
//       print("DioError: ${e.message}");
//       Get.snackbar(
//         'Error',
//         'An error occurred while creating the booking',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Unexpected Error: $e");
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

class CreateBookingController extends GetxController {
  // Observable fields for booking data
  var pickupLocation = ''.obs;
  var dropoffLocation = ''.obs;
  var isLoading = false.obs;

  // Store the date as a string
  var bookingDate = ''.obs;

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

  Future<void> createBooking() async {
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

      // Call the booking endpoint with pickup, dropoff, and booking date
      final response = await _dio.post('/bookings/createbooking/', data: {
        'pickup_location': pickupLocation.value,
        'dropoff_location': dropoffLocation.value,
        'booking_for': bookingDate.value, // string date
      });

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Booking created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Clear fields after success
        pickupLocation.value = '';
        dropoffLocation.value = '';
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
    } on DioError catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while creating the booking',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}


