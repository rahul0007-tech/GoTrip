import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';

enum UserType { Passenger, Driver }

class LoginChoicePage extends StatefulWidget {
  const LoginChoicePage({Key? key}) : super(key: key);

  @override
  _LoginChoicePageState createState() => _LoginChoicePageState();
}

class _LoginChoicePageState extends State<LoginChoicePage> {
  UserType? _userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Login Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("Passenger"),
              leading: Radio<UserType>(
                value: UserType.Passenger,
                groupValue: _userType,
                onChanged: (UserType? value) {
                  setState(() {
                    _userType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Driver"),
              leading: Radio<UserType>(
                value: UserType.Driver,
                groupValue: _userType,
                onChanged: (UserType? value) {
                  setState(() {
                    _userType = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Continue"),
              onPressed: () {
                if (_userType == null) {
                  Get.snackbar("Error", "Please select a user type");
                } else if (_userType == UserType.Passenger) {
                  Get.toNamed('/login');
                } else if (_userType == UserType.Driver) {
                  Get.toNamed('/driver_login');
                }
              },
            ),
            SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to signup page
                      Get.toNamed('/signup_choice');
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
    );
  }
}
