import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

class PassengerProfileImageController extends GetxController {
  final _storage = GetStorage();

  var photo = ''.obs;
  var isUploading = false.obs;
  var uploadError = ''.obs;

  final String baseUrl = 'http://10.0.2.2:8000';

  /// Picks image from gallery and returns the selected File or null
  Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      print('[pickImageFromGallery] Opening image picker...');
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        print('[pickImageFromGallery] User cancelled image picking.');
        return null;
      }

      print('[pickImageFromGallery] Image picked at path: ${pickedFile.path}');
      return File(pickedFile.path);
    } catch (e) {
      print('[pickImageFromGallery] Error picking image: $e');
      return null;
    }
  }

  /// Uploads the given image File to backend using `http` and updates photo url on success
  Future<void> uploadProfileImage(File imageFile) async {
    isUploading.value = true;
    uploadError.value = '';

    try {
      final token = _storage.read('access_token');
      if (token == null) {
        throw Exception('No access token found');
      }

      String fileName = imageFile.path.split('/').last;
      final uri = Uri.parse('$baseUrl/users/change-passenger-profile-picture/');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final mimeSplit = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        imageFile.path,
        filename: fileName,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      ));

      print('[uploadProfileImage] Sending request...');
      final response = await request.send();

      final responseBody = await http.Response.fromStream(response);
      print('[uploadProfileImage] Response: ${response.statusCode}');
      print('[uploadProfileImage] Body: ${responseBody.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody.body);


        if (json != null && json['status'] == 'success') {
          final newPhotoUrl = json['data']['photo'] ?? '';
          if (newPhotoUrl.isNotEmpty) {
            photo.value = '$baseUrl$newPhotoUrl';
            print('[uploadProfileImage] Updated photo URL: ${photo.value}');
          }
          Get.snackbar('Success', json['message'] ?? 'Profile image updated successfully',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          throw Exception(json?['message'] ?? 'Unexpected error');
        }
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e, stack) {
      uploadError.value = 'Error uploading image: $e';
      print('[uploadProfileImage] Exception: $e');
      print('[uploadProfileImage] Stacktrace: $stack');
      Get.snackbar('Error', uploadError.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUploading.value = false;
      print('[uploadProfileImage] Upload finished.');
    }
  }
}
