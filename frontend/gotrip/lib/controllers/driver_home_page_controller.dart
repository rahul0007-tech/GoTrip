import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../model/user_model/driver_model.dart';
import '../model/booking_model/upcomming_booking.dart';
import '../model/booking_model/trip_history.dart';

class DriverHomePageController extends GetxController {
  final totalEarnings = '₹24,580'.obs;
  final todayEarnings = '₹1,250'.obs;
  final rideCompleted = 18.obs;
  final rating = 4.8.obs;
  final isOnline = true.obs;
  final isLoading = false.obs;
  
  // Add driver profile using your existing model
  final Rx<DriverModel?> driverProfile = Rx<DriverModel?>(null);
  final isProfileLoading = true.obs;
  
  // Add upcoming bookings using the specialized adapter model
  final RxList<UpcomingBooking> upcomingBookings = <UpcomingBooking>[].obs;
  final isBookingsLoading = true.obs;
  final hasBookingsError = false.obs;
  final bookingsErrorMessage = ''.obs;
  
  // Update trip history list to use proper model
  final RxList<TripHistory> tripHistory = <TripHistory>[].obs;
  final isTripHistoryLoading = true.obs;
  final hasTripHistoryError = false.obs;
  final tripHistoryErrorMessage = ''.obs;
  
  // Add vehicle images state
  final RxList<Map<String, dynamic>> vehicleImages = <Map<String, dynamic>>[].obs;
  final isVehicleImagesLoading = true.obs;
  final hasVehicleImagesError = false.obs;
  final vehicleImagesErrorMessage = ''.obs;
  
  // Computed property for upcoming rides count
  int get upcomingRidesCount => upcomingBookings.length;
  
  // Storage for token
  final _storage = GetStorage();
  
