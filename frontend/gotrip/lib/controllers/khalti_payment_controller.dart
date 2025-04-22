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

  void clearPaymentData() {
    payment.clear();
    errorMessage.value = '';
    isPaymentInitialized.value = false;
  }

  Future<bool> initiatePayment(int bookingID, int driverId) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      clearPaymentData();
      
      print("Initiating payment for booking ID: $bookingID with driver ID: $driverId");
      
      final response = await httpClient.post(
        '/payments/khalti-initiate/', 
        data: {
          "return_url": "http://localhost:8000/payments/khalti-verify/",
          "website_url": "http://localhost:8000",
          "booking_id": bookingID,
          "driver_id": driverId
        },
      );

      print("Payment initiation response: ${response.data}");

      if (response.data['status'] == "success" && response.data['data'] != null) {
        final responseData = response.data['data'];
        print("Response data: $responseData");

        // Validate required fields from backend response
        if (responseData['payment_id'] == null || responseData['pidx'] == null) {
          print("Missing required fields in response: $responseData");
          errorMessage.value = "Invalid payment data received";
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return false;
        }

        // Create payment model with validated data
        PaymentModel paymentInformation = PaymentModel(
          paymentId: responseData['payment_id'] as int,
          pidx: responseData['pidx'].toString(),
          amount: (responseData['amount'] as num).toDouble().toInt(),
          status: 'initiated'
        );

        print("Created payment model with PIDX: ${paymentInformation.pidx}");
        payment.value = [paymentInformation];
        isPaymentInitialized.value = true;
        return true;
      }
      
      errorMessage.value = response.data['message'] ?? "Payment initialization failed";
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      print("Error during payment initialization: $e");
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

  Future<bool> verifyPayment(String pidx, String paymentID) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      print("Verifying payment with PIDX: $pidx, PaymentID: $paymentID");
      
      final response = await httpClient.post(
        '/payments/khalti-verify/',
        data: {
          'payment_id': paymentID,
          'pidx': pidx
        }
      );

      print("Payment verification response: ${response.data}");

      if (response.data['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Payment verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Update payment model with completed status
        final currentPayment = payment.first;
        payment.value = [PaymentModel(
          paymentId: currentPayment.paymentId,
          pidx: currentPayment.pidx,
          amount: currentPayment.amount,
          status: 'completed'
        )];
        
        Get.offNamed('/payment-success');
        return true;
      }
      
      // Handle error cases
      errorMessage.value = response.data['message'] ?? "Payment verification failed";
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
  
  bool isPaymentReady() {
    return payment.isNotEmpty && payment.first.pidx.isNotEmpty;
  }
}