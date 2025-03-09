// change_password_controller.dart
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ChangePasswordController extends GetxController {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000', // Your backend URL
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  ));

  final box = GetStorage();

  // Observable loading state
  var isLoading = false.obs;

  // Function to call the change password API
  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    isLoading.value = true;
    try {
      // Retrieve the access token from storage
      String? accessToken = box.read('access_token');
      if (accessToken == null) {
        Get.snackbar(
          'Error',
          'No access token found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Set the authorization header
      _dio.options.headers["Authorization"] = "Bearer $accessToken";

      // Make the POST request to your change password endpoint
      final response = await _dio.post('/users/change-password/', data: {
        'oldPassword': oldPassword,
        'password': newPassword,
        'password2': confirmPassword,
      });

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Password changed successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
  // Convert response data to string if possible, otherwise use e.message, otherwise use a fallback
  String errorMsg = (e.response?.data?.toString() ?? e.message) ?? 'Unknown error';

  Get.snackbar(
    'Error',
    errorMsg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
} catch (e) {
  // Handle any other exceptions
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
