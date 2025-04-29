import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/utils/app_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

enum UserType { Passenger, Driver }

class SignupChoicePage extends StatefulWidget {

  
  const SignupChoicePage({Key? key}) : super(key: key);

  @override
  _SignupChoicePageState createState() => _SignupChoicePageState();
}

class _SignupChoicePageState extends State<SignupChoicePage> {
  UserType? _userType;

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Logo and app name
                    Center(
                      child: Column(
                        children: [
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
                          Text(
                            'GoTrip',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your Ultimate Travel Companion',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Welcome text
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Welcome to GoTrip',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Fast, reliable rides at your fingertips. Experience seamless travel with professional drivers and comfortable vehicles.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Illustration section
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.1),
                                  Colors.blue.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          
                          // Road line drawing
                          CustomPaint(
                            size: Size(MediaQuery.of(context).size.width * 0.8, 100),
                            painter: RoadPainter(primaryColor.withOpacity(0.7)),
                          ),
                          
                          // Passenger icon
                          Positioned(
                            left: 40,
                            top: 40,
                            child: _buildAnimatedCircleIcon(
                              icon: LineAwesomeIcons.user,
                              label: 'Passenger',
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                          
                          // Driver icon
                          Positioned(
                            right: 40,
                            top: 70,
                            child: _buildAnimatedCircleIcon(
                              icon: LineAwesomeIcons.car_side_solid,
                              label: 'Driver',
                              color: Colors.green,
                              size: 28,
                            ),
                          ),
                          
                          // Destination icon
                          Positioned(
                            right: 80,
                            bottom: 30,
                            child: _buildAnimatedCircleIcon(
                              icon: LineAwesomeIcons.map_marker_solid,
                              label: 'Destinations',
                              color: accentColor,
                              size: 28,
                            ),
                          ),
                          
                          // Center icon - app logo
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: primaryColor.withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              LineAwesomeIcons.route_solid,
                              color: primaryColor,
                              size: 38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Selection text
                    Center(
                      child: Text(
                        'How would you like to use GoTrip?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // User type options
                    Row(
                      children: [
                        Expanded(
                          child: _buildOptionCard(
                            type: UserType.Passenger,
                            title: 'Passenger',
                            icon: LineAwesomeIcons.user,
                            color: Colors.blue,
                            isSelected: _userType == UserType.Passenger,
                            onTap: () {
                              setState(() {
                                _userType = UserType.Passenger;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildOptionCard(
                            type: UserType.Driver,
                            title: 'Driver',
                            icon: LineAwesomeIcons.car_side_solid,
                            color: Colors.green,
                            isSelected: _userType == UserType.Driver,
                            onTap: () {
                              setState(() {
                                _userType = UserType.Driver;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Get started button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _userType == null
                            ? null
                            : () {
                                if (_userType == UserType.Passenger) {
                                  Get.toNamed('/signup');
                                } else if (_userType == UserType.Driver) {
                                  Get.toNamed('/driver_signup');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _userType == null 
                              ? 'Select an option' 
                              : 'Continue as ${_userType == UserType.Passenger ? 'Passenger' : 'Driver'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/login_choice');
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircleIcon({
    required IconData icon, 
    required String label, 
    required Color color, 
    required double size
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: size,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildOptionCard({
    required UserType type,
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? color.withOpacity(0.2) 
                  : Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for road lines
class RoadPainter extends CustomPainter {
  final Color color;
  
  RoadPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    final dashPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    // Draw curved path
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width / 2, 
      size.height, 
      size.width, 
      size.height / 3
    );
    
    // Draw the main road
    canvas.drawPath(path, paint);
    
    // Draw dashed line on road (center line)
    const dashWidth = 8.0;
    const dashSpace = 5.0;
    
    // Calculate the distance along the path
    final metrics = path.computeMetrics().single;
    final distance = metrics.length;
    
    double startDistance = 0.0;
    while (startDistance < distance) {
      // Extract a segment of the path
      final extractPath = metrics.extractPath(
        startDistance,
        startDistance + dashWidth > distance ? distance : startDistance + dashWidth,
      );
      canvas.drawPath(extractPath, dashPaint);
      
      // Move forward by dash width + dash space
      startDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}