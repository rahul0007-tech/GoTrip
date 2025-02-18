import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignupController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var password = ''.obs;

  final Dio _dio = Dio(BaseOptions(
    // baseUrl: 'http://192.168.1.16:8000', // Change for local backend
    baseUrl: 'http://10.0.2.2:8000',

    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  ));

  void signup() async {
    if (username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    print("User Input:");
    print("Username: ${username.value}");
    print("Email: ${email.value}");
    print("Phone Number: ${phoneNumber.value}");
    print("Password: ${password.value}");

    try {
      final response = await _dio.post(
        '/users/passenger/', 
        data: {
          'name': username.value.trim(),
          'email': email.value.trim(),
          'phone': phoneNumber.value.trim(), 
          'password': password.value.trim(),
        },
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        String successMessage = response.data['message'] ?? 'Signup successful! Please verify your OTP.';
        
        Get.snackbar(
          'Success',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to OTP page
        Get.toNamed('/otp');
      } else {
        String errorMessage = response.data['message'] ?? 'Signup failed';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      print("DioError: ${e.message}");

      String errorMessage = 'An unexpected error occurred';

      if (e.response != null) {
        print("Response Data: ${e.response?.data}");
        print("Response Status Code: ${e.response?.statusCode}");

        if (e.response?.data is Map<String, dynamic>) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Unexpected Error: $e");
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }



}
