// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/get_booking_controller.dart';
// import '../../utils/app_colors.dart';

// class AvailableBookingPage extends StatelessWidget {
//   final AvailableBookingController controller = Get.put(AvailableBookingController());

//   AvailableBookingPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Available Booking'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (controller.errorMessage.value.isNotEmpty) {
//             return Center(
//               child: Text(
//                 controller.errorMessage.value,
//                 style: TextStyle(color: Colors.red),
//               ),
//             );
//           }
//           if (controller.bookings.isEmpty) {
//             return Center(child: Text('No available bookings found.'));
//           }
//           // Display booking details with an "Accept" button for each row
//           return ListView.builder(
//             itemCount: controller.bookings.length,
//             itemBuilder: (context, index) {
//               final booking = controller.bookings[index];
//               return Card(
//                 child: ListTile(
//                   title: Text('Passenger: ${booking['passenger']?.toString() ?? 'N/A'}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Pickup: ${booking['pickup_location'] ?? 'N/A'}'),
//                       Text('Destination: ${booking['dropoff_location'] ?? 'N/A'}'),
//                       Text('Fare: ${booking['fare']?.toString() ?? 'N/A'}'),
//                     ],
//                   ),
//                   // Added Accept button
//                   trailing: ElevatedButton(
//                     child: Text('Accept'),
//                     onPressed: () {
//                       controller.acceptBooking(booking);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get_booking_controller.dart';
import '../../utils/app_colors.dart';

class AvailableBookingPage extends StatelessWidget {
  final AvailableBookingController controller = Get.put(AvailableBookingController());

  AvailableBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Booking'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (controller.bookings.isEmpty) {
            return Center(child: Text('No available bookings found.'));
          }
          // Display booking details with an "Accept" button for each row
          return ListView.builder(
            itemCount: controller.bookings.length,
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];
              return Card(
                child: ListTile(
                  title: Text('Passenger: ${booking['passenger']?.toString() ?? 'N/A'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup: ${booking['pickup_location'] ?? 'N/A'}'),
                      Text('Destination: ${booking['dropoff_location'] ?? 'N/A'}'),
                      Text('Fare: ${booking['fare']?.toString() ?? 'N/A'}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    child: Text('Accept'),
                    onPressed: () {
                      controller.acceptBooking(booking);
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}


