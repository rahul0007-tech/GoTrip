// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';

// class LoginController extends GetxController {
//   var email = ''.obs;
//   var password = ''.obs;
//   var rememberMe = false.obs; // Add this for remember me checkbox

//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: 'http://10.0.2.2:8000',
//     connectTimeout: Duration(seconds: 20),
//     receiveTimeout: Duration(seconds: 20),
//   ));

//   final box = GetStorage();

//   @override
//   void onInit() {
//     super.onInit();
//     // Check if we have stored credentials
//     final savedEmail = box.read('passenger_email');
//     final savedPassword = box.read('passenger_password');
//     if (savedEmail != null && savedPassword != null) {
//       email.value = savedEmail;
//       password.value = savedPassword;
//       rememberMe.value = true;
//     }
//   }

//   void login() async {
//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Email and Password are required',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       final response = await _dio.post(
//         '/users/passengerLogin/',
//         data: {
//           'email': email.value.trim(),
//           'password': password.value.trim(),
//         },
//       );

//       print("Response Data: ${response.data}");

//       if (response.statusCode == 200) {
//         String accessToken = response.data['token']['access'];
//         box.write('access_token', accessToken);
        
//         // Store user type for app initialization checks
//         box.write('user_type', 'passenger');
        
//         // If remember me is checked, store credentials
//         if (rememberMe.value) {
//           box.write('passenger_email', email.value.trim());
//           box.write('passenger_password', password.value.trim());
//           box.write('is_logged_in', true);
//         } else {
//           // Clear any saved credentials if remember me is not checked
//           box.remove('passenger_email');
//           box.remove('passenger_password');
//           box.write('is_logged_in', false);
//         }

//         Get.snackbar(
//           'Success',
//           'Login Successful',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         Get.offNamed('/main');
//       } else {
//         String errorMessage =
//             response.data['errors']?['non_field_errors']?[0] ?? 'Login failed';
//         Get.snackbar(
//           'Error',
//           errorMessage,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } on DioError catch (e) {
//       print("DioError: ${e.message}");

//       String errorMessage = 'An unexpected error occurred';

//       if (e.response != null) {
//         print("Response Data: ${e.response?.data}");
//         print("Response Status Code: ${e.response?.statusCode}");

//         if (e.response?.data is Map<String, dynamic>) {
//           errorMessage =
//               e.response?.data['errors']?['non_field_errors']?[0] ?? errorMessage;
//         }
//       }

//       Get.snackbar(
//         'Error',
//         errorMessage,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Unexpected Error: $e");
//       Get.snackbar(
//         'Error',
//         'An unexpected error occurred',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
  
//   void logout() {
//     // Clear access token
//     box.remove('access_token');
    
//     // If not using remember me, clear credentials too
//     if (!rememberMe.value) {
//       box.remove('passenger_email');
//       box.remove('passenger_password');
//     }
    
//     box.write('is_logged_in', false);
//     Get.offAllNamed('/login_choice');
//   }
// }





import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/controllers/passenger_otp_controller.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var rememberMe = false.obs; // Add this for remember me checkbox

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  ));

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Check if we have stored credentials
    final savedEmail = box.read('passenger_email');
    final savedPassword = box.read('passenger_password');
    if (savedEmail != null && savedPassword != null) {
      email.value = savedEmail;
      password.value = savedPassword;
      rememberMe.value = true;
    }
  }

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
        '/users/passengerLogin/',
        data: {
          'email': email.value.trim(),
          'password': password.value.trim(),
        },
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Handle the case where the user is not verified
        if (response.data.containsKey('error') && 
            response.data['error'].toString().contains('not verified')) {
          
          // Navigate to OTP verification page with the email
          Get.toNamed('/otp', arguments: {
            'email': email.value.trim(),
            'fromLogin': true
          });
          
          Get.snackbar(
            'Verification Required',
            'Please verify your email to continue',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
        
        String accessToken = response.data['token']['access'];
        box.write('access_token', accessToken);
        
        // Store user type for app initialization checks
        box.write('user_type', 'passenger');
        
        // If remember me is checked, store credentials
        if (rememberMe.value) {
          box.write('passenger_email', email.value.trim());
          box.write('passenger_password', password.value.trim());
          box.write('is_logged_in', true);
        } else {
          // Clear any saved credentials if remember me is not checked
          box.remove('passenger_email');
          box.remove('passenger_password');
          box.write('is_logged_in', false);
        }

        Get.snackbar(
          'Success',
          'Login Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed('/main');
      } else {
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
    } catch (error) {
      print("Error: $error");
      
      // Handle DioError
      if (error is DioError && error.response != null) {
        final responseData = error.response?.data;
        
        // Check for "not verified" error in DioError response
        if (responseData is Map<String, dynamic> && 
            responseData.containsKey('error') && 
            responseData['error'].toString().contains('not verified')) {
          
          // Navigate to OTP verification page with the email
          Get.toNamed('/otp', arguments: {
            'email': email.value.trim(),
            'fromLogin': true
          });
          
          Get.snackbar(
            'Verification Required',
            'Please verify your email to continue',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        // Handle other API errors
        String errorMessage = 'An unexpected error occurred';
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['errors']?['non_field_errors']?[0] ?? 
                        responseData['error'] ?? 
                        errorMessage;
        }
        
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        // Handle other errors
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
  
  void logout() {
    // Clear access token
    box.remove('access_token');
    
    // If not using remember me, clear credentials too
    if (!rememberMe.value) {
      box.remove('passenger_email');
      box.remove('passenger_password');
    }
    
    box.write('is_logged_in', false);
    Get.offAllNamed('/login_choice');
  }
}