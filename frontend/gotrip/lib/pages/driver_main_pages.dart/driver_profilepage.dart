
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/driver_profile_controller.dart';
// import '../../utils/app_colors.dart';

// class DriverProfilepage extends StatelessWidget {
//   final DriverProfileController controller = Get.find<DriverProfileController>();

//   DriverProfilepage({Key? key}) : super(key: key);

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
//               Image.network(controller.license.value),
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
//                 'Created at: ${controller.created_at.value}',
//                 style: TextStyle(fontSize: 16),
//               ),
//                             SizedBox(height: 10),
//               Text(
//                 'Updated at: ${controller.updated_at.value}',
//                 style: TextStyle(fontSize: 16),
//               ),
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
import 'package:gotrip/controllers/driver_profile_controller.dart';
import '../../utils/app_colors.dart';

class DriverProfilepage extends StatelessWidget {
  final DriverProfileController controller = Get.find<DriverProfileController>();

  DriverProfilepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        // Show a loading indicator while the profile data is being fetched
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        // Show error state
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text('Failed to load profile data'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchUserProfile(),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: controller.photo.value.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(controller.photo.value),
                          onBackgroundImageError: (e, stackTrace) {
                            print("Image error: $e");
                          },
                        )
                      : CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),
                ),
                SizedBox(height: 20),
                Text(
                  'Name: ${controller.username.value}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                
                // Only show license image if available
                if (controller.license.value.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('License:', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          controller.license.value,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            print("License image error: $error");
                            return Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Center(
                                child: Text('Unable to load license image'),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                
                Text(
                  'Email: ${controller.email.value}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${controller.phone.value}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Created at: ${controller.created_at.value}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Updated at: ${controller.updated_at.value}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => controller.logout(),
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/change_password'),
                      child: Text("Change Password"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}