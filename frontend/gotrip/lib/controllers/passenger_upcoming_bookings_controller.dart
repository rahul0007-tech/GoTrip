// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import '../network/http_client.dart';
// import '../model/booking_model/passenger_upcoming_booking.dart';

// class PassengerUpcomingBookingsController extends GetxController {
//   final RxList<PassengerUpcomingBooking> bookings = <PassengerUpcomingBooking>[].obs;
//   final RxBool isLoading = true.obs;
//   final RxBool hasError = false.obs;
//   final RxString errorMessage = ''.obs;
  
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUpcomingBookings();
//   }

//   Future<void> fetchUpcomingBookings() async {
//     try {
//       isLoading(true);
//       hasError(false);
//       errorMessage('');
      
//       final response = await httpClient.get('/bookings/passengerupcomingbookings/');
      
//       if (response.statusCode == 200 && response.data != null) {
//         final responseData = PassengerUpcomingBookingsResponse.fromJson(response.data);
        
//         if (responseData.status == 'success') {
//           bookings.assignAll(responseData.data);
//           hasError(false);
//           errorMessage('');
//         } else {
//           bookings.clear();
//           hasError(true);
//           errorMessage(responseData.message);
//         }
//       } else {
//         bookings.clear();
//         hasError(true);
//         errorMessage('Failed to load bookings');
//       }
//     } catch (e) {
//       print('Error fetching bookings: $e');
//       bookings.clear();
//       hasError(true);
//       if (e is DioException) {
//         if (e.response?.statusCode == 404) {
//           errorMessage('No bookings found');
//         } else {
//           errorMessage(e.response?.data?['message'] ?? 'Failed to load bookings');
//         }
//       } else {
//         errorMessage('Failed to load bookings');
//       }
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> cancelBooking(int bookingId) async {
//     try {
//       final response = await httpClient.post(
//         '/bookings/cancel-booking/',
//         data: {'booking_id': bookingId},
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Success',
//           'Booking cancelled successfully',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
        
//         await fetchUpcomingBookings();
//       }
//     } catch (e) {
//       print('Error cancelling booking: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to cancel booking. Please try again.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> refresh() async {
//     await fetchUpcomingBookings();
//   }
// }