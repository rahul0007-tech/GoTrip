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








// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/auth_controller.dart';
// import 'package:gotrip/controllers/location_controller.dart';
// import 'package:gotrip/controllers/passenger_profile_controller.dart';
// import 'package:gotrip/controllers/passenger_home_page_controller.dart';
// import 'package:gotrip/model/booking_model/upcomming_booking.dart';
// import 'package:gotrip/utils/app_colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../constants/api_constants.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Add this for SVG support
// import 'package:shimmer/shimmer.dart'; // Add this for loading effects

// class HomePage extends StatelessWidget {
//   final PassengerProfileController profileController =
//       Get.put(PassengerProfileController());
//   final PassengerHomePageController bookingsController =
//       Get.put(PassengerHomePageController());
//   final LocationController locationController = Get.put(LocationController());

//   HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get.put(AuthController());
//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: RefreshIndicator(
//         color: AppColors.primary,
//         onRefresh: () => bookingsController.refreshData(),
//         child: CustomScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           slivers: [
//             // Custom App Bar with animated effects
//             SliverAppBar(
//               expandedHeight: 120,
//               floating: false,
//               pinned: true,
//               backgroundColor: AppColors.primary,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         AppColors.primary,
//                         AppColors.primary.withOpacity(0.8),
//                       ],
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 10),
//                           Obx(() {
//                             final passenger = profileController.passenger.value;
//                             return Row(
//                               children: [
//                                 // Profile Photo with animated border
//                                 GestureDetector(
//                                   onTap: () => Get.toNamed('/profile'),
//                                   child: Hero(
//                                     tag: 'profile-photo',
//                                     child: Container(
//                                       padding: EdgeInsets.all(3),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: Colors.white,
//                                           width: 2,
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(0.1),
//                                             blurRadius: 10,
//                                             spreadRadius: 1,
//                                           ),
//                                         ],
//                                       ),
//                                       child: ClipOval(
//                                         child: passenger?.photo != null
//                                             ? CachedNetworkImage(
//                                                 imageUrl: passenger!.photo!,
//                                                 width: 45,
//                                                 height: 45,
//                                                 fit: BoxFit.cover,
//                                                 placeholder: (context, url) =>
//                                                     CircularProgressIndicator(
//                                                   color: Colors.white,
//                                                   strokeWidth: 2,
//                                                 ),
//                                                 errorWidget: (context, url, error) =>
//                                                     Image.asset(
//                                                   'asset/images/profile_placeholder.png',
//                                                   width: 45,
//                                                   height: 45,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               )
//                                             : Image.asset(
//                                                 'asset/images/profile_placeholder.png',
//                                                 width: 45,
//                                                 height: 45,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 15),
//                                 // Welcome Text with animation
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Welcome back,',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.white.withOpacity(0.9),
//                                         ),
//                                       ),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         '${passenger?.name ?? 'User'}!',
//                                         style: const TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Notification Bell with badge
//                                 Container(
//                                   margin: EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.notifications_outlined, 
//                                                  color: Colors.white),
//                                         onPressed: () {
//                                           // Notification logic here
//                                         },
//                                       ),
//                                       Positioned(
//                                         right: 8,
//                                         top: 8,
//                                         child: Container(
//                                           padding: EdgeInsets.all(4),
//                                           decoration: BoxDecoration(
//                                             color: Colors.redAccent,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           constraints: BoxConstraints(
//                                             minWidth: 12,
//                                             minHeight: 12,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Menu
//                                 PopupMenuButton(
//                                   icon: Icon(Icons.more_vert, color: Colors.white),
//                                   elevation: 8,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   itemBuilder: (context) => [
//                                     PopupMenuItem(
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.settings, 
//                                                size: 20, 
//                                                color: AppColors.primary),
//                                           SizedBox(width: 12),
//                                           Text('Settings',
//                                               style: TextStyle(fontWeight: FontWeight.w500)),
//                                         ],
//                                       ),
//                                       value: 'settings',
//                                     ),
//                                     PopupMenuItem(
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.logout, 
//                                                size: 20, 
//                                                color: Colors.redAccent),
//                                           SizedBox(width: 12),
//                                           Text('Logout',
//                                               style: TextStyle(fontWeight: FontWeight.w500)),
//                                         ],
//                                       ),
//                                       value: 'logout',
//                                       onTap: () {
//                                         authController.logout();
//                                         Get.offAllNamed('/login');
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Main Content
//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Search and Destination Section
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 15,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         // Search field with animation
//                         Padding(
//                           padding: EdgeInsets.all(16),
//                           child: InkWell(
//                             onTap: () {
//                               Get.toNamed('/create_booking_page');
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[100],
//                                 borderRadius: BorderRadius.circular(30),
//                                 border: Border.all(
//                                   color: Colors.grey[300]!,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.search,
//                                     color: AppColors.primary,
//                                   ),
//                                   SizedBox(width: 12),
//                                   Text(
//                                     'Where do you want to go?',
//                                     style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
                        
