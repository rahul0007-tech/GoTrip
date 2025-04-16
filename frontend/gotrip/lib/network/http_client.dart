import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

// Define base URL as a constant
const String baseUrl = 'http://10.0.2.2:8000';

final Dio httpClient = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 30),  // Increased for file uploads
  receiveTimeout: const Duration(seconds: 30),  // Increased for file uploads
  sendTimeout: const Duration(seconds: 30),     // Added for file uploads
  headers: {
    'Accept': 'application/json',
  },
  validateStatus: (status) {
    return status! < 500;  // Accept all status codes below 500
  },
))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      print("Making request to: ${options.path}");
      print("Request data: ${options.data}");
      
      // Get the token from GetStorage before each request
      final box = GetStorage();
      String? token = box.read('access_token');

      if (token != null) {
        // Add the token to the Authorization header
        options.headers['Authorization'] = 'Bearer $token';
      }

      // Don't set content-type for multipart/form-data, let Dio handle it
      if (options.data is! FormData) {
        options.headers['Content-Type'] = 'application/json';
      }

      return handler.next(options);
    },
    onResponse: (response, handler) {
      print("Response from ${response.requestOptions.path}: ${response.statusCode}");
      print("Response data: ${response.data}");
      return handler.next(response);
    },
    onError: (error, handler) {
      print("Error on ${error.requestOptions.path}: ${error.message}");
      print("Error response: ${error.response?.data}");
      return handler.next(error);
    },
  ));