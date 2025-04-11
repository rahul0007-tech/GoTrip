


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/utils/app_colors.dart';

// class BookingsPage extends StatelessWidget {
//   const BookingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bookings'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Create Your Booking',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Redirect to the Create Booking page
//                 Get.toNamed('/create_booking_page');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               ),
//               child: Text('Create Booking'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Redirect to the Accepted Drivers page
//                 Get.toNamed('/accepted_drivers');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               ),
//               child: Text('Show Accepted Drivers'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define consistent colors
    final Color primaryColor = AppColors.primary;
    final Color secondaryColor = Colors.teal.shade50;
    final Color accentColor = Colors.amber.shade600;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     'My Bookings',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 22,
      //     ),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   foregroundColor: Colors.black87,
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with welcome message
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Bookings',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your trips and explore new destinations',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content with cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Create booking card
                  _buildActionCard(
                    title: 'Create a New Booking',
                    description: 'Plan your next adventure with our reliable drivers',
                    icon: LineAwesomeIcons.plus_circle_solid,
                    iconColor: Colors.green,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade50,
                        Colors.teal.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Get.toNamed('/create_booking_page');
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // View drivers card
                  _buildActionCard(
                    title: 'View Accepted Drivers',
                    description: 'Check the drivers who accepted your booking requests',
                    icon: LineAwesomeIcons.user_check_solid,
                    iconColor: Colors.blue,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade50,
                        Colors.cyan.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Get.toNamed('/accepted_drivers');
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Recent bookings section
                  const Text(
                    'Your Recent Bookings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'View and manage your recent trip requests',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Placeholder for recent bookings (empty state)
                  _buildEmptyBookingsState(),
                  
                  const SizedBox(height: 30),
                  
                  // Quick tips section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              LineAwesomeIcons.lightbulb,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Booking Tips',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildTipItem(
                          'Book in advance for better availability',
                          LineAwesomeIcons.calendar_check,
                        ),
                        _buildTipItem(
                          'Choose the right vehicle type for your needs',
                          LineAwesomeIcons.car_side_solid,
                        ),
                        _buildTipItem(
                          'Provide accurate pickup location details',
                          LineAwesomeIcons.map_marker_solid,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating action button for quick booking
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/create_booking_page');
        },
        backgroundColor: accentColor,
        icon: const Icon(LineAwesomeIcons.plus_solid),
        label: const Text(
          'New Booking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  
  // Helper method to build action cards
  Widget _buildActionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build booking tip items
  Widget _buildTipItem(String tip, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.teal.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Empty state for recent bookings
  Widget _buildEmptyBookingsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            LineAwesomeIcons.calendar_day_solid,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Recent Bookings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booking history will appear here once you create your first booking',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/create_booking_page');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Create Your First Booking',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}