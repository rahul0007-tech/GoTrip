import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
import 'package:gotrip/model/booking_model/upcomming_booking.dart';

class PassengerHomePageController extends GetxController {
  final isLoading = false.obs;

  // Add upcoming bookings using the specialized model
  final RxList<UpcomingBooking> upcomingBookings = <UpcomingBooking>[].obs;
  final isBookingsLoading = true.obs;
  final hasBookingsError = false.obs;
  final bookingsErrorMessage = ''.obs;

  // Storage for token
  final _storage = GetStorage();

  // API endpoints
  final String upcomingBookingsEndpoint = '/bookings/passengerupcomingbookings/';

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
      bookingsErrorMessage.value = '';

      if (_getToken() == null) {
        hasBookingsError.value = true;
        bookingsErrorMessage.value = 'Authentication required';
        return;
      }

      final response = await _dio.get(upcomingBookingsEndpoint);
      print('API Response for upcoming bookings: ${response.data}'); // Debug log

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as String;
        final message = responseData['message'] as String;

        if (status == 'success') {
          final List<dynamic> bookingsData = responseData['data'] as List<dynamic>;
          final List<UpcomingBooking> parsedBookings = bookingsData
              .map((booking) {
                final bookingStatus = booking['status'] ?? 'pending';
                print('Booking ${booking['id']} status: $bookingStatus'); // Debug log
                return UpcomingBooking(
                  id: booking['id'],
                  passenger: Passenger(name: ''),
                  pickupLocation: booking['pickup_location'],
                  dropoffLocation: DropoffLocation(
                    name: (booking['dropoff_location'] as Map<String, dynamic>)['name'],
                  ),
                  fare: booking['fare'].toString(),
                  bookingFor: booking['booking_for'],
                  bookingTime: booking['booking_time'],
                  status: bookingStatus,
                  paymentStatus: booking['payment_status'] ?? 'pending',
                  driver: booking['driver'] != null
                      ? Driver(
                          id: booking['driver']['id'],
                          name: booking['driver']['name'],
                          vehicle: booking['driver']['vehicle'] != null
                              ? Vehicle(
                                  vehicleColor: booking['driver']['vehicle']['vehicle_color'],
                                  vehicleCompany: booking['driver']['vehicle']['vehicle_company'],
                                  vehicleNumber: booking['driver']['vehicle']['vehicle_number'],
                                  sittingCapacity: booking['driver']['vehicle']['sitting_capacity'],
                                  vehicleType: booking['driver']['vehicle']['vehicle_type'] != null
                                      ? VehicleType(
                                          id: booking['driver']['vehicle']['vehicle_type']['id'],
                                          name: booking['driver']['vehicle']['vehicle_type']['name'],
                                          displayName: booking['driver']['vehicle']['vehicle_type']['display_name'],
                                        )
                                      : null,
                                  vehicleFuelType: booking['driver']['vehicle']['vehicle_fuel_type'] != null
                                      ? VehicleFuelType(
                                          id: booking['driver']['vehicle']['vehicle_fuel_type']['id'],
                                          name: booking['driver']['vehicle']['vehicle_fuel_type']['name'],
                                          displayName: booking['driver']['vehicle']['vehicle_fuel_type']['display_name'],
                                        )
                                      : null,
                                  images: (booking['driver']['vehicle']['images'] as List<dynamic>?)
                                      ?.map((image) => VehicleImage(
                                            id: image['id'],
                                            image: image['image'],
                                          ))
                                      .toList(),
                                )
                              : null,
                        )
                      : null,
                );
              })
              .toList();

          upcomingBookings.assignAll(parsedBookings);
          print('Loaded ${upcomingBookings.length} bookings'); // Debug log
          print('Booking statuses: ${upcomingBookings.map((b) => '${b.id}: ${b.status}').join(', ')}'); // Debug log
          hasBookingsError.value = false;
          bookingsErrorMessage.value = '';
        } else {
          hasBookingsError.value = true;
          bookingsErrorMessage.value = message;
          upcomingBookings.clear();
        }
      }
    } on DioException catch (e) {
      hasBookingsError.value = true;
      if (e.response?.statusCode == 404) {
        final responseData = e.response?.data as Map<String, dynamic>?;
        bookingsErrorMessage.value = responseData?['message'] ?? 'No upcoming bookings found';
      } else {
        bookingsErrorMessage.value = 'Failed to load upcoming bookings';
      }
      upcomingBookings.clear();
    } catch (e) {
      print('Error fetching bookings: $e');
      hasBookingsError.value = true;
      bookingsErrorMessage.value = 'An unexpected error occurred';
      upcomingBookings.clear();
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

  // Change booking status
  Future<void> changeBookingStatus(int bookingId) async {
    try {
      isLoading.value = true;

      // Find the booking to log its current status
      final booking = upcomingBookings.firstWhere(
        (b) => b.id == bookingId,
        orElse: () => throw Exception("Booking not found with ID: $bookingId"),
      );
      print('Attempting to change status for booking $bookingId');
      print('Current booking details: ID=${booking.id}, Status=${booking.status}, Payment=${booking.paymentStatus}');

      if (_getToken() == null) {
        Get.snackbar(
          'Login Required',
          'Please log in to change booking status',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('Sending status change request for booking $bookingId');
      final response = await _dio.post(
        '/bookings/changebookingstatus/',
        data: {'booking_id': bookingId},
      );
      print('Status change API response: ${response.data}');

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Booking status updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh the bookings list to show updated status
        await fetchUpcomingBookings();
      }
    } catch (e) {
      String errorMessage = 'Failed to update booking status';

      if (e is DioException && e.response?.data != null) {
        print('API error response: ${e.response?.data}');
        // Extract error message from API response
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['error'] ?? e.response?.data['message'] ?? errorMessage;
        } else {
          print('Non-map response data: ${e.response?.data}');
        }
      } else {
        print('Exception while updating booking status: $e');
      }

      Get.snackbar(
        'Error',
        errorMessage,
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
    try {
      // Get PassengerProfileController
      final PassengerProfileController profileController = Get.find<PassengerProfileController>();

      // Fetch both bookings and profile concurrently
      await Future.wait([
        fetchUpcomingBookings(),
        profileController.fetchProfile(),
      ]);

      print('Refresh completed: Bookings and profile updated');
    } catch (e) {
      print('Error during refresh: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}