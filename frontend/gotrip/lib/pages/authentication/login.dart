// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/utils/app_colors.dart';
// import 'package:gotrip/utils/custom_button.dart';
// import 'package:gotrip/utils/custom_input.dart';
// import '../../controllers/passenger_login_controller.dart';

// class LoginPage extends StatelessWidget {
//   final controller = Get.find<LoginController>();

//   LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Image.asset(
//                     'asset/images/login_icon.png', // Add a login icon in assets
//                     height: 100,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Welcome Back!',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 CustomInput(
//                   labelText: 'Email',
//                   prefixIcon: Icons.email,
//                   keyboardType: TextInputType.emailAddress,
//                   onChanged: (value) => controller.email.value = value,
//                 ),
//                 SizedBox(height: 10),
//                 CustomInput(
//                   labelText: 'Password',
//                   prefixIcon: Icons.lock,
//                   obscureText: true,
//                   onChanged: (value) => controller.password.value = value,
//                 ),
//                 SizedBox(height: 20),
//                 CustomButton(
//                   label: 'Login',
//                   onPressed: controller.login,
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: TextButton(
//                     onPressed: () {
//                       // Navigate to signup page
//                       Get.toNamed('/signup_choice');
//                     },
//                     child: Text(
//                       "Don't have an account? Signup here",
//                       style: TextStyle(color: AppColors.primary),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:gotrip/utils/custom_button.dart';
import 'package:gotrip/utils/custom_input.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../controllers/passenger_login_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.find<LoginController>();
  
  LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Define consistent colors
    final Color primaryColor = AppColors.primary;
    final Color secondaryColor = Colors.teal.shade50;
    final Color accentColor = Colors.amber.shade600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: primaryColor,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // App logo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.car_side_solid,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // App name
                    Text(
                      'GoTrip',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Welcome text
                    Column(
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Login to continue your journey',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Login form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Email field
                          _buildInputField(
                            label: 'Email',
                            hint: 'Enter your email address',
                            icon: LineAwesomeIcons.envelope,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => controller.email.value = value,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Password field
                          _buildInputField(
                            label: 'Password',
                            hint: 'Enter your password',
                            icon: LineAwesomeIcons.lock_solid,
                            isPassword: true,
                            onChanged: (value) => controller.password.value = value,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Forgot password link
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to forgot password page
                                Get.snackbar(
                                  'Coming Soon',
                                  'Password recovery will be available soon.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          Obx(() => Row(
  children: [
    Checkbox(
      value: controller.rememberMe.value,
      onChanged: (value) {
        controller.rememberMe.value = value ?? false;
      },
      activeColor: AppColors.primary,
    ),
    Text(
      'Remember me',
      style: TextStyle(
        color: Colors.grey[700],
      ),
    ),
  ],
)),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Signup link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/signup_choice');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: TextField(
            obscureText: isPassword,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}