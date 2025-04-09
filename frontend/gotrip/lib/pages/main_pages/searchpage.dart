// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:gotrip/controllers/display_vehicle_type_controller.dart';

// class SearchPage extends StatelessWidget {
//   const SearchPage({super.key});

//   // Helper method to get appropriate icon based on vehicle type
//   IconData _getVehicleIcon(String vehicleType) {
//     switch (vehicleType.toLowerCase()) {
//       case 'suv':
//       case '4x4':
//         return LineAwesomeIcons.car_side_solid;
//       case 'sedan':
//         return LineAwesomeIcons.car_solid;
//       case 'off road':
//         return LineAwesomeIcons.truck_pickup_solid;
//       case 'hatchback':
//         return LineAwesomeIcons.car_solid;
//       default:
//         return LineAwesomeIcons.car_alt_solid;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get the vehicle controller
//     final VehicleController vehicleController = Get.find<VehicleController>();

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Search for Vehicles'),
//         // backgroundColor: Colors.teal,
//         actions: [
//           // Refresh button
//           IconButton(
//             icon: const Icon(LineAwesomeIcons.sync_solid),
//             onPressed: () => vehicleController.fetchVehicleTypes(),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             const SizedBox(height: 20),
//             Expanded(
//               child: Obx(() {
//                 // Show loading indicator
//                 if (vehicleController.isLoading.value) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
                
//                 // Show error message if any
//                 if (vehicleController.errorMessage.value.isNotEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           vehicleController.errorMessage.value,
//                           style: const TextStyle(color: Colors.red),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () => vehicleController.fetchVehicleTypes(),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.teal,
//                           ),
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
                
//                 // Show empty state
//                 if (vehicleController.vehicleTypes.isEmpty) {
//                   return const Center(
//                     child: Text('No vehicle types available'),
//                   );
//                 }
                
//                 // Show list of vehicle types
//                 return ListView.builder(
//                   itemCount: vehicleController.vehicleTypes.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final vehicleType = vehicleController.vehicleTypes[index];
//                     return Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.teal,
//                           child: Icon(
//                             _getVehicleIcon(vehicleType.name),
//                             color: Colors.white,
//                           ),
//                         ),
//                         title: Text(
//                           vehicleType.displayName,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text('Vehicle Type ID: ${vehicleType.id}'),
//                         trailing: const Icon(Icons.arrow_forward_ios,
//                             color: Colors.grey),
//                         onTap: () {
//                           // Navigate to drivers page with this vehicle type
//                           print('Navigating to drivers page with ID: ${vehicleType.id}, name: ${vehicleType.displayName}');
//                           Get.toNamed('/drivers', arguments: {
//                             'vehicleTypeId': vehicleType.id,
//                             'vehicleTypeName': vehicleType.displayName,
//                           });
//                         },
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:gotrip/controllers/display_vehicle_type_controller.dart';

// class SearchPage extends StatelessWidget {
//   const SearchPage({super.key});

//   // Helper method to get appropriate icon based on vehicle type
//   IconData _getVehicleIcon(String vehicleType) {
//     switch (vehicleType.toLowerCase()) {
//       case 'suv':
//       case '4x4':
//         return LineAwesomeIcons.car_side_solid;
//       case 'sedan':
//         return LineAwesomeIcons.car_solid;
//       case 'off road':
//         return LineAwesomeIcons.truck_pickup_solid;
//       case 'hatchback':
//         return LineAwesomeIcons.car_solid;
//       default:
//         return LineAwesomeIcons.car_alt_solid;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get the vehicle controller
//     final VehicleController vehicleController = Get.find<VehicleController>();
    
//     // Define colors for the theme
//     final Color primaryColor = Colors.teal.shade700;
//     final Color secondaryColor = Colors.teal.shade50;
//     final Color accentColor = Colors.amber.shade600;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Choose Your Ride',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         actions: [
//           // Refresh button
//           IconButton(
//             icon: Icon(LineAwesomeIcons.sync_solid, color: primaryColor),
//             onPressed: () => vehicleController.fetchVehicleTypes(),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Search bar section with animation
//           Container(
//             margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 10,
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//             ),
//             // child: TextField(
//             //   decoration: InputDecoration(
//             //     hintText: 'Where would you like to go?',
//             //     hintStyle: TextStyle(color: Colors.grey.shade400),
//             //     prefixIcon: Icon(Icons.search, color: primaryColor),
//             //     suffixIcon: Icon(Icons.mic, color: Colors.grey.shade400),
//             //     border: InputBorder.none,
//             //     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             //   ),
//             // ),
//           ),
          
//           // Categories section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//               //   // const Text(
//               //   //   'Choose Your Ride',
//               //   //   style: TextStyle(
//               //   //     fontSize: 20,
//               //   //     fontWeight: FontWeight.bold,
//               //   //   ),
//               //   ),
//                 // const Center(
//                 // child:Text(
//                 //   'Select a vehicle type that suits your needs',
//                 //   style: TextStyle(
//                 //     fontSize: 14,
//                 //     color: Colors.grey.shade600,
                    
