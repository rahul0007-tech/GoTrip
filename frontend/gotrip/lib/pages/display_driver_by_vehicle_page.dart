// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:gotrip/controllers/display_driver_by_vehicle_type_controller.dart';

// class DriversPage extends StatelessWidget {
//   const DriversPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Get the driver controller
//     final DriverController driverController = Get.find<DriverController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text('Drivers - ${driverController.selectedVehicleTypeName.value}')),
//         backgroundColor: Colors.teal,
//         actions: [
//           // Refresh button
//           IconButton(
//             icon: const Icon(LineAwesomeIcons.sync_solid),
//             onPressed: () => driverController.retryLoading(),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(() {
//           // Show loading indicator
//           if (driverController.isLoading.value) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
          
//           // Show error message if any
//           if (driverController.errorMessage.value.isNotEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     driverController.errorMessage.value,
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => driverController.retryLoading(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal,
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
          
//           // Show empty state
//           if (driverController.drivers.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     LineAwesomeIcons.car_crash_solid,
//                     size: 64,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No drivers available for ${driverController.selectedVehicleTypeName.value}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }
          
//           // Show list of drivers
//           return ListView.builder(
//             itemCount: driverController.drivers.length,
//             itemBuilder: (BuildContext context, int index) {
//               final driver = driverController.drivers[index];
//               final vehicle = driver['vehicle'] ?? {};
              
//               return Card(
//                 elevation: 3,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.teal,
//                             radius: 30,
//                             child: Text(
//                               driver['name'] != null ? driver['name'].substring(0, 1).toUpperCase() : '?',
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   driver['name'] ?? 'Unknown Driver',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'ID: ${driver['id']}',
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 24),
//                       Text(
//                         'Vehicle Details',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal[700],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildVehicleDetailRow(
//                         Icons.color_lens,
//                         'Color',
//                         vehicle['vehicle_color'] ?? 'N/A',
//                       ),
//                       _buildVehicleDetailRow(
//                         Icons.business,
//                         'Company',
//                         vehicle['vehicle_company'] ?? 'N/A',
//                       ),
//                       _buildVehicleDetailRow(
//                         Icons.confirmation_number,
//                         'Number',
//                         vehicle['vehicle_number'] ?? 'N/A',
//                       ),
//                       _buildVehicleDetailRow(
//                         Icons.airline_seat_recline_normal,
//                         'Seats',
//                         vehicle['sitting_capacity']?.toString() ?? 'N/A',
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               // Navigate to driver details or booking screen
//                               Get.snackbar(
//                                 'Selection',
//                                 'You selected ${driver['name']}',
//                                 snackPosition: SnackPosition.BOTTOM,
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               foregroundColor: Colors.white,
//                             ),
//                             child: const Text('Select Driver'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }

//   // Helper method to build vehicle detail rows
//   Widget _buildVehicleDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           const SizedBox(width: 8),
//           Text(
//             '$label:',
//             style: TextStyle(
//               color: Colors.grey[700],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:gotrip/controllers/display_driver_by_vehicle_type_controller.dart';
import 'package:gotrip/utils/app_colors.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the driver controller
    final DriverController driverController = Get.find<DriverController>();
    
    // Define consistent colors
    final Color primaryColor = AppColors.primary;
    final Color secondaryColor = Colors.teal.shade50;
    final Color accentColor = Colors.amber.shade600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Obx(() => Text(
          'Available Drivers',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )),
        elevation: 0,
        backgroundColor: primaryColor,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(LineAwesomeIcons.sync_solid),
            onPressed: () => driverController.retryLoading(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top banner with vehicle type info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  driverController.selectedVehicleTypeName.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Choose your preferred driver',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            )),
          ),
          
          // Main content area
          Expanded(
            child: Obx(() {
              // Show loading indicator
              if (driverController.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Finding available drivers...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Show error message if any
              if (driverController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LineAwesomeIcons.exclamation_circle_solid,
                            size: 50,
                            color: Colors.red.shade400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Unable to Load Drivers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          driverController.errorMessage.value,
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => driverController.retryLoading(),
                          icon: const Icon(LineAwesomeIcons.sync_solid),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              // Show empty state
              if (driverController.drivers.isEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LineAwesomeIcons.car_crash_solid,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Drivers Available',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'We couldn\'t find any drivers for ${driverController.selectedVehicleTypeName.value} at this time',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(LineAwesomeIcons.arrow_left_solid),
                          label: const Text('Choose Another Vehicle Type'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              // Show list of drivers with enhanced UI
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: driverController.drivers.length,
                itemBuilder: (BuildContext context, int index) {
                  final driver = driverController.drivers[index];
                  final vehicle = driver['vehicle'] ?? {};
                  
                  // Get first letter of driver name for avatar
                  final String initialLetter = driver['name'] != null && driver['name'].isNotEmpty 
                      ? driver['name'].toString().substring(0, 1).toUpperCase() 
                      : '?';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Driver profile section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Driver avatar with colored background
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    initialLetter,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 16),
                              
                              // Driver info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            driver['name'] ?? 'Unknown Driver',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Available',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Driver ID and rating
                                    Row(
                                      children: [
                                        Text(
                                          'ID: ${driver['id']}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        Text(
                                          _getRandomRating(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Vehicle details section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LineAwesomeIcons.car_side_solid,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Vehicle Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Vehicle details in grid layout
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildVehicleDetailCard(
                                      icon: Icons.color_lens,
                                      label: 'Color',
                                      value: vehicle['vehicle_color'] ?? 'N/A',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildVehicleDetailCard(
                                      icon: Icons.business,
                                      label: 'Make',
                                      value: vehicle['vehicle_company'] ?? 'N/A',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildVehicleDetailCard(
                                      icon: Icons.confirmation_number,
                                      label: 'Number',
                                      value: vehicle['vehicle_number'] ?? 'N/A',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildVehicleDetailCard(
                                      icon: Icons.airline_seat_recline_normal,
                                      label: 'Seats',
                                      value: vehicle['sitting_capacity']?.toString() ?? 'N/A',
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Book now button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to booking screen with this driver
                                    Get.snackbar(
                                      'Driver Selected',
                                      'You selected ${driver['name']}',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.shade100,
                                      colorText: Colors.green.shade800,
                                      margin: const EdgeInsets.all(8),
                                      borderRadius: 10,
                                      icon: const Icon(
                                        LineAwesomeIcons.check_circle,
                                        color: Colors.green,
                                      ),
                                    );
                                    
                                    // Add navigation to booking page
                                    Get.toNamed('/create_booking_page', arguments: {
                                      'driverId': driver['id'],
                                      'driverName': driver['name'],
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Book ${driver['name']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper method to build vehicle detail cards
  Widget _buildVehicleDetailCard({
    required IconData icon, 
    required String label, 
    required String value
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon, 
                size: 16, 
                color: Colors.grey.shade600
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  // Helper method to generate random ratings for demo purposes
  String _getRandomRating() {
    final List<String> ratings = ['4.7', '4.8', '4.9', '5.0', '4.6'];
    return ratings[DateTime.now().millisecond % ratings.length];
  }
}