import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // Method to handle logout
  void logout() async {
    // Clear session or authentication data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to the login page after logout
    Get.offAllNamed('/login');
  }
}
