import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/auth_controller.dart';
import 'package:gotrip/controllers/location_controller.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
import 'package:gotrip/controllers/passenger_home_page_controller.dart';
import 'package:gotrip/model/booking_model/upcomming_booking.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/api_constants.dart'; // Add this import

class HomePage extends StatelessWidget {
  final PassengerProfileController profileController =
      Get.put(PassengerProfileController());
  final PassengerHomePageController bookingsController =
      Get.put(PassengerHomePageController());
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
              icon:
                  Icon(Icons.notifications_outlined, color: AppColors.primary),
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
        onRefresh: () => bookingsController.refreshData(),
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
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        color: AppColors.primary,
                                        strokeWidth: 2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
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
                              child: CachedNetworkImage(
                                imageUrl: location.locationImage != null 
                                    ? '${ApiConstants.baseUrl}${location.locationImage}'
                                    : 'asset/images/destination1.jpg',
                                width: 160,
                                height: 190,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'asset/images/destination1.jpg',
                                  width: 160,
                                  height: 190,
                                  fit: BoxFit.cover,
                                ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                      onPressed: () => bookingsController.refreshData(),
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
                if (bookingsController.isBookingsLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (bookingsController.hasBookingsError.value) {
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
                          bookingsController.bookingsErrorMessage.value,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => bookingsController.refreshData(),
                          icon: Icon(Icons.refresh),
                          label: Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (bookingsController.upcomingBookings.isEmpty) {
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

                // Display the actual bookings
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: bookingsController.upcomingBookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingsController.upcomingBookings[index];
                    return buildBookingCard(booking);
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

  Widget buildBookingCard(UpcomingBooking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking #${booking.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (booking.driver != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Driver: ${booking.driver!.name}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${booking.fare}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From: ${booking.pickupLocation}',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'To: ${booking.dropoffLocation.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (booking.driver?.vehicle != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.directions_car, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${booking.driver!.vehicle!.vehicleCompany} - ${booking.driver!.vehicle!.vehicleColor}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Number: ${booking.driver!.vehicle!.vehicleNumber}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),

            /// Replace your current single image implementation with this:
            if (booking.driver?.vehicle?.images != null &&
                booking.driver!.vehicle!.images!.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: booking.driver!.vehicle!.images!.length > 3
                            ? 3
                            : booking.driver!.vehicle!.images!.length,
                        itemBuilder: (context, imageIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: _getFullImageUrl(booking.driver!
                                    .vehicle!.images![imageIndex].image),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[600],
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (booking.driver!.vehicle!.images!.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: Opacity(
                                  opacity: 0.5,
                                  child: CachedNetworkImage(
                                    imageUrl: _getFullImageUrl(booking
                                        .driver!.vehicle!.images![3].image),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "+${booking.driver!.vehicle!.images!.length - 3}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      booking.getFormattedDate(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      booking.getFormattedTime(),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFullImageUrl(String imagePath) {
    // If it's already a full URL starting with http:// or https://, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // If it starts with a slash, ensure we don't get double slashes
    String path = imagePath;
    if (path.startsWith('/')) {
      path = path.substring(1);
    }

    // Use the ApiConstants.baseUrl to create the full URL
    return '${ApiConstants.baseUrl}/$path';
  }
}
