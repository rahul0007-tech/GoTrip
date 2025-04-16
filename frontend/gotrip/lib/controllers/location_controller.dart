import 'package:get/get.dart';
import 'package:gotrip/model/location.dart';
import 'package:gotrip/network/http_client.dart';

class LocationController extends GetxController {
  var locations = <Location>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      isLoading(true);
      final response = await httpClient.get('/bookings/locations/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        locations.value = data.map((json) => Location.fromJson(json)).toList();
      } else {
        error.value = 'Failed to load locations';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}