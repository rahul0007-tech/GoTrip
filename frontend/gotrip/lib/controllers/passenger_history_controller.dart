import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gotrip/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';

class PassengerHistoryController extends GetxController {
  final _storage = GetStorage();
  
  // Trip history related variables
  final RxList<dynamic> tripHistory = <dynamic>[].obs;
  final isTripHistoryLoading = true.obs;
  final hasTripHistoryError = false.obs;
  final tripHistoryErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPassengerHistory();
  }

  Future<void> fetchPassengerHistory() async {
    try {
      isTripHistoryLoading.value = true;
      hasTripHistoryError.value = false;
      tripHistoryErrorMessage.value = '';

      // Get token from storage
      final String? token = _storage.read('access_token');
      
      if (token == null) {
        hasTripHistoryError.value = true;
        tripHistoryErrorMessage.value = 'Authentication required';
        return;
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/users/passengerbookinghistory/');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Using Bearer token format
        },
      );

      print('Trip history response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['status'] == 'success') {
          tripHistory.assignAll(responseData['data']);
          print('Loaded ${tripHistory.length} trips');
        } else {
          hasTripHistoryError.value = true;
          tripHistoryErrorMessage.value = responseData['message'] ?? 'Failed to load trip history';
        }
      } else if (response.statusCode == 404) {
        final responseData = json.decode(response.body);
        hasTripHistoryError.value = true;
        tripHistoryErrorMessage.value = responseData['message'] ?? 'No trip history found';
        tripHistory.clear();
      } else {
        hasTripHistoryError.value = true;
        tripHistoryErrorMessage.value = 'Failed to load trip history: ${response.statusCode}';
        tripHistory.clear();
      }
    } catch (e) {
      print('Error fetching trip history: $e');
      hasTripHistoryError.value = true;
      tripHistoryErrorMessage.value = 'Error: ${e.toString()}';
      tripHistory.clear();
    } finally {
      isTripHistoryLoading.value = false;
    }
  }

  Future<void> refreshHistory() async {
    return fetchPassengerHistory();
  }
  
  // Helper methods for formatting data
  String getFormattedDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      final String month = _getMonthName(date.month);
      return '$month ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String getFormattedTime(String timeStr) {
    try {
      return timeStr.substring(0, 5);
    } catch (e) {
      return timeStr;
    }
  }
  
  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }
  
  bool isCompletedTrip(String bookingFor) {
    try {
      final tripDate = DateTime.parse(bookingFor);
      final now = DateTime.now();
      return tripDate.isBefore(now);
    } catch (e) {
      return false;
    }
  }
}