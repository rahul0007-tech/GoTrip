// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/accept_booking_controller.dart';
// import '../../utils/app_colors.dart';

// class AcceptBookingPage extends StatelessWidget {
//   final AcceptBookingController controller = Get.find<AcceptBookingController>();

//   AcceptBookingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accept Booking'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Booking ID'),
//                 onChanged: (value) => controller.bookingId.value = value,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: controller.acceptBooking,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                 ),
//                 child: Text('Accept Booking'),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/accept_booking_controller.dart';
import '../../utils/app_colors.dart';

class AcceptBookingPage extends StatelessWidget {
  final AcceptBookingController controller = Get.find<AcceptBookingController>();

  AcceptBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Booking'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Booking ID Input Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Booking ID',
                      hintText: 'Enter Booking ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) => controller.bookingId.value = value,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Accept Button Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: controller.acceptBooking,
                  style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(AppColors.primary) ,
                  ),
                  child: Text(
                    'Accept Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
