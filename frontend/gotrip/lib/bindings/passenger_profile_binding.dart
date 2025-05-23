import 'package:get/get.dart';
import 'package:gotrip/controllers/profile_image_update_passenger_controller.dart';
import '../controllers/passenger_profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<PassengerProfileImageController>(() => PassengerProfileImageController());
  }
}
