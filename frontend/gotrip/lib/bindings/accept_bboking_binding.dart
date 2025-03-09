import 'package:get/get.dart';
import '../controllers/accept_booking_controller.dart';

class AcceptBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AcceptBookingController>(() => AcceptBookingController());
  }
}
