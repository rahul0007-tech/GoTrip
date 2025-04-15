// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:get_storage/get_storage.dart';

// class DriverHomePageController extends GetxController {
//   final totalEarnings = '₹24,580'.obs;
//   final todayEarnings = '₹1,250'.obs;
//   final rideCompleted = 18.obs;
//   final rating = 4.8.obs;
//   final isOnline = true.obs;
//   final isLoading = false.obs;
//   final upcomingRides = 3.obs;
  
//   // Storage for token
//   final _storage = GetStorage();
  
//   // Correct API endpoint based on your Django backend
//   final String apiEndpoint = '/users/driverstatus/';
  
//   // Create a Dio instance directly in the controller
//   late final Dio _dio;
  
//   @override
//   void onInit() {
//     super.onInit();
    
//     // Initialize Dio with correct configuration
//     _dio = Dio(BaseOptions(
//       baseUrl: 'http://10.0.2.2:8000', // For Android emulator
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       },
//     ));
    
//     // Add token interceptor
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           // Get token from storage
//           final String? token = _getToken();
          
//           if (token != null && token.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $token';
//             print('Adding auth token: Bearer $token');
//           } else {
//             print('No auth token available');
//           }
          
//           return handler.next(options);
//         },
//         onError: (e, handler) {
//           print('Request error: ${e.message}');
          
//           // Handle 401 Unauthorized errors
//           if (e.response?.statusCode == 401) {
//             print('401 Unauthorized: User needs to log in again');
            
//             // Show login required message
//             Get.snackbar(
//               'Session Expired',
//               'Please log in again to continue',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//               colorText: Colors.white,
//               duration: const Duration(seconds: 3),
//             );
            
//             // Optional: Navigate to login screen
//             // Get.offAllNamed('/login');
//           }
          
//           return handler.next(e);
//         },
//       ),
//     );
//   }
  
//   // Get token from storage
//   String? _getToken() {
//     return _storage.read('access_token');
//   }
  
//   // Mock booking data
//   final upcomingBookings = [
//     {
//       'id': 'B-7842',
//       'passengerName': 'Rahul Sharma',
//       'pickup': 'Thamel, Kathmandu',
//       'destination': 'Pokhara Lakeside',
//       'time': '10:30 AM',
//       'date': 'April 12, 2025',
//       'amount': '₹3,500',
//       'distance': '204 km',
//       'passengerImage': 'assets/images/profile/user1.jpg',
//     },
//     {
//       'id': 'B-7843',
//       'passengerName': 'Anisha Gurung',
//       'pickup': 'Boudha, Kathmandu',
//       'destination': 'Nagarkot View Point',
//       'time': '2:15 PM',
//       'date': 'April 13, 2025',
//       'amount': '₹1,200',
//       'distance': '32 km',
//       'passengerImage': 'assets/images/profile/user2.jpg',
//     },
//     {
//       'id': 'B-7844',
//       'passengerName': 'Bijay Thapa',
//       'pickup': 'Tribhuvan Airport',
//       'destination': 'Hotel Yak & Yeti',
//       'time': '9:45 AM',
//       'date': 'April 14, 2025',
//       'amount': '₹850',
//       'distance': '7 km',
//       'passengerImage': 'assets/images/profile/user3.jpg',
//     },
//   ].obs;
  
//   // For testing purposes - set a token manually if needed
//   Future<void> setTestToken(String token) async {
//     await _storage.write('access_token', token);
//     print('Test token set: $token');
//   }
  
//   // Toggle online status with API integration
//   Future<void> toggleOnlineStatus() async {
//     try {
//       isLoading.value = true;
      
//       // Check if token exists
//       if (_getToken() == null) {
//         print('No token available, prompting login');
//         Get.snackbar(
//           'Login Required',
//           'Please log in to change your status',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         // Get.offAllNamed('/login');
//         return;
//       }
      
//       print('Calling API: $apiEndpoint');
//       final response = await _dio.post(apiEndpoint);
      
//       print('Response received: ${response.data}');
      
//       // Update local state based on API response
//       final String newStatus = response.data['data'].toString();
//       isOnline.value = newStatus == 'free'; // 'free' = online, 'busy' = offline
      
//       // Show success message
//       Get.snackbar(
//         'Status Updated',
//         response.data['message'] ?? 'Status updated successfully',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: isOnline.value ? Colors.green : Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error toggling status: $e');
      
//       // Only show error if it's not a 401 (that's handled in the interceptor)
//       if (e is DioException && e.response?.statusCode != 401) {
//         Get.snackbar(
//           'Error',
//           'Failed to update status. Please try again.',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

// We'll use your existing model directly without modifying it
// Just import it from your model folder
import '../model/user_model/driver_model.dart';

class DriverHomePageController extends GetxController {
  final totalEarnings = '₹24,580'.obs;
  final todayEarnings = '₹1,250'.obs;
  final rideCompleted = 18.obs;
  final rating = 4.8.obs;
  final isOnline = true.obs;
  final isLoading = false.obs;
  final upcomingRides = 3.obs;
  
  // Add driver profile using your existing model
  final Rx<DriverModel?> driverProfile = Rx<DriverModel?>(null);
  final isProfileLoading = true.obs;
  
  // Storage for token
  final _storage = GetStorage();
  
  // API endpoints
  final String statusEndpoint = '/users/driverstatus/';
  final String profileEndpoint = '/users/driverprofile/';
  
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
            print('No auth token available');
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
    
    // Fetch driver profile when controller initializes
    fetchDriverProfile();
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
  
  // Mock booking data
  final upcomingBookings = [
    {
      'id': 'B-7842',
      'passengerName': 'Rahul Sharma',
      'pickup': 'Thamel, Kathmandu',
      'destination': 'Pokhara Lakeside',
      'time': '10:30 AM',
      'date': 'April 12, 2025',
      'amount': '₹3,500',
      'distance': '204 km',
      'passengerImage': 'assets/images/profile/user1.jpg',
    },
    {
      'id': 'B-7843',
      'passengerName': 'Anisha Gurung',
      'pickup': 'Boudha, Kathmandu',
      'destination': 'Nagarkot View Point',
      'time': '2:15 PM',
      'date': 'April 13, 2025',
      'amount': '₹1,200',
      'distance': '32 km',
      'passengerImage': 'assets/images/profile/user2.jpg',
    },
    {
      'id': 'B-7844',
      'passengerName': 'Bijay Thapa',
      'pickup': 'Tribhuvan Airport',
      'destination': 'Hotel Yak & Yeti',
      'time': '9:45 AM',
      'date': 'April 14, 2025',
      'amount': '₹850',
      'distance': '7 km',
      'passengerImage': 'assets/images/profile/user3.jpg',
    },
  ].obs;
  
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
    // You can add more refresh logic here like fetching latest bookings, etc.
  }
}