import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';
import '../../controllers/driver_home_page_controller.dart';
import '../driver_status_card.dart';
import '../bookings/driver_upcoming_booking.dart';

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
              
              // Upcoming Rides - Using the extracted widget
              buildUpcomingRides(controller),
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
                onTap: () async {
                  try {
                    await controller.fetchDriverHistory();
                    Get.toNamed('/driver-history');
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to fetch trip history',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[900],
                    );
                  }
                },
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
        children: [Container(
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
          // const SizedBox(height: 16),
          // const SizedBox(height: 16),
          
          // Vehicle Images Section
          Container(
            width: double.infinity,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Vehicle Images',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.fetchVehicleImages(),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.isVehicleImagesLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.hasVehicleImagesError.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          controller.vehicleImagesErrorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  }

                  if (controller.vehicleImages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No vehicle images available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.vehicleImages.length,
                      itemBuilder: (context, index) {
                        final imageData = controller.vehicleImages[index];
                        return Container(
                          width: 160,
                          margin: EdgeInsets.only(right: index < controller.vehicleImages.length - 1 ? 12 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage('http://10.0.2.2:8000${imageData['image_url']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
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
}