//                         // Quick booking options
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               _buildQuickActionButton(
//                                 icon: Icons.home_outlined,
//                                 label: 'Home',
//                                 color: Colors.blue[700]!,
//                                 onTap: () {},
//                               ),
//                               _buildQuickActionButton(
//                                 icon: Icons.work_outline_rounded,
//                                 label: 'Work',
//                                 color: Colors.orange[700]!,
//                                 onTap: () {},
//                               ),
//                               _buildQuickActionButton(
//                                 icon: Icons.star_border_rounded,
//                                 label: 'Saved',
//                                 color: Colors.amber[700]!,
//                                 onTap: () {},
//                               ),
//                               _buildQuickActionButton(
//                                 icon: Icons.history,
//                                 label: 'History',
//                                 color: Colors.purple[700]!,
//                                 onTap: () {},
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Service Types with better visuals
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Book Your Ride',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildServiceTypeCard(
//                                 icon: Icons.directions_car,
//                                 title: 'Standard',
//                                 description: 'Comfortable rides',
//                                 price: '₹149',
//                                 isPopular: false,
//                               ),
//                             ),
//                             SizedBox(width: 15),
//                             Expanded(
//                               child: _buildServiceTypeCard(
//                                 icon: Icons.airline_seat_recline_extra,
//                                 title: 'Premium',
//                                 description: 'Luxury travels',
//                                 price: '₹349',
//                                 isPopular: true,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: 25),

//                   // Popular Destinations with enhanced cards
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Popular Destinations',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text(
//                             'View All',
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 12),

