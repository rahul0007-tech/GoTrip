// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/passenger_otp_controller.dart';
// import 'package:gotrip/utils/custom_button.dart';
// import 'package:gotrip/utils/custom_input.dart';

// class OTPPage extends StatelessWidget {
//   OTPPage({super.key});

//   final List<TextEditingController> otpControllers =
//       List.generate(5, (index) => TextEditingController());

//   final controller = Get.find<OTPController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verify OTP'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             CustomInput(
//               labelText: 'Email',
//               prefixIcon: Icons.email,
//               onChanged: (value) => controller.email.value = value,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Enter the OTP sent to your email',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.teal,
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
//                         controller.updateOTP(index, value);
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
//               label: "Verify",
//               onPressed: () => controller.verifyOTP(),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: () => controller.resendOTP(),
//               child: Text(
//                 'Resend OTP',
//                 style: TextStyle(color: Colors.teal),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/passenger_otp_controller.dart';
import 'package:gotrip/utils/custom_button.dart';
import 'package:gotrip/utils/custom_input.dart';
import 'dart:async';

class OTPPage extends StatefulWidget {
  OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> with SingleTickerProviderStateMixin {
  final List<TextEditingController> otpControllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (index) => FocusNode());
  final controller = Get.find<OTPController>();
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _timer;
  int _remainingTime = 120; // 2 minutes in seconds
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String get formattedTime {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.teal.shade700),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Verify Your Identity',
          style: TextStyle(
            color: Colors.teal.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal.shade50,
                    ),
                    child: Icon(
                      Icons.verified_user,
                      size: 60,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(() => Text(
                    'Please enter the verification code sent to\n${controller.email.value.isNotEmpty ? controller.email.value : "your email"}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  )),
                  SizedBox(height: 40),
                  CustomInput(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    onChanged: (value) => controller.email.value = value,
                    // borderRadius: 12,
                    // fillColor: Colors.grey.shade50,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.14,
                        height: MediaQuery.of(context).size.width * 0.14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: otpControllers[index],
                          focusNode: focusNodes[index],
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.teal.shade700, width: 1.5),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.updateOTP(index, value);
                              if (index < 4) {
                                focusNodes[index + 1].requestFocus();
                              } else {
                                focusNodes[index].unfocus();
                              }
                            } else {
                              if (index > 0) {
                                focusNodes[index - 1].requestFocus();
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => controller.verifyOTP(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal.shade700,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Verify & Continue",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code? ',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      _remainingTime > 0
                          ? Text(
                              'Resend in $formattedTime',
                              style: TextStyle(
                                color: Colors.teal.shade300,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                controller.resendOTP();
                                setState(() {
                                  _remainingTime = 120;
                                  startTimer();
                                });
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Colors.teal.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}