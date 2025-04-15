import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../network/http_client.dart'; // Import your Dio HTTP client
import '../bookings_by_location_page.dart'; // Import the BookingDetailsPage
import '../../model/booking_model/booking_model.dart'; // Import your model

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading = true;
  List<LocationModel> _locations = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      // Using your Dio HTTP client
      final response = await httpClient.get('/bookings/search-location/');
      
      // Dio automatically parses JSON and puts the data in response.data
      if (response.statusCode == 200) {
        final List<dynamic> locationsJson = response.data;
        
        // Convert JSON to your model objects
        setState(() {
          _locations = locationsJson
              .map((location) => LocationModel(
                    id: int.parse(location['id'].toString()),
                    name: location['name'].toString(),
                    fare: double.parse(location['fare'].toString()),
                  ))
              .toList();
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // Handle the specific case when no locations are found
        setState(() {
          _error = 'No locations found';
          _isLoading = false;
        });
      } else {
        // Handle other error statuses
        setState(() {
          _error = 'Failed to load locations. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      setState(() {
        if (e.response != null) {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx
          _error = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
        } else if (e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout) {
          _error = 'Connection timeout. Please check your internet connection.';
        } else {
          _error = 'Error: ${e.message}';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Exception: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onLocationSelected(LocationModel location) {
    // Navigate to BookingDetailsPage
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingDetailsPage(
          locationId: location.id,
          locationName: location.name,
        ),
      ),
    );
  }

  // Helper method to format fare
  String formatFare(double fare) {
    return '\$${fare.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Available Locations'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Select a Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
                    : Expanded(
                        child: _locations.isEmpty
                            ? Center(child: Text('No locations available'))
                            : ListView.builder(
                                itemCount: _locations.length,
                                itemBuilder: (context, index) {
                                  final location = _locations[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(12),
                                      title: Text(
                                        location.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Fare: ${formatFare(location.fare)}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                                      onTap: () => _onLocationSelected(location),
                                    ),
                                  );
                                },
                              ),
                      ),
          ],
        ),
      ),
    );
  }
}