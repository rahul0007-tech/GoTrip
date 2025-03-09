import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/accept_booking_controller.dart';
import '../../utils/app_colors.dart';

class AcceptBookingPage extends StatelessWidget {
  final AcceptBookingController controller = Get.find<AcceptBookingController>();

  AcceptBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Booking'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Booking ID'),
                onChanged: (value) => controller.bookingId.value = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.acceptBooking,
                child: Text('Accept Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