//                   Obx(() {
//                     if (locationController.isLoading.value) {
//                       return _buildDestinationsShimmer();
//                     }
//                     if (locationController.error.value.isNotEmpty) {
//                       return _buildErrorWidget(
//                         errorMessage: locationController.error.value,
//                         onRetry: () => locationController.fetchLocations(),
//                       );
//                     }
//                     return Container(
//                       height: 200,
//                       child: ListView.builder(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         scrollDirection: Axis.horizontal,
//                         itemCount: locationController.locations.length,
//                         itemBuilder: (context, index) {
//                           final location = locationController.locations[index];
//                           return Container(
//                             width: 180,
//                             margin: EdgeInsets.only(right: 15),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   spreadRadius: 1,
//                                   blurRadius: 12,
//                                   offset: Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(20),
//                               child: Stack(
//                                 children: [
//                                   // Background image with gradient
//                                   Hero(
//                                     tag: 'location-${location.id}',
//                                     child: CachedNetworkImage(
//                                       imageUrl: location.locationImage != null 
//                                           ? '${ApiConstants.baseUrl}${location.locationImage}'
//                                           : 'asset/images/destination1.jpg',
//                                       width: 180,
//                                       height: 200,
//                                       fit: BoxFit.cover,
//                                       placeholder: (context, url) => Container(
//                                         color: Colors.grey[200],
//                                         child: Center(
//                                           child: CircularProgressIndicator(
//                                             valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//                                           ),
//                                         ),
//                                       ),
//                                       errorWidget: (context, url, error) => Image.asset(
//                                         'asset/images/destination1.jpg',
//                                         width: 180,
//                                         height: 200,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   // Gradient overlay 
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter,
//                                         colors: [
//                                           Colors.transparent,
//                                           Colors.black.withOpacity(0.8),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   // Bottom content
//                                   Positioned(
//                                     bottom: 0,
//                                     left: 0,
//                                     right: 0,
//                                     child: Container(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             location.name,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                             ),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           SizedBox(height: 5),
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.star,
//                                                     color: Colors.amber,
//                                                     size: 14,
//                                                   ),
//                                                   SizedBox(width: 4),
//                                                   Text(
//                                                     '4.8',
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: 10,
//                                                   vertical: 5,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: AppColors.primary,
//                                                   borderRadius: BorderRadius.circular(12),
//                                                 ),
//                                                 child: Text(
//                                                   '₹${location.fare}',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   // Top right bookmark button 
//                                   Positioned(
//                                     top: 10,
//                                     right: 10,
//                                     child: Container(
//                                       padding: EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.9),
//                                         shape: BoxShape.circle,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(0.1),
//                                             blurRadius: 8,
//                                             spreadRadius: 1,
//                                           ),
//                                         ],
//                                       ),
//                                       child: Icon(
//                                         Icons.favorite_border,
//                                         color: Colors.red[400],
//                                         size: 18,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }),

//                   SizedBox(height: 30),

//                   // Upcoming Bookings Section with enhanced cards
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Upcoming Trips',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextButton.icon(
//                           onPressed: () => bookingsController.refreshData(),
//                           icon: Icon(
//                             Icons.refresh,
//                             size: 16,
//                             color: AppColors.primary,
//                           ),
//                           label: Text(
//                             'Refresh',
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 15),

//                   Obx(() {
//                     if (bookingsController.isBookingsLoading.value) {
//                       return _buildBookingsShimmer();
//                     }

//                     if (bookingsController.hasBookingsError.value) {
//                       return _buildErrorWidget(
//                         errorMessage: bookingsController.bookingsErrorMessage.value,
//                         onRetry: () => bookingsController.refreshData(),
//                       );
//                     }

//                     if (bookingsController.upcomingBookings.isEmpty) {
//                       return _buildEmptyStateWidget();
//                     }

//                     // Display the actual bookings
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       itemCount: bookingsController.upcomingBookings.length,
//                       itemBuilder: (context, index) {
//                         final booking = bookingsController.upcomingBookings[index];
//                         return buildBookingCard(booking);
//                       },
//                     );
//                   }),

//                   SizedBox(height: 100), // Extra space at bottom for FAB
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       // Enhanced Floating action button
//       floatingActionButton: Container(
//         height: 60,
//         width: 180,
//         margin: EdgeInsets.only(bottom: 15),
//         child: FloatingActionButton.extended(
//           onPressed: () {
//             Get.toNamed('/create_booking_page');
//           },
//           label: Text(
//             'Book Now',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           icon: Icon(Icons.directions_car),
//           backgroundColor: AppColors.primary,
//           elevation: 8,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   // Helper method to build quick action buttons with enhanced UI
//   Widget _buildQuickActionButton({
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
//             padding: EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: color.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 22,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[800],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to build service type cards
//   Widget _buildServiceTypeCard({
//     required IconData icon,
//     required String title,
//     required String description,
//     required String price,
//     required bool isPopular,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 1,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(
//           color: isPopular ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
//           width: isPopular ? 2 : 0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: isPopular
//                       ? AppColors.primary.withOpacity(0.1)
//                       : Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: isPopular ? AppColors.primary : Colors.grey[700],
//                   size: 22,
//                 ),
//               ),
//               if (isPopular)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     'Popular',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             description,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'From $price',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: isPopular ? AppColors.primary : Colors.black87,
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward,
//                 size: 16,
//                 color: isPopular ? AppColors.primary : Colors.grey[700],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Enhanced booking card with better visuals
//   Widget buildBookingCard(UpcomingBooking booking) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 15,
//             spreadRadius: 1,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Trip status bar at the top
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.05),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 12,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'Confirmed',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '₹${booking.fare}',
//                     style: TextStyle(
//                       color: Colors.green[700],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Main content
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Booking ID and time
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Booking #${booking.id}',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
//                         const SizedBox(width: 4),
//                         Text(
//                           booking.getFormattedTime(),
//                           style: TextStyle(
//                             color: Colors.grey[800],
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
                
