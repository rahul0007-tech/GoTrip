import 'package:get/get.dart';
import '../controllers/passenger_upcoming_bookings_controller.dart';

class PassengerUpcomingBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerUpcomingBookingsController>(
      () => PassengerUpcomingBookingsController(),
    );
  }
}