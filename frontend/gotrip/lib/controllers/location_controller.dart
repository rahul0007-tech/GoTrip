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
        print('Location data received: $data'); // Debug print
        locations.value = data.map((json) => Location.fromJson(json)).toList();
        print('Locations parsed: ${locations.length}'); // Debug print
        // Print first location details if available
        if (locations.isNotEmpty) {
          print('First location details: ${locations[0].name}, Image: ${locations[0].locationImage}');
        }
      } else {
        error.value = 'Failed to load locations';
      }
    } catch (e) {
      error.value = 'Error: $e';
      print('Error fetching locations: $e'); // Debug print
    } finally {
      isLoading(false);
    }
  }
}