//                 //   ),
                  
//                 // ),
//                 // ),
//                                 Center(
//                   child: Text(
//                     'Select a vehicle type that suits your needs',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
                
//               ],
              
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           // Vehicle types list
//           Expanded(
//             child: Obx(() {
//               // Show loading indicator
//               if (vehicleController.isLoading.value) {
//                 return Center(
//                   child: CircularProgressIndicator(
//                     color: primaryColor,
//                   ),
//                 );
//               }
              
//               // Show error message if any
//               if (vehicleController.errorMessage.value.isNotEmpty) {
//                 return Center(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 32),
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 10,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           LineAwesomeIcons.exclamation_circle_solid,
//                           size: 60,
//                           color: Colors.red.shade300,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           vehicleController.errorMessage.value,
//                           style: TextStyle(color: Colors.red.shade400),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 24),
//                         ElevatedButton(
//                           onPressed: () => vehicleController.fetchVehicleTypes(),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryColor,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: const Text(
//                             'Retry',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
              
//               // Show empty state
//               if (vehicleController.vehicleTypes.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         LineAwesomeIcons.car_crash_solid,
//                         size: 80,
//                         color: Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No vehicle types available',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Try refreshing or check back later',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
              
//               // Show list of vehicle types with enhanced UI
//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: vehicleController.vehicleTypes.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final vehicleType = vehicleController.vehicleTypes[index];
                  
