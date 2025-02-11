// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/otp_controller.dart';
// import 'package:gotrip/utils/custom_button.dart';
// import 'package:gotrip/utils/custom_input.dart';

// class OTPPage extends StatelessWidget {
//   OTPPage({super.key});

//   final List<TextEditingController> otpControllers =
//       List.generate(5, (index) => TextEditingController());
//   final FocusNode _focusNode = FocusNode();

//   final controller = Get.find<OTPController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verify OTP'),
//         elevation: 0,
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             CustomInput(
//                   labelText: 'Email',
//                   prefixIcon: Icons.person,
//                   onChanged: (value) => controller.email.value = value,
//                 ),
//             Center(
//               child: Text(
//                 'Enter the OTP sent to your email',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal,
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(5, (index) {
//                 return SizedBox(
//                   width: 50,
//                   child: TextField(
//                     controller: otpControllers[index],
//                     focusNode: index == 0 ? _focusNode : null,
//                     keyboardType: TextInputType.number,
//                     maxLength: 1,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     decoration: InputDecoration(
//                       counterText: "",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.teal),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.teal, width: 2),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       if (value.isNotEmpty) {
//                         if (index < 4) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       } else {
//                         if (index > 0) {
//                           FocusScope.of(context).previousFocus();
//                         }
//                       }
//                     },
//                   ),
//                 );
//               }),
//             ),
//             SizedBox(height: 20),
//             CustomButton(
//                 label: "Verify",
//                 onPressed: () {
//                   String otp = otpControllers
//                       .map((controller) => controller.text)
//                       .join();
//                   if (otp == "12345") {
//                     Get.snackbar('Success', 'OTP Verified!');
//                     Get.offNamed('/login'); // Navigate to login page
//                   } else {
//                     Get.snackbar(
//                       'Error',
//                       'Please enter the complete OTP.',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Get.theme.colorScheme.error,
//                       colorText: Get.theme.colorScheme.onError,
//                       margin: EdgeInsets.all(10),
//                       borderRadius: 10,
//                     );
//                   }
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/otp_controller.dart';
import 'package:gotrip/utils/custom_button.dart';
import 'package:gotrip/utils/custom_input.dart';

class OTPPage extends StatelessWidget {
  OTPPage({super.key});

  final List<TextEditingController> otpControllers =
      List.generate(5, (index) => TextEditingController());

  final controller = Get.find<OTPController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CustomInput(
              labelText: 'Email',
              prefixIcon: Icons.email,
              onChanged: (value) => controller.email.value = value,
            ),
            SizedBox(height: 20),
            Text(
              'Enter the OTP sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.updateOTP(index, value);
                        if (index < 4) {
                          FocusScope.of(context).nextFocus();
                        }
                      } else {
                        if (index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            CustomButton(
              label: "Verify",
              onPressed: () => controller.verifyOTP(),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => controller.resendOTP(),
              child: Text(
                'Resend OTP',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
