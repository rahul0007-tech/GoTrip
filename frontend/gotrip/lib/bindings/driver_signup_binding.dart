import 'package:get/get.dart';
import '../controllers/driver_signup_controller.dart';

class DriverSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverSignupController>(() => DriverSignupController());
  }
}
