
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/driver_profile_controller.dart';
import '../../utils/app_colors.dart';

class DriverProfilepage extends StatelessWidget {
  final DriverProfileController controller = Get.find<DriverProfileController>();

  DriverProfilepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        // Show a loading indicator while the profile data is being fetched
        if (
            controller.username.value.isEmpty &&
            controller.email.value.isEmpty &&
            controller.phone.value.isEmpty&&
            controller.photo.value.isEmpty
            ) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.photo.value.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(controller.photo.value),
                    )
                  : CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
              SizedBox(height: 20),
              Text(
                'Name: ${controller.username.value}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Image.network(controller.license.value),
              Text(
                'Email: ${controller.email.value}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Phone: ${controller.phone.value}',
                style: TextStyle(fontSize: 16),
              ),
                            SizedBox(height: 10),
              Text(
                'Created at: ${controller.created_at.value}',
                style: TextStyle(fontSize: 16),
              ),
                            SizedBox(height: 10),
              Text(
                'Updated at: ${controller.updated_at.value}',
                style: TextStyle(fontSize: 16),
              ),
                            SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.logout(),
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.toNamed('/change_password'),
                child: Text("Change Password"),
              ),
            ],
          ),
        );
      }),
    );
  }
}