import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/user_model/driver_model.dart';
import '../../utils/app_colors.dart';

class DriverDetailsPage extends StatelessWidget {
  final DriverModel driver = Get.arguments;
  
  DriverDetailsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
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
                        driver.name.isNotEmpty ? driver.name[0].toUpperCase() : '?',
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
                          driver.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(),
                      
                      // Driver phone
                      ListTile(
                        leading: Icon(Icons.phone, color: AppColors.primary),
                        title: Text('Phone'),
                        subtitle: Text(
                          driver.phone.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Divider(),
                      
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
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic to call the driver
                      Get.snackbar(
                        'Call Driver',
                        'Calling ${driver.name}',
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
                        'Opening chat with ${driver.name}',
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
                      'You have selected ${driver.name} for this booking',
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