//                 SizedBox(height: 20),
                
//                 // Route visualization
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blue.withOpacity(0.3),
//                                 blurRadius: 5,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: 2,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                           ),
//                         ),
//                         Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.red.withOpacity(0.3),
//                                 blurRadius: 5,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'From',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                           SizedBox(height: 2),
//                           Text(
//                             booking.pickupLocation,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 24),
//                           Text(
//                             'To',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                           SizedBox(height: 2),
//                           Text(
//                             booking.dropoffLocation.name,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 Divider(height: 30, color: Colors.grey[200], thickness: 1),
                
//                 // Driver and Vehicle Info with better layout
//                 if (booking.driver != null) ...[
//                   Row(
//                     children: [
//                       // Driver photo
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: AppColors.primary.withOpacity(0.3),
//                             width: 2,
//                           ),
//                         ),
//                         // child: ClipOval(
//                         //   child: booking.driver?.photo != null
//                         //       ? CachedNetworkImage(
//                         //           imageUrl: booking.driver!.photo!,
//                         //           width: 50,
//                         //           height: 50,
//                         //           fit: BoxFit.cover,
//                         //           placeholder: (context, url) => Center(
//                         //             child: CircularProgressIndicator(
//                         //               color: AppColors.primary,
//                         //               strokeWidth: 2,
//                         //             ),
//                         //           ),
//                         //           errorWidget: (context, url, error) => Image.asset(
//                         //             'asset/images/profile_placeholder.png',
//                         //             width: 50,
//                         //             height: 50,
//                         //             fit: BoxFit.cover,
//                         //           ),
//                         //         )
//                         //       : Image.asset(
//                         //           'asset/images/profile_placeholder.png',
//                         //           width: 50,
//                         //           height: 50,
//                         //           fit: BoxFit.cover,
//                         //         ),
//                         // ),
//                       ),
//                       SizedBox(width: 16),
//                       // Driver details
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               booking.driver!.name,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.star,
//                                   color: Colors.amber,
//                                   size: 14,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Text(
//                                   '4.8',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   '• Professional Driver',
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Call button
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.phone_outlined,
//                             color: Colors.green[700],
//                             size: 20,
//                           ),
//                           onPressed: () {
//                             // Call driver logic
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   SizedBox(height: 16),
                  
//                   // Vehicle details with icons
//                   if (booking.driver?.vehicle != null) ...[
//                     Container(
//                       padding: EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.grey[200]!,
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.directions_car,
//                             size: 20,
//                             color: AppColors.primary,
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${booking.driver!.vehicle!.vehicleCompany} - ${booking.driver!.vehicle!.vehicleColor}',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   'License: ${booking.driver!.vehicle!.vehicleNumber}',
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                    
//                     // Vehicle images with better layout
//                     if (booking.driver?.vehicle?.images != null &&
//                         booking.driver!.vehicle!.images!.isNotEmpty) ...[
//                       SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Text(
//                             'Vehicle Photos',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           Icon(
//                             Icons.verified,
//                             size: 14,
//                             color: Colors.green,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       SizedBox(
//                         height: 70,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: booking.driver!.vehicle!.images!.length > 3
//                               ? 3
//                               : booking.driver!.vehicle!.images!.length,
//                           itemBuilder: (context, imageIndex) {
//                             return Container(
//                               width: 70,
//                               height: 70,
//                               margin: EdgeInsets.only(right: 8),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: Colors.grey[200]!,
//                                   width: 1,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.05),
//                                     blurRadius: 5,
//                                     spreadRadius: 1,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: CachedNetworkImage(
//                                   imageUrl: _getFullImageUrl(booking.driver!
//                                       .vehicle!.images![imageIndex].image),
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) => Container(
//                                     color: Colors.grey[200],
//                                     child: Center(
//                                       child: SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color: AppColors.primary,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   errorWidget: (context, url, error) {
//                                     return Container(
//                                       color: Colors.grey[300],
//                                       child: Icon(
//                                         Icons.broken_image,
//                                         color: Colors.grey[600],
//                                         size: 20,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       if (booking.driver!.vehicle!.images!.length > 3)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             "+ ${booking.driver!.vehicle!.images!.length - 3} more photos",
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ],
//                 ],
                
//                 Divider(height: 30, color: Colors.grey[200], thickness: 1),
                
//                 // Trip date and time with better layout
//                 Row(
//                   children: [
//                     // Date container
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[50],
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: Colors.grey[200]!,
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(
//                                 Icons.calendar_today,
//                                 size: 16,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Date',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                                 Text(
//                                   booking.getFormattedDate(),
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     // Time container
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[50],
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: Colors.grey[200]!,
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(
//                                 Icons.access_time,
//                                 size: 16,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Time',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                                 Text(
//                                   booking.getFormattedTime(),
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
          
//           // Bottom action buttons
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // View details logic
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: AppColors.primary,
//                       elevation: 0,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(
//                           color: AppColors.primary,
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                     child: Text(
//                       'View Details',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Track ride logic
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       'Track Ride',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
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

//   // Helper method for destinations shimmer loading effect
//   Widget _buildDestinationsShimmer() {
//     return Container(
//       height: 200,
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: ListView.builder(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           scrollDirection: Axis.horizontal,
//           itemCount: 3,
//           itemBuilder: (_, __) => Container(
//             width: 180,
//             margin: EdgeInsets.only(right: 15),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method for bookings shimmer loading effect
//   Widget _buildBookingsShimmer() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: 2,
//           itemBuilder: (_, __) => Container(
//             height: 200,
//             margin: EdgeInsets.only(bottom: 16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method for empty state
//   Widget _buildEmptyStateWidget() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       padding: EdgeInsets.all(30),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           SizedBox(
//             width: 120,
//             height: 120,
//             child: Image.asset(
//               'asset/images/empty_bookings.png',
//               // If you don't have this asset, replace with:
//               // child: Icon(
//               //   Icons.calendar_today_outlined,
//               //   size: 80,
//               //   color: Colors.grey[300],
//               // ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'No Upcoming Trips',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Book your first ride and it will appear here.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () {
//               Get.toNamed('/create_booking_page');
//             },
//             icon: Icon(Icons.directions_car),
//             label: Text('Book Now'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method for error state
//   Widget _buildErrorWidget({
//     required String errorMessage,
//     required VoidCallback onRetry,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 50,
//             color: Colors.red[300],
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Oops! Something went wrong',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.grey[700],
//               fontSize: 14,
//             ),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: onRetry,
//             icon: Icon(Icons.refresh),
//             label: Text('Try Again'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getFullImageUrl(String imagePath) {
//     // If it's already a full URL starting with http:// or https://, return as is
//     if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
//       return imagePath;
//     }

//     // If it starts with a slash, ensure we don't get double slashes
//     String path = imagePath;
//     if (path.startsWith('/')) {
//       path = path.substring(1);
//     }

//     // Use the ApiConstants.baseUrl to create the full URL
//     return '${ApiConstants.baseUrl}/$path';
//   }
// }

