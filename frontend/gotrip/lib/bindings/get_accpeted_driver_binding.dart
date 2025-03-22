import 'package:get/get.dart';
import 'package:gotrip/controllers/get_accepted_drivers_controller.dart';

class AcceptedDriversBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AcceptedDriversController>(() => AcceptedDriversController());
  }
}