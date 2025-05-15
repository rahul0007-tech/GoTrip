import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/model/booking_model/passenger_upcoming_booking.dart';
import 'package:gotrip/network/http_client.dart';

class HistoryController extends GetxController {
  // Observable variables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var bookingHistory = <PassengerUpcomingBooking>[].obs;
  
  final box = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    fetchBookingHistory();
  }
  
  // Fetch booking history using Dio and httpClient
  Future<void> fetchBookingHistory() async {
    isLoading(true);
    hasError(false);
    errorMessage('');
    bookingHistory.clear();
    
    try {
      // Get response using the httpClient (which should already handle token)
      final response = await httpClient.get('/bookings/passengerbookinghistory/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success') {
          // Parse the response using the model
          final bookingsResponse = PassengerUpcomingBookingsResponse.fromJson(data);
          bookingHistory.value = bookingsResponse.data;
        } else {
          hasError(true);
          errorMessage(data['message'] ?? 'Unknown error occurred');
          Get.snackbar(
            'Error',
            data['message'] ?? 'Failed to load booking history',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        hasError(true);
        errorMessage('Failed to load booking history. Status: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Failed to load booking history. Status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError(true);
      if (e is DioException) {
        if (e.response != null) {
          errorMessage('Error: ${e.response?.statusMessage}');
        } else {
          errorMessage('Network error: ${e.message}');
        }
      } else {
        errorMessage('Error: ${e.toString()}');
      }
      
      Get.snackbar(
        'Error',
        'Failed to load booking history: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
  
  // Method to get upcoming bookings (future dates)
  List<PassengerUpcomingBooking> getUpcomingBookings() {
    final now = DateTime.now();
    return bookingHistory.where((booking) {
      try {
        final bookingDate = DateTime.parse(booking.bookingFor);
        return bookingDate.isAfter(now);
      } catch (e) {
        print('Error parsing date: $e');
        return false;
      }
    }).toList();
  }
  
  // Method to get past bookings (past dates)
  List<PassengerUpcomingBooking> getPastBookings() {
    final now = DateTime.now();
    return bookingHistory.where((booking) {
      try {
        final bookingDate = DateTime.parse(booking.bookingFor);
        return bookingDate.isBefore(now) || bookingDate.isAtSameMomentAs(now);
      } catch (e) {
        print('Error parsing date: $e');
        return false;
      }
    }).toList();
  }
  
  // Method to refresh the booking history
  void refreshBookingHistory() {
    fetchBookingHistory();
  }
  
  // Method to filter bookings by destination
  List<PassengerUpcomingBooking> filterByDestination(String destination) {
    return bookingHistory.where((booking) => 
      booking.dropoffLocation.name.toLowerCase().contains(destination.toLowerCase())
    ).toList();
  }
  
  // Method to filter bookings by driver
  List<PassengerUpcomingBooking> filterByDriver(String driverName) {
    return bookingHistory.where((booking) => 
      booking.driver != null && 
      booking.driver!.name.toLowerCase().contains(driverName.toLowerCase())
    ).toList();
  }
}