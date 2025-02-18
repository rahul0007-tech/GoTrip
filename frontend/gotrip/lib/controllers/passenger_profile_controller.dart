import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  // Observable fields for profile data
  // var id = ''.obs;
  var username = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var created_at = ''.obs;
  var updated_at = ''.obs;

  // Setup Dio with your base URL
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000', // Change to your backend URL
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  ));

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
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
        return;
      }

      // Set the token in the headers
      _dio.options.headers["Authorization"] = "Bearer $accessToken";

      final response = await _dio.get('/users/passengerprofile/');
      print("Profile Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Adjust the keys below based on the JSON structure returned by your API
        // id.value = response.data['id'] ?? '';
        username.value = response.data['name'] ?? '';
        email.value = response.data['email'] ?? '';
        phone.value = response.data['phone']?.toString() ?? '';
        created_at.value = response.data['Created_at']?.toString()?? '';
        updated_at.value = response.data['updated_at']?.toString()?? '';

      } else {
        Get.snackbar(
          'Error',
          'Failed to load profile data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");
      Get.snackbar(
        'Error',
        'An error occurred while fetching profile data',
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
  void logout() {
  // Remove tokens from storage
  box.remove('access_token');
  // box.remove('refresh_token');

  // Optionally, show a confirmation message
  Get.snackbar(
    'Logged Out',
    'You have been successfully logged out.',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );

  // Navigate to the login page (replace with your route name)
  Get.offAllNamed('/login');
  }
}