//                   // Get appropriate background color for vehicle type
//                   Color bgColor;
//                   switch (vehicleType.name.toLowerCase()) {
//                     case 'off road':
//                       bgColor = Colors.brown.shade50;
//                       break;
//                     case 'suv':
//                       bgColor = Colors.blue.shade50;
//                       break;
//                     case 'sedan':
//                       bgColor = Colors.green.shade50;
//                       break;
//                     case 'hatchback':
//                       bgColor = Colors.purple.shade50;
//                       break;
//                     case '4x4':
//                       bgColor = Colors.orange.shade50;
//                       break;
//                     default:
//                       bgColor = secondaryColor;
//                   }
                  
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 10,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: InkWell(
//                       onTap: () {
//                         // Navigate to drivers page with this vehicle type
//                         print('Navigating to drivers page with ID: ${vehicleType.id}, name: ${vehicleType.displayName}');
//                         Get.toNamed('/drivers', arguments: {
//                           'vehicleTypeId': vehicleType.id,
//                           'vehicleTypeName': vehicleType.displayName,
//                         });
//                       },
//                       borderRadius: BorderRadius.circular(16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           children: [
//                             // Vehicle icon
//                             Container(
//                               width: 70,
//                               height: 70,
//                               decoration: BoxDecoration(
//                                 color: bgColor,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Icon(
//                                 _getVehicleIcon(vehicleType.name),
//                                 color: primaryColor,
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             // Vehicle info
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     vehicleType.displayName,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     _getVehicleDescription(vehicleType.name),
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       _buildFeatureBadge(Icons.people, 'Seats', vehicleType.name),
//                                       const SizedBox(width: 12),
//                                       _buildFeatureBadge(Icons.luggage, 'Luggage', vehicleType.name),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: primaryColor,
//                               size: 16,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
  
//   // Helper method to get vehicle descriptions
//   String _getVehicleDescription(String vehicleType) {
//     switch (vehicleType.toLowerCase()) {
//       case 'suv':
//         return 'Spacious vehicle with higher ground clearance';
//       case '4x4':
//         return 'All-terrain vehicle for rugged adventures';
//       case 'sedan':
//         return 'Classic comfort with ample trunk space';
//       case 'off road':
//         return 'Designed for rough terrain and wilderness';
//       case 'hatchback':
//         return 'Compact and efficient city navigator';
//       default:
//         return 'Comfortable ride for your journey';
//     }
//   }
  
//   // Helper method to build feature badges
//   Widget _buildFeatureBadge(IconData icon, String label, String vehicleType) {
//     // Get appropriate data based on vehicle type
//     String data;
//     if (label == 'Seats') {
//       switch (vehicleType.toLowerCase()) {
//         case 'suv':
//           data = '5-7';
//           break;
//         case '4x4':
//           data = '5-7';
//           break;
//         case 'sedan':
//           data = '5';
//           break;
//         case 'off road':
//           data = '4-6';
//           break;
//         case 'hatchback':
//           data = '4-5';
//           break;
//         default:
//           data = '4+';
//       }
//     } else { // Luggage
//       switch (vehicleType.toLowerCase()) {
//         case 'suv':
//           data = 'Large';
//           break;
//         case '4x4':
//           data = 'Large';
//           break;
//         case 'sedan':
//           data = 'Medium';
//           break;
//         case 'off road':
//           data = 'Medium';
//           break;
//         case 'hatchback':
//           data = 'Small';
//           break;
//         default:
//           data = 'Varies';
//       }
//     }
    
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 14,
//             color: Colors.grey.shade700,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             '$label: $data',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade700,
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
import 'package:gotrip/controllers/display_vehicle_type_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  // Helper method to get appropriate icon based on vehicle type
  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'suv':
      case '4x4':
        return LineAwesomeIcons.car_side_solid;
      case 'sedan':
        return LineAwesomeIcons.car_solid;
      case 'off road':
        return LineAwesomeIcons.truck_pickup_solid;
      case 'hatchback':
        return LineAwesomeIcons.car_solid;
      default:
        return LineAwesomeIcons.car_alt_solid;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the vehicle controller
    final VehicleController vehicleController = Get.find<VehicleController>();
    
    // Define colors for the theme
    final Color primaryColor = Colors.teal.shade700;
    final Color secondaryColor = Colors.teal.shade50;
    final Color accentColor = Colors.amber.shade600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Choose Your Ride',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Refresh button
          IconButton(
            icon: Icon(LineAwesomeIcons.sync_solid, color: primaryColor),
            onPressed: () => vehicleController.fetchVehicleTypes(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar section with animation
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Where would you like to go?',
          //       hintStyle: TextStyle(color: Colors.grey.shade400),
          //       prefixIcon: Icon(Icons.search, color: primaryColor),
          //       suffixIcon: Icon(Icons.mic, color: Colors.grey.shade400),
          //       border: InputBorder.none,
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          //     ),
          //   ),
          ),
          
          // Categories section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Center(
                //   child: Text(
                //     'Choose Your Ride',
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Select a vehicle type that suits your needs',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Vehicle types list
          Expanded(
            child: Obx(() {
              // Show loading indicator
              if (vehicleController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              
              // Show error message if any
              if (vehicleController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
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
                        Icon(
                          LineAwesomeIcons.exclamation_circle_solid,
                          size: 60,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          vehicleController.errorMessage.value,
                          style: TextStyle(color: Colors.red.shade400),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => vehicleController.fetchVehicleTypes(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              // Show empty state
              if (vehicleController.vehicleTypes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LineAwesomeIcons.car_crash_solid,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No vehicle types available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try refreshing or check back later',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Show list of vehicle types with enhanced UI
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: vehicleController.vehicleTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  final vehicleType = vehicleController.vehicleTypes[index];
                  
                  // Get appropriate background color for vehicle type
                  Color bgColor;
                  switch (vehicleType.name.toLowerCase()) {
                    case 'off road':
                      bgColor = Colors.brown.shade50;
                      break;
                    case 'suv':
                      bgColor = Colors.blue.shade50;
                      break;
                    case 'sedan':
                      bgColor = Colors.green.shade50;
                      break;
                    case 'hatchback':
                      bgColor = Colors.purple.shade50;
                      break;
                    case '4x4':
                      bgColor = Colors.orange.shade50;
                      break;
                    default:
                      bgColor = secondaryColor;
                  }
                  
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
                    child: InkWell(
                      onTap: () {
                        // Navigate to drivers page with this vehicle type
                        print('Navigating to drivers page with ID: ${vehicleType.id}, name: ${vehicleType.displayName}');
                        Get.toNamed('/drivers', arguments: {
                          'vehicleTypeId': vehicleType.id,
                          'vehicleTypeName': vehicleType.displayName,
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Vehicle icon
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getVehicleIcon(vehicleType.name),
                                color: primaryColor,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Vehicle info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vehicleType.displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getVehicleDescription(vehicleType.name),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildFeatureBadge(Icons.people, 'Seats', vehicleType.name),
                                      const SizedBox(width: 12),
                                      _buildFeatureBadge(Icons.luggage, 'Luggage', vehicleType.name),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
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
  
  // Helper method to get vehicle descriptions
  String _getVehicleDescription(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'suv':
        return 'Spacious vehicle with higher ground clearance';
      case '4x4':
        return 'All-terrain vehicle for rugged adventures';
      case 'sedan':
        return 'Classic comfort with ample trunk space';
      case 'off road':
        return 'Designed for rough terrain and wilderness';
      case 'hatchback':
        return 'Compact and efficient city navigator';
      default:
        return 'Comfortable ride for your journey';
    }
  }
  
  // Helper method to build feature badges
  Widget _buildFeatureBadge(IconData icon, String label, String vehicleType) {
    // Get appropriate data based on vehicle type
    String data;
    if (label == 'Seats') {
      switch (vehicleType.toLowerCase()) {
        case 'suv':
          data = '5-7';
          break;
        case '4x4':
          data = '5-7';
          break;
        case 'sedan':
          data = '5';
          break;
        case 'off road':
          data = '4-6';
          break;
        case 'hatchback':
          data = '4-5';
          break;
        default:
          data = '4+';
      }
    } else { // Luggage
      switch (vehicleType.toLowerCase()) {
        case 'suv':
          data = 'Large';
          break;
        case '4x4':
          data = 'Large';
          break;
        case 'sedan':
          data = 'Medium';
          break;
        case 'off road':
          data = 'Medium';
          break;
        case 'hatchback':
          data = 'Small';
          break;
        default:
          data = 'Varies';
      }
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $data',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}