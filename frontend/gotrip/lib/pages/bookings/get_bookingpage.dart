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
//                   title: Text('Passenger: ${booking.passenger?.toString() ?? 'N/A'}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Pickup: ${booking.pickupLocation ?? 'N/A'}'),
//                       Text('Destination: ${booking.dropoffLocation ?? 'N/A'}'),
//                       Text('Fare: ${booking.fare?.toString() ?? 'N/A'}'),
//                       Text('Booking Date: ${booking.bookingFor ?? 'N/A'}')
//                     ],
//                   ),
//                   trailing: Obx(() {
//                     return ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: controller.isBookingAccepted(booking.id) 
//                             ? Colors.grey 
//                             : AppColors.primary,
//                       ),
//                       child: Text(
//                         controller.isBookingAccepted(booking.id) 
//                             ? 'Accepted' 
//                             : 'Accept'
//                       ),
//                       onPressed: controller.isBookingAccepted(booking.id) 
//                           ? null 
//                           : () {
//                               controller.acceptBooking(booking.id);
//                             },
//                     );
//                   }),
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

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
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           'Available Bookings',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: AppColors.primary,
//             ),
//           );
//         }
        
//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
//                 SizedBox(height: 16),
//                 Text(
//                   controller.errorMessage.value,
//                   style: TextStyle(
//                     color: Colors.red[700],
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => controller.getAvailableBooking(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text('Try Again'),
//                 ),
//               ],
//             ),
//           );
//         }
        
//         if (controller.bookings.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.calendar_today_outlined,
//                   size: 60,
//                   color: Colors.grey[400],
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'No available bookings found',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Check back later for new booking requests',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => controller.getAvailableBooking(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text('Refresh'),
//                 ),
//               ],
//             ),
//           );
//         }
        
//         // Display booking cards
//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: controller.bookings.length,
//           itemBuilder: (context, index) {
//             final booking = controller.bookings[index];
//             return Container(
//               margin: EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Passenger info and booking date
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: AppColors.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                     ),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: AppColors.primary,
//                           child: Icon(
//                             Icons.person,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${booking.passenger?.toString() ?? 'Passenger'}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Text(
//                                 'Booking for: ${booking.bookingFor ?? 'N/A'}',
//                                 style: TextStyle(
//                                   color: Colors.grey[600],
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '₹${booking.fare?.toString() ?? 'N/A'}',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   // Route details
//                   Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         // Pickup location
//                         Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.green[50],
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.location_on,
//                                 color: Colors.green,
//                                 size: 20,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Pickup',
//                                     style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${booking.pickupLocation ?? 'Not specified'}',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
                        
//                         // Dotted line connector
//                         Padding(
//                           padding: EdgeInsets.only(left: 12),
//                           child: SizedBox(
//                             height: 30,
//                             child: VerticalDivider(
//                               color: Colors.grey[300],
//                               thickness: 2,
//                               width: 20,
//                             ),
//                           ),
//                         ),
                        
//                         // Destination location
//                         Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.red[50],
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.location_on,
//                                 color: Colors.red,
//                                 size: 20,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Destination',
//                                     style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${booking.dropoffLocation ?? 'Not specified'}',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   // Accept button
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         top: BorderSide(color: Colors.grey[200]!),
//                       ),
//                     ),
//                     child: Obx(() {
//                       final isAccepted = controller.isBookingAccepted(booking.id);
//                       return ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: isAccepted ? Colors.grey[300] : AppColors.primary,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           isAccepted ? 'Booking Accepted' : 'Accept Booking',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: isAccepted ? Colors.grey[700] : Colors.white,
//                           ),
//                         ),
//                         onPressed: isAccepted 
//                             ? null 
//                             : () => controller.acceptBooking(booking.id),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Available Bookings',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
    
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }
        
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchAvailableBookings(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        if (controller.bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No available bookings found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for new booking requests',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchAvailableBookings(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Refresh'),
                ),
              ],
            ),
          );
        }
        
        // Display booking cards
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Passenger info and booking date
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${booking.passenger?.toString() ?? 'Passenger'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Booking for: ${booking.bookingFor ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '₹${booking.fare?.toString() ?? 'N/A'}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Route details
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Pickup location
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pickup',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${booking.pickupLocation ?? 'Not specified'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Dotted line connector
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.grey[300],
                              thickness: 2,
                              width: 20,
                            ),
                          ),
                        ),
                        
                        // Destination location
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Destination',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${booking.dropoffLocation ?? 'Not specified'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Accept button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Obx(() {
                      final isAccepted = controller.isBookingAccepted(booking.id);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAccepted ? Colors.grey[400] : AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: isAccepted ? 0 : 2,
                        ),
                        child: Text(
                          isAccepted ? 'Booking Accepted' : 'Accept Booking',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isAccepted ? Colors.white : Colors.white,
                          ),
                        ),
                        onPressed: isAccepted 
                            ? null  // Disable the button when already accepted
                            : () => controller.acceptBooking(booking.id),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}