// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BookingsPage extends StatelessWidget {
//   const BookingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bookings'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Create Your Booking',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Redirect to the Create Booking page
//                 Get.toNamed('/create_booking_page');
//               },
//               child: Text('Create Booking'),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/model/booking_model/booking_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create Your Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirect to the Create Booking page
                Get.toNamed('/create_booking_page');
              },
              child: const Text('Create Booking'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the AcceptedDriversPage
                Get.to(() => const AcceptedDriversPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Show Accepted Drivers',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AcceptedDriversPage extends StatefulWidget {
  const AcceptedDriversPage({super.key});

  @override
  State<AcceptedDriversPage> createState() => _AcceptedDriversPageState();
}

class _AcceptedDriversPageState extends State<AcceptedDriversPage> {
  final _bookingsController = BookingsController();
  bool _isLoading = false;
  List<BookingWithDrivers> _bookingsWithDrivers = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBookingsWithDrivers();
  }

  Future<void> _loadBookingsWithDrivers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final bookings = await _bookingsController.fetchBookings();
      _bookingsWithDrivers = [];

      // For each booking, fetch its accepted drivers
      for (final booking in bookings) {
        final drivers = await _bookingsController.fetchAcceptedDrivers(booking.id);
        _bookingsWithDrivers.add(BookingWithDrivers(booking: booking, drivers: drivers));
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load bookings and drivers: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Drivers'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadBookingsWithDrivers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _bookingsWithDrivers.isEmpty
                  ? const Center(
                      child: Text(
                        'No bookings with accepted drivers found',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _bookingsWithDrivers.length,
                      itemBuilder: (context, index) {
                        final bookingWithDrivers = _bookingsWithDrivers[index];
                        return BookingDriversCard(bookingWithDrivers: bookingWithDrivers);
                      },
                    ),
    );
  }
}

class BookingDriversCard extends StatelessWidget {
  final BookingWithDrivers bookingWithDrivers;

  const BookingDriversCard({super.key, required this.bookingWithDrivers});

  @override
  Widget build(BuildContext context) {
    final booking = bookingWithDrivers.booking;
    final drivers = bookingWithDrivers.drivers;

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade100,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking #${booking.id}',
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Pickup: ${booking.pickupLocation}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Dropoff: ${booking.dropoffLocationName}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Fare: ${booking.fare}',
                  style: const TextStyle(fontSize: 14),
                ),
                if (booking.bookingFor != null)
                  Text(
                    'Date: ${booking.bookingFor!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 8),
            child: Text(
              'Accepted Drivers',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drivers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('No drivers have accepted this booking yet'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(driver.name),
                      subtitle: Text('Phone: ${driver.phone}'),
                    );
                  },
                ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// Controller to handle API calls
class BookingsController {
  // You should replace this with your actual API URL and add token handling
  final String baseUrl = 'https://your-api-url.com/api';
  
  // Method to get auth token - implement as needed
  Future<String> _getToken() async {
    // Implement your token retrieval logic here
    // This could be from secure storage, GetX, etc.
    return 'your_auth_token';
  }

  // Fetch all bookings
  Future<List<BookingModel>> fetchBookings() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }

  // Fetch accepted drivers for a booking
  Future<List<DriverModel>> fetchAcceptedDrivers(int bookingId) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/bookings/accepted-drivers/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'booking_id': bookingId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> driversData = data['accepted_drivers'];
        return driversData.map((json) => DriverModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load accepted drivers. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching accepted drivers: $e');
    }
  }
}

// Models
class BookingWithDrivers {
  final BookingModel booking;
  final List<DriverModel> drivers;

  BookingWithDrivers({
    required this.booking,
    required this.drivers,
  });
}

class DriverModel {
  final int id;
  final String name;
  final String phone;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

// Note: This is just a reference - you need to import your actual BookingModel
// or copy its implementation here if it's not available
/*
@JsonSerializable(explicitToJson: true)
class BookingModel {
  final int id;
  final int passenger;
  
  @JsonKey(name: "pickup_location")
  final String pickupLocation;
  
  @JsonKey(name: "dropoff_location") 
  final dynamic dropoffLocation;
  
  final String fare;
  
  @JsonKey(name: "booking_for")
  final DateTime? bookingFor;

  BookingModel({
    required this.id,
    required this.passenger,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.bookingFor,
  });

  String get dropoffLocationName {
    if (dropoffLocation is String) {
      return dropoffLocation;
    } else if (dropoffLocation is Map<String, dynamic>) {
      return dropoffLocation['name'] ?? '';
    }
    return '';
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
*/