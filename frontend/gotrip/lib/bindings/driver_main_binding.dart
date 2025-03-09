import 'package:get/get.dart';
import '../controllers/passenger_profile_controller.dart';
// If you have other controllers for Home, Search, Bookings, import them too.

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Put all controllers that any tab might need:
    Get.lazyPut<ProfileController>(() => ProfileController());
    // Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<SearchController>(() => SearchController());
  }
}