// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/utils/app_colors.dart';
// import '../../controllers/passenger_upcoming_bookings_controller.dart';
// import '../../model/booking_model/passenger_upcoming_booking.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../constants/api_constants.dart';

// class PassengerUpcomingBookingsPage extends GetView<PassengerUpcomingBookingsController> {
//   const PassengerUpcomingBookingsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upcoming Bookings'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: RefreshIndicator(
//         onRefresh: controller.refresh,
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (controller.hasError.value) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     controller.errorMessage.value,
//                     style: TextStyle(color: Colors.grey[600]),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   TextButton.icon(
//                     onPressed: () => controller.fetchUpcomingBookings(),
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Try Again'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (controller.bookings.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.calendar_today_outlined,
//                     size: 48,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No upcoming bookings',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: controller.bookings.length,
//             itemBuilder: (context, index) {
//               final booking = controller.bookings[index];
//               return buildBookingCard(booking);
//             },
//           );
//         }),
//       ),
//     );
//   }

//   Widget buildBookingCard(PassengerUpcomingBooking booking) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Booking #${booking.id}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         if (booking.driver != null) ...[
//                           const SizedBox(height: 4),
//                           Text(
//                             'Driver: ${booking.driver!.name}',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         '₹${booking.fare}',
//                         style: TextStyle(
//                           color: Colors.green[700],
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 buildLocationInfo(
//                   icon: Icons.circle,
//                   color: Colors.green,
//                   label: booking.pickupLocation,
//                 ),
//                 buildLocationDivider(),
//                 buildLocationInfo(
//                   icon: Icons.place,
//                   color: Colors.red,
//                   label: booking.dropoffLocation.name,
//                 ),
//                 if (booking.driver?.vehicle != null && 
//                     booking.driver!.vehicle!.images.isNotEmpty) ...[
//                   const Divider(height: 24),
//                   SizedBox(
//                     height: 120,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: booking.driver!.vehicle!.images.length,
//                       itemBuilder: (context, index) {
//                         final image = booking.driver!.vehicle!.images[index];
//                         return Container(
//                           width: 160,
//                           margin: const EdgeInsets.only(right: 12),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: CachedNetworkImage(
//                               imageUrl: '${ApiConstants.baseUrl}${image.image}',
//                               fit: BoxFit.cover,
//                               placeholder: (context, url) => Container(
//                                 color: Colors.grey[200],
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//                                   ),
//                                 ),
//                               ),
//                               errorWidget: (context, url, error) => Container(
//                                 color: Colors.grey[200],
//                                 child: Icon(Icons.error_outline, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//                 const Divider(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           booking.getFormattedDate(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           booking.getFormattedTime(),
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (booking.status.toLowerCase() != 'completed' && 
//                         booking.status.toLowerCase() != 'canceled') ...[
//                       TextButton(
//                         onPressed: () => controller.cancelBooking(booking.id),
//                         style: TextButton.styleFrom(
//                           foregroundColor: Colors.red,
//                         ),
//                         child: const Text('Cancel'),
//                       ),
//                     ],
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     buildStatusChip(booking.status),
//                     buildPaymentStatusChip(booking.paymentStatus),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildLocationInfo({
//     required IconData icon,
//     required Color color,
//     required String label,
//   }) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 12,
//           color: color,
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildLocationDivider() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
//       child: Column(
//         children: List.generate(
//           3,
//           (index) => Padding(
//             padding: const EdgeInsets.symmetric(vertical: 1),
//             child: Container(
//               width: 2,
//               height: 2,
//               color: Colors.grey[400],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildStatusChip(String status) {
//     Color backgroundColor;
//     Color textColor;
//     String displayText;

//     switch (status.toLowerCase()) {
//       case 'pending':
//         backgroundColor = Colors.orange.withOpacity(0.1);
//         textColor = Colors.orange[700]!;
//         displayText = 'Pending';
//         break;
//       case 'confirmed':
//         backgroundColor = Colors.green.withOpacity(0.1);
//         textColor = Colors.green[700]!;
//         displayText = 'Confirmed';
//         break;
//       case 'completed':
//         backgroundColor = Colors.blue.withOpacity(0.1);
//         textColor = Colors.blue[700]!;
//         displayText = 'Completed';
//         break;
//       case 'canceled':
//         backgroundColor = Colors.red.withOpacity(0.1);
//         textColor = Colors.red[700]!;
//         displayText = 'Canceled';
//         break;
//       default:
//         backgroundColor = Colors.grey.withOpacity(0.1);
//         textColor = Colors.grey[700]!;
//         displayText = status;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 4,
//       ),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         displayText,
//         style: TextStyle(
//           color: textColor,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget buildPaymentStatusChip(String status) {
//     Color backgroundColor;
//     Color textColor;
//     String displayText;

//     switch (status.toLowerCase()) {
//       case 'pending':
//         backgroundColor = Colors.orange.withOpacity(0.1);
//         textColor = Colors.orange[700]!;
//         displayText = 'Payment Pending';
//         break;
//       case 'partial':
//         backgroundColor = Colors.purple.withOpacity(0.1);
//         textColor = Colors.purple[700]!;
//         displayText = 'Partially Paid';
//         break;
//       case 'confirmed':
//         backgroundColor = Colors.green.withOpacity(0.1);
//         textColor = Colors.green[700]!;
//         displayText = 'Paid';
//         break;
//       case 'canceled':
//         backgroundColor = Colors.red.withOpacity(0.1);
//         textColor = Colors.red[700]!;
//         displayText = 'Payment Canceled';
//         break;
//       default:
//         backgroundColor = Colors.grey.withOpacity(0.1);
//         textColor = Colors.grey[700]!;
//         displayText = status;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 4,
//       ),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         displayText,
//         style: TextStyle(
//           color: textColor,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }