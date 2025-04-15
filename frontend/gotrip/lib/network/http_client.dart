import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

// Define base URL as a constant
const String baseUrl = 'http://10.0.2.2:8000';

final Dio httpClient = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Get the token from GetStorage before each request
      final box = GetStorage();
      String? token = box.read('access_token');

      if (token != null) {
        // Add the token to the Authorization header
        options.headers['Authorization'] = 'Bearer $token';
      }

      return handler.next(options); // Continue with the request
    },
  ));