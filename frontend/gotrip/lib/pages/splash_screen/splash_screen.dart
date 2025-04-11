import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:dio/dio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 4)); // Short delay for splash screen
    
    final isLoggedIn = box.read('is_logged_in') ?? false;
    final token = box.read('access_token');
    final userType = box.read('user_type');
    
    if (isLoggedIn && token != null) {
      // Verify token is still valid with your backend
      try {
        final response = await _dio.post(
          '/users/verify-token/',
          data: {'token': token},
        );
        
        // Token is valid, navigate to the appropriate screen
        if (response.statusCode == 200) {
          if (userType == 'passenger') {
            Get.offNamed('/main');
          } else if (userType == 'driver') {
            Get.offNamed('/driver_main_page');
          } else {
            Get.offNamed('/login_choice');
          }
        } else {
          // Token invalid, go to login
          Get.offNamed('/login_choice');
        }
      } catch (e) {
        // Error checking token, go to login
        print("Token verification error: $e");
        Get.offNamed('/login_choice');
      }
    } else {
      // Not logged in, go to login choice
      Get.offNamed('/login_choice');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo here
            Icon(
              Icons.directions_car_filled,
              size: 80,
              color: AppColors.primary,
            ),
            SizedBox(height: 24),
            Text(
              'GoTrip',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
