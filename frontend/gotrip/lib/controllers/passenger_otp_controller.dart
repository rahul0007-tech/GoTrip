// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/network/http_client.dart';

// class OTPController extends GetxController {
//   final otp = List<String>.filled(5, "").obs;
//   var email = ''.obs;

//   void updateOTP(int index, String value) {
//     if (value.length <= 1) {
//       otp[index] = value;
//       otp.refresh();
//     }
//   }

//   Future<void> sendOTP() async {
//     if (email.value.trim().isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Email is required',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       final response = await httpClient.post('/users/send-otp/', data: {
//         'email': email.value.trim(),
//       });

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Success',
//           'OTP sent to your email',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['message'] ?? 'Failed to send OTP',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Something went wrong. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> verifyOTP() async {
//     final finalOtp = otp.join('');

//     if (finalOtp.length < 5) {
//       Get.snackbar(
//         'Error',
//         'Please enter the complete OTP.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       final response = await httpClient.post('/users/verify/', data: {
//         'email': email.value.trim(),
//         'otp': finalOtp,
//       });

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Success',
//           'OTP Verified!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         Get.offNamed('/home'); // Navigate to home screen
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['message'] ?? 'Invalid OTP',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Something went wrong. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> resendOTP() async {
//     await sendOTP(); // Resend OTP using the same function
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/network/http_client.dart';

class OTPController extends GetxController {
  final otp = List<String>.filled(5, "").obs;
  var email = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if email was passed as argument from login flow
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email.value = Get.arguments['email'];
      // Auto-send OTP when coming from login flow
      if (email.value.isNotEmpty) {
        resendOTP();
      }
    }
  }

  void updateOTP(int index, String value) {
    if (value.length <= 1) {
      otp[index] = value;
      otp.refresh();
    }
  }

  Future<void> sendOTP() async {
    if (email.value.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    try {
      final response = await httpClient.post('/users/send-otp/', data: {
        'email': email.value.trim(),
      });

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'OTP sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? response.data['error'] ?? 'Failed to send OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP() async {
    final finalOtp = otp.join('');

    if (finalOtp.length < 5) {
      Get.snackbar(
        'Error',
        'Please enter the complete OTP.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    try {
      final response = await httpClient.post('/users/verify/', data: {
        'email': email.value.trim(),
        'otp': finalOtp,
      });

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'OTP Verified!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Check if we came from login flow
        if (Get.arguments != null && Get.arguments['fromLogin'] == true) {
          // Go back to login
          Get.offNamed('/login');
        } else {
          // Go to home screen
          Get.offNamed('/home');
        }
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? response.data['error'] ?? 'Invalid OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOTP() async {
    if (email.value.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    try {
      // Use the correct resend-otp endpoint as per your API
      final response = await httpClient.post('/users/resend-otp/', data: {
        'email': email.value.trim(),
      });

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'New OTP sent successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['error'] ?? 'Failed to resend OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error resending OTP: $e");
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}