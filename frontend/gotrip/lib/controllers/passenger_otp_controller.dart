// import 'package:flutter/material.dart';
// import 'package:flutter/src/material/theme_data.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/network/http_client.dart';

// class OTPController extends GetxController {
//   // Make the list reactive
//   final otp = List<String>.filled(5, "").obs;
//   var email = ''.obs;

//   void updateOTP(int index, String value) {
//     if (value.length <= 1) {
//       otp[index] = value; // Update the specific digit
//       otp.refresh(); // Notify GetX to refresh the widget
//     }
//   }

//   void sendOTP() async {
//       if(otp.isEmpty ){
//         Get.snackbar(
//         'Error',
//         'All fields are required',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return;
//       }

//       final finalOtp = otp.toString();

//     try {
//       final response = httpClient.post('/users/verify/',
//         data: {
//           'email' : email.value.trim(),
//           'otp' : finalOtp
//         }
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         String successMessage = response.data['message'] ?? 'Signup successful! Please verify your OTP.';
        
//         Get.snackbar(
//           'Success',
//           successMessage,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );

//         // Navigate to OTP page
//         Get.toNamed('/otp');
//       } else {
//         String errorMessage = response.data['message'] ?? 'Signup failed';
//         Get.snackbar(
//           'Error',
//           errorMessage,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
      
//     }

//   }

//   void resendOTP() {
//     Get.snackbar(
//       'OTP Sent',
//       'A new OTP has been sent to your email.',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Get.theme.primaryColor,
//       colorText: Get.theme.colorScheme.onPrimary,
//       margin: EdgeInsets.all(10),
//       borderRadius: 10,
//     );
//   }

//   void verifyOTP() {
//     if (otp.join().length < 5) {
//       Get.snackbar(
//         'Error',
//         'Please enter the complete OTP.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Get.theme.errorColor,
//         colorText: Get.theme.colorScheme.onError,
//         margin: EdgeInsets.all(10),
//         borderRadius: 10,
//       );
//     } else {
//       Get.snackbar(
//         'Success',
//         'OTP Verified!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Get.theme.primaryColor,
//         colorText: Get.theme.colorScheme.onPrimary,
//         margin: EdgeInsets.all(10),
//         borderRadius: 10,
//       );
//       Get.offNamed('/home');
//     }
//   }
// }

// extension on ThemeData {
//   get errorColor => null;
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/network/http_client.dart';

class OTPController extends GetxController {
  final otp = List<String>.filled(5, "").obs;
  var email = ''.obs;

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
          response.data['message'] ?? 'Failed to send OTP',
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
        Get.offNamed('/home'); // Navigate to home screen
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Invalid OTP',
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
    }
  }

  Future<void> resendOTP() async {
    await sendOTP(); // Resend OTP using the same function
  }
}
