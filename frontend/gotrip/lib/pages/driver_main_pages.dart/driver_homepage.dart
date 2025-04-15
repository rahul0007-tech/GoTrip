


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/utils/app_colors.dart';
// import '../../controllers/driver_home_page_controller.dart';

// class DriverHomePage extends StatelessWidget {
//   // Create the controller instance directly to avoid dependency injection issues
//   final DriverHomePageController controller = Get.put(DriverHomePageController());

//   DriverHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             Image.asset(
//               'asset/images/trophy_icon.png', 
//               height: 30,
//               // If you don't have this image, replace it with:
//               // Icon(Icons.directions_car, color: AppColors.primary, size: 30),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               'GoTrip Driver',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold, 
//                 color: AppColors.primary,
//                 fontSize: 20,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Obx(() => controller.isLoading.value 
//             ? const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                   ),
//                 ),
//               )
//             : Switch(
//                 value: controller.isOnline.value,
//                 activeColor: Colors.green,
//                 activeTrackColor: Colors.green[200],
//                 inactiveThumbColor: Colors.red,
//                 inactiveTrackColor: Colors.red[200],
//                 onChanged: (value) async {
//                   await controller.toggleOnlineStatus();
//                 },
//               )
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             icon: Icon(Icons.notifications, color: AppColors.primary),
//             onPressed: () {
//               Get.snackbar(
//                 'Notifications',
//                 'No new notifications',
//                 snackPosition: SnackPosition.TOP,
//               );
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // Simulate refresh
//           await Future.delayed(const Duration(seconds: 1));
//           return;
//         },
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Status Card and Greeting
//               _buildDriverStatusCard(),
              
//               // Quick Actions
//               _buildQuickActions(),
              
//               // Stats Overview
//               _buildStatsOverview(),
              
//               // Upcoming Rides
//               _buildUpcomingRides(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDriverStatusCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.white,
//                 backgroundImage: const AssetImage('assets/images/profile/driver_profile.jpg'),
//                 // If you don't have this image, replace backgroundImage with:
//                 // child: Icon(Icons.person, size: 40, color: AppColors.primary),
//               ),
//               const SizedBox(width: 15),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Welcome back,',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const Text(
//                     'Dipesh Karki',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber, size: 18),
//                       Obx(() => Text(
//                         ' ${controller.rating.value}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )),
//                       const Text(
//                         ' · Driver Rating',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // Status Indicator
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Obx(() => Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: controller.isOnline.value ? Colors.green : Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       controller.isOnline.value ? Icons.circle : Icons.circle_outlined,
//                       color: Colors.white,
//                       size: 12,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       controller.isOnline.value ? 'ONLINE' : 'OFFLINE',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(
//                       Icons.directions_car,
//                       color: Colors.white,
//                       size: 14,
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       'VERIFIED DRIVER',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Quick Actions',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildActionButton(
//                 icon: Icons.history,
//                 label: 'Trip History',
//                 color: Colors.blue,
//                 onTap: () {},
//               ),
//               _buildActionButton(
//                 icon: Icons.payment,
//                 label: 'Earnings',
//                 color: Colors.green,
//                 onTap: () {},
//               ),
//               _buildActionButton(
//                 icon: Icons.account_balance_wallet,
//                 label: 'Wallet',
//                 color: Colors.purple,
//                 onTap: () {},
//               ),
//               _buildActionButton(
//                 icon: Icons.support_agent,
//                 label: 'Support',
//                 color: Colors.orange,
//                 onTap: () {},
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 28,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsOverview() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Your Stats',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatItem(
//                   icon: Icons.account_balance_wallet,
//                   label: 'Total Earnings',
//                   value: controller.totalEarnings.value,
//                   color: Colors.green,
//                 ),
//               ),
//               Expanded(
//                 child: _buildStatItem(
//                   icon: Icons.today,
//                   label: 'Today',
//                   value: controller.todayEarnings.value,
//                   color: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatItem(
//                   icon: Icons.pin_drop,
//                   label: 'Rides Completed',
//                   value: controller.rideCompleted.toString(),
//                   color: Colors.orange,
//                 ),
//               ),
//               Expanded(
//                 child: _buildStatItem(
//                   icon: Icons.navigation,
//                   label: 'Upcoming Rides',
//                   value: controller.upcomingRides.toString(),
//                   color: Colors.purple,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.amber.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.amber.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.tips_and_updates,
//                   color: Colors.amber[800],
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     'Complete 2 more trips today and earn a bonus of ₹500!',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.amber[800],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 color: color,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildUpcomingRides() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Your Upcoming Rides',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   'View All',
//                   style: TextStyle(
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Obx(() {
//             if (controller.upcomingBookings.isEmpty) {
//               return Center(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     Icon(
//                       Icons.directions_car_outlined,
//                       size: 80,
//                       color: Colors.grey[400],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No upcoming rides',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'New ride requests will appear here',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
            
//             return ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: controller.upcomingBookings.length,
//               itemBuilder: (context, index) {
//                 final booking = controller.upcomingBookings[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               // Use a default avatar if no image available
//                               child: Container(
//                                 width: 60,
//                                 height: 60,
//                                 color: Colors.grey[200],
//                                 child: Icon(
//                                   Icons.person,
//                                   color: Colors.grey[400],
//                                   size: 40,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         booking['passengerName'] ?? 'Passenger',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppColors.primary.withOpacity(0.1),
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: Text(
//                                           booking['id'] ?? 'B-0000',
//                                           style: TextStyle(
//                                             color: AppColors.primary,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.calendar_today,
//                                         size: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         booking['date'] ?? 'Date not available',
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Icon(
//                                         Icons.access_time,
//                                         size: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         booking['time'] ?? 'Time not available',
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),
//                                   _buildLocationInfo(
//                                     icon: Icons.circle,
//                                     color: Colors.green,
//                                     label: booking['pickup'] ?? 'Pickup location',
//                                   ),
//                                   _buildLocationDivider(),
//                                   _buildLocationInfo(
//                                     icon: Icons.location_on,
//                                     color: Colors.red,
//                                     label: booking['destination'] ?? 'Destination',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Divider(height: 1),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.route,
//                                   size: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   booking['distance'] ?? 'Distance not available',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.attach_money,
//                                   size: 16,
//                                   color: Colors.green[600],
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   booking['amount'] ?? 'Amount not available',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     color: Colors.green[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           // Navigate to ride details
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(16),
//                               bottomRight: Radius.circular(16),
//                             ),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'VIEW DETAILS',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationInfo({required IconData icon, required Color color, required String label}) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: color,
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLocationDivider() {
//     return Container(
//       margin: const EdgeInsets.only(left: 8),
//       height: 20,
//       width: 1,
//       color: Colors.grey[300],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';
import '../../controllers/driver_home_page_controller.dart';
import '../driver_status_card.dart';

class DriverHomePage extends StatelessWidget {
  // Create the controller instance directly to avoid dependency injection issues
  final DriverHomePageController controller = Get.put(DriverHomePageController());

  DriverHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'asset/images/trophy_icon.png', 
              height: 30,
              // If you don't have this image, replace it with:
              // Icon(Icons.directions_car, color: AppColors.primary, size: 30),
            ),
            const SizedBox(width: 10),
            Text(
              'GoTrip Driver',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: AppColors.primary,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Obx(() => controller.isLoading.value 
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
            : Switch(
                value: controller.isOnline.value,
                activeColor: Colors.green,
                activeTrackColor: Colors.green[200],
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red[200],
                onChanged: (value) async {
                  await controller.toggleOnlineStatus();
                },
              )
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.primary),
            onPressed: () {
              Get.snackbar(
                'Notifications',
                'No new notifications',
                snackPosition: SnackPosition.TOP,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data from API
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card and Greeting - Using the extracted widget
              buildDriverStatusCard(controller),
              
              // Quick Actions
              _buildQuickActions(),
              
              // Stats Overview
              _buildStatsOverview(),
              
              // Upcoming Rides
              _buildUpcomingRides(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                icon: Icons.history,
                label: 'Trip History',
                color: Colors.blue,
                onTap: () {},
              ),
              _buildActionButton(
                icon: Icons.payment,
                label: 'Earnings',
                color: Colors.green,
                onTap: () {},
              ),
              _buildActionButton(
                icon: Icons.account_balance_wallet,
                label: 'Wallet',
                color: Colors.purple,
                onTap: () {},
              ),
              _buildActionButton(
                icon: Icons.support_agent,
                label: 'Support',
                color: Colors.orange,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Total Earnings',
                  value: controller.totalEarnings.value,
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.today,
                  label: 'Today',
                  value: controller.todayEarnings.value,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.pin_drop,
                  label: 'Rides Completed',
                  value: controller.rideCompleted.toString(),
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.navigation,
                  label: 'Upcoming Rides',
                  value: controller.upcomingRides.toString(),
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: Colors.amber[800],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Complete 2 more trips today and earn a bonus of ₹500!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingRides() {
    // Rest of the method remains unchanged
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Upcoming Rides',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.upcomingBookings.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      Icons.directions_car_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No upcoming rides',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'New ride requests will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.upcomingBookings.length,
              itemBuilder: (context, index) {
                final booking = controller.upcomingBookings[index];
                // Rest of your booking item UI
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[400],
                                  size: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        booking['passengerName'] ?? 'Passenger',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          booking['id'] ?? 'B-0000',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        booking['date'] ?? 'Date not available',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                        ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        booking['time'] ?? 'Time not available',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildLocationInfo(
                                    icon: Icons.circle,
                                    color: Colors.green,
                                    label: booking['pickup'] ?? 'Pickup location',
                                  ),
                                  _buildLocationDivider(),
                                  _buildLocationInfo(
                                    icon: Icons.location_on,
                                    color: Colors.red,
                                    label: booking['destination'] ?? 'Destination',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.route,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  booking['distance'] ?? 'Distance not available',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                  color: Colors.green[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  booking['amount'] ?? 'Amount not available',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigate to ride details
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'VIEW DETAILS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLocationInfo({required IconData icon, required Color color, required String label}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      height: 20,
      width: 1,
      color: Colors.grey[300],
    );
  }
}