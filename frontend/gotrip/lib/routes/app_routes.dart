import 'package:get/get.dart';
import 'package:gotrip/pages/profile/passenger_profile_page.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
// import 'package:gotrip/pages/bookings/create_booking_page.dart';
import 'package:gotrip/controllers/create_booking_controller.dart';

class AppRoutes {
  static const String passengerUpcomingBookings = '/passenger/upcoming-bookings';
  static const String createBooking = '/create_booking_page';
  
  static final routes = [
    GetPage(
      name: '/profile',
      page: () => const PassengerProfilePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PassengerProfileController());
      }),
    ),
    // GetPage(
    //   name: createBooking,
    //   page: () => CreateBookingPage(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => CreateBookingController());
    //   }),
    // ),
  ];
}