import 'package:get/get.dart';
import '../controllers/get_booking_controller.dart';

class AvailableBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvailableBookingController>(() => AvailableBookingController());
  }
}
