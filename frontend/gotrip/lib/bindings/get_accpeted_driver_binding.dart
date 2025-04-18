import 'package:get/get.dart';
import 'package:gotrip/controllers/get_accepted_drivers_controller.dart';
import 'package:gotrip/controllers/khalti_payment_controller.dart';

class AcceptedDriversBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AcceptedDriversController>(
      () => AcceptedDriversController(),
      

    );
    Get.lazyPut<KhaltiPaymentController>(
      () => KhaltiPaymentController(),
      

    );
  }
}