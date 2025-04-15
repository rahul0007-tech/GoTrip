


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:dio/dio.dart'; // Import Dio for API calls
// import '../network/http_client.dart'; // Import your HTTP client
// import '../model/booking_model/booking_model.dart'; // Import your existing model 

// class BookingDetailsPage extends StatefulWidget {
//   final int locationId;
//   final String locationName;

//   const BookingDetailsPage({
//     Key? key, 
//     required this.locationId,
//     required this.locationName,
//   }) : super(key: key);

//   @override
//   State<BookingDetailsPage> createState() => _BookingDetailsPageState();
// }

// class _BookingDetailsPageState extends State<BookingDetailsPage> {
//   bool _isLoading = true;
//   List<BookingModel> _bookings = [];
//   String? _error;
//   Map<int, bool> _acceptedBookings = {}; // Track which bookings have been accepted

//   @override
//   void initState() {
//     super.initState();
//     _fetchBookings();
//   }

//   Future<void> _fetchBookings() async {
//     try {
//       // Using Dio for API calls
//       final response = await httpClient.get(
//         '/bookings/booking-by-location/',
//         data: {'location_id': widget.locationId},
//       );

//       if (response.statusCode == 200) {
//         final responseData = response.data;
        
//         if (responseData['status'] == 'success') {
//           final List<dynamic> bookingsJson = responseData['data'];
          
//           setState(() {
//             _bookings = bookingsJson.map((booking) {
//               // Manual parsing to handle potential type issues and null values
//               return BookingModel(
//                 id: booking['id'] != null ? int.parse(booking['id'].toString()) : 0,
//                 passenger: booking['passenger'] != null ? int.parse(booking['passenger'].toString()) : 0,
//                 pickupLocation: booking['pickup_location']?.toString() ?? '',
//                 dropoffLocation: booking['dropoff_location'] ?? '',
//                 fare: booking['fare']?.toString() ?? '0',
//                 bookingFor: booking['booking_for'] != null 
//                   ? DateTime.parse(booking['booking_for'].toString()) 
//                   : null,
//               );
//             }).toList();
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _error = responseData['message'] ?? 'Failed to load bookings';
//             _isLoading = false;
//           });
//         }
//       } else if (response.statusCode == 404) {
//         setState(() {
//           _error = 'No bookings found for this location';
//           _isLoading = false;
//         });
//       }
//     } on DioException catch (e) {
//       setState(() {
//         if (e.response != null) {
//           try {
//             final errorData = e.response!.data;
//             if (errorData is Map<String, dynamic> && errorData.containsKey('error')) {
//               _error = errorData['error'];
//             } else {
//               _error = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
//             }
//           } catch (_) {
//             _error = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
//           }
//         } else if (e.type == DioExceptionType.connectionTimeout ||
//                   e.type == DioExceptionType.receiveTimeout) {
//           _error = 'Connection timeout. Please check your internet connection.';
//         } else {
//           _error = 'Error: ${e.message}';
//         }
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Exception: ${e.toString()}';
//         _isLoading = false;
//       });
//     }
//   }

//   // New method to accept a booking
//   Future<void> _acceptBooking(int bookingId) async {
//     // Show loading indicator
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Call the accept booking API
//       final response = await httpClient.post(
//         '/bookings/accept-booking/',
//         data: {'booking_id': bookingId},
//       );

//       // Handle successful response
//       if (response.statusCode == 200) {
//         // Update local state to reflect the booking is now accepted
//         setState(() {
//           _acceptedBookings[bookingId] = true;
//           _isLoading = false;
//         });

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Booking accepted successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         // Handle other status codes
//         setState(() {
//           _isLoading = false;
//         });
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to accept booking'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } on DioException catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
      
//       // Extract error message from response if available
//       String errorMessage = 'Failed to accept booking';
//       if (e.response != null && e.response!.data is Map<String, dynamic>) {
//         final Map<String, dynamic> errorData = e.response!.data;
//         errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
//       }
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bookings for ${widget.locationName}'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : _error != null
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _error!,
//                           style: TextStyle(color: Colors.red),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _fetchBookings,
//                           child: Text('Retry'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.teal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : _bookings.isEmpty
//                     ? Center(
//                         child: Text(
//                           'No bookings available for this location',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: _bookings.length,
//                         itemBuilder: (context, index) {
//                           final booking = _bookings[index];
//                           // Check if this booking has been accepted
//                           final isAccepted = _acceptedBookings[booking.id] ?? false;
                          
//                           return Card(
//                             margin: EdgeInsets.only(bottom: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 3,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Booking #${booking.id}',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                       Chip(
//                                         label: Text(
//                                           'Pending',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         backgroundColor: Colors.orange,
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 12),
//                                   _buildInfoRow(
//                                     'Pickup:',
//                                     booking.pickupLocation,
//                                     Icons.location_on_outlined,
//                                   ),
//                                   SizedBox(height: 8),
//                                   _buildInfoRow(
//                                     'Dropoff:',
//                                     booking.dropoffLocationName,
//                                     Icons.location_on,
//                                   ),
//                                   SizedBox(height: 8),
//                                   _buildInfoRow(
//                                     'Date:',
//                                     booking.bookingFor != null 
//                                       ? DateFormat('MMM dd, yyyy').format(booking.bookingFor!)
//                                       : 'Not specified',
//                                     Icons.calendar_today,
//                                   ),
//                                   SizedBox(height: 8),
//                                   _buildInfoRow(
//                                     'Fare:',
//                                     '\$${booking.fare}',
//                                     Icons.attach_money,
//                                   ),
//                                   SizedBox(height: 16),
//                                   Center(
//                                     child: ElevatedButton(
//                                       onPressed: isAccepted 
//                                           ? null  // Disable button if already accepted
//                                           : () => _acceptBooking(booking.id),
//                                       child: Text(
//                                           isAccepted ? 'Booking Accepted' : 'Accept Booking'
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: isAccepted ? Colors.grey : Colors.teal,
//                                         minimumSize: Size(double.infinity, 45),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.teal, size: 20),
//         SizedBox(width: 8),
//         Text(
//           label,
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:dio/dio.dart'; // Import Dio for API calls
import '../network/http_client.dart'; // Import your HTTP client
import '../model/booking_model/booking_model.dart'; // Import your existing model 

class BookingDetailsPage extends StatefulWidget {
  final int locationId;
  final String locationName;

  const BookingDetailsPage({
    Key? key, 
    required this.locationId,
    required this.locationName,
  }) : super(key: key);

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  bool _isLoading = true;
  List<BookingModel> _bookings = [];
  String? _error;
  Map<int, bool> _acceptedBookings = {}; // Track which bookings have been accepted

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      // Using Dio for API calls
      final response = await httpClient.get(
        '/bookings/booking-by-location/',
        data: {'location_id': widget.locationId},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['status'] == 'success') {
          final List<dynamic> bookingsJson = responseData['data'];
          
          setState(() {
            _bookings = bookingsJson.map((booking) {
              // Manual parsing to handle potential type issues and null values
              return BookingModel(
                id: booking['id'] != null ? int.parse(booking['id'].toString()) : 0,
                passenger: booking['passenger'] != null ? int.parse(booking['passenger'].toString()) : 0,
                pickupLocation: booking['pickup_location']?.toString() ?? '',
                dropoffLocation: booking['dropoff_location']?.toString() ?? '',
                fare: booking['fare']?.toString() ?? '0',
                bookingFor: booking['booking_for'] != null 
                  ? DateTime.parse(booking['booking_for'].toString()) 
                  : null,
              );
            }).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = responseData['message'] ?? 'Failed to load bookings';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _error = 'No bookings found for this location';
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        if (e.response != null) {
          try {
            final errorData = e.response!.data;
            if (errorData is Map<String, dynamic> && errorData.containsKey('error')) {
              _error = errorData['error'];
            } else {
              _error = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
            }
          } catch (_) {
            _error = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout) {
          _error = 'Connection timeout. Please check your internet connection.';
        } else {
          _error = 'Error: ${e.message}';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Exception: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // New method to accept a booking
  Future<void> _acceptBooking(int bookingId) async {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the accept booking API
      final response = await httpClient.post(
        '/bookings/accept-booking/',
        data: {'booking_id': bookingId},
      );

      // Handle successful response
      if (response.statusCode == 200) {
        // Update local state to reflect the booking is now accepted
        setState(() {
          _acceptedBookings[bookingId] = true;
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking accepted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle other status codes
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept booking'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Extract error message from response if available
      String errorMessage = 'Failed to accept booking';
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final Map<String, dynamic> errorData = e.response!.data;
        errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings for ${widget.locationName}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchBookings,
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  )
                : _bookings.isEmpty
                    ? Center(
                        child: Text(
                          'No bookings available for this location',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          final booking = _bookings[index];
                          // Check if this booking has been accepted
                          final isAccepted = _acceptedBookings[booking.id] ?? false;
                          
                          return Card(
                            margin: EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Booking #${booking.id}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(
                                          'Pending',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  _buildInfoRow(
                                    'Pickup:',
                                    booking.pickupLocation,
                                    Icons.location_on_outlined,
                                  ),
                                  SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Date:',
                                    booking.bookingFor != null 
                                      ? DateFormat('MMM dd, yyyy').format(booking.bookingFor!)
                                      : 'Not specified',
                                    Icons.calendar_today,
                                  ),
                                  SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Fare:',
                                    '\$${booking.fare}',
                                    Icons.attach_money,
                                  ),
                                  SizedBox(height: 16),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: isAccepted 
                                          ? null  // Disable button if already accepted
                                          : () => _acceptBooking(booking.id),
                                      child: Text(
                                          isAccepted ? 'Booking Accepted' : 'Accept Booking'
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isAccepted ? Colors.grey : Colors.teal,
                                        minimumSize: Size(double.infinity, 45),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}