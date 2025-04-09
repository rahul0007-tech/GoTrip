import 'package:get/get.dart';
import 'package:gotrip/controllers/display_driver_by_vehicle_type_controller.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverController>(() => DriverController());
  }
}