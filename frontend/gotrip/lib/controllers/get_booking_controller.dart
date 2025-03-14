// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class AvailableBookingController extends GetxController {
//   // Observables for loading state, booking details, and error messages
//   var isLoading = false.obs;
//   var bookings = <dynamic>[].obs;
//   var errorMessage = ''.obs;

//   // Setup Dio with your backend URL
//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: 'http://10.0.2.2:8000', // Update with your backend URL if needed
//     connectTimeout: Duration(seconds: 20),
//     receiveTimeout: Duration(seconds: 20),
//   ));

//   final box = GetStorage();

//   @override
//   void onInit() {
//     super.onInit();
//     getAvailableBooking();
//   }

//   Future<void> getAvailableBooking() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       // Retrieve the access token from storage
//       String? accessToken = box.read('access_token');
//       if (accessToken == null) {
//         errorMessage.value = 'No access token found. Please login again.';
//         Get.snackbar(
//           'Error',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Set the token in the headers
//       _dio.options.headers["Authorization"] = "Bearer $accessToken";

//       // Call the available booking endpoint
//       final response = await _dio.get('/bookings/available-booking/');
//       print("Available Booking Response Data: ${response.data}");

//       if (response.statusCode == 200) {
//         if (response.data is List) {
//           bookings.value = response.data;
//           Get.snackbar(
//           'Success',
//           'Available booking retrieved successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         }

//       } else {
//         errorMessage.value = 'Failed to retrieve available booking.';
//         Get.snackbar(
//           'Error',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } on DioError catch (e) {
//       print("DioError: ${e.message}");
//       errorMessage.value = 'An error occurred while fetching available booking.';
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Unexpected Error: $e");
//       errorMessage.value = 'An unexpected error occurred.';
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   Future<void> acceptBooking(Map booking) async {
//     try {
//       final bookingId = booking['id'];
//       // Call your accept endpoint (adjust the endpoint and data as needed)
//       final response = await _dio.post('/bookings/accept', data: {'booking_id': bookingId});
//       if (response.statusCode == 200) {
//         // Optionally remove the accepted booking from the list
//         bookings.remove(booking);
//         Get.snackbar(
//           'Success',
//           'Booking accepted successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to accept booking.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } on DioError catch (e) {
//       print("DioError: ${e.message}");
//       Get.snackbar(
//         'Error',
//         'An error occurred while accepting the booking.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Unexpected Error: $e");
//       Get.snackbar(
//         'Error',
//         'An unexpected error occurred.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AvailableBookingController extends GetxController {
  // Observables for loading state, booking details, and error messages
  var isLoading = false.obs;
  var bookings = <dynamic>[].obs;
  var errorMessage = ''.obs;

  // Setup Dio with your backend URL
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000', // Update with your backend URL if needed
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  ));

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getAvailableBooking();
  }

  Future<void> getAvailableBooking() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Retrieve the access token from storage
      String? accessToken = box.read('access_token');
      if (accessToken == null) {
        errorMessage.value = 'No access token found. Please login again.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      // Set the token in the headers
      _dio.options.headers["Authorization"] = "Bearer $accessToken";

      // Call the available booking endpoint
      final response = await _dio.get('/bookings/available-booking/');
      print("Available Booking Response Data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          bookings.value = response.data;
          Get.snackbar(
            'Success',
            'Available booking retrieved successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = 'Failed to retrieve available booking.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");
      errorMessage.value = 'An error occurred while fetching available booking.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Unexpected Error: $e");
      errorMessage.value = 'An unexpected error occurred.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptBooking(Map booking) async {
    // 1. Print the booking map to see what keys it has
    print('Selected booking: $booking');

    // 2. If the key is "booking_id", use that
    final bookingId = booking['id'];

    try {
      final response = await _dio.post(
        '/bookings/accept-booking/',
        data: {'booking_id': bookingId}, // Must match your Django view
      );

      if (response.statusCode == 200) {
        bookings.remove(booking);
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Booking accepted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to accept booking.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e) {
      // Print out the error details to debug
      print('DioError: ${e.message}');
      print('Response data: ${e.response?.data}');
      
      String errorMsg = 'An error occurred while accepting the booking.';
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        // Check both "error" and "message" since your view can return either
        if (data.containsKey('error')) {
          errorMsg = data['error'];
        } else if (data.containsKey('message')) {
          errorMsg = data['message'];
        }
      }

      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Unexpected Error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
  // New method to accept a booking by calling your backend API
//   Future<void> acceptBooking(Map booking) async {
//     try {
//       final bookingId = booking['booking_id'];
//       // Call your accept booking endpoint matching the Django API view
//       final response = await _dio.post(
//         '/bookings/accept-booking/', // Ensure this endpoint matches your routing setup
//         data: {'booking_id': bookingId},
//       );

//       if (response.statusCode == 200) {
//         // Remove the accepted booking from the list
//         bookings.remove(booking);
//         Get.snackbar(
//           'Success',
//           response.data['message'] ?? 'Booking accepted successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['message'] ?? 'Failed to accept booking.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } on DioError catch (e) {
//       print("DioError: ${e.message}");
//       String errorMsg = 'An error occurred while accepting the booking.';
//   if (e.response?.data is Map<String, dynamic>) {
//     // Safely read 'message' from the data
//     final data = e.response!.data as Map<String, dynamic>;
//     if (data.containsKey('error')) {
//       errorMsg = data['error'];
//     } else if (data.containsKey('message')) {
//       errorMsg = data['message'];
//     }
//   }
//       Get.snackbar(
//         'Error',
//         errorMsg,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Unexpected Error: $e");
//       Get.snackbar(
//         'Error',
//         'An unexpected error occurred.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
// }




