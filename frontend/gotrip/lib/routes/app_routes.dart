import 'package:get/get.dart';
import 'package:gotrip/bindings/passenger_profile_binding.dart';
import 'package:gotrip/pages/profile/passenger_profile_page.dart';

class AppRoutes {
  static const String passengerUpcomingBookings = '/passenger/upcoming-bookings';
  static const String createBooking = '/create_booking_page';
  
  static final routes = [
    GetPage(
      name: '/profile',
      page: () => const PassengerProfilePage(),
      binding: ProfileBinding(),
    ),
  ];
}