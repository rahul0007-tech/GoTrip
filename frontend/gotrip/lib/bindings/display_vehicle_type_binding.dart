import 'package:get/get.dart';
import '../controllers/display_vehicle_type_controller.dart';

class VehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VehicleController());  // Using Get.put instead of Get.lazyPut might help
  }
}