// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:gotrip/model/payment_model/payment_model.dart';
// import 'package:gotrip/network/http_client.dart';

// class KhaltiPaymentController extends GetxController {
//   var isLoading = false.obs;
//   var payment = <PaymentModel>[].obs;
//   var errorMessage = ''.obs;

//   final box = GetStorage();

//   // for initiate payment
//   Future<void> initiatePayment(int bookingID, String phoneNumber) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       // Call the available booking endpoint
//       final response =
//           await httpClient.post('/payments/khalti-initiate/', data: {
//         "return_url": "http://localhost:8000/payments/khalti-verify/",
//         "website_url": "http://localhost:8000",
//         "booking_id": bookingID,
//         "phone_number": phoneNumber
//       },
      
//       );

//       if (response.data['status'] == "success") {
//         print(response.data);
//         // Extract the 'data' field and map it to the list of BookingModel objects
//         List<dynamic> responseData = response.data['data'];
//         List<PaymentModel> paymentInformation = responseData
//             .map((booking) => PaymentModel.fromJson(booking))
//             .toList();

//         // Update the bookings list first to show something to user
//         payment.value = paymentInformation;

//         // No need for a success snackbar on initial load - it's annoying
//         if (errorMessage.value.isNotEmpty) {
//           errorMessage.value = '';
//         }
//       } else {
//         errorMessage.value = "${response.data['message']}";
//         Get.snackbar(
//           'Error',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } on DioError catch (e) {
//       print("DioError: ${e.message}");
//       errorMessage.value = 'An error occurred while initiating payment.';
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Unexpected Error: $e");
//       errorMessage.value = 'An unexpected error occurred.';
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

// // For verifying the payment
//   Future<void> verifyPayment(String pidx, String paymentID) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final response = await httpClient.post('/payments/khalti-verify/',
//           data: {'pidx': pidx, 'payment_id': paymentID});

//       if (response.data['status'] == "success") {
//         // If the payment is successful, show the success message
//         Get.snackbar(
//           'Success',
//           'Payment completed successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );

//         // Optionally, handle the response data as per your business logic
//         List<dynamic> responseData = response.data['data'];
//         List<PaymentModel> paymentInformation = responseData
//             .map((payment) => PaymentModel.fromJson(payment))
//             .toList();

//         payment.value = paymentInformation;
//       } else {
//         errorMessage.value = response.data['message'];
//         Get.snackbar(
//           'Error',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } on DioError catch (e) {
//       print("DioError: ${e.message}");
//       errorMessage.value = 'An error occurred while verifying payment.';
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Unexpected Error: $e");
//       errorMessage.value = 'An unexpected error occurred.';
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void clearPaymentData() {}
// }


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotrip/model/payment_model/payment_model.dart';
import 'package:gotrip/network/http_client.dart';

class KhaltiPaymentController extends GetxController {
  var isLoading = false.obs;
  var payment = <PaymentModel>[].obs;
  var errorMessage = ''.obs;
  var isPaymentInitialized = false.obs;

  final box = GetStorage();

  // Clear existing payment data
  void clearPaymentData() {
    payment.clear();
    errorMessage.value = '';
    isPaymentInitialized.value = false;
  }

  // for initiate payment
  Future<bool> initiatePayment(int bookingID, String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Clear any existing payment data first
      clearPaymentData();
      
      print("Initiating payment for booking ID: $bookingID, phone: $phoneNumber");
      
      // Call the payment initiation endpoint
      final response = await httpClient.post(
        '/payments/khalti-initiate/', 
        data: {
          "return_url": "http://localhost:8000/payments/khalti-verify/",
          "website_url": "http://localhost:8000",
          "booking_id": bookingID,
          "phone_number": phoneNumber
        },
      );

      print("Payment initiation response: ${response.data}");

      if (response.data['status'] == "success") {
      // Extract the 'data' field which is a Map (not a List)
      var responseData = response.data['data'];
      
      if (responseData == null) {
        errorMessage.value = "No payment data received from server";
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

        
        // Convert response to PaymentModel objects
        PaymentModel paymentInformation = PaymentModel.fromJson(responseData);


        // Update the payment list
        payment.value = [paymentInformation];
        isPaymentInitialized.value = true;
      
        print("Payment initialized successfully. PIDX: ${payment.first.pidx}");
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? "Payment initialization failed";
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");
      print("DioError response: ${e.response?.data}");
      
      // Check if the error response contains details
      String errorMsg = 'An error occurred while initiating payment.';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message'];
      }
      
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      print("Unexpected Error: $e");
      errorMessage.value = 'An unexpected error occurred: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // For verifying the payment
  Future<bool> verifyPayment(String pidx, String paymentID) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      print("Verifying payment with PIDX: $pidx, PaymentID: $paymentID");
      
      final response = await httpClient.post(
        '/payments/khalti-verify/',
        data: {'pidx': pidx, 'payment_id': paymentID}
      );

      print("Payment verification response: ${response.data}");

      if (response.data['status'] == "success") {
        // If the payment is successful, show the success message
        Get.snackbar(
          'Success',
          'Payment verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Update payment information if returned by the API
        if (response.data['data'] != null) {
          List<dynamic> responseData = response.data['data'];
          List<PaymentModel> paymentInformation = responseData
              .map((item) => PaymentModel.fromJson(item))
              .toList();

          payment.value = paymentInformation;
        }
        
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? "Payment verification failed";
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");
      print("DioError response: ${e.response?.data}");
      
      // Check if the error response contains details
      String errorMsg = 'An error occurred while verifying payment.';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message'];
      }
      
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      print("Unexpected Error: $e");
      errorMessage.value = 'An unexpected error occurred: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      print("Error message: ${errorMessage.value}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method to check if a payment is ready for processing
  bool isPaymentReady() {
    return payment.isNotEmpty && 
           payment.first.pidx != null && 
           payment.first.pidx!.isNotEmpty;
  }
}