  // API endpoints
  final String statusEndpoint = '/users/driverstatus/';
  final String profileEndpoint = '/users/driverprofile/';
  final String upcomingBookingsEndpoint = '/bookings/driverupcommingbooking/';
  final String driverBookingHistoryEndpoint = '/bookings/driverbookinghistory/';
  
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
          // Get token from storage
          final String? token = _getToken();
          
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print('Adding auth token: Bearer $token');
          } else {
            print('No token available');
          }
          
          return handler.next(options);
        },
        onError: (e, handler) {
          print('Request error: ${e.message}');
          
          // Handle 401 Unauthorized errors
          if (e.response?.statusCode == 401) {
            print('401 Unauthorized: User needs to log in again');
            
            // Show login required message
            Get.snackbar(
              'Session Expired',
              'Please log in again to continue',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            
            // Optional: Navigate to login screen
            // Get.offAllNamed('/login');
          }
          
          return handler.next(e);
        },
      ),
    );
    
    // Initialize data
    initData();
  }
  
  // Initialize all data
  Future<void> initData() async {
    await fetchDriverProfile();
    await fetchUpcomingBookings();
    await fetchVehicleImages(); // Add this line
  }
  
  // Get token from storage
  String? _getToken() {
    return _storage.read('access_token');
  }
  
  // Fetch driver profile from API
  Future<void> fetchDriverProfile() async {
    try {
      isProfileLoading.value = true;
      
      // Check if token exists
      if (_getToken() == null) {
        print('No token available, cannot fetch profile');
        return;
      }
      
      print('Fetching driver profile from: $profileEndpoint');
      final response = await _dio.get(profileEndpoint);
      
      print('Profile response received');
      
      if (response.statusCode == 200) {
        // Parse profile data using your existing model
        final profileData = DriverModel.fromJson(response.data);
        driverProfile.value = profileData;
        
        // Update online status based on profile data
        isOnline.value = profileData.status == 'free';
        
        print('Driver profile loaded: ${profileData.name}');
      }
    } catch (e) {
      print('Error fetching driver profile: $e');
      // No need to show a snackbar here as it might be annoying during initial load
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> fetchDriverHistory() async {
    try {
      isTripHistoryLoading.value = true;
      hasTripHistoryError.value = false;
      
      if (_getToken() == null) {
        print('No token available, cannot fetch history');
        hasTripHistoryError.value = true;
        tripHistoryErrorMessage.value = 'Authentication required';
        return;
      }
      
      print('Fetching driver history from: $driverBookingHistoryEndpoint');
      final response = await _dio.get(driverBookingHistoryEndpoint);
      
      print('Driver history response received: ${response.data}');
      
      if (response.statusCode == 200) {
        final historyResponse = DriverTripHistoryResponse.fromJson(response.data);
        tripHistory.assignAll(historyResponse.data);
        print('Loaded ${tripHistory.length} trips');
      } else {
        hasTripHistoryError.value = true;
        tripHistoryErrorMessage.value = 'Failed to load trip history';
      }
    } catch (e) {
      print('Error fetching driver history: $e');
      hasTripHistoryError.value = true;
      tripHistoryErrorMessage.value = 'Failed to load trip history';
    } finally {
      isTripHistoryLoading.value = false;
    }
  }
  
  // Fetch upcoming bookings from API
  Future<void> fetchUpcomingBookings() async {
    try {
      isBookingsLoading.value = true;
      hasBookingsError.value = false;
      
      // Check if token exists
      if (_getToken() == null) {
        print('No token available, cannot fetch bookings');
        hasBookingsError.value = true;
        bookingsErrorMessage.value = 'Authentication required';
        return;
      }
      
      print('Fetching upcoming bookings from: $upcomingBookingsEndpoint');
      final response = await _dio.get(upcomingBookingsEndpoint);
      
      print('Bookings response received: ${response.data}');
      
      if (response.statusCode == 200) {
        // Debugging - print the type of response data
        print('Response data type: ${response.data.runtimeType}');
        
        // Check if the response contains the expected structure
        if (response.data is Map<String, dynamic> && 
            response.data.containsKey('status') && 
            response.data.containsKey('data')) {
          
          // First clear the existing list to avoid conflicts
          upcomingBookings.clear();
          
          final responseStatus = response.data['status'] as String;
          final responseMessage = response.data['message'] as String;
          
          if (responseStatus == 'success') {
            // Get the raw data list
            final List<dynamic> rawBookings = response.data['data'];
            
            // Manually convert each item in the list to an UpcomingBooking
            List<UpcomingBooking> parsedBookings = [];
            for (var booking in rawBookings) {
              try {
                parsedBookings.add(UpcomingBooking.fromJson(booking));
              } catch (e) {
                print('Error parsing booking: $e');
                print('Problematic booking data: $booking');
              }
            }
            
            // Now safely assign the parsed bookings to our observable list
            upcomingBookings.assignAll(parsedBookings);
            print('Loaded ${upcomingBookings.length} upcoming bookings');
          } else {
            // Handle API error response
            hasBookingsError.value = true;
            bookingsErrorMessage.value = responseMessage;
            print('API error: $responseMessage');
          }
        } else {
          // Invalid response format
          hasBookingsError.value = true;
          bookingsErrorMessage.value = 'Invalid response format';
          print('Invalid response format: ${response.data}');
        }
      }
    } catch (e) {
      print('Error fetching upcoming bookings: $e');
      hasBookingsError.value = true;
      
      // Check if it's a 404 Not Found (no bookings)
      if (e is DioException && e.response?.statusCode == 404) {
        // This is an expected response when no bookings are found
        bookingsErrorMessage.value = 'No upcoming bookings found';
        // Clear the list just in case
        upcomingBookings.clear();
      } else {
        // Some other error occurred
        bookingsErrorMessage.value = 'Failed to load upcoming bookings';
      }
    } finally {
      isBookingsLoading.value = false;
    }
  }
  
  // Add vehicle images fetch method
  Future<void> fetchVehicleImages() async {
    try {
      isVehicleImagesLoading.value = true;
      hasVehicleImagesError.value = false;
      
      if (_getToken() == null) {
        print('No token available, cannot fetch vehicle images');
        hasVehicleImagesError.value = true;
        vehicleImagesErrorMessage.value = 'Authentication required';
        return;
      }
      
      final response = await _dio.get('/vehicles/get-vehicle-image/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          vehicleImages.assignAll(List<Map<String, dynamic>>.from(data['data']));
          print('Loaded ${vehicleImages.length} vehicle images');
        } else {
          hasVehicleImagesError.value = true;
          vehicleImagesErrorMessage.value = data['message'] ?? 'Failed to load vehicle images';
        }
      }
    } catch (e) {
      print('Error fetching vehicle images: $e');
      hasVehicleImagesError.value = true;
      if (e is DioException && e.response?.statusCode == 404) {
        vehicleImagesErrorMessage.value = 'No images found for this vehicle.';
        vehicleImages.clear();
      } else {
        vehicleImagesErrorMessage.value = 'Failed to load vehicle images';
      }
    } finally {
      isVehicleImagesLoading.value = false;
    }
  }
  
  // Toggle online status with API integration
  Future<void> toggleOnlineStatus() async {
    try {
      isLoading.value = true;
      
      // Check if token exists
      if (_getToken() == null) {
        print('No token available, prompting login');
        Get.snackbar(
          'Login Required',
          'Please log in to change your status',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      print('Calling API: $statusEndpoint');
      final response = await _dio.post(statusEndpoint);
      
      print('Response received: ${response.data}');
      
      // Update local state based on API response
      final String newStatus = response.data['data'].toString();
      isOnline.value = newStatus == 'free'; // 'free' = online, 'busy' = offline
      
      // Refresh the profile to get updated data
      fetchDriverProfile();
      
      // Show success message
      Get.snackbar(
        'Status Updated',
        response.data['message'] ?? 'Status updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: isOnline.value ? Colors.green : Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error toggling status: $e');
      
      // Only show error if it's not a 401 (that's handled in the interceptor)
      if (e is DioException && e.response?.statusCode != 401) {
        Get.snackbar(
          'Error',
          'Failed to update status. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  // Pull to refresh functionality
  Future<void> refreshData() async {
    await fetchDriverProfile();
    await fetchUpcomingBookings();
    await fetchVehicleImages(); // Add this line
    // You can add more refresh logic here if needed
  }
}
