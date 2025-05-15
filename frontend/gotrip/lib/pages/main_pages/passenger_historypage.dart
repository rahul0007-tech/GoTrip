import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/history_controller.dart';
import 'package:gotrip/model/booking_model/passenger_upcoming_booking.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  final controller = Get.find<HistoryController>();
  
  // Format for displaying currency
  final currencyFormat = NumberFormat.currency(
    symbol: 'Rs ',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Your Trip History',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshBookingHistory(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading your trips...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[300],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshBookingHistory(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        // Only show past bookings
        final pastBookings = controller.getPastBookings();
        
        if (pastBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/no_trips.png', // Add this image to your assets
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                    Icon(
                      Icons.directions_car_outlined, 
                      size: 100,
                      color: Colors.grey[400],
                    ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No trip history yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Your completed trips will appear here',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        
        return _buildBookingListWidget(pastBookings);
      }),
    );
  }
  
  Widget _buildBookingListWidget(List<PassengerUpcomingBooking> bookings) {
    // Group bookings by month for better organization
    final groupedBookings = <String, List<PassengerUpcomingBooking>>{};
    
    for (var booking in bookings) {
      try {
        final date = DateTime.parse(booking.bookingFor);
        final monthKey = DateFormat('MMMM yyyy').format(date);
        
        if (!groupedBookings.containsKey(monthKey)) {
          groupedBookings[monthKey] = [];
        }
        
        groupedBookings[monthKey]!.add(booking);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    
    // Sort the keys (months) in reverse chronological order
    final sortedMonths = groupedBookings.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a);
        final dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA);
      });
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      itemCount: sortedMonths.length,
      itemBuilder: (context, monthIndex) {
        final month = sortedMonths[monthIndex];
        final monthBookings = groupedBookings[month]!;
        
        // Sort bookings within each month in reverse chronological order
        monthBookings.sort((a, b) {
          final dateA = DateTime.parse(a.bookingFor);
          final dateB = DateTime.parse(b.bookingFor);
          return dateB.compareTo(dateA);
        });
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                month,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: monthBookings.length,
              itemBuilder: (context, index) => _buildTripCard(monthBookings[index]),
            ),
            if (monthIndex < sortedMonths.length - 1)
              const Divider(height: 32, thickness: 1),
          ],
        );
      },
    );
  }
  
  Widget _buildTripCard(PassengerUpcomingBooking booking) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showTripDetails(booking),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip header with date and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        booking.getFormattedDate(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Rs ${booking.fare}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Trip route visualization
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.green,
                      ),
                      Container(
                        width: 1.5,
                        height: 30,
                        color: Colors.grey[400],
                      ),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.red[700],
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.pickupLocation,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          booking.dropoffLocation.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Driver and trip status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Driver info (if available)
                  if (booking.driver != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          booking.driver!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  
                  // Trip status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(booking.status).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getStatusText(booking.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'failed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
  
  String _getStatusText(String status) {
    // Capitalize first letter and make rest lowercase
    if (status.isEmpty) return 'Pending';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
  
  void _showTripDetails(PassengerUpcomingBooking booking) {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom sheet header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trip Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              
              // Trip Details
              const SizedBox(height: 16),
              
              // Trip ID and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    'Trip ID',
                    '#${booking.id}',
                    Icons.confirmation_number_outlined,
                  ),
                  _buildDetailItem(
                    'Date',
                    booking.getFormattedDate(),
                    Icons.calendar_today,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Time and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    'Time',
                    booking.getFormattedTime(),
                    Icons.access_time,
                  ),
                  _buildDetailItem(
                    'Status',
                    _getStatusText(booking.status),
                    Icons.info_outline,
                    valueColor: _getStatusColor(booking.status),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Fare and Payment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    'Fare',
                    'Rs ${booking.fare}',
                    Icons.attach_money,
                    valueColor: Colors.green[700],
                    valueBold: true,
                  ),
                  _buildDetailItem(
                    'Payment',
                    _getStatusText(booking.paymentStatus),
                    Icons.payment,
                    valueColor: _getStatusColor(booking.paymentStatus),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              
              // Trip route
              const Text(
                'Trip Route',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Pickup
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 14,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.pickupLocation,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Route line
              Padding(
                padding: const EdgeInsets.only(left: 21),
                child: Container(
                  height: 30,
                  width: 2,
                  color: Colors.grey[300],
                ),
              ),
              
              // Destination
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Destination',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.dropoffLocation.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (booking.driver != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                
                // Driver details
                const Text(
                  'Driver Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.driver!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (booking.driver!.vehicle != null)
                          Text(
                            'Vehicle: ${booking.driver!.vehicle!.vehicleCompany} (${booking.driver!.vehicle!.vehicleColor})',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        if (booking.driver!.vehicle != null)
                          Text(
                            'Number: ${booking.driver!.vehicle!.vehicleNumber}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                // Vehicle details
                if (booking.driver!.vehicle != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildVehicleDetailItem(
                        'Type',
                        booking.driver!.vehicle!.vehicleType.displayName,
                        Icons.category,
                      ),
                      const SizedBox(width: 16),
                      _buildVehicleDetailItem(
                        'Fuel',
                        booking.driver!.vehicle!.vehicleFuelType.displayName,
                        Icons.local_gas_station,
                      ),
                      const SizedBox(width: 16),
                      _buildVehicleDetailItem(
                        'Seats',
                        '${booking.driver!.vehicle!.sittingCapacity}',
                        Icons.event_seat,
                      ),
                    ],
                  ),
                  
                  // Vehicle images
                  if (booking.driver!.vehicle!.images.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Vehicle Images',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: booking.driver!.vehicle!.images.length,
                        itemBuilder: (context, index) {
                          final image = booking.driver!.vehicle!.images[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image.image,
                                width: 150,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 150,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.grey,
                                      ),
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
                ],
              ],
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
  
  Widget _buildVehicleDetailItem(
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.blue[700],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}