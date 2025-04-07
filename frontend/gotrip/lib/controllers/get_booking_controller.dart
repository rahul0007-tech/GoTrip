// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:gotrip/model/booking_model/booking_model.dart';
// import 'package:gotrip/network/http_client.dart';

// class AvailableBookingController extends GetxController {
//   // Observables for loading state, booking details, and error messages
//   var isLoading = false.obs;
//   var bookings = <BookingModel>[].obs;
//   var errorMessage = ''.obs;
  
//   // Track accepted bookings
//   var acceptedBookingIds = <int>[].obs;

//   final box = GetStorage();

//   @override
//   void onInit() {
//     super.onInit();
//     getAvailableBooking();
//   }

//   // Check if a booking is accepted
//   bool isBookingAccepted(int bookingId) {
//     return acceptedBookingIds.contains(bookingId);
//   }
  
//   Future<void> getAvailableBooking() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       // Call the available booking endpoint
//       final response = await httpClient.get('/bookings/available-booking/');

//       if (response.data['status'] == "success") {
//         // Extract the 'data' field and map it to the list of BookingModel objects
//         List<dynamic> responseData = response.data['data'];
//         bookings.value = responseData
//             .map((booking) => BookingModel.fromJson(booking))
//             .toList();
        
//         Get.snackbar(
//           'Success',
//           "${response.data['message']}",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         errorMessage.value = "${response.data['message']}";
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

//   Future<void> acceptBooking(int bookingId) async {
//     try {
//       final response = await httpClient.post(
//         '/bookings/accept-booking/',
//         data: {'booking_id': bookingId}, // Must match your Django view
//       );

//       if (response.statusCode == 200) {
//         // Mark this booking as accepted
//         if (!acceptedBookingIds.contains(bookingId)) {
//           acceptedBookingIds.add(bookingId);
//         }
        
//         // Refresh the list of available bookings
//         getAvailableBooking();
        
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
//       // Print out the error details to debug
//       String errorMsg = 'An error occurred while accepting the booking.';
//       if (e.response?.data is Map<String, dynamic>) {
//         final data = e.response!.data as Map<String, dynamic>;
//         // Check both "error" and "message" since your view can return either
//         if (data.containsKey('error')) {
//           errorMsg = data['error'];
//         } else if (data.containsKey('message')) {
//           errorMsg = data['message'];
//         }
//       }

//       Get.snackbar(
//         'Error',
//         errorMsg,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print('Unexpected Error: $e');
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
import 'package:gotrip/model/booking_model/booking_model.dart';
import 'package:gotrip/network/http_client.dart';

class AvailableBookingController extends GetxController {
  // Observables for loading state, booking details, and error messages
  var isLoading = false.obs;
  var bookings = <BookingModel>[].obs;
  var errorMessage = ''.obs;
  
  // Track accepted bookings - make it a RxMap for more reactive updates
  final acceptedBookings = <int, bool>{}.obs;

  final box = GetStorage();
  
  // Constants for storage
  static const String ACCEPTED_BOOKINGS_KEY = 'accepted_bookings';
  
  @override
  void onInit() {
    super.onInit();
    // Load previously accepted bookings from storage
    loadAcceptedBookings();
    fetchAvailableBookings();
  }
  
  // Load accepted bookings from persistent storage
  void loadAcceptedBookings() {
    try {
      final List<dynamic>? storedIds = box.read<List<dynamic>>(ACCEPTED_BOOKINGS_KEY);
      if (storedIds != null && storedIds.isNotEmpty) {
        // Create a map of booking IDs to acceptance status
        for (final id in storedIds) {
          if (id is int) {
            acceptedBookings[id] = true;
          }
        }
        print('Loaded accepted bookings: ${acceptedBookings.keys.toList()}');
      }
    } catch (e) {
      print('Error loading accepted bookings: $e');
    }
  }
  
  // Save accepted bookings to persistent storage
  void saveAcceptedBookings() {
    try {
      final List<int> bookingIds = acceptedBookings.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();
      
      box.write(ACCEPTED_BOOKINGS_KEY, bookingIds);
      print('Saved accepted bookings: $bookingIds');
    } catch (e) {
      print('Error saving accepted bookings: $e');
    }
  }

  // Check if a booking is accepted - more reactive now
  bool isBookingAccepted(int bookingId) {
    return acceptedBookings[bookingId] == true;
  }

  // Renamed for clarity
  Future<void> fetchAvailableBookings() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // First, ensure we have loaded accepted bookings
      loadAcceptedBookings();
      
      // Call the available booking endpoint
      final response = await httpClient.get('/bookings/available-booking/');

      if (response.data['status'] == "success") {
        // Extract the 'data' field and map it to the list of BookingModel objects
        List<dynamic> responseData = response.data['data'];
        List<BookingModel> fetchedBookings = responseData
            .map((booking) => BookingModel.fromJson(booking))
            .toList();
            
        // Update the bookings list first to show something to user
        bookings.value = fetchedBookings;
        
        // Then check acceptance status for each booking in parallel
        await Future.wait(
          fetchedBookings.map((booking) => checkDriverInAcceptedList(booking.id))
        );
        
        // No need for a success snackbar on initial load - it's annoying
        if (errorMessage.value.isNotEmpty) {
          errorMessage.value = '';
        }
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
  
  // New method to check if driver is in the accepted list for this booking
  Future<void> checkDriverInAcceptedList(int bookingId) async {
    try {
      // Get driver ID from storage
      final driverId = box.read('user_id');
      if (driverId == null) return;
      
      // First check local storage
      if (acceptedBookings[bookingId] == true) {
        print('Booking $bookingId is already marked as accepted locally');
        return;
      }
      
      // Then verify with the server
      final response = await httpClient.get(
        '/bookings/check-acceptance/$bookingId/$driverId/',
      );
      
      if (response.statusCode == 200) {
        final bool isAccepted = response.data['is_accepted'] == true;
        print('Server says booking $bookingId acceptance status: $isAccepted');
        
        // Update our local state
        acceptedBookings[bookingId] = isAccepted;
        
        // If accepted, save to storage
        if (isAccepted) {
          saveAcceptedBookings();
        }
      }
    } catch (e) {
      print('Error checking booking acceptance for ID $bookingId: $e');
      
      // Fallback to local storage in case of server error
      if (acceptedBookings.keys.contains(bookingId)) {
        print('Using local fallback for booking $bookingId');
      }
    }
  }

  Future<void> acceptBooking(int bookingId) async {
    try {
      // Immediately mark as accepted for better UX
      acceptedBookings[bookingId] = true;
      
      final response = await httpClient.post(
        '/bookings/accept-booking/',
        data: {'booking_id': bookingId},
      );

      if (response.statusCode == 200) {
        // Confirm the acceptance status
        acceptedBookings[bookingId] = true;
        
        // Save to persistent storage
        saveAcceptedBookings();
        
        // Show success message
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Booking accepted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Revert the acceptance if server rejected
        acceptedBookings.remove(bookingId);
        
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to accept booking.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e) {
      // Revert the acceptance if there was an error
      acceptedBookings.remove(bookingId);
      
      String errorMsg = 'An error occurred while accepting the booking.';
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
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
      // Revert the acceptance if there was an error
      acceptedBookings.remove(bookingId);
      
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