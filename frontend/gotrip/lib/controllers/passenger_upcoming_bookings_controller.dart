import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../network/http_client.dart';
import '../model/booking_model/upcomming_booking.dart';

class PassengerUpcomingBookingsController extends GetxController {
  final RxList<UpcomingBooking> bookings = <UpcomingBooking>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchUpcomingBookings();
  }

  Future<void> fetchUpcomingBookings() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');
      
      final response = await httpClient.get('/bookings/accepted-drivers/');
      
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final List<dynamic> bookingsData = responseData['data'] ?? [];
          final List<UpcomingBooking> parsedBookings = [];
          
          for (var bookingData in bookingsData) {
            try {
              if (bookingData != null) {
                final booking = UpcomingBooking(
                  id: bookingData['booking_id'] ?? 0,
                  passenger: Passenger(name: ''), // We don't need passenger info in passenger view
                  pickupLocation: bookingData['pickup_location'] ?? '',
                  dropoffLocation: DropoffLocation(
                    name: (bookingData['dropoff_location'] as Map<String, dynamic>?)?['name'] ?? ''
                  ),
                  fare: (bookingData['fare'] ?? '').toString(),
                  bookingFor: bookingData['booking_for'] ?? '',
                  bookingTime: bookingData['booking_time'],
                  driver: bookingData['driver'] != null ? 
                    Driver(
                      id: bookingData['driver']['id'] ?? 0,
                      name: bookingData['driver']['name'] ?? '',
                      vehicle: null // Vehicle info not needed for now
                    ) : null
                );
                parsedBookings.add(booking);
              }
            } catch (e) {
              print('Error parsing booking: $e');
              print('Problematic booking data: $bookingData');
            }
          }
          
          bookings.assignAll(parsedBookings);
          hasError(false);
          errorMessage('');
        } else {
          bookings.clear();
          hasError(true);
          errorMessage(responseData['message'] ?? 'No bookings found');
        }
      } else {
        bookings.clear();
        hasError(true);
        errorMessage('Failed to load bookings');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
      bookings.clear();
      hasError(true);
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          errorMessage('No bookings found');
        } else {
          errorMessage(e.response?.data?['message'] ?? 'Failed to load bookings');
        }
      } else {
        errorMessage('Failed to load bookings');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> refresh() async {
    await fetchUpcomingBookings();
  }
}