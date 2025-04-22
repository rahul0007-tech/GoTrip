// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../controllers/create_booking_controller.dart';

// class LocationMapWidget extends StatelessWidget {
//   final CreateBookingController controller;

//   const LocationMapWidget({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Stack(
//           children: [
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: controller.currentLocation.value,
//                 zoom: 15,
//               ),
//               onMapCreated: (GoogleMapController mapController) {
//                 controller.mapController = mapController;
//                 controller.getCurrentLocation();
//               },
//               markers: controller.markers,
//               onTap: controller.onMapTap,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               zoomControlsEnabled: true,
//               mapToolbarEnabled: false,
//             ),
//             if (controller.isLoadingCurrentLocation.value)
//               Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Text('Getting current location...'),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }