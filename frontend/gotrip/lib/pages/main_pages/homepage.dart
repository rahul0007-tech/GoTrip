import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/auth_controller.dart';
import 'package:gotrip/controllers/location_controller.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
import 'package:gotrip/controllers/passenger_upcoming_bookings_controller.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:gotrip/network/http_client.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatelessWidget {
  final PassengerProfileController profileController = Get.put(PassengerProfileController());
  final PassengerUpcomingBookingsController bookingsController = Get.put(PassengerUpcomingBookingsController());
  final LocationController locationController = Get.put(LocationController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.directions_car, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'GoTrip',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: AppColors.primary,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, color: AppColors.primary),
              onPressed: () {
                // Notification logic here
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: AppColors.primary),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
                value: 'settings',
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
                value: 'logout',
                onTap: () {
                  authController.logout();
                  Get.offAllNamed('/login');
                },
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => bookingsController.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section with greeting and profile
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final passenger = profileController.passenger.value;
                      return Row(
                        children: [
                          // Profile Photo with border
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: passenger?.photo != null
                                  ? CachedNetworkImage(
                                      imageUrl: passenger!.photo!,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => CircularProgressIndicator(
                                        color: AppColors.primary,
                                        strokeWidth: 2,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        'asset/images/profile_placeholder.png',
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      'asset/images/profile_placeholder.png',
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Welcome Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${passenger?.name ?? 'User'}!',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 30),

                    // Where do you want to go? headline
                    Text(
                      'Where do you want to go?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Quick action buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickActionButton(
                      icon: Icons.history,
                      label: 'History',
                      color: Colors.purple[700]!,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // Popular Destinations Section with stylish cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Destinations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              
              Obx(() {
                if (locationController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                if (locationController.error.value.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      locationController.error.value,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return Container(
                  height: 190,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: locationController.locations.length,
                    itemBuilder: (context, index) {
                      final location = locationController.locations[index];
                      return Container(
                        width: 160,
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Image with rounded corners
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                location.locationImage != null
                                    ? baseUrl + location.locationImage!
                                    : 'https://via.placeholder.com/160x190',
                                width: 160,
                                height: 190,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            // Content
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            location.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '\$${location.fare}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Favorite button
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.red[400],
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 15),
              
              SizedBox(height: 25),

              // Upcoming Bookings Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Bookings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => bookingsController.refresh(),
                      child: Text(
                        'Refresh',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              
              Obx(() {
                if (bookingsController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (bookingsController.hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          bookingsController.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => bookingsController.refresh(),
                          icon: Icon(Icons.refresh),
                          label: Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (bookingsController.bookings.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No upcoming bookings',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: bookingsController.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingsController.bookings[index];
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Icon(Icons.directions_car, color: AppColors.primary),
                            ),
                            title: Text(
                              booking.dropoffLocation.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'From: ${booking.pickupLocation}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Rs. ${booking.fare}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      'Driver: ${booking.driver?.name ?? 'Unknown'}',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.car_rental, size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${booking.driver?.vehicle?.vehicleCompany ?? 'Unknown'} - ${booking.driver?.vehicle?.vehicleColor ?? 'Unknown'}',
                                        style: TextStyle(color: Colors.grey[800]),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.numbers, size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      booking.driver?.vehicle?.vehicleNumber ?? 'Unknown',
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.event_seat, size: 18, color: Colors.grey[600]),
                                        SizedBox(width: 8),
                                        Text(
                                          '${booking.driver?.vehicle?.sittingCapacity ?? 'Unknown'} seats',
                                          style: TextStyle(color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.local_gas_station, size: 18, color: Colors.grey[600]),
                                        SizedBox(width: 8),
                                        Text(
                                          booking.driver?.vehicle?.vehicleFuelType?.displayName ?? 'Unknown',
                                          style: TextStyle(color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      booking.getFormattedDate(),
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      booking.getFormattedTime(),
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      // Floating action button for booking
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/create_booking_page');
        },
        label: Text('Book Now'),
        icon: Icon(Icons.directions_car),
        backgroundColor: AppColors.primary,
      ),
      // Removed bottomNavigationBar
    );
  }
  
  // Helper method to build quick action buttons
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
