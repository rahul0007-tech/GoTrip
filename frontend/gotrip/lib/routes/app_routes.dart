import 'package:get/get.dart';
import 'package:gotrip/pages/profile/passenger_profile_page.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
import '../bindings/passenger_upcoming_booking_binding.dart';
import '../pages/bookings/passenger_upcoming_booking.dart';

class AppRoutes {
  static const String passengerUpcomingBookings = '/passenger/upcoming-bookings';
  
  static final routes = [
    GetPage(
      name: '/profile',
      page: () => const PassengerProfilePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PassengerProfileController());
      }),
    ),
    GetPage(
      name: passengerUpcomingBookings,
      page: () => const PassengerUpcomingBookingsPage(),
      binding: PassengerUpcomingBookingBinding(),
    ),
  ];
}