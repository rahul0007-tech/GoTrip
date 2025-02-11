import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  void login() {
    // Perform validation and simulate login
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill out all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        
        borderRadius: 10,
      );
    } else {
      // Simulate successful login
      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 10,
      );

      // Navigate to home page
      Get.offNamed('/main');
    }
  }
}
