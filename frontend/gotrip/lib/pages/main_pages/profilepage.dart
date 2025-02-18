import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/passenger_profile_controller.dart';
import '../../utils/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  ProfilePage({Key? key}) : super(key: key);

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
            controller.phone.value.isEmpty
            ) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${controller.username.value}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
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
            ],
          ),
        );
      }),
    );
  }
}
