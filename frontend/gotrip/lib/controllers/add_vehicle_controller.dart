import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../model/vehicle_model.dart';
import '../network/http_client.dart';

class AddVehicleController extends GetxController {
  // Form key and controllers
  final formKey = GlobalKey<FormState>();
  final vehicleColorController = TextEditingController();
  final vehicleCompanyController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final sittingCapacityController = TextEditingController();
  
  // Observables for UI state
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Dropdown data
  var vehicleTypes = <VehicleTypeModel>[].obs;
  var fuelTypes = <FuelTypeModel>[].obs;
  
  // Selected values
  var selectedVehicleTypeId = RxnInt();
  var selectedFuelTypeId = RxnInt();
  
  // Vehicle images
  var vehicleImages = <File>[].obs;
  
  // Storage for auth token
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchVehicleTypes();
    fetchFuelTypes();
  }
  
  @override
  void onClose() {
    vehicleColorController.dispose();
    vehicleCompanyController.dispose();
    vehicleNumberController.dispose();
    sittingCapacityController.dispose();
    super.onClose();
  }
  
  // Fetch vehicle types from API
  Future<void> fetchVehicleTypes() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      print("Attempting to fetch vehicle types");
      final response = await httpClient.get('/vehicles/vehicle-types/');
      
      print("Vehicle types response: ${response.statusCode}, ${response.data}");
      
      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
          List<dynamic> data = response.data['data'];
          vehicleTypes.value = data
              .map((type) => VehicleTypeModel.fromJson(type))
              .toList();
          
          if (vehicleTypes.isNotEmpty) {
            selectedVehicleTypeId.value = vehicleTypes[0].id;
          }
        } else {
          errorMessage.value = response.data['message'] ?? 'Failed to load vehicle types';
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = 'Failed to load vehicle types: ${response.statusCode}';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on dio.DioException catch (e) {
      print("DioError details: ${e.type}, ${e.message}");
      print("Response data: ${e.response?.data}");
      print("Response status code: ${e.response?.statusCode}");
      
      errorMessage.value = 'An error occurred while fetching vehicle types.';
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
  
  // Fetch fuel types from API
  Future<void> fetchFuelTypes() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      print("Attempting to fetch fuel types");
      final response = await httpClient.get('/vehicles/fuel-types/');
      
      print("Fuel types response: ${response.statusCode}, ${response.data}");
      
      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
          List<dynamic> data = response.data['data'];
          fuelTypes.value = data
              .map((type) => FuelTypeModel.fromJson(type))
              .toList();
          
          if (fuelTypes.isNotEmpty) {
            selectedFuelTypeId.value = fuelTypes[0].id;
          }
        } else {
          errorMessage.value = response.data['message'] ?? 'Failed to load fuel types';
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = 'Failed to load fuel types: ${response.statusCode}';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on dio.DioException catch (e) {
      print("DioError details: ${e.type}, ${e.message}");
      print("Response data: ${e.response?.data}");
      print("Response status code: ${e.response?.statusCode}");
      
      errorMessage.value = 'An error occurred while fetching fuel types.';
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
  
  // Pick images from gallery or camera
  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      
      if (images.isNotEmpty) {
        // Convert XFile to File and add to list
        final files = images.map((xfile) => File(xfile.path)).toList();
        vehicleImages.addAll(files);
      }
    } catch (e) {
      print("Error picking images: $e");
      Get.snackbar(
        'Error',
        'Failed to pick images',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
  
  // Remove an image
  void removeImage(int index) {
    if (index >= 0 && index < vehicleImages.length) {
      vehicleImages.removeAt(index);
    }
  }
  
  // Submit vehicle
  Future<void> submitVehicle() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Create a map of fields first
      Map<String, dynamic> fields = {
        'vehicle_color': vehicleColorController.text,
        'vehicle_company': vehicleCompanyController.text,
        'vehicle_type': selectedVehicleTypeId.value.toString(),
        'vehicle_fuel_type': selectedFuelTypeId.value.toString(),
        'vehicle_number': vehicleNumberController.text,
        'sitting_capacity': sittingCapacityController.text,
      };
      
      print("Submitting vehicle with data: $fields");
      
      // Create FormData with the fields using the dio namespace
      var formData = dio.FormData.fromMap(fields);
      
      // Add images if any
      for (var i = 0; i < vehicleImages.length; i++) {
        print("Adding image ${i+1} of ${vehicleImages.length}");
        formData.files.add(
          MapEntry(
            'uploaded_images', 
            await dio.MultipartFile.fromFile(
              vehicleImages[i].path,
              filename: 'image_$i.jpg',
            ),
          ),
        );
      }
      
      // Send request
      print("Sending POST request to vehicles/add-vehicle/");
      final response = await httpClient.post(
        '/vehicles/add-vehicle/',
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      print("Add vehicle response: ${response.statusCode}, ${response.data}");
      
      if (response.data['status'] == 'success') {
        // Clear form and return to previous screen
        clearForm();
        Get.back(result: true);
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Vehicle added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw response.data['message'] ?? 'Failed to add vehicle';
      }
    } on dio.DioException catch (e) {
      print("DioError details: ${e.type}, ${e.message}");
      print("Response data: ${e.response?.data}");
      print("Response status code: ${e.response?.statusCode}");
      
      String errorMsg = 'An error occurred while adding the vehicle.';
      
      if (e.response?.statusCode == 400 && e.response?.data['message'] == 'You already have a vehicle') {
        errorMsg = 'You already have a vehicle registered. You cannot add another one.';
      } else if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('message')) {
          errorMsg = data['message'].toString();
        } else if (data.containsKey('error')) {
          errorMsg = data['error'].toString();
        } else if (data.containsKey('errors')) {
          errorMsg = data['errors'].toString();
        }
      }
      
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
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
  
  // Clear form
  void clearForm() {
    vehicleColorController.clear();
    vehicleCompanyController.clear();
    vehicleNumberController.clear();
    sittingCapacityController.clear();
    vehicleImages.clear();
    formKey.currentState?.reset();
  }
}