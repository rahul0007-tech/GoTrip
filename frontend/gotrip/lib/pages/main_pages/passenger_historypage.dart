// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/passenger_history_controller.dart';
// import 'package:gotrip/utils/app_colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../constants/api_constants.dart';

// class PassengerHistoryPage extends StatelessWidget {
//   final PassengerHistoryController controller = Get.put(PassengerHistoryController());

//   PassengerHistoryPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Trip History'),
//         backgroundColor: AppColors.primary,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () => controller.refreshHistory(),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => controller.refreshHistory(),
//         child: Obx(() {
//           if (controller.isTripHistoryLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (controller.hasTripHistoryError.value) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     controller.tripHistoryErrorMessage.value,
//                     style: TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => controller.refreshHistory(),
//                     child: Text('Retry'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (controller.tripHistory.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.history, size: 64, color: Colors.grey),
//                   SizedBox(height: 16),
//                   Text(
//                     'No trip history found',
//                     style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.toNamed('/create_booking_page');
//                     },
//                     child: Text('Book Now'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // Sort trips by date (most recent first)
//           final sortedTrips = List.from(controller.tripHistory)
//             ..sort((a, b) {
//               try {
//                 final dateA = DateTime.parse(a['booking_for']);
//                 final dateB = DateTime.parse(b['booking_for']);
//                 return dateB.compareTo(dateA);
//               } catch (_) {
//                 return 0;
//               }
//             });

//           return ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: sortedTrips.length,
//             itemBuilder: (context, index) {
//               final trip = sortedTrips[index];
//               return Card(
//                 margin: EdgeInsets.only(bottom: 16),
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Trip #${trip['id']}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                             decoration: BoxDecoration(
//                               color: controller.isCompletedTrip(trip['booking_for'])
//                                   ? Colors.green[100]
//                                   : Colors.blue[100],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               controller.isCompletedTrip(trip['booking_for'])
//                                   ? 'Completed'
//                                   : 'Scheduled',
//                               style: TextStyle(
//                                 color: controller.isCompletedTrip(trip['booking_for'])
//                                     ? Colors.green[800]
//                                     : Colors.blue[800],
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12),

//                       // Fare
//                       Text(
//                         '₹${trip['fare']}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: Colors.green,
//                         ),
//                       ),
//                       SizedBox(height: 16),

//                       // Route info
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.blue, size: 20),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'From: ${trip['pickup_location']}',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   'To: ${trip['dropoff_location']['name']}',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12),

//                       // Date and time
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_today, color: Colors.grey, size: 20),
//                           SizedBox(width: 8),
//                           Text(
//                             controller.getFormattedDate(trip['booking_for']),
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                           SizedBox(width: 16),
//                           Icon(Icons.access_time, color: Colors.grey, size: 20),
//                           SizedBox(width: 8),
//                           Text(
//                             controller.getFormattedTime(trip['booking_time'] ?? ''),
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ],
//                       ),
                      
//                       // Driver information if available
//                       if (trip['driver'] != null) ...[
//                         SizedBox(height: 16),
//                         Divider(),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(Icons.person, color: AppColors.primary),
//                             SizedBox(width: 8),
//                             Text(
//                               'Driver: ${trip['driver']['name']}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
                        
//                         if (trip['driver']['vehicle'] != null) ...[
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 28),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${trip['driver']['vehicle']['vehicle_company']} ${trip['driver']['vehicle']['vehicle_color']}',
//                                   style: TextStyle(color: Colors.grey[700]),
//                                 ),
//                                 Text(
//                                   'Vehicle Number: ${trip['driver']['vehicle']['vehicle_number']}',
//                                   style: TextStyle(color: Colors.grey[700]),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
                        
//                         // Vehicle images if available
//                         if (trip['driver']['vehicle'] != null && 
//                             trip['driver']['vehicle']['images'] != null &&
//                             trip['driver']['vehicle']['images'].length > 0) ...[
//                           SizedBox(height: 12),
//                           Text(
//                             'Vehicle Images',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           SizedBox(
//                             height: 80,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: trip['driver']['vehicle']['images'].length,
//                               itemBuilder: (context, imageIndex) {
//                                 final image = trip['driver']['vehicle']['images'][imageIndex];
//                                 return Container(
//                                   width: 80,
//                                   height: 80,
//                                   margin: EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(color: Colors.grey[300]!),
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: CachedNetworkImage(
//                                       imageUrl: _getFullImageUrl(image['image']),
//                                       fit: BoxFit.cover,
//                                       placeholder: (context, url) => Center(
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                         ),
//                                       ),
//                                       errorWidget: (context, url, error) {
//                                         print('Error loading image: $url - $error');
//                                         return Center(
//                                           child: Icon(Icons.error, color: Colors.red),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ],
                      
