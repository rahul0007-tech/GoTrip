// // change_password_page.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/change_password.dart';

// class ChangePasswordPage extends StatelessWidget {
//   final ChangePasswordController controller = Get.find<ChangePasswordController>();

//   // Text controllers for input fields
//   final TextEditingController oldPasswordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   ChangePasswordPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Change Password"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: oldPasswordController,
//               decoration: InputDecoration(labelText: "Old Password"),
//               obscureText: true,
//             ),
//             TextField(
//               controller: newPasswordController,
//               decoration: InputDecoration(labelText: "New Password"),
//               obscureText: true,
//             ),
//             TextField(
//               controller: confirmPasswordController,
//               decoration: InputDecoration(labelText: "Confirm New Password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             // Show a loading indicator when the API call is in progress
//             Obx(() => controller.isLoading.value
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: () {
//                       controller.changePassword(
//                         oldPasswordController.text,
//                         newPasswordController.text,
//                         confirmPasswordController.text,
//                       );
//                     },
//                     child: Text("Change Password"),
//                   )),
//           ],
//         ),
//       ),
//     );
//   }
// }



// change_password_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/change_password.dart';
import 'package:gotrip/utils/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ChangePasswordController controller = Get.find<ChangePasswordController>();
  
  // Text controllers for input fields
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // Toggle password visibility
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers to update UI when text changes
    oldPasswordController.addListener(_updateState);
    newPasswordController.addListener(_updateState);
    confirmPasswordController.addListener(_updateState);
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    oldPasswordController.removeListener(_updateState);
    newPasswordController.removeListener(_updateState);
    confirmPasswordController.removeListener(_updateState);
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Update UI when text changes
  void _updateState() {
    setState(() {});
  }

  // Check if all fields are filled
  bool _areAllFieldsFilled() {
    return oldPasswordController.text.isNotEmpty && 
           newPasswordController.text.isNotEmpty && 
           confirmPasswordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current password field with toggle visibility
            _buildPasswordField(
              controller: oldPasswordController,
              labelText: "Current password",
              obscureText: _obscureOldPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureOldPassword = !_obscureOldPassword;
                });
              },
            ),
            SizedBox(height: 16),
            
            // New password field with toggle visibility
            _buildPasswordField(
              controller: newPasswordController,
              labelText: "New password",
              obscureText: _obscureNewPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            SizedBox(height: 16),
            
            // Confirm password field with toggle visibility
            _buildPasswordField(
              controller: confirmPasswordController,
              labelText: "Confirm new password",
              obscureText: _obscureConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            
            Spacer(), // Push button to bottom
            
            // Change Password button
            Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ElevatedButton(
                    onPressed: _areAllFieldsFilled() 
                      ? () {
                          controller.changePassword(
                            oldPasswordController.text,
                            newPasswordController.text,
                            confirmPasswordController.text,
                          );
                        } 
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _areAllFieldsFilled() ? AppColors.primary : Colors.grey[300],
                      disabledBackgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Change",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _areAllFieldsFilled() ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  )),
            SizedBox(height: 30), // Add some bottom padding for better appearance
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey[600],
            ),
            onPressed: onToggleVisibility,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}