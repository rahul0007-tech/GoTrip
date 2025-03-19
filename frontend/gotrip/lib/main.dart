import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/passenger_otp_controller.dart';
import 'package:gotrip/controllers/passenger_signup_controller.dart';
import 'package:gotrip/controllers/driver_signup_controller.dart';
import 'routes/app_pages.dart';

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
        Get.put(DriverSignupController());
        Get.put(OTPController());
      }),
    );
  }
}



// import 'package:get_storage/get_storage.dart';


// void main() async {
//   // Initialize GetStorage before running the app
//   await GetStorage.init();

//   // Check if token exists in storage
//   final box = GetStorage();
//   final token = box.read('access_token');

//   // Run the app and decide initial route based on token presence
//   runApp(MyApp(token: token));
// }

// class MyApp extends StatelessWidget {
//   final String? token;

//   // Pass the token to the MyApp constructor
//   const MyApp({super.key, this.token});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Vehicle Booking App',
//       initialRoute: token == null ? AppPages.initial : '/main', // Navigate based on token presence
//       getPages: AppPages.routes,
//       initialBinding: BindingsBuilder(() {
//         Get.put(SignupController());
//         Get.put(DriverSignupController());
//         Get.put(OTPController());
//       }),
//     );
//   }
// }
