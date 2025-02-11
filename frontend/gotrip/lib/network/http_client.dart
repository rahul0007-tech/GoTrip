import 'package:dio/dio.dart';



// final Dio _dio = Dio(BaseOptions(
//     // baseUrl: 'http://192.168.1.16:8000', // Change for local backend
//     baseUrl: 'http://10.0.2.2:8000',

//     connectTimeout: Duration(seconds: 20),
//     receiveTimeout: Duration(seconds: 20),
// ));



import 'package:gotrip/constants/constant.dart';
import 'package:gotrip/network/storage_service.dart';




StorageService _storageService = SharedPrefsService();

var token = _storageService.getString('auth_token');


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
      // Get the token from SharedPreferences dynamically before each request
      String? token = await _storageService.getString('auth_token');

      if (token != null) {
        // Add the token to the Authorization header
        options.headers['Authorization'] = 'Bearer $token';
      }

      return handler.next(options); // Continue with the request
    },
  ));