import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../controllers/display_driver_by_vehicle_type_controller.dart';

class DriversPage extends StatelessWidget {
  final int vehicleTypeId;
  final String vehicleTypeName;

  const DriversPage({
    Key? key,
    required this.vehicleTypeId,
    required this.vehicleTypeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverController(vehicleTypeId: vehicleTypeId));

    return Scaffold(
      appBar: AppBar(
        title: Text('$vehicleTypeName Drivers'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available $vehicleTypeName Drivers',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.fetchDrivers(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (controller.drivers.isEmpty) {
                  return const Center(
                    child: Text('No drivers available for this vehicle type'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.drivers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final driver = controller.drivers[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    radius: 25,
                                    child: Text(
                                      driver.name.isNotEmpty ? driver.name[0].toUpperCase() : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'Driver ID: ${driver.id}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Text(
                                'Vehicle Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildVehicleDetail('Company', driver.vehicle.vehicleCompany),
                              _buildVehicleDetail('Color', driver.vehicle.vehicleColor),
                              _buildVehicleDetail('Number', driver.vehicle.vehicleNumber),
                              _buildVehicleDetail(
                                'Capacity', 
                                '${driver.vehicle.sittingCapacity} seats'
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      _showBookingDialog(context, driver);
                                    },
                                    icon: const Icon(LineAwesomeIcons.car),
                                    label: const Text('Book Now'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context, DriverWithVehicle driver) {
    Get.dialog(
      AlertDialog(
        title: Text('Book ${driver.name}'),
        content: const Text(
          'Do you want to book this driver?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            onPressed: () {
              // Implement booking logic here
              Get.back();
              Get.snackbar(
                'Booking Requested',
                'Your booking request for ${driver.name} has been sent.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}