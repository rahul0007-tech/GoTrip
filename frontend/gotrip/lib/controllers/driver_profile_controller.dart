import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/network/http_client.dart';
import 'package:dio/dio.dart' as dio;

class DriverProfileController extends GetxController {
  final box = GetStorage();

  var username = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var photo = ''.obs;
  var license = ''.obs;
  var created_at = ''.obs;
  var updated_at = ''.obs;
  var hasVehicle = false.obs;

  var isLoading = true.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("DriverProfileController initialized");
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    print("Fetching user profile...");
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await httpClient.get('/users/driverprofile/');
      print("HTTP GET /users/driverprofile/ response: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Profile data received: ${response.data}");

        username.value = response.data['name'] ?? '';
        email.value = response.data['email'] ?? '';
        phone.value = response.data['phone']?.toString() ?? '';
        photo.value = response.data['photo'] ?? '';
        license.value = response.data['license'] ?? '';
        created_at.value = response.data['Created_at']?.toString() ?? '';
        updated_at.value = response.data['updated_at']?.toString() ?? '';
        hasVehicle.value = response.data['has_vehicle'] ?? false;

        print("Parsed profile data: "
            "username=$username, "
            "email=$email, "
            "phone=$phone, "
            "photo=$photo, "
            "license=$license, "
            "created_at=$created_at, "
            "updated_at=$updated_at, "
            "hasVehicle=${hasVehicle.value}");
      } else {
        hasError.value = true;
        print("Non-200 response received: ${response.statusCode}");
        Get.snackbar(
          'Error',
          'Failed to load profile data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError.value = true;
      print("Exception during profile fetch: $e");
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print("Finished fetching profile. isLoading set to false.");
    }
  }

  void logout() {
    print("Logging out...");
    box.remove('access_token');
    print("Access token removed from storage.");

    Get.snackbar(
      'Logged Out',
      'You have been successfully logged out.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.offAllNamed('/login_choice');
    print("Navigated to login screen.");
  }

  Future<void> uploadVehicleImages(List<dynamic> images) async {
    try {
      final formData = dio.FormData();
      
      for (var image in images) {
        formData.files.add(
          MapEntry(
            'uploaded_images',
            await dio.MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
          ),
        );
      }

      final response = await httpClient.post(
        '/vehicles/vehicle-image/',
        data: formData,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Vehicle images uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to upload images',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error uploading vehicle images: $e");
      Get.snackbar(
        'Error',
        'Failed to upload images',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
