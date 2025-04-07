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

  final box = GetStorage();

  // for initiate payment
  Future<Map<String, dynamic>?> initiatePayment(int bookingID, String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Call the payment initiation endpoint
      final response = await httpClient.post('/payments/khalti-initiate/', data: {
        "return_url": "http://localhost:8000/payments/khalti-verify/",
        "website_url": "http://localhost:8000",
        "booking_id": bookingID,
        "phone_number": phoneNumber
      });

      print("Payment initiation response: ${response.data}");

      if (response.data['status'] == "success") {
        // Extract payment data from response
        final data = response.data['data'];
        
        // Create PaymentModel object(s)
        if (data is List) {
          // If data is a list, map each item to PaymentModel
          payment.value = data.map((item) => PaymentModel.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          // If data is a single object, create a single PaymentModel
          final model = PaymentModel(
            paymentId: data['payment_id'] ?? 0,
            pidx: data['pidx'] ?? '',
            amount: _parseAmount(data['amount']),
          );
          payment.value = [model];
        }

        // Clear any error message
        if (errorMessage.value.isNotEmpty) {
          errorMessage.value = '';
        }
        
        isLoading.value = false;
        return response.data;
      } else {
        errorMessage.value = response.data['message'] ?? "Payment initiation failed";
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return null;
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");
      errorMessage.value = 'An error occurred while initiating payment.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      errorMessage.value = 'An unexpected error occurred.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return null;
    }
  }

  // Helper method to parse amount from different formats
  int _parseAmount(dynamic amount) {
    if (amount is int) {
      return amount;
    } else if (amount is double) {
      return amount.toInt();
    } else if (amount is String) {
      return int.tryParse(amount) ?? 0;
    }
    return 0;
  }

  // For verifying the payment
  Future<bool> verifyPayment(String pidx, String paymentID) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await httpClient.post('/payments/khalti-verify/',
          data: {'pidx': pidx, 'payment_id': paymentID});

      print("Verification response: ${response.data}");

      if (response.data['status'] == "success") {
        // If the payment is successful, show the success message
        Get.snackbar(
          'Success',
          'Payment completed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Update payment data if available
        final data = response.data['data'];
        if (data is List && data.isNotEmpty) {
          payment.value = data.map((item) => PaymentModel.fromJson(item)).toList();
        }
        
        isLoading.value = false;
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
        isLoading.value = false;
        return false;
      }
    } on DioError catch (e) {
      print("DioError: ${e.message}");
      errorMessage.value = 'An error occurred while verifying payment.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return false;
    } catch (e) {
      print("Unexpected Error: $e");
      errorMessage.value = 'An unexpected error occurred.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return false;
    }
  }

  // Clear payment data
  void clearPaymentData() {
    payment.clear();
    errorMessage.value = '';
  }
}
