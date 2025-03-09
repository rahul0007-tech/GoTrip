import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_booking_controller.dart';
import '../../utils/app_colors.dart';

class CreateBookingPage extends StatelessWidget {
  final CreateBookingController controller = Get.put(CreateBookingController());

  CreateBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Booking'),
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
                decoration: InputDecoration(labelText: 'Pickup Location'),
                onChanged: (value) => controller.pickupLocation.value = value,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Dropoff Location'),
                onChanged: (value) => controller.dropoffLocation.value = value,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: controller.createBooking,
                child: Text('Create Booking'),
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
