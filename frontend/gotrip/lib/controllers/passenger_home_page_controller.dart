import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../model/booking_model/passenger_upcoming_booking.dart';

class PassengerHomePageController extends GetxController {
  final isLoading = false.obs;
  
  // Add upcoming bookings using the specialized model
  final RxList<PassengerUpcomingBooking> upcomingBookings = <PassengerUpcomingBooking>[].obs;
  final isBookingsLoading = true.obs;
  final hasBookingsError = false.obs;
  final bookingsErrorMessage = ''.obs;
  
  // Storage for token
  final _storage = GetStorage();
  
  // API endpoints
  final String upcomingBookingsEndpoint = '/bookings/passengerupcomingbooking/';
  
  // Create a Dio instance directly in the controller
  late final Dio _dio;
  
  @override
  void onInit() {
    super.onInit();
    
    // Initialize Dio with correct configuration
    _dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8000', // For Android emulator
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    
    // Add token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = _getToken();
          
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            Get.snackbar(
              'Session Expired',
              'Please log in again to continue',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
          return handler.next(e);
        },
      ),
    );
    
    // Initialize data
    fetchUpcomingBookings();
  }
  
  // Get token from storage
  String? _getToken() {
    return _storage.read('access_token');
  }
  
  // Fetch upcoming bookings from API
  Future<void> fetchUpcomingBookings() async {
    try {
      isBookingsLoading.value = true;
      hasBookingsError.value = false;
      
      if (_getToken() == null) {
        hasBookingsError.value = true;
        bookingsErrorMessage.value = 'Authentication required';
        return;
      }
      
      final response = await _dio.get(upcomingBookingsEndpoint);
      
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic> && 
            response.data.containsKey('status') && 
            response.data.containsKey('data')) {
          
          upcomingBookings.clear();
          
          final responseStatus = response.data['status'] as String;
          final responseMessage = response.data['message'] as String;
          
          if (responseStatus == 'success') {
            final List<dynamic> rawBookings = response.data['data'];
            
            List<PassengerUpcomingBooking> parsedBookings = [];
            for (var booking in rawBookings) {
              try {
                parsedBookings.add(PassengerUpcomingBooking.fromJson(booking));
              } catch (e) {
                print('Error parsing booking: $e');
              }
            }
            
            upcomingBookings.assignAll(parsedBookings);
          } else {
            hasBookingsError.value = true;
            bookingsErrorMessage.value = responseMessage;
          }
        } else {
          hasBookingsError.value = true;
          bookingsErrorMessage.value = 'Invalid response format';
        }
      }
    } catch (e) {
      hasBookingsError.value = true;
      
      if (e is DioException && e.response?.statusCode == 404) {
        bookingsErrorMessage.value = 'No upcoming bookings found';
        upcomingBookings.clear();
      } else {
        bookingsErrorMessage.value = 'Failed to load upcoming bookings';
      }
    } finally {
      isBookingsLoading.value = false;
    }
  }
  
  // Cancel a booking
  Future<void> cancelBooking(int bookingId) async {
    try {
      isLoading.value = true;
      
      if (_getToken() == null) {
        Get.snackbar(
          'Login Required',
          'Please log in to cancel booking',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await _dio.post(
        '/bookings/cancel-booking/',
        data: {'booking_id': bookingId},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Booking cancelled successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        await fetchUpcomingBookings();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel booking. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Pull to refresh functionality
  Future<void> refreshData() async {
    await fetchUpcomingBookings();
  }
}