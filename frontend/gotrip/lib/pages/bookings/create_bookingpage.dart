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
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Booking'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Pickup Location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                onChanged: (value) => controller.pickupLocation.value = value,
              ),
              SizedBox(height: 16),
              
              // Dropdown for locations
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: controller.isLoadingLocations.value
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<LocationModel>(
                          isExpanded: true,
                          hint: Text('Select Destination'),
                          value: controller.selectedLocation.value,
                          icon: Icon(Icons.arrow_drop_down),
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
                                    Text(location.name),
                                    Text(
                                      '₹${location.fare.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
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
              
              SizedBox(height: 16),
              TextField(
                controller: controller.dateController,
                decoration: InputDecoration(
                  labelText: 'Booking Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
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
              ),
              
              // Show selected location details
              if (controller.selectedLocation.value != null)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Destination',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Location: ${controller.selectedLocation.value!.name}'),
                          Text(
                            'Fare: ₹${controller.selectedLocation.value!.fare.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.createBooking,
                  child: Text(
                    'Create Booking',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}


