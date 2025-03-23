import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverBookingsPage extends StatelessWidget {
  const DriverBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Accept Your Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirect to the Accept Booking page
                Get.toNamed('/accept_booking_page');
              },
              child: Text('Accept Booking'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirect to the Available Booking page
                Get.toNamed('/get_booking'); // Navigate to the AvailableBookingPage
              },
              child: Text('View Available Bookings'),
            ),
          ],
        ),
      ),
    );
  }
}
 

