// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/model/booking_model/booking_model.dart';
// import '../../controllers/create_booking_controller.dart';
// import '../../utils/app_colors.dart';

// class CreateBookingPage extends StatelessWidget {
//   final CreateBookingController controller = Get.put(CreateBookingController());

//   CreateBookingPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Define consistent colors
//     final Color primaryColor = AppColors.primary;
//     final Color secondaryColor = Colors.teal.shade50;
//     final Color accentColor = Colors.amber.shade600;
    
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'Create Booking',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: primaryColor,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
        
//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top banner
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Book Your Ride',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Fill in the details to confirm your booking',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 14,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Form container
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 10,
//                       offset: const Offset(0, 1),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Section title
//                     const Text(
//                       'Trip Details',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
                    
//                     // Pickup Location field with icon
//                     _buildTextField(
//                       label: 'Pickup Location',
//                       icon: Icons.location_on,
//                       onChanged: (value) => controller.pickupLocation.value = value,
//                       hintText: 'Enter your pickup location',
//                     ),
//                     const SizedBox(height: 20),
                    
//                     // Dropdown for destination locations
//                     _buildSectionTitle('Destination', Icons.pin_drop),
//                     const SizedBox(height: 10),
                    
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//                       child: controller.isLoadingLocations.value
//                           ? const Center(
//                               child: Padding(
//                                 padding: EdgeInsets.all(10.0),
//                                 child: CircularProgressIndicator(),
//                               ),
//                             )
//                           : DropdownButtonHideUnderline(
//                               child: DropdownButton<LocationModel>(
//                                 isExpanded: true,
//                                 hint: Text(
//                                   'Select Destination',
//                                   style: TextStyle(color: Colors.grey.shade600),
//                                 ),
//                                 value: controller.selectedLocation.value,
//                                 icon: const Icon(Icons.keyboard_arrow_down),
//                                 elevation: 16,
//                                 onChanged: (LocationModel? location) {
//                                   controller.setSelectedLocation(location);
//                                 },
//                                 items: controller.locations.map<DropdownMenuItem<LocationModel>>(
//                                   (LocationModel location) {
//                                     return DropdownMenuItem<LocationModel>(
//                                       value: location,
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             location.name,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                                             decoration: BoxDecoration(
//                                               color: Colors.green.shade50,
//                                               borderRadius: BorderRadius.circular(20),
//                                             ),
//                                             child: Text(
//                                               '₹${location.fare.toStringAsFixed(2)}',
//                                               style: TextStyle(
//                                                 color: Colors.green.shade700,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ).toList(),
//                               ),
//                             ),
//                     ),
//                     const SizedBox(height: 20),
                    
//                     // Date selection field
//                     _buildSectionTitle('Booking Date', Icons.calendar_today),
//                     const SizedBox(height: 10),
                    
//                     InkWell(
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.now(),
//                           lastDate: DateTime(2100),
//                           builder: (context, child) {
//                             return Theme(
//                               data: Theme.of(context).copyWith(
//                                 colorScheme: ColorScheme.light(
//                                   primary: primaryColor,
//                                 ),
//                               ),
//                               child: child!,
//                             );
//                           },
//                         );
//                         if (pickedDate != null) {
//                           // Format the date as desired (e.g. YYYY-MM-DD)
//                           String formattedDate =
//                               pickedDate.toLocal().toString().split(' ')[0];
//                           // Update the text field and bookingDate observable
//                           controller.dateController.text = formattedDate;
//                           controller.bookingDate.value = formattedDate;
//                         }
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.calendar_month,
//                               color: primaryColor,
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Obx(() => Text(
//                                 controller.bookingDate.value.isEmpty
//                                     ? 'Select Booking Date'
//                                     : controller.bookingDate.value,
//                                 style: TextStyle(
//                                   color: controller.bookingDate.value.isEmpty
//                                       ? Colors.grey.shade600
//                                       : Colors.black,
//                                   fontWeight: controller.bookingDate.value.isEmpty
//                                       ? FontWeight.normal
//                                       : FontWeight.w500,
//                                 ),
//                               )),
//                             ),
//                             Icon(
//                               Icons.arrow_drop_down,
//                               color: Colors.grey.shade600,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
              
//               // Selected location details card
//               if (controller.selectedLocation.value != null)
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [primaryColor, primaryColor.withOpacity(0.8)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_outlined,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                           const SizedBox(width: 8),
//                           const Text(
//                             'Trip Summary',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildSummaryItem(
//                         'From:',
//                         controller.pickupLocation.value.isEmpty
//                             ? 'Not specified'
//                             : controller.pickupLocation.value,
//                       ),
//                       const SizedBox(height: 8),
//                       _buildSummaryItem(
//                         'To:',
//                         controller.selectedLocation.value!.name,
//                       ),
//                       const SizedBox(height: 8),
//                       Obx(() => _buildSummaryItem(
//                         'Date:',
//                         controller.bookingDate.value.isEmpty
//                             ? 'Not selected'
//                             : controller.bookingDate.value,
//                       )),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Total Fare:',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: accentColor,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               '₹${controller.selectedLocation.value!.fare.toStringAsFixed(2)}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
              
//               // Book Now button
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 56,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Show confirmation dialog before creating booking
//                       _showConfirmationDialog(context, primaryColor);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: accentColor,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     child: const Text(
//                       'Book Now',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
  
//   // Helper method to build text fields
//   Widget _buildTextField({
//     required String label,
//     required IconData icon,
//     required Function(String) onChanged,
//     String hintText = '',
//     TextEditingController? controller,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle(label, icon),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: TextField(
//             controller: controller,
//             readOnly: readOnly,
//             onTap: onTap,
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(color: Colors.grey.shade500),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
  
//   // Helper method to build section titles
//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 18,
//           color: AppColors.primary,
//         ),
//         const SizedBox(width: 6),
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
  
//   // Helper method to build summary items
//   Widget _buildSummaryItem(String label, String value) {
//     return Row(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.9),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
  
//   // Confirmation dialog
//   void _showConfirmationDialog(BuildContext context, Color primaryColor) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text(
//             'Confirm Booking',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: const Text(
//             'Are you sure you want to create this booking?',
//             textAlign: TextAlign.center,
//           ),
//           actionsAlignment: MainAxisAlignment.center,
//           actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 controller.createBooking();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: const Text(
//                 'Confirm',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/model/booking_model/booking_model.dart';
import '../../controllers/create_booking_controller.dart';
import '../../utils/app_colors.dart';

class CreateBookingPage extends StatelessWidget {
  final CreateBookingController controller = Get.put(CreateBookingController());

  CreateBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define consistent colors
    final Color primaryColor = AppColors.primary;
    final Color secondaryColor = Colors.teal.shade50;
    final Color accentColor = Colors.amber.shade600;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Create Booking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Book Your Ride',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fill in the details to confirm your booking',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Form container
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    const Text(
                      'Trip Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Pickup Location field with icon
                    _buildTextField(
                      label: 'Pickup Location',
                      icon: Icons.location_on,
                      onChanged: (value) => controller.pickupLocation.value = value,
                      hintText: 'Enter your pickup location',
                    ),
                    const SizedBox(height: 20),
                    
                    // Dropdown for destination locations
                    _buildSectionTitle('Destination', Icons.pin_drop),
                    const SizedBox(height: 10),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: controller.isLoadingLocations.value
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : DropdownButtonHideUnderline(
                              child: DropdownButton<LocationModel>(
                                isExpanded: true,
                                hint: Text(
                                  'Select Destination',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                value: controller.selectedLocation.value,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                elevation: 16,
                                onChanged: (LocationModel? location) {
                                  controller.setSelectedLocation(location);
                                },
                                items: controller.locations.map<DropdownMenuItem<LocationModel>>(
                                  (LocationModel location) {
                                    return DropdownMenuItem<LocationModel>(
                                      value: location,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            location.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '₹${location.fare.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.green.shade700,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Date selection field
                    _buildSectionTitle('Booking Date', Icons.calendar_today),
                    const SizedBox(height: 10),
                    
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primaryColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          // Format the date as desired (e.g. YYYY-MM-DD)
                          String formattedDate =
                              pickedDate.toLocal().toString().split(' ')[0];
                          // Update the text field and bookingDate observable
                          controller.dateController.text = formattedDate;
                          controller.bookingDate.value = formattedDate;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Obx(() => Text(
                                controller.bookingDate.value.isEmpty
                                    ? 'Select Booking Date'
                                    : controller.bookingDate.value,
                                style: TextStyle(
                                  color: controller.bookingDate.value.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.black,
                                  fontWeight: controller.bookingDate.value.isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                                ),
                              )),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Time selection field
                    _buildSectionTitle('Booking Time', Icons.access_time),
                    const SizedBox(height: 10),
                    
                    InkWell(
                      onTap: () async {
                        // Use current time as default
                        final TimeOfDay initialTime = TimeOfDay.now();
                        
                        // Show time picker
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: controller.bookingTime.value.isNotEmpty
                              ? TimeOfDay(
                                  hour: int.parse(controller.bookingTime.value.split(':')[0]),
                                  minute: int.parse(controller.bookingTime.value.split(':')[1])
                                )
                              : initialTime,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primaryColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        
                        if (pickedTime != null) {
                          // Format the time as HH:MM
                          final formattedTime = 
                            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                          
                          // Update the booking time
                          controller.bookingTime.value = formattedTime;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Obx(() => Text(
                                controller.bookingTime.value.isEmpty
                                    ? 'Select Booking Time'
                                    : controller.bookingTime.value,
                                style: TextStyle(
                                  color: controller.bookingTime.value.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.black,
                                  fontWeight: controller.bookingTime.value.isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                                ),
                              )),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              
              // Selected location details card
              if (controller.selectedLocation.value != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Trip Summary',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryItem(
                        'From:',
                        controller.pickupLocation.value.isEmpty
                            ? 'Not specified'
                            : controller.pickupLocation.value,
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryItem(
                        'To:',
                        controller.selectedLocation.value!.name,
                      ),
                      const SizedBox(height: 8),
                      Obx(() => _buildSummaryItem(
                        'Date:',
                        controller.bookingDate.value.isEmpty
                            ? 'Not selected'
                            : controller.bookingDate.value,
                      )),
                      const SizedBox(height: 8),
                      Obx(() => _buildSummaryItem(
                        'Time:',
                        controller.bookingTime.value.isEmpty
                            ? 'Not selected'
                            : controller.bookingTime.value,
                      )),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Fare:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '₹${controller.selectedLocation.value!.fare.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
              // Book Now button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate that time is selected
                      if (controller.bookingTime.value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select booking time'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      // Show confirmation dialog before creating booking
                      _showConfirmationDialog(context, primaryColor);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  
  // Helper method to build text fields
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String hintText = '',
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label, icon),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
  
  // Helper method to build section titles
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
  
  // Helper method to build summary items
  Widget _buildSummaryItem(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  // Confirmation dialog
  void _showConfirmationDialog(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Confirm Booking',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to create this booking?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.createBooking();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ); 
      },
    );
  }
}