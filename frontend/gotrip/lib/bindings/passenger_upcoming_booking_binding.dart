import 'package:get/get.dart';
import '../controllers/passenger_home_page_controller.dart';

class PassengerUpcomingBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerHomePageController>(
      () => PassengerHomePageController(),
    );
  }
}