import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/model/booking_model/booking_model.dart';
import 'package:gotrip/network/http_client.dart';

class AvailableBookingController extends GetxController {
  // Observables for loading state, booking details, and error messages
  var isLoading = false.obs;
  var bookings = <BookingModel>[].obs;
  var errorMessage = ''.obs;
  
  // Track accepted bookings
  var acceptedBookingIds = <int>[].obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getAvailableBooking();
  }

  // Check if a booking is accepted
  bool isBookingAccepted(int bookingId) {
    return acceptedBookingIds.contains(bookingId);
  }
  
  Future<void> getAvailableBooking() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Call the available booking endpoint
      final response = await httpClient.get('/bookings/available-booking/');

      if (response.data['status'] == "success") {
        // Extract the 'data' field and map it to the list of BookingModel objects
        List<dynamic> responseData = response.data['data'];
        bookings.value = responseData
            .map((booking) => BookingModel.fromJson(booking))
            .toList();
        
        Get.snackbar(
          'Success',
          "${response.data['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = "${response.data['message']}";
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

  Future<void> acceptBooking(int bookingId) async {
    try {
      final response = await httpClient.post(
        '/bookings/accept-booking/',
        data: {'booking_id': bookingId}, // Must match your Django view
      );

      if (response.statusCode == 200) {
        // Mark this booking as accepted
        if (!acceptedBookingIds.contains(bookingId)) {
          acceptedBookingIds.add(bookingId);
        }
        
        // Refresh the list of available bookings
        getAvailableBooking();
        
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