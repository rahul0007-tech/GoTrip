// change_password_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/change_password.dart';

class ChangePasswordPage extends StatelessWidget {
  final ChangePasswordController controller = Get.find<ChangePasswordController>();

  // Text controllers for input fields
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(labelText: "Old Password"),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirm New Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Show a loading indicator when the API call is in progress
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      controller.changePassword(
                        oldPasswordController.text,
                        newPasswordController.text,
                        confirmPasswordController.text,
                      );
                    },
                    child: Text("Change Password"),
                  )),
          ],
        ),
      ),
    );
  }
}
