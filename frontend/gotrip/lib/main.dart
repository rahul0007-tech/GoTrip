import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/otp_controller.dart';
import 'package:gotrip/controllers/signup_controller.dart';
import 'routes/app_pages.dart';
import 'bindings/signup_binding.dart';
import 'bindings/otp_binding.dart';

void main() {
  runApp(MyApp());
}   

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Booking App',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(SignupController());
        Get.put(OTPController()); // ✅ Ensure OTPController is globally available
      }),
    );
  }
}



