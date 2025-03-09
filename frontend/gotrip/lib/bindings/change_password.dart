// change_password_binding.dart
import 'package:get/get.dart';
import 'package:gotrip/controllers/change_password.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}
