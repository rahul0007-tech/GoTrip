// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/get_accepted_drivers_controller.dart';
// import 'package:gotrip/model/user_model/driver_model.dart';
// import 'package:gotrip/utils/app_colors.dart';
// import 'package:intl/intl.dart';

// class AcceptedDriversPage extends StatelessWidget {
//   final AcceptedDriversController controller = Get.find<AcceptedDriversController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accepted Drivers'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (controller.hasError.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Error: ${controller.errorMessage.value}',
//                   style: TextStyle(color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => controller.getAcceptedDrivers(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                   ),
//                   child: Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }

//         if (controller.bookingsWithDrivers.isEmpty) {
//           return Center(
//             child: Text(
//               'No drivers have accepted your bookings yet.',
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: () => controller.getAcceptedDrivers(),
//           child: ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: controller.bookingsWithDrivers.length,
//             itemBuilder: (context, index) {
//               final booking = controller.bookingsWithDrivers[index];
//               final List<DriverModel> drivers = booking['drivers'];
//               final bookingDate = DateFormat('MMM dd, yyyy').format(booking['booking_for']);
              
//               return Card(
//                 elevation: 4,
//                 margin: EdgeInsets.only(bottom: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       color: AppColors.primary.withOpacity(0.1),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Booking #${booking['booking_id']}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow('Date', bookingDate),
//                           _buildInfoRow('Pickup', booking['pickup_location']),
//                           _buildInfoRow('Destination', booking['dropoff_location'].name),
//                           _buildInfoRow('Fare', '₹${booking['fare']}'),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Available Drivers (${drivers.length})',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 12),
//                           _buildDriversList(drivers, booking['booking_id']),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDriversList(List<DriverModel> drivers, int bookingId) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: drivers.length,
//       itemBuilder: (context, index) {
//         final driver = drivers[index];
//         return Container(
//           margin: EdgeInsets.only(bottom: 10),
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[300]!),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: AppColors.primary,
//                 radius: 25,
//                 child: Text(
//                   driver.name.substring(0, 1).toUpperCase(),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       driver.name,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     // Show phone if available
//                     if (driver.phone != 0 && driver.phone != null) ...[
//                       SizedBox(height: 4),
//                       Text(
//                         'Phone: ${driver.phone}',
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _showSelectDriverConfirmation(driver, bookingId);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 ),
//                 child: Text('Select'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showSelectDriverConfirmation(DriverModel driver, int bookingId) {
//     Get.dialog(
//       AlertDialog(
//         title: Text('Confirm Driver Selection'),
//         content: Text('Do you want to select ${driver.name} as your driver?'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               // Pass driver ID instead of driver name
//               controller.selectDriver(bookingId, driver.id);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
//             child: Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/get_accepted_drivers_controller.dart';
// import 'package:gotrip/controllers/passenger_profile_controller.dart';
// import 'package:gotrip/controllers/khalti_payment_controller.dart';
// import 'package:gotrip/model/user_model/driver_model.dart';
// import 'package:gotrip/pages/payment/khalti_payment_screen.dart';
// import 'package:gotrip/utils/app_colors.dart';
// import 'package:intl/intl.dart';

// class AcceptedDriversPage extends StatelessWidget {
//   final AcceptedDriversController controller = Get.find<AcceptedDriversController>();
//   final ProfileController profileController = Get.find<ProfileController>();

//   final KhaltiPaymentController khaltiPaymentController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accepted Drivers'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (controller.hasError.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Error: ${controller.errorMessage.value}',
//                   style: TextStyle(color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => controller.getAcceptedDrivers(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                   ),
//                   child: Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }

//         if (controller.bookingsWithDrivers.isEmpty) {
//           return Center(
//             child: Text(
//               'No drivers have accepted your bookings yet.',
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: () => controller.getAcceptedDrivers(),
//           child: ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: controller.bookingsWithDrivers.length,
//             itemBuilder: (context, index) {
//               final booking = controller.bookingsWithDrivers[index];
//               final List<DriverModel> drivers = booking['drivers'];
//               final bookingDate = DateFormat('MMM dd, yyyy').format(booking['booking_for']);
              
//               return Card(
//                 elevation: 4,
//                 margin: EdgeInsets.only(bottom: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       color: AppColors.primary.withOpacity(0.1),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Booking #${booking['booking_id']}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow('Date', bookingDate),
//                           _buildInfoRow('Pickup', booking['pickup_location']),
//                           _buildInfoRow('Destination', booking['dropoff_location'].name),
//                           _buildInfoRow('Fare', '₹${booking['fare']}'),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Available Drivers (${drivers.length})',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 12),
//                           _buildDriversList(drivers, booking),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDriversList(List<DriverModel> drivers, dynamic booking) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: drivers.length,
//       itemBuilder: (context, index) {
//         final driver = drivers[index];
//         final bookingId = booking['booking_id'];
//         final fare = booking['fare'];

