import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/user_model/driver_model.dart';
import '../../utils/app_colors.dart';

// Import the adapter
import 'driver_details_adapter.dart';

class DriverDetailsPage extends StatelessWidget {
  // Use the adapter to safely get the driver model from arguments
  final DriverModel driver;
  
  DriverDetailsPage({Key? key}) 
      : driver = DriverDetailsAdapter.fromArguments(Get.arguments),
        super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Make sure to safely access fields that might be empty
    String nameInitial = driver.name.isNotEmpty ? driver.name[0].toUpperCase() : '?';
    String displayName = driver.name.isNotEmpty ? driver.name : 'Unknown Driver';
    String displayPhone = driver.phone != 0 ? driver.phone.toString() : 'Not available';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Details'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Driver profile image or avatar
              driver.photo != null && driver.photo!.isNotEmpty
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(driver.photo!),
                      backgroundColor: AppColors.primary,
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        nameInitial,
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
              SizedBox(height: 20),
              
              // Driver details card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Driver name
                      ListTile(
                        leading: Icon(Icons.person, color: AppColors.primary),
                        title: Text('Name'),
                        subtitle: Text(
                          displayName,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(),
                      
                      // Only show phone if it's available (not 0)
                      if (driver.phone != 0) ...[
                        ListTile(
                          leading: Icon(Icons.phone, color: AppColors.primary),
                          title: Text('Phone'),
                          subtitle: Text(
                            displayPhone,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(),
                      ],
                      
                      // Driver email (if available)
                      if (driver.email != null && driver.email!.isNotEmpty) ...[
                        ListTile(
                          leading: Icon(Icons.email, color: AppColors.primary),
                          title: Text('Email'),
                          subtitle: Text(
                            driver.email!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(),
                      ],
                      
                      // Driver status (if available)
                      if (driver.status != null && driver.status!.isNotEmpty) ...[
                        ListTile(
                          leading: Icon(
                            Icons.circle,
                            color: driver.status == 'free' ? Colors.green : Colors.orange,
                          ),
                          title: Text('Status'),
                          subtitle: Text(
                            driver.status == 'free' ? 'Available' : 'Busy',
                            style: TextStyle(
                              fontSize: 16,
                              color: driver.status == 'free' ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Only show the call button if phone is available
                  if (driver.phone != 0)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Logic to call the driver
                        Get.snackbar(
                          'Call Driver',
                          'Calling ${displayName}',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      icon: Icon(Icons.call),
                      label: Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                    ),
                  
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic to send message to the driver
                      Get.snackbar(
                        'Message Driver',
                        'Opening chat with ${displayName}',
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                    icon: Icon(Icons.message),
                    label: Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Select driver button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to select this driver for the booking
                    Get.back();
                    Get.back();
                    Get.snackbar(
                      'Driver Selected',
                      'You have selected ${displayName} for this booking',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Select This Driver',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}