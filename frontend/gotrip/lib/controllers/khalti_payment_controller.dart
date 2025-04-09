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
  Future<void> initiatePayment(int bookingID, String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Call the available booking endpoint
      final response =
          await httpClient.post('/payments/khalti-initiate/', data: {
        "return_url": "http://localhost:8000/payments/khalti-verify/",
        "website_url": "http://localhost:8000",
        "booking_id": bookingID,
        "phone_number": phoneNumber
      },
      
      );

      if (response.data['status'] == "success") {
        print(response.data);
        // Extract the 'data' field and map it to the list of BookingModel objects
        List<dynamic> responseData = response.data['data'];
        List<PaymentModel> paymentInformation = responseData
            .map((booking) => PaymentModel.fromJson(booking))
            .toList();

        // Update the bookings list first to show something to user
        payment.value = paymentInformation;

        // No need for a success snackbar on initial load - it's annoying
        if (errorMessage.value.isNotEmpty) {
          errorMessage.value = '';
        }
      } else {
        errorMessage.value = "${response.data['message']}";
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
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
    } finally {
      isLoading.value = false;
    }
  }

// For verifying the payment
  Future<void> verifyPayment(String pidx, String paymentID) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await httpClient.post('/payments/khalti-verify/',
          data: {'pidx': pidx, 'payment_id': paymentID});

      if (response.data['status'] == "success") {
        // If the payment is successful, show the success message
        Get.snackbar(
          'Success',
          'Payment completed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Optionally, handle the response data as per your business logic
        List<dynamic> responseData = response.data['data'];
        List<PaymentModel> paymentInformation = responseData
            .map((payment) => PaymentModel.fromJson(payment))
            .toList();

        payment.value = paymentInformation;
      } else {
        errorMessage.value = response.data['message'];
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
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
    } finally {
      isLoading.value = false;
    }
  }

  void clearPaymentData() {}
}
