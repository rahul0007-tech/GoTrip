// import 'package:get/get.dart';
// import 'package:gotrip/pages/authentication/login.dart';
// import 'package:gotrip/pages/authentication/otp_verification.dart';
// import '../pages/authentication/signup.dart';
// import '../pages/main_pages/homepage.dart';
// import '../bindings/signup_binding.dart';
// import '../bindings/login_binding.dart';
// import '../bindings/otp_binding.dart';

// class AppPages {
//   static const initial = '/signup'; // Start with signup

//   static final routes = [
//     GetPage(
//       name: '/signup',
//       page: () => SignupPage(),
//       binding: SignupBinding(),
//     ),
//     GetPage(
//       name: '/login',
//       page: () => LoginPage(),
//       binding: LoginBinding(),
//     ),
//     GetPage(
//       name: '/otp',
//       page: () => OTPPage(),
//       binding: OTPBinding(),
//     ),
//     GetPage(
//       name: '/home',
//       page: () => HomePage(),
//     ),
//   ];
// }

// import 'package:get/get.dart';
// import 'package:gotrip/bindings/login_binding.dart';
// import 'package:gotrip/bindings/signup_binding.dart';
// import 'package:gotrip/pages/authentication/login.dart';
// import 'package:gotrip/pages/authentication/otp_verification.dart';
// import 'package:gotrip/pages/authentication/signup.dart';
// import 'package:gotrip/pages/main_pages/homepage.dart';
// import 'package:gotrip/pages/main_pages/profilepage.dart';
// import 'package:gotrip/pages/main_pages/searchpage.dart';
// import 'package:gotrip/pages/mainpage.dart';
// import '../pages/main_pages/bookingpage.dart';

// class AppPages {
//   static const initial = '/signup'; // Start from signup page

//   static final routes = [
//     GetPage(
//         name: '/signup', page: () => SignupPage(), binding: SignupBinding()),
//     GetPage(name: '/login', page: () => LoginPage(), binding: LoginBinding()),
//     GetPage(
//       name: '/otp',
//       page: () => OTPPage(),
//       binding: OTPBinding(),
//     ),
//     GetPage(
//       name: '/main',
//       page: () => MainPage(),
//     ),
//     GetPage(
//       name: '/home',
//       page: () => HomePage(),
//     ),
//     GetPage(
//       name: '/search',
//       page: () => SearchPage(),
//     ),
//     GetPage(
//       name: '/bookings',
//       page: () => BookingsPage(),
//     ),
//     GetPage(
//       name: '/profile',
//       page: () => ProfilePage(),
//     ),
//   ];
// }

import 'package:get/get.dart';
import 'package:gotrip/bindings/login_binding.dart';
import 'package:gotrip/bindings/signup_binding.dart';
import 'package:gotrip/bindings/otp_binding.dart'; // ✅ Import OTPBinding
import 'package:gotrip/pages/authentication/login.dart';
import 'package:gotrip/pages/authentication/otp_verification.dart';
import 'package:gotrip/pages/authentication/signup.dart';
import 'package:gotrip/pages/main_pages/homepage.dart';
import 'package:gotrip/pages/main_pages/profilepage.dart';
import 'package:gotrip/pages/main_pages/searchpage.dart';
import 'package:gotrip/pages/mainpage.dart';
import '../pages/main_pages/bookingpage.dart';

class AppPages {
  static const initial = '/signup'; // Start from signup page

  static final routes = [
    GetPage(name: '/signup', page: () => SignupPage(), binding: SignupBinding()),
    GetPage(name: '/login', page: () => LoginPage(), binding: LoginBinding()),
    GetPage(name: '/otp', page: () => OTPPage(), binding: OTPBinding()), // ✅ FIXED
    GetPage(name: '/main', page: () => MainPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/search', page: () => SearchPage()),
    GetPage(name: '/bookings', page: () => BookingsPage()),
    GetPage(name: '/profile', page: () => ProfilePage()),
  ];
}

