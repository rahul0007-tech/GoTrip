import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/auth_controller.dart';
import 'package:gotrip/controllers/location_controller.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
import 'package:gotrip/controllers/passenger_home_page_controller.dart';
import 'package:gotrip/model/booking_model/upcomming_booking.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/api_constants.dart';

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

              // Popular Destinations Section with improved UI
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Popular Destinations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.explore, size: 16, color: AppColors.primary),
                      label: Text(
                        'Explore',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // Improved Popular Destinations List
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
                  height: 210,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: locationController.locations.length,
                    itemBuilder: (context, index) {
                      final location = locationController.locations[index];
                      return Container(
                        width: 180,
                        margin: EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 12,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Image with rounded corners
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: CachedNetworkImage(
                                imageUrl: location.locationImage != null 
                                    ? '${ApiConstants.baseUrl}${location.locationImage}'
                                    : 'asset/images/destination1.jpg',
                                width: 180,
                                height: 210,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'asset/images/destination1.jpg',
                                  width: 180,
                                  height: 210,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Gradient overlay with improved gradient
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.8),
                                  ],
                                  stops: [0.5, 0.75, 1.0],
                                ),
                              ),
                            ),
                            // Content
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
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
                                    SizedBox(height: 8),
                                    Text(
                                      location.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '4.8',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '(120+)',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Favorite button with improved UI
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.red[400],
                                  size: 16,
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

              SizedBox(height: 30),

              // Upcoming Bookings Section with improved UI
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upcoming Bookings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => bookingsController.refreshData(),
                      icon: Icon(Icons.refresh, size: 16, color: AppColors.primary),
                      label: Text(
                        'Refresh',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // Improved Upcoming Bookings List
              Obx(() {
                if (bookingsController.isBookingsLoading.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                if (bookingsController.hasBookingsError.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
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
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => bookingsController.refreshData(),
                            icon: Icon(Icons.refresh),
                            label: Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (bookingsController.upcomingBookings.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No upcoming bookings',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Book a trip to start your journey',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed('/create_booking_page');
                            },
                            icon: Icon(Icons.add),
                            label: Text('Book Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Display the improved bookings
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: bookingsController.upcomingBookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingsController.upcomingBookings[index];
                    return buildImprovedBookingCard(booking);
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
    );
  }

  // Helper method to build quick action buttons
Widget _buildQuickActionButton({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return GestureDetector(
    onTap: () {
      if (label == 'History') {
        Get.toNamed('/trip_history');
      }
    },
    child: Column(
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
    ),
  );
}

  // Improved booking card with status change button
  Widget buildImprovedBookingCard(UpcomingBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with booking info and status badge
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking #${booking.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          booking.getFormattedDate(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          booking.getFormattedTime(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '₹${booking.fare}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route information with improved design
                Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.green[600],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey[400],
                        ),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.red[600],
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.pickupLocation,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 18),
                          Text(
                            booking.dropoffLocation.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),

                // Driver details with avatar (if available)
                if (booking.driver != null)
                  Row(
                    children: [
                      // Driver avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        // child: ClipOval(
                        //   child: booking.driver?.photo != null
                        //       ? CachedNetworkImage(
                        //           imageUrl: booking.driver!.photo!,
                        //           fit: BoxFit.cover,
                        //           placeholder: (context, url) => Center(
                        //             child: CircularProgressIndicator(
                        //               strokeWidth: 2,
                        //               color: AppColors.primary,
                        //             ),
                        //           ),
                        //           errorWidget: (context, url, error) => Icon(
                        //             Icons.person,
                        //             color: Colors.grey[400],
                        //             size: 30,
                        //           ),
                        //         )
                        //       : Icon(
                        //           Icons.person,
                        //           color: Colors.grey[400],
                        //           size: 30,
                        //         ),
                        // ),
                      ),
                      SizedBox(width: 12),
                      // Driver information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.driver!.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            if (booking.driver!.vehicle != null)
                              Text(
                                '${booking.driver!.vehicle!.vehicleCompany} ${booking.driver!.vehicle!.vehicleColor} • ${booking.driver!.vehicle!.vehicleNumber}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 4),  // This adds a small vertical space
                              Text(
                                'Type: ${booking.driver!.vehicle!.vehicleType?.displayName ?? 'N/A'} • Fuel: ${booking.driver!.vehicle!.vehicleFuelType?.displayName ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Driver rating
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                // Vehicle Images (if available)
                if (booking.driver?.vehicle?.images != null &&
                    booking.driver!.vehicle!.images!.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(
                    'Vehicle Images',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: booking.driver!.vehicle!.images!.length > 4
                          ? 4
                          : booking.driver!.vehicle!.images!.length,
                      itemBuilder: (context, imageIndex) {
                        return Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            
                  borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: _getFullImageUrl(booking.driver!
                                  .vehicle!.images![imageIndex].image),
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[200],
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) {
                                return Container(
                                  width: 70,
                                  height: 70,
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
                ],

                SizedBox(height: 20),
                
                // Status change button (new addition)
                ElevatedButton.icon(
                  onPressed: () {
                    // Will call API later as requested
                    print('Change status button pressed for booking ${booking.id}');
                  },
                  icon: Icon(Icons.update),
                  label: Text('Change Booking Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
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
