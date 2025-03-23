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
//                         SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Redirect to the Create Booking page
//                 Get.toNamed('/accepted_drivers');
//               },
//               child: Text('Show Accepted Drivers'),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Your Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirect to the Create Booking page
                Get.toNamed('/create_booking_page');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Create Booking'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirect to the Accepted Drivers page
                Get.toNamed('/accepted_drivers');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Show Accepted Drivers'),
            ),
          ],
        ),
      ),
    );
  }
}