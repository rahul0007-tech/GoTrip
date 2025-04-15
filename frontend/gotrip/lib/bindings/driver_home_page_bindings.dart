import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../controllers/driver_home_page_controller.dart'; // Adjust the import as per your project structure

class DriverHomePageBindings extends Bindings {
  @override
  void dependencies() {
    // Register Dio if it's not already registered
    if (!Get.isRegistered<Dio>()) {
      Get.put<Dio>(
        Dio(BaseOptions(
          baseUrl: 'http://10.0.2.2:8000', // For Android emulator
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) async {
                // Get token from storage
                final token = await _getToken();
                
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
                
                return handler.next(options);
              },
              onError: (e, handler) {
                // Handle common errors like 401 Unauthorized
                if (e.response?.statusCode == 401) {
                  // Redirect to login or refresh token
                  // Get.offAllNamed('/login');
                }
                return handler.next(e);
              },
            ),
          ),
        permanent: true,
      );
    }
    
    // Register the controller
    Get.lazyPut<DriverHomePageController>(() => DriverHomePageController());
  }
  
  // Helper method to get token from your storage solution
  Future<String?> _getToken() async {
    // Replace this with your actual token retrieval logic
    // Example if using GetStorage:
    // final box = GetStorage();
    // return box.read('access_token');
    
    // Example if using SharedPreferences:
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString('access_token');
    
    // For now, returning a placeholder
    return 'your_auth_token_here';
  }
}