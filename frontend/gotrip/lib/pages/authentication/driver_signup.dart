import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/driver_signup_controller.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:gotrip/utils/custom_button.dart';
import 'package:gotrip/utils/custom_input.dart';

class DriverSignupPage extends StatelessWidget {
  final controller = Get.find<DriverSignupController>();

  DriverSignupPage({super.key});

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
                    'asset/images/driver_signup.jpg',
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'CREATE YOUR Driver ACCOUNT',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
                SizedBox(height: 20),
                CustomInput(
                  labelText: 'Username',
                  prefixIcon: Icons.person,
                  onChanged: (value) => controller.username.value = value,
                ),
                SizedBox(height: 10),
                CustomInput(
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => controller.email.value = value,
                ),
                SizedBox(height: 10),
                CustomInput(
                  labelText: 'Phone number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => controller.phoneNumber.value = value,
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
                  label: "SIGNUP",
                  onPressed: controller.signup,
                ),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed('/login_choice');
                    },
                    child: Text(
                      'already have an account? login instead',
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
