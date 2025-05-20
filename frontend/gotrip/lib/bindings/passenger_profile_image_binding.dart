import 'package:get/get.dart';
import 'package:gotrip/controllers/profile_image_update_passenger_controller.dart';

class PassengerProfileImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerProfileImageController>(() => PassengerProfileImageController());
    
  }
}