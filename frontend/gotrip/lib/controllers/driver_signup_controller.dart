import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import'package:dio/dio.dart' as dio;
import 'package:dio/src/multipart_file.dart';

class DriverSignupController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var password = ''.obs;
  Rx<File?> licenseImage = Rx<File?>(null);
  var isImageUploading = false.obs;

  final ImagePicker _picker = ImagePicker();
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  Future<void> pickLicenseImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        licenseImage.value = File(image.path);
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void signup() async {
    if (username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        licenseImage.value == null) {
      Get.snackbar(
        'Error',
        'All fields including license image are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isImageUploading.value = true;
    
    try {
      // Create the FormData object manually to avoid type issues
      final formData = dio.FormData();
      
      // Add text fields
      formData.fields.add(MapEntry('name', username.value.trim()));
      formData.fields.add(MapEntry('email', email.value.trim()));
      formData.fields.add(MapEntry('phone', phoneNumber.value.trim()));
      formData.fields.add(MapEntry('password', password.value.trim()));
      formData.fields.add(MapEntry('status', 'busy')); // Default status
      
      // Add the license file
      final licenseFile = await dio.MultipartFile.fromFile(
        licenseImage.value!.path,
        filename: 'license.jpg',
      );
      formData.files.add(MapEntry('license', licenseFile));

      final response = await _dio.post(
        '/users/driver/',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        String successMessage =
            response.data['message'] ?? 'Driver registered successfully!';
        Get.snackbar(
          'Success',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed('/driver_login');
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
    } finally {
      isImageUploading.value = false;
    }
  }
}