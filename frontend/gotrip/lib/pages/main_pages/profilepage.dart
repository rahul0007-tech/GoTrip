// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/helper/date_format.dart';
// import '../../controllers/passenger_profile_controller.dart';
// import '../../utils/app_colors.dart';

// class ProfilePage extends StatelessWidget {
//   final ProfileController controller = Get.find<ProfileController>();

//   ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Obx(() {
//         // Show a loading indicator while the profile data is being fetched
//         if (
//             controller.username.value.isEmpty &&
//             controller.email.value.isEmpty &&
//             controller.phone.value.isEmpty&&
//             controller.photo.value.isEmpty
//             ) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               controller.photo.value.isNotEmpty
//                   ? CircleAvatar(
//                       radius: 50,
//                       backgroundImage: NetworkImage(controller.photo.value),
//                     )
//                   : CircleAvatar(
//                       radius: 50,
//                       child: Icon(Icons.person, size: 50),
//                     ),
//               SizedBox(height: 20),
//               Text(
//                 'Name: ${controller.username.value}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Email: ${controller.email.value}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Phone: ${controller.phone.value}',
//                 style: TextStyle(fontSize: 16),
//               ),
//                             SizedBox(height: 10),
//               Text(
//                 'Created at: ${DateUtil.formatDate(controller.created_at.value)}',
//                 style: TextStyle(fontSize: 16),
//               ),
//                             SizedBox(height: 10),
//               Text(
//   'Updated at: ${DateUtil.formatDate(controller.updated_at.value)}',
//   style: TextStyle(fontSize: 16),
// ),
// SizedBox(height: 20),
//                             SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => controller.logout(),
//                 child: Text('Logout'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () => Get.toNamed('/change_password'),
//                 child: Text("Change Password"),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/helper/date_format.dart';
import '../../controllers/passenger_profile_controller.dart';
import '../../utils/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        // Show a loading indicator while the profile data is being fetched
        if (
            controller.username.value.isEmpty &&
            controller.email.value.isEmpty &&
            controller.phone.value.isEmpty &&
            controller.photo.value.isEmpty
            ) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile header section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    // Profile avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFEAE4FF), // Light purple background
                        shape: BoxShape.circle,
                      ),
                      child: controller.photo.value.isNotEmpty
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(controller.photo.value),
                            )
                          : Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    // User name
                    Text(
                      controller.username.value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // User email
                    Text(
                      controller.email.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile menu items
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    _buildMenuTile(Icons.person_outline, 'My Profile', () {
                      // Show detailed profile info in a bottom sheet
                      Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Container(
                                    height: 5,
                                    width: 40,
                                    margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Detailed Profile',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                
                                // Phone
                                _buildProfileDetailItem(
                                  Icons.phone_outlined,
                                  'Phone',
                                  controller.phone.value,
                                ),
                                SizedBox(height: 16),
                                
                                // Created at
                                _buildProfileDetailItem(
                                  Icons.calendar_today_outlined,
                                  'Created at',
                                  DateUtil.formatDate(controller.created_at.value),
                                ),
                                SizedBox(height: 16),
                                
                                // Updated at
                                _buildProfileDetailItem(
                                  Icons.update_outlined,
                                  'Updated at',
                                  DateUtil.formatDate(controller.updated_at.value),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        isScrollControlled: true,
                      );
                    }),
                    _buildMenuTile(Icons.lock_outline, 'Change Password', () {
                      Get.toNamed('/change_password');
                    }),
                    
                    _buildMenuTile(Icons.logout, 'Log Out', 
                      () => controller.logout(),
                      isLogout: true
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.redAccent : Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.redAccent : Colors.black87,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }
  
  Widget _buildProfileDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}