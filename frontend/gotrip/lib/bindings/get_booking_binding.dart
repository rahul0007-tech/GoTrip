import 'package:get/get.dart';
import 'package:gotrip/controllers/khalti_payment_controller.dart';
import '../controllers/get_booking_controller.dart';

class AvailableBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvailableBookingController>(() => AvailableBookingController());
    Get.lazyPut<KhaltiPaymentController>(() => KhaltiPaymentController());
  }
}
