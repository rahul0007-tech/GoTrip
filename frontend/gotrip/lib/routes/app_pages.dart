

import 'package:get/get.dart';
import 'package:gotrip/bindings/passenger_login_binding.dart';
import 'package:gotrip/bindings/passenger_signup_binding.dart';
import 'package:gotrip/bindings/passenger_otp_binding.dart'; // ✅ Import OTPBinding
import 'package:gotrip/pages/authentication/login.dart';
import 'package:gotrip/pages/authentication/otp_verification.dart';
import 'package:gotrip/pages/authentication/signup.dart';
import 'package:gotrip/pages/main_pages/homepage.dart';
import 'package:gotrip/pages/main_pages/profilepage.dart';
import 'package:gotrip/pages/main_pages/searchpage.dart';
import 'package:gotrip/pages/mainpage.dart';
import '../pages/main_pages/bookingpage.dart';
import 'package:gotrip/bindings/passenger_profile_binding.dart';
import 'package:gotrip/bindings/main_bindings.dart';

class AppPages {
  static const initial = '/signup'; // Start from signup page

  static final routes = [
    GetPage(name: '/signup', page: () => SignupPage(), binding: SignupBinding()),
    GetPage(name: '/login', page: () => LoginPage(), binding: LoginBinding()),
    GetPage(name: '/otp', page: () => OTPPage(), binding: OTPBinding()), // ✅ FIXED
    GetPage(name: '/main', page: () => MainPage(), binding: MainBinding(),),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/search', page: () => SearchPage()),
    GetPage(name: '/bookings', page: () => BookingsPage()),
    GetPage(name: '/profile', page: () => ProfilePage(), binding: ProfileBinding()),
  ];
}