//                       // Action buttons
//                       SizedBox(height: 16),
//                       if (controller.isCompletedTrip(trip['booking_for'])) ...[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             OutlinedButton.icon(
//                               onPressed: () {
//                                 // Rating functionality
//                               },
//                               icon: Icon(Icons.star),
//                               label: Text('Rate Trip'),
//                             ),
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 // Book again functionality
//                                 Get.toNamed('/create_booking_page');
//                               },
//                               icon: Icon(Icons.refresh),
//                               label: Text('Book Again'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.primary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ] else ...[
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               // View details functionality
//                             },
//                             icon: Icon(Icons.info_outline),
//                             label: Text('View Details'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                       ],
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

//   // FIXED: The _getFullImageUrl method to avoid path duplication 
//   String _getFullImageUrl(String imagePath) {
//     // If it's already a full URL starting with http:// or https://, return as is
//     if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
//       return imagePath;
//     }
    
//     // Remove any leading slash from the path to avoid double slashes
//     String path = imagePath;
//     if (path.startsWith('/')) {
//       path = path.substring(1);
//     }
    
//     // Make sure baseUrl doesn't end with a slash
//     String baseUrl = ApiConstants.baseUrl;
//     if (baseUrl.endsWith('/')) {
//       baseUrl = baseUrl.substring(0, baseUrl.length - 1);
//     }
    
//     // Combine base URL and path with a slash in between
//     return '$baseUrl/$path';
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/passenger_history_controller.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/api_constants.dart';

class PassengerHistoryPage extends StatelessWidget {
  final PassengerHistoryController controller = Get.put(PassengerHistoryController());

  PassengerHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.refreshHistory(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshHistory(),
        child: Obx(() {
          if (controller.isTripHistoryLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.hasTripHistoryError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.tripHistoryErrorMessage.value,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshHistory(),
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.tripHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No trip history found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/create_booking_page');
                    },
                    child: Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }

          // Sort trips by date (most recent first)
          final sortedTrips = List.from(controller.tripHistory)
            ..sort((a, b) {
              try {
                final dateA = DateTime.parse(a['booking_for']);
                final dateB = DateTime.parse(b['booking_for']);
                return dateB.compareTo(dateA);
              } catch (_) {
                return 0;
              }
            });

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: sortedTrips.length,
            itemBuilder: (context, index) {
              final trip = sortedTrips[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trip #${trip['id']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: controller.isCompletedTrip(trip['booking_for'])
                                  ? Colors.green[100]
                                  : Colors.blue[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              controller.isCompletedTrip(trip['booking_for'])
                                  ? 'Completed'
                                  : 'Scheduled',
                              style: TextStyle(
                                color: controller.isCompletedTrip(trip['booking_for'])
                                    ? Colors.green[800]
                                    : Colors.blue[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Fare
                      Text(
                        '₹${trip['fare']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Route info
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From: ${trip['pickup_location']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'To: ${trip['dropoff_location']['name']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Date and time
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                          SizedBox(width: 8),
                          Text(
                            controller.getFormattedDate(trip['booking_for']),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.access_time, color: Colors.grey, size: 20),
                          SizedBox(width: 8),
                          Text(
                            controller.getFormattedTime(trip['booking_time'] ?? ''),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      
                      // Driver information if available
                      if (trip['driver'] != null) ...[
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Driver: ${trip['driver']['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        
                        if (trip['driver']['vehicle'] != null) ...[
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${trip['driver']['vehicle']['vehicle_company']} ${trip['driver']['vehicle']['vehicle_color']}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Text(
                                  'Vehicle Number: ${trip['driver']['vehicle']['vehicle_number']}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        // Vehicle images if available
                        if (trip['driver']['vehicle'] != null && 
                            trip['driver']['vehicle']['images'] != null &&
                            trip['driver']['vehicle']['images'].length > 0) ...[
                          SizedBox(height: 12),
                          Text(
                            'Vehicle Images',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: trip['driver']['vehicle']['images'].length,
                              itemBuilder: (context, imageIndex) {
                                final image = trip['driver']['vehicle']['images'][imageIndex];
                                return Container(
                                  width: 80,
                                  height: 80,
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: _getFullImageUrl(image['image']),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) {
                                        print('Error loading image: $url - $error');
                                        return Center(
                                          child: Icon(Icons.error, color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                      
                      // Action buttons
                      SizedBox(height: 16),
                      if (controller.isCompletedTrip(trip['booking_for'])) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                // Rating functionality
                              },
                              icon: Icon(Icons.star),
                              label: Text('Rate Trip'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Book again functionality
                                Get.toNamed('/create_booking_page');
                              },
                              icon: Icon(Icons.refresh),
                              label: Text('Book Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // View details functionality
                            },
                            icon: Icon(Icons.info_outline),
                            label: Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Fixed _getFullImageUrl method to properly construct image URLs
  String _getFullImageUrl(String imagePath) {
    // If it's already a full URL starting with http:// or https://, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Remove any leading slash from the path to avoid double slashes
    String path = imagePath;
    if (path.startsWith('/')) {
      path = path.substring(1);
    }

    // Make sure baseUrl doesn't end with a slash
    String baseUrl = ApiConstants.baseUrl;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    
    // Combine base URL and path with a slash in between
    return '$baseUrl/$path';
  }
}