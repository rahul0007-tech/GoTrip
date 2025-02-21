import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DriverLoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000', // Update this to match your backend URL
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  ));

  final box = GetStorage();

  void login() async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and Password are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final response = await _dio.post(
        '/users/driverlogin/',
        data: {
          'email': email.value.trim(),
          'password': password.value.trim(),
        },
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // String token = response.data['token'];
        String accessToken = response.data['token']['access'];
        box.write('access_token', accessToken);

        Get.snackbar(
          'Success',
          'Login Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed('/main');

        // Optionally, store the token locally, then navigate to the home page.
        // For example: Get.toNamed('/home');
      } else {
        // Handle error responses from the backend.
        String errorMessage =
            response.data['errors']?['non_field_errors']?[0] ?? 'Login failed';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");

      String errorMessage = 'An unexpected error occurred';

      if (e.response != null) {
        print("Response Data: ${e.response?.data}");
        print("Response Status Code: ${e.response?.statusCode}");

        if (e.response?.data is Map<String, dynamic>) {
          errorMessage =
              e.response?.data['errors']?['non_field_errors']?[0] ?? errorMessage;
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