//         return Container(
//           margin: EdgeInsets.only(bottom: 10),
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[300]!),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: AppColors.primary,
//                     radius: 25,
//                     child: Text(
//                       driver.name.substring(0, 1).toUpperCase(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           driver.name,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         // Show phone if available
//                         if (driver.phone != 0 && driver.phone != null) ...[
//                           SizedBox(height: 4),
//                           Text(
//                             'Phone: ${driver.phone}',
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         _showSelectDriverConfirmation(driver, bookingId);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       ),
//                       child: Text('Select Driver'),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         _initiatePayment(bookingId, fare.toString());
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       ),
//                       child: Text('Pay Now'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _initiatePayment(int bookingId, String fare) {
//     // Get phone number from ProfileController
//     final phoneNumber = profileController.phone.value;

//     if (phoneNumber.isEmpty) {
//       Get.snackbar(
//         'Error', 
//         'Phone number is not available',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     // Show confirmation dialog before payment
//     Get.dialog(
//       AlertDialog(
//         title: Text('Confirm Payment'),
//         content: Text('Do you want to pay ₹$fare for this booking?'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Initiate Khalti payment
//               khaltiPaymentController.initiatePayment(bookingId, phoneNumber);
//               Get.to(KhaltiSDKDemo());
              
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             child: Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSelectDriverConfirmation(DriverModel driver, int bookingId) {
//     Get.dialog(
//       AlertDialog(
//         title: Text('Confirm Driver Selection'),
//         content: Text('Do you want to select ${driver.name} as your driver?'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               // Pass driver ID instead of driver name
//               controller.selectDriver(bookingId, driver.id);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
//             child: Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/get_accepted_drivers_controller.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
import 'package:gotrip/controllers/khalti_payment_controller.dart';
import 'package:gotrip/model/user_model/driver_model.dart';
import 'package:gotrip/pages/payment/khalti_payment_screen.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:intl/intl.dart';

class AcceptedDriversPage extends StatelessWidget {
  final AcceptedDriversController controller = Get.find<AcceptedDriversController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final KhaltiPaymentController khaltiPaymentController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Drivers'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.errorMessage.value}',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.getAcceptedDrivers(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.bookingsWithDrivers.isEmpty) {
          return Center(
            child: Text(
              'No drivers have accepted your bookings yet.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getAcceptedDrivers(),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.bookingsWithDrivers.length,
            itemBuilder: (context, index) {
              final booking = controller.bookingsWithDrivers[index];
              final List<DriverModel> drivers = booking['drivers'];
              final bookingDate = DateFormat('MMM dd, yyyy').format(booking['booking_for']);
              
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color: AppColors.primary.withOpacity(0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking #${booking['booking_id']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow('Date', bookingDate),
                          _buildInfoRow('Pickup', booking['pickup_location']),
                          _buildInfoRow('Destination', booking['dropoff_location'].name),
                          _buildInfoRow('Fare', '₹${booking['fare']}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Drivers (${drivers.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildDriversList(drivers, booking),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriversList(List<DriverModel> drivers, dynamic booking) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        final driver = drivers[index];
        final bookingId = booking['booking_id'];
        final fare = booking['fare'];

        return Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 25,
                    child: Text(
                      driver.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
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
                        // Show phone if available
                        if (driver.phone != 0 && driver.phone != null) ...[
                          SizedBox(height: 4),
                          Text(
                            'Phone: ${driver.phone}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showSelectDriverConfirmation(driver, bookingId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: Text('Select Driver'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _initiatePayment(bookingId, fare.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: Text('Pay Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

void _initiatePayment(int bookingId, String fare) {
  // Get phone number
  final phoneNumber = profileController.phone.value;

  if (phoneNumber.isEmpty) {
    Get.snackbar('Error', 'Phone number is not available',
      backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  // Show confirmation dialog
  Get.dialog(
    AlertDialog(
      title: Text('Confirm Payment'),
      content: Text('Do you want to pay ₹$fare for this booking?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Get.back(); // Close dialog
            khaltiPaymentController.clearPaymentData();
            
            // Direct approach without async/await
            khaltiPaymentController.initiatePayment(bookingId, phoneNumber);
            // Go directly to payment screen
            Get.to(() => KhaltiSDKDemo());
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text('Confirm'),
        ),
      ],
    ),
  );
}

  void _showSelectDriverConfirmation(DriverModel driver, int bookingId) {
    Get.dialog(
      AlertDialog(
        title: Text('Confirm Driver Selection'),
        content: Text('Do you want to select ${driver.name} as your driver?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Pass driver ID instead of driver name
              controller.selectDriver(bookingId, driver.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}