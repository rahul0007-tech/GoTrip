import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/driver_signup_controller.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:gotrip/utils/custom_button.dart';
import 'package:gotrip/utils/custom_input.dart';

class DriverSignupPage extends StatefulWidget {
  DriverSignupPage({super.key});

  @override
  State<DriverSignupPage> createState() => _DriverSignupPageState();
}

class _DriverSignupPageState extends State<DriverSignupPage> with TickerProviderStateMixin {
  final controller = Get.find<DriverSignupController>();
  late final List<AnimationController> _animControllers;
  
  @override
  void initState() {
    super.initState();
    // Create animation controllers for staggered effects
    _animControllers = List.generate(
      6, // 5 fields + 1 button
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600),
      )
    );
    
    // Start animations with staggered delays
    for (int i = 0; i < _animControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 150 * i), () {
        if (mounted) {
          _animControllers[i].forward();
        }
      });
    }
  }
  
  @override
  void dispose() {
    for (var controller in _animControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor,
              AppColors.backgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo with animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              fit: BoxFit.cover,
                              'asset/images/gotrip_logo.jpg',
                              height: 120,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Heading with animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'CREATE YOUR DRIVER ACCOUNT',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Username Field
                    _buildAnimatedField(
                      controller: _animControllers[0],
                      child: CustomInput(
                        labelText: 'Username',
                        prefixIcon: Icons.person_outline,
                        onChanged: (value) => controller.username.value = value,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Email Field
                    _buildAnimatedField(
                      controller: _animControllers[1],
                      child: CustomInput(
                        labelText: 'Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => controller.email.value = value,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Phone Field
                    _buildAnimatedField(
                      controller: _animControllers[2],
                      child: CustomInput(
                        labelText: 'Phone number',
                        prefixIcon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => controller.phoneNumber.value = value,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Password Field
                    _buildAnimatedField(
                      controller: _animControllers[3],
                      child: CustomInput(
                        labelText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        onChanged: (value) => controller.password.value = value,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // License Image Picker
                    _buildAnimatedField(
                      controller: _animControllers[4],
                      child: InkWell(
                        onTap: controller.pickLicenseImage,
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Obx(() => controller.licenseImage.value == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: AppColors.primary,
                                    size: 30,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Upload License Image',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      controller.licenseImage.value!,
                                      width: double.infinity,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.edit, color: AppColors.primary),
                                      onPressed: controller.pickLicenseImage,
                                      iconSize: 20,
                                      padding: EdgeInsets.all(4),
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Signup button
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animControllers[5],
                        curve: Curves.easeOut,
                      )),
                      child: FadeTransition(
                        opacity: _animControllers[5],
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Obx(() => controller.isImageUploading.value
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : CustomButton(
                                label: "SIGN UP",
                                onPressed: controller.signup,
                              ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Login link with animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 900),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: child,
                        );
                      },
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('/login_choice');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Log in',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedField({
    required AnimationController controller,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0.3, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      )),
      child: FadeTransition(
        opacity: controller,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}