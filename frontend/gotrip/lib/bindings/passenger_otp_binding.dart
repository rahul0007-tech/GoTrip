import 'package:get/get.dart';
import '../controllers/passenger_otp_controller.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OTPController>(() => OTPController());
  }
}
