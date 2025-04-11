// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/passenger_otp_controller.dart';
// import 'package:gotrip/controllers/passenger_signup_controller.dart';
// import 'package:gotrip/controllers/driver_signup_controller.dart';
// import 'routes/app_pages.dart';

// void main() {
//   runApp(MyApp());
// }   

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Vehicle Booking App',
//       initialRoute: AppPages.initial,
//       getPages: AppPages.routes,
//       initialBinding: BindingsBuilder(() {
//         Get.put(SignupController());
//         Get.put(DriverSignupController());
//         Get.put(OTPController());
//       }),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/passenger_otp_controller.dart';
import 'package:gotrip/controllers/passenger_signup_controller.dart';
import 'package:gotrip/controllers/driver_signup_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';

void main() async {
  await GetStorage.init(); // Make sure this is initialized first
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isLoggedIn = box.read('is_logged_in') ?? false;
    final userType = box.read('user_type');
    
    // Determine the initial route based on login status
    String initialRoute = AppPages.initial;
    
    if (isLoggedIn) {
      if (userType == 'passenger') {
        initialRoute = '/main';
      } else if (userType == 'driver') {
        initialRoute = '/driver_main_page';
      }
    }
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Booking App',
      initialRoute: initialRoute, // Use dynamic initial route
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(SignupController());
        Get.put(DriverSignupController());
        Get.put(OTPController());
      }),
    );
  }
}