// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import '../controllers/create_booking_controller.dart';
// import '../utils/app_colors.dart';

// class PokharaMapWidget extends StatelessWidget {
//   final CreateBookingController controller;

//   // Pokhara city center coordinates
//   static const LatLng _pokharaCenterCoordinates = LatLng(28.2096, 83.9856);
  
//   // Pokhara map bounds
//   static final LatLngBounds _pokharaBounds = LatLngBounds(
//     southwest: const LatLng(28.1496, 83.9256), // SW corner of Pokhara
//     northeast: const LatLng(28.2696, 84.0456), // NE corner of Pokhara
//   );

//   const PokharaMapWidget({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 200,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade300),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 1,
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Stack(
//               children: [
//                 // The map
//                 GoogleMap(
//                   initialCameraPosition: const CameraPosition(
//                     target: _pokharaCenterCoordinates,
//                     zoom: 14.0,
//                   ),
//                   onMapCreated: (GoogleMapController mapController) {
//                     controller.mapController = mapController;
//                     // Set initial map bounds to Pokhara area
//                     _setMapBounds(mapController);
//                   },
//                   onTap: _handleMapTap,
//                   markers: controller.markers,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: false,
//                   zoomControlsEnabled: false,
//                   // Restrict the map to Pokhara bounds
//                   cameraTargetBounds: CameraTargetBounds(_pokharaBounds),
//                 ),
                
//                 // Loading indicator when getting current location
//                 Positioned.fill(
//                   child: Center(
//                     child: Obx(() => controller.isLoadingCurrentLocation.value
//                         ? Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const CircularProgressIndicator(),
//                           )
//                         : const SizedBox.shrink()),
//                   ),
//                 ),
                
//                 // My location button at bottom right
//                 Positioned(
//                   right: 8,
//                   bottom: 8,
//                   child: FloatingActionButton.small(
//                     backgroundColor: Colors.white,
//                     foregroundColor: AppColors.primary,
//                     onPressed: controller.getCurrentLocation,
//                     child: const Icon(Icons.my_location),
//                   ),
//                 ),
                
//                 // Map label at top
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       'Pokhara, Nepal',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             const Icon(
//               Icons.info_outline,
//               size: 14,
//               color: Colors.grey,
//             ),
//             const SizedBox(width: 4),
//             Expanded(
//               child: Text(
//                 'Tap on the map to select your pickup location in Pokhara',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Handle map tap to update location
//   void _handleMapTap(LatLng position) async {
//     // Check if the tapped position is within Pokhara bounds
//     if (!_isPositionWithinBounds(position, _pokharaBounds)) {
//       // Show a message that the location is outside Pokhara
//       Get.snackbar(
//         'Location outside Pokhara',
//         'Please select a location within Pokhara city limits.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//       return;
//     }
    
//     // Update the controller with the new position
//     controller.selectedLocation.value = position;
//     controller.updateMarker(position);
    
//     // Get address from tapped location using geocoding
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
      
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
        
//         // Format the address string
//         List<String> addressParts = [
//           place.street ?? '',
//           place.subLocality ?? '',
//           place.locality ?? '',
//           'Pokhara, Nepal',
//         ].where((element) => element.isNotEmpty).toList();
        
//         controller.pickupLocation.value = addressParts.join(', ');
//       } else {
//         // Fallback if no address is found
//         controller.pickupLocation.value = 'Selected location in Pokhara (${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)})';
//       }
//     } catch (e) {
//       // Fallback if geocoding fails
//       controller.pickupLocation.value = 'Selected location in Pokhara (${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)})';
//     }
//   }
  
//   // Check if a position is within the given bounds
//   bool _isPositionWithinBounds(LatLng position, LatLngBounds bounds) {
//     return position.latitude >= bounds.southwest.latitude &&
//            position.latitude <= bounds.northeast.latitude &&
//            position.longitude >= bounds.southwest.longitude &&
//            position.longitude <= bounds.northeast.longitude;
//   }
  
//   // Set map bounds to Pokhara area
//   void _setMapBounds(GoogleMapController mapController) {
//     mapController.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         _pokharaBounds,
//         50.0, // padding
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../controllers/create_booking_controller.dart';
import '../utils/app_colors.dart';

class PokharaMapWidget extends StatelessWidget {
  final CreateBookingController controller;

  // Pokhara city center coordinates
  static const LatLng _pokharaCenterCoordinates = LatLng(28.2096, 83.9856);
  
  // Pokhara map bounds
  static final LatLngBounds _pokharaBounds = LatLngBounds(
    southwest: const LatLng(28.1496, 83.9256), // SW corner of Pokhara
    northeast: const LatLng(28.2696, 84.0456), // NE corner of Pokhara
  );

  const PokharaMapWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // The map
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: _pokharaCenterCoordinates,
                    zoom: 14.0,
                  ),
                  onMapCreated: (GoogleMapController mapController) {
                    print("Map created successfully!");
                    controller.mapController = mapController;
                    // Set initial map bounds to Pokhara area
                    _setMapBounds(mapController);
                  },
                  onTap: _handleMapTap,
                  markers: controller.markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true, // Enable zoom controls for debugging
                  mapToolbarEnabled: true, // Enable map toolbar for debugging
                  // Restrict the map to Pokhara bounds
                  cameraTargetBounds: CameraTargetBounds(_pokharaBounds),
                ),
                
                // Loading indicator when getting current location
                Positioned.fill(
                  child: Center(
                    child: Obx(() => controller.isLoadingCurrentLocation.value
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const CircularProgressIndicator(),
                          )
                        : const SizedBox.shrink()),
                  ),
                ),
                
                // My location button at bottom right
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    onPressed: controller.getCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),
                
                // Map label at top
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Pokhara, Nepal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                
                // Add a background in case map fails to load
                Positioned.fill(
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.map_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Loading map of Pokhara...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Tap on the map to select your pickup location in Pokhara',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Handle map tap to update location
  void _handleMapTap(LatLng position) async {
    // Check if the tapped position is within Pokhara bounds
    if (!_isPositionWithinBounds(position, _pokharaBounds)) {
      // Show a message that the location is outside Pokhara
      Get.snackbar(
        'Location outside Pokhara',
        'Please select a location within Pokhara city limits.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }
    
    // Update the controller with the new position
    controller.selectedLocation.value = position;
    controller.updateMarker(position);
    
    // Get address from tapped location using geocoding
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        // Format the address string
        List<String> addressParts = [
          place.street ?? '',
          place.subLocality ?? '',
          place.locality ?? '',
          'Pokhara, Nepal',
        ].where((element) => element.isNotEmpty).toList();
        
        controller.pickupLocation.value = addressParts.join(', ');
      } else {
        // Fallback if no address is found
        controller.pickupLocation.value = 'Selected location in Pokhara (${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)})';
      }
    } catch (e) {
      print("Geocoding error: $e");
      // Fallback if geocoding fails
      controller.pickupLocation.value = 'Selected location in Pokhara (${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)})';
    }
  }
  
  // Check if a position is within the given bounds
  bool _isPositionWithinBounds(LatLng position, LatLngBounds bounds) {
    return position.latitude >= bounds.southwest.latitude &&
           position.latitude <= bounds.northeast.latitude &&
           position.longitude >= bounds.southwest.longitude &&
           position.longitude <= bounds.northeast.longitude;
  }
  
  // Set map bounds to Pokhara area
  void _setMapBounds(GoogleMapController mapController) {
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        _pokharaBounds,
        50.0, // padding
      ),
    );
  }
}