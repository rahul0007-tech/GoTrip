import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/get_accepted_drivers_controller.dart';
import '../../model/user_model/driver_model.dart';
import '../../utils/app_colors.dart';

class AcceptedDriversPage extends StatelessWidget {
  final AcceptedDriversController controller = Get.put(AcceptedDriversController());
  
  AcceptedDriversPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Drivers'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.getUserBookings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          // Show list of user's bookings if none is selected
          if (controller.selectedBookingId.value == null) {
            if (controller.userBookings.isEmpty) {
              return Center(child: Text('You have no bookings yet'));
            }
            
            return ListView.builder(
              itemCount: controller.userBookings.length,
              itemBuilder: (context, index) {
                final booking = controller.userBookings[index];
                return Card(
                  child: ListTile(
                    title: Text('Booking ID: ${booking.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From: ${booking.pickupLocation ?? 'N/A'}'),
                        Text('To: ${booking.dropoffLocation is String ? booking.dropoffLocation : (booking.dropoffLocation?['name'] ?? 'N/A')}'),
                        Text('Fare: ${booking.fare ?? 'N/A'}'),
                        if (booking.bookingFor != null) 
                          Text('Date: ${booking.bookingFor.toString().split('T')[0]}')
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () => controller.getAcceptedDriversForBooking(booking.id),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            );
          }
          
          // Show message if no drivers have accepted the booking
          if (controller.acceptedDrivers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No drivers have accepted this booking yet'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.clearSelectedBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text('Back to Bookings'),
                  ),
                ],
              ),
            );
          }
          
          // Show selected booking details and the list of accepted drivers
          return Column(
            children: [
              // Booking details header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking ID: ${controller.selectedBookingId.value}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    if (controller.getSelectedBooking() != null) ...[
                      Text('From: ${controller.getSelectedBooking()!.pickupLocation ?? 'N/A'}'),
                      Text('To: ${controller.getSelectedBooking()!.dropoffLocation is String ? controller.getSelectedBooking()!.dropoffLocation : (controller.getSelectedBooking()!.dropoffLocation?['name'] ?? 'N/A')}'),
                      Text('Fare: ${controller.getSelectedBooking()!.fare ?? 'N/A'}'),
                    ],
                    SizedBox(height: 8),
                    Text(
                      '${controller.acceptedDrivers.length} drivers have accepted',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              
              // Back button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: controller.clearSelectedBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Back to Bookings'),
                ),
              ),
              
              // Drivers list
              Expanded(
                child: ListView.builder(
                  itemCount: controller.acceptedDrivers.length,
                  itemBuilder: (context, index) {
                    final driver = controller.acceptedDrivers[index];
                    return _buildDriverCard(driver);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  
  Widget _buildDriverCard(DriverModel driver) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 24,
                  child: Text(
                    driver.name.isNotEmpty ? driver.name[0].toUpperCase() : '?',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Phone: ${driver.phone}'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => controller.contactDriver(driver),
                  icon: Icon(Icons.phone),
                  label: Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => controller.selectDriver(driver),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}