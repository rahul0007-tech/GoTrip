import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/model/booking_model/booking_model.dart';
import 'package:gotrip/network/http_client.dart';

import '../model/user_model/driver_model.dart';

class AcceptedDriversController extends GetxController {
  // Observables for loading state, bookings, drivers, and error messages
  var isLoading = false.obs;
  var userBookings = <BookingModel>[].obs;
  var selectedBookingId = RxnInt(null);
  var acceptedDrivers = <DriverModel>[].obs;
  var errorMessage = ''.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getUserBookings();
  }

  // Get all bookings for the current user
  Future<void> getUserBookings() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await httpClient.get('/bookings/');

      if (response.data['status'] == "success") {
        List<dynamic> responseData = response.data['data'];
        userBookings.value = responseData
            .map((booking) => BookingModel.fromJson(booking))
            .toList();
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
      errorMessage.value = 'An error occurred while fetching bookings.';
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

  // Get accepted drivers for a specific booking
  Future<void> getAcceptedDriversForBooking(int bookingId) async {
    isLoading.value = true;
    errorMessage.value = '';
    selectedBookingId.value = bookingId;
    
    try {
      final response = await httpClient.post(
        '/get-accepted-drivers/',
        data: {'booking_id': bookingId},
      );

      if (response.statusCode == 200) {
        // Clear previous drivers
        acceptedDrivers.clear();
        
        // Parse the response according to your Django API
        List<dynamic> driversData = response.data['accepted_drivers'] ?? [];
        
        if (driversData.isNotEmpty) {
          acceptedDrivers.value = driversData
              .map((driver) => DriverModel.fromJson(driver))
              .toList();
        }
      } else {
        errorMessage.value = response.data['error'] ?? 'Failed to load accepted drivers.';
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
      String errorMsg = 'An error occurred while fetching accepted drivers.';
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data.containsKey('error')) {
          errorMsg = data['error'];
        }
      }
      
      errorMessage.value = errorMsg;
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

  // Check if a booking has already been selected
  bool isBookingSelected(int bookingId) {
    return selectedBookingId.value == bookingId;
  }

  // Clear the selected booking and drivers list
  void clearSelectedBooking() {
    selectedBookingId.value = null;
    acceptedDrivers.clear();
  }

  // Get the selected booking object
  BookingModel? getSelectedBooking() {
    if (selectedBookingId.value == null) return null;
    
    try {
      return userBookings.firstWhere((booking) => booking.id == selectedBookingId.value);
    } catch (e) {
      return null;
    }
  }
  
  // Select a driver (you can implement any actions needed when a driver is selected)
  void selectDriver(DriverModel driver) {
    Get.toNamed('/driver_details', arguments: driver);
  }

  // Contact a driver
  void contactDriver(DriverModel driver) {
    // Implement logic to contact the driver (e.g., make a call)
    Get.snackbar(
      'Contact Driver',
      'Calling ${driver.name} at ${driver.phone}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}