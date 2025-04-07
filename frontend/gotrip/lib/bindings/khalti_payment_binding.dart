// import 'package:get/get.dart';
// import '../controllers/khalti_payment_controller.dart';

// class AvailableBookingBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<KhaltiPaymentController>(() => KhaltiPaymentController());
//   }
// }



import 'package:get/get.dart';
import '../controllers/khalti_payment_controller.dart';


class KhaltiPaymentBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure KhaltiPaymentController is lazily put
    Get.lazyPut<KhaltiPaymentController>(() => KhaltiPaymentController());
  }
}