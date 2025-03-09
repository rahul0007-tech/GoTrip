import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AcceptBookingController extends GetxController {
  // Observable field for booking id input
  var bookingId = ''.obs;
  var isLoading = false.obs;

  // Setup Dio with your backend URL
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000', // Change to your backend URL
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  ));

  final box = GetStorage();

  Future<void> acceptBooking() async {
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

      // Send POST request to the accept booking endpoint with the booking_id
      final response = await _dio.post('/bookings/accept/', data: {
        'booking_id': bookingId.value,
      });
      print("Accept Booking Response: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Booking accepted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Optionally clear the booking ID field
        bookingId.value = '';
      } else {
        Get.snackbar(
          'Error',
          'Failed to accept booking',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");
      Get.snackbar(
        'Error',
        'An error occurred while accepting the booking',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Unexpected Error: $e");
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
