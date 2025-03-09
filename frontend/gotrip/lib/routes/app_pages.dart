

import 'package:get/get.dart';
import 'package:gotrip/bindings/accept_bboking_binding.dart';
import 'package:gotrip/bindings/create_booking_binding.dart';

import 'package:gotrip/bindings/passenger_login_binding.dart';
import 'package:gotrip/bindings/driver_login_binding.dart';
import 'package:gotrip/bindings/passenger_signup_binding.dart';
import 'package:gotrip/bindings/driver_signup_binding.dart';
import 'package:gotrip/bindings/passenger_otp_binding.dart';
import 'package:gotrip/bindings/change_password.dart';
import 'package:gotrip/pages/authentication/login_choice.dart';
import 'package:gotrip/pages/authentication/signup_choice.dart';
import 'package:gotrip/pages/authentication/login.dart';
import 'package:gotrip/pages/authentication/driver_login.dart';
import 'package:gotrip/pages/authentication/otp_verification.dart';
import 'package:gotrip/pages/authentication/signup.dart';
import 'package:gotrip/pages/authentication/driver_signup.dart';
import 'package:gotrip/pages/bookings/accept_booking_page.dart';
import 'package:gotrip/pages/driver_mainpage.dart';
import 'package:gotrip/pages/main_pages/homepage.dart';
import 'package:gotrip/pages/main_pages/profilepage.dart';
import 'package:gotrip/pages/driver_main_pages.dart/driver_profilepage.dart';
import 'package:gotrip/pages/main_pages/searchpage.dart';
import 'package:gotrip/pages/authentication/change_password.dart';
import 'package:gotrip/pages/bookings/create_bookingpage.dart';
import 'package:gotrip/pages/mainpage.dart';
import '../pages/main_pages/bookingpage.dart';
import 'package:gotrip/bindings/passenger_profile_binding.dart';
import 'package:gotrip/bindings/driver_profile_binding.dart';
import 'package:gotrip/bindings/main_bindings.dart';

class AppPages {
  static const initial = '/signup_choice'; // Start from signup page

  static final routes = [GetPage(name: '/signup_choice', page: () => const SignupChoicePage(),),
    GetPage(name: '/signup', page: () => SignupPage(), binding: SignupBinding(),),
    GetPage(name: '/driver_signup', page: () => DriverSignupPage(), binding: DriverSignupBinding(),),
    GetPage(name: '/login_choice', page: () => LoginChoicePage(),),
    GetPage(name: '/login', page: () => LoginPage(), binding: LoginBinding()),
    GetPage(name: '/driver_login', page: () => DriverLoginPage(), binding: DriverLoginBinding()),
    GetPage(name: '/otp', page: () => OTPPage(), binding: OTPBinding()),
    GetPage(name: '/main', page: () => MainPage(), binding: MainBinding(),),
    GetPage(name: '/driver_main_page', page: () => DriverMainPage(), binding: DriverProfileBinding(),),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/search', page: () => SearchPage()),
    GetPage(name: '/bookings', page: () => BookingsPage()),
    GetPage(name: '/profile', page: () => ProfilePage(), binding: ProfileBinding()),
    GetPage(name: '/driver_profile', page: () => DriverProfilepage(), binding: DriverProfileBinding(),),
    GetPage(name: '/change_password', page: () => ChangePasswordPage(), binding: ChangePasswordBinding(),),
    GetPage(name: '/create_booking_page', page: ()=> CreateBookingPage(),binding: CreateBookingBinding()),
    GetPage(name: '/accept_booking', page: () => AcceptBookingPage(), binding: AcceptBookingBinding(),),
  ];
}

