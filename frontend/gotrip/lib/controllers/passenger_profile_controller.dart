import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/network/http_client.dart';
import 'package:gotrip/model/passenger.dart';

class ProfileController extends GetxController {

  final box = GetStorage();

  var username = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var photo = ''.obs;
  var created_at = ''.obs;
  var updated_at = ''.obs;


  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    try { 

      final response = await httpClient.get('/users/passengerprofile/');

      if (response.statusCode == 200) {
        username.value = response.data['name'] ?? '';
        email.value = response.data['email'] ?? '';
        phone.value = response.data['phone']?.toString() ?? '';
        photo.value = response.data['photo'] ?? '';
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
  box.remove('access_token');

  Get.snackbar(
    'Logged Out',
    'You have been successfully logged out.',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );

  Get.offAllNamed('/login_choice');
  }
}

class PassengerProfileController extends GetxController {
  final Rxn<Passenger> passenger = Rxn<Passenger>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final response = await httpClient.get('/users/passengerprofile/');
      
      if (response.statusCode == 200) {
        // The API returns the full URL, so we can use it directly
        passenger.value = Passenger.fromJson(response.data);
      } else {
        error.value = 'Failed to load profile';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}




