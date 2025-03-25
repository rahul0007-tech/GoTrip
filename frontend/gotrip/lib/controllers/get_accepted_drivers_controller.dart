import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gotrip/model/booking_model/booking_model.dart';
import 'package:gotrip/model/user_model/driver_model.dart';
import 'package:gotrip/network/http_client.dart';

class AcceptedDriversController extends GetxController {
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  
  // List to store the booking entries with their accepted drivers
  var bookingsWithDrivers = RxList<Map<String, dynamic>>([]);

  @override
  void onInit() {
    super.onInit();
    getAcceptedDrivers();
  }

  // Fetch accepted drivers for the passenger's pending bookings
  Future<void> getAcceptedDrivers() async {
    isLoading(true);
    hasError(false);
    errorMessage('');
    bookingsWithDrivers.clear();
    
    try {
      final response = await httpClient.get('/bookings/accepted-drivers/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success') {
          final List<dynamic> bookingsData = data['data'];
          
          for (var bookingData in bookingsData) {
            // Extract booking information
            final bookingId = bookingData['booking_id'];
            final pickupLocation = bookingData['pickup_location'];
            
            // Handle dropoff_location correctly - it's now a nested object
            final dropoffLocationData = bookingData['dropoff_location'];
            final dropoffLocation = LocationModel(
              id: 0, // ID might not be in the response, using default
              name: dropoffLocationData['name'],
              fare: double.parse(dropoffLocationData['fare'].toString()),
            );
            
            final fare = bookingData['fare'];
            final bookingFor = DateTime.parse(bookingData['booking_for']);
            
            // Extract drivers with IDs - Update to include the ID
            final List<dynamic> driversData = bookingData['accepted_drivers'];
            final List<DriverModel> drivers = [];
            
            for (var driverData in driversData) {
              // Updated to include driver ID from the response
              drivers.add(
                DriverModel(
                  id: driverData['id'] ?? 0, // Get driver ID from response
                  name: driverData['name'],
                  phone: driverData['phone'] ?? 0, // Get phone if available
                  email: driverData['email'], // Get email if available
                  status: null,
                  photo: null,
                ),
              );
            }
            
            // Add to the list
            bookingsWithDrivers.add({
              'booking_id': bookingId,
              'pickup_location': pickupLocation,
              'dropoff_location': dropoffLocation,
              'fare': fare,
              'booking_for': bookingFor,
              'drivers': drivers,
            });
          }
        } else {
          hasError(true);
          errorMessage('Failed to get data: ${data['message']}');
        }
      } else {
        hasError(true);
        errorMessage('Failed to get accepted drivers. Status: ${response.statusCode}');
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
    } finally {
      isLoading(false);
    }
  }
  
  // Method to select a driver for a booking - Updated to send driver_id
  Future<void> selectDriver(int bookingId, int driverId) async {
    try {
      isLoading(true);
      
      // Updated to send driver_id matching the API requirements
      final response = await httpClient.post(
        '/bookings/select-driver/',
        data: {
          'booking_id': bookingId,
          'driver_id': driverId,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' || data['message'] == 'Driver selected successfully') {
          Get.snackbar(
            'Success',
            'Driver selected successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Refresh the list after selecting a driver
          await getAcceptedDrivers();
        } else {
          Get.snackbar(
            'Error',
            data['message'] ?? data['error'] ?? 'Failed to select driver',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to select driver. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}