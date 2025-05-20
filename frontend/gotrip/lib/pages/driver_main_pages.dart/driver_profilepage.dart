// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/driver_profile_controller.dart';
// import '../../utils/app_colors.dart';
// import 'package:image_picker/image_picker.dart';

// class DriverProfilepage extends StatelessWidget {
//   final DriverProfileController controller = Get.find<DriverProfileController>();
//   final ImagePicker _picker = ImagePicker();

//   DriverProfilepage({Key? key}) : super(key: key);

//   Future<void> _pickAndUploadImages() async {
//     try {
//       final List<XFile>? images = await _picker.pickMultiImage();
//       if (images != null && images.isNotEmpty) {
//         await controller.uploadVehicleImages(images);
//       }
//     } catch (e) {
//       print('Error picking images: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to pick images',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         // Show a loading indicator while the profile data is being fetched
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator(color: AppColors.primary));
//         }
        
//         // Show error state
//         if (controller.hasError.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 48, color: Colors.red),
//                 SizedBox(height: 16),
//                 Text('Failed to load profile data'),
//                 SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => controller.fetchUserProfile(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: Text('Try Again'),
//                 ),
//               ],
//             ),
//           );
//         }
        
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               // Profile header section
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 24),
//                 child: Column(
//                   children: [
//                     // Profile avatar
//                     Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         color: Color(0xFFEAE4FF), // Light purple background
//                         shape: BoxShape.circle,
//                       ),
//                       child: controller.photo.value.isNotEmpty
//                           ? CircleAvatar(
//                               radius: 60,
//                               backgroundImage: NetworkImage(controller.photo.value),
//                               onBackgroundImageError: (e, stackTrace) {
//                                 print("Image error: $e");
//                               },
//                             )
//                           : Icon(Icons.person, size: 60, color: Colors.white),
//                     ),
//                     SizedBox(height: 16),
//                     // User name
//                     Text(
//                       controller.username.value,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     // User email
//                     Text(
//                       controller.email.value,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Profile menu items
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   children: [
//                     _buildMenuTile(Icons.person_outline, 'My Profile', () {
//                       // Show detailed profile info in a bottom sheet
//                       Get.bottomSheet(
//                         Container(
//                           padding: EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                           ),
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Center(
//                                   child: Container(
//                                     height: 5,
//                                     width: 40,
//                                     margin: EdgeInsets.only(bottom: 20),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                                 Center(
//                                   child: Text(
//                                     'Detailed Profile',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
                                
//                                 // Phone
//                                 _buildProfileDetailItem(
//                                   Icons.phone_outlined,
//                                   'Phone',
//                                   controller.phone.value,
//                                 ),
//                                 SizedBox(height: 16),
                                
//                                 // License (if available)
//                                 if (controller.license.value.isNotEmpty) ...[
//                                   Text(
//                                     'License:',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.network(
//                                       controller.license.value,
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.contain,
//                                       errorBuilder: (context, error, stackTrace) {
//                                         return Container(
//                                           height: 100,
//                                           width: double.infinity,
//                                           color: Colors.grey[200],
//                                           child: Center(
//                                             child: Text('Unable to load license image'),
//                                           ),
//                                         );
//                                       },
//                                       loadingBuilder: (context, child, loadingProgress) {
//                                         if (loadingProgress == null) return child;
//                                         return Container(
//                                           height: 100,
//                                           width: double.infinity,
//                                           color: Colors.grey[200],
//                                           child: Center(
//                                             child: CircularProgressIndicator(
//                                               value: loadingProgress.expectedTotalBytes != null
//                                                   ? loadingProgress.cumulativeBytesLoaded /
//                                                       loadingProgress.expectedTotalBytes!
//                                                   : null,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                 ],
                                
//                                 // Created at
//                                 _buildProfileDetailItem(
//                                   Icons.calendar_today_outlined,
//                                   'Created at',
//                                   controller.created_at.value,
//                                 ),
//                                 SizedBox(height: 16),
                                
//                                 // Updated at
//                                 _buildProfileDetailItem(
//                                   Icons.update_outlined,
//                                   'Updated at',
//                                   controller.updated_at.value,
//                                 ),
//                                 SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         ),
//                         isScrollControlled: true,
//                       );
//                     }),
                    
//                     // Conditionally show Add Vehicle or Vehicle Added status
//                     if (!controller.hasVehicle.value)
//                       _buildMenuTile(Icons.directions_car_outlined, 'Add Your Vehicle', () {
//                         Get.toNamed('/add_vehicle');
//                       })
//                     else
//                       Column(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(bottom: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               leading: Icon(
//                                 Icons.directions_car_outlined,
//                                 color: Colors.green,
//                               ),
//                               title: Text(
//                                 'Vehicle Added',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               trailing: Icon(
//                                 Icons.check_circle,
//                                 color: Colors.green,
//                                 size: 20,
//                               ),
//                               contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//                             ),
//                           ),
//                           _buildMenuTile(Icons.add_photo_alternate_outlined, 'Add Vehicle Images', 
//                             _pickAndUploadImages,
//                           ),
//                         ],
//                       ),
                    
//                     _buildMenuTile(Icons.lock_outline, 'Change Password', () {
//                       Get.toNamed('/change_password');
//                     }),
                    
//                     _buildMenuTile(Icons.logout, 'Log Out', 
//                       () => controller.logout(),
//                       isLogout: true
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
  
//   Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isLogout ? Colors.redAccent : Colors.black54,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: isLogout ? Colors.redAccent : Colors.black87,
//           ),
//         ),
//         trailing: Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//         contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//       ),
//     );
//   }
  
//   Widget _buildProfileDetailItem(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: AppColors.primary, size: 20),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/driver_profile_controller.dart';
import '../../utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class DriverProfilePage extends StatelessWidget {
  final DriverProfileController controller = Get.find<DriverProfileController>();
  final ImagePicker _picker = ImagePicker();

  DriverProfilePage({Key? key}) : super(key: key);

  Future<void> _pickAndUploadImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        await controller.uploadVehicleImages(images);
      }
    } catch (e) {
      print('Error picking images: $e');
      Get.snackbar(
        'Error',
        'Failed to pick images',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.setTempProfileImage(image);
      }
    } catch (e) {
      print('Error picking profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick profile image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(() => controller.tempProfileImage.value != null
              ? Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: TextButton(
                    onPressed: () => controller.updateProfileImage(),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        // Show a loading indicator while the profile data is being fetched
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
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
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFFEAE4FF), // Light purple background
                          shape: BoxShape.circle,
                        ),
                        child: controller.tempProfileImage.value != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(File(controller.tempProfileImage.value!.path)),
                              )
                            : controller.photo.value.isNotEmpty
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(controller.photo.value),
                                    onBackgroundImageError: (e, stackTrace) {
                                      print("Image error: $e");
                                    },
                                  )
                                : Icon(Icons.person, size: 60, color: Colors.white),
                      ),
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
                                
                                // License (if available)
                                if (controller.license.value.isNotEmpty) ...[
                                  Text(
                                    'License:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      controller.license.value,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 100,
                                          width: double.infinity,
                                          color: Colors.grey[200],
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
                                  SizedBox(height: 16),
                                ],
                                
                                // Created at
                                _buildProfileDetailItem(
                                  Icons.calendar_today_outlined,
                                  'Created at',
                                  controller.created_at.value,
                                ),
                                SizedBox(height: 16),
                                
                                // Updated at
                                _buildProfileDetailItem(
                                  Icons.update_outlined,
                                  'Updated at',
                                  controller.updated_at.value,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        isScrollControlled: true,
                      );
                    }),
                    
                    // Conditionally show Add Vehicle or Vehicle Added status
                    if (!controller.hasVehicle.value)
                      _buildMenuTile(Icons.directions_car_outlined, 'Add Your Vehicle', () {
                        Get.toNamed('/add_vehicle');
                      })
                    else
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.directions_car_outlined,
                                color: Colors.green,
                              ),
                              title: Text(
                                'Vehicle Added',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                              trailing: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            ),
                          ),
                          _buildMenuTile(Icons.add_photo_alternate_outlined, 'Add Vehicle Images', 
                            _pickAndUploadImages,
                          ),
                        ],
                      ),
                    
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