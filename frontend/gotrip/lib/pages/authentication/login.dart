import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:gotrip/utils/custom_button.dart';
import 'package:gotrip/utils/custom_input.dart';
import '../../controllers/passenger_login_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.find<LoginController>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'asset/images/login_icon.png', // Add a login icon in assets
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 20),
                CustomInput(
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => controller.email.value = value,
                ),
                SizedBox(height: 10),
                CustomInput(
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  onChanged: (value) => controller.password.value = value,
                ),
                SizedBox(height: 20),
                CustomButton(
                  label: 'Login',
                  onPressed: controller.login,
                ),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to signup page
                      Get.toNamed('/signup');
                    },
                    child: Text(
                      "Don't have an account? Signup here",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
