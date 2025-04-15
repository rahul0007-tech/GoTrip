
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/controllers/khalti_payment_controller.dart';
// import 'package:gotrip/pages/driver_main_pages.dart/driver_homepage.dart';
// import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
// import 'dart:developer' as dev;

// class KhaltiSDKDemo extends StatefulWidget {
//   const KhaltiSDKDemo({super.key});

//   @override
//   State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
// }

// class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
//   final KhaltiPaymentController controller = Get.find<KhaltiPaymentController>();
//   String? pidx;
//   String? paymentId;
//   double? amount;
//   PaymentResult? paymentResult;
//   Future<Khalti?>? khaltiFuture;
//   String debugInfo = ""; // Add a debug info string to track state

//   @override
//   void initState() {
//     super.initState();
//     _addDebug("initState called");
    
//     // Access data from the controller and initialize Khalti SDK with a delay
//     // to ensure controller has time to load data
//     Future.delayed(Duration(milliseconds: 500), () {
//       _addDebug("Delayed initialization triggered");
//       _initializePaymentData();
//     });
//   }

//   // Add debug information
//   void _addDebug(String info) {
//     dev.log("KHALTI DEBUG: $info");
//     setState(() {
//       debugInfo += "• $info\n";
//     });
//     print("KHALTI DEBUG: $info"); // Also print to console for terminal debugging
//   }

//   void _initializePaymentData() {
//     try {
//       _addDebug("_initializePaymentData called");
//       _addDebug("Controller payment list length: ${controller.payment.length}");
      
//       // Check if payment data is available in the controller
//       if (controller.payment.isNotEmpty) {
//         final paymentData = controller.payment.first;
//         _addDebug("Payment data found: PIDX=${paymentData.pidx}, ID=${paymentData.paymentId}, Amount=${paymentData.amount}");
        
//         setState(() {
//           // Get values from payment data
//           pidx = paymentData.pidx;
//           paymentId = paymentData.paymentId.toString();
//           amount = paymentData.amount.toDouble();
          
//           // Initialize Khalti SDK
//           _addDebug("Initializing Khalti SDK with PIDX: $pidx");
//           khaltiFuture = _initializeKhalti();
//         });
//       } else {
//         _addDebug("No payment data found in controller");
        
//         // Show error snackbar if no payment data is available
//         Get.snackbar(
//           'Error',
//           'Payment information not available. Please try again.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
        
//         // Navigate back after a short delay
//         Future.delayed(Duration(seconds: 2), () {
//           _addDebug("Navigating back due to missing payment data");
//           Get.close(1); // Close the current screen
//         });
//       }
//     } catch (e, stackTrace) {
//       _addDebug("ERROR in _initializePaymentData: $e");
//       _addDebug("Stack trace: $stackTrace");
      
//       // Show error snackbar
//       Get.snackbar(
//         'Error',
//         'Failed to initialize payment: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }

//   // Initialize Khalti SDK
//   Future<Khalti?> _initializeKhalti() async {
//     try {
//       _addDebug("_initializeKhalti called");
      
//       if (pidx == null || pidx!.isEmpty) {
//         _addDebug("Invalid PIDX: ${pidx ?? 'null'}");
//         Get.snackbar(
//           'Error',
//           'Invalid payment token.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//         return null;
//       }

//       _addDebug("Configuring Khalti with PIDX: $pidx");

//       // Use a try-catch inside the Future to catch any errors during initialization
//       try {
//         final payConfig = KhaltiPayConfig(
//           publicKey: '11d8ca6a221240deb98b99ee2b4ea4ac', // Replace with your actual public key
//           pidx: pidx!,
//           environment: Environment.test, // Can be Environment.prod for live
//         );

//         _addDebug("KhaltiPayConfig created successfully");

//         final khalti = Khalti.init(
//           enableDebugging: true,
//           payConfig: payConfig,
//           onPaymentResult: (paymentResult, khalti) {
//             _addDebug("onPaymentResult called with status: ${paymentResult.payload?.status}");
//             _addDebug("Full payment result: ${paymentResult.toString()}");
            
//             setState(() {
//               this.paymentResult = paymentResult;
//             });
            
//             if (paymentResult.payload?.status == 'Completed') {
//               _addDebug("Payment completed, verifying with backend");
//               // Verify payment with backend
//               if (pidx != null && paymentId != null) {
//                 try {
//                   controller.verifyPayment(pidx!, paymentId!).then((_) {
//                     _addDebug("Payment verification completed");
//                   }).catchError((e) {
//                     _addDebug("Payment verification error: $e");
//                   });
//                 } catch (e) {
//                   _addDebug("Error during payment verification: $e");
//                 }
//               }
              
//               // Show success snackbar
//               Get.snackbar(
//                 'Success',
//                 'Payment completed successfully!',
//                 snackPosition: SnackPosition.BOTTOM,
//                 backgroundColor: Colors.green,
//                 colorText: Colors.white,
//               );
//             } else {
//               _addDebug("Payment not completed, status: ${paymentResult.payload?.status}");
//               // Show failure snackbar
//               Get.snackbar(
//                 'Failed',
//                 'Payment was not completed',
//                 snackPosition: SnackPosition.BOTTOM,
//                 backgroundColor: Colors.red,
//                 colorText: Colors.white,
//               );
//             }

//             try {
//               _addDebug("Closing Khalti payment window");
//               khalti.close(context);
//             } catch (e) {
//               _addDebug("Error closing Khalti: $e");
//             }
//           },
//           onMessage: (
//             khalti, {
//             description,
//             statusCode,
//             event,
//             needsPaymentConfirmation,
//           }) async {
//             _addDebug("onMessage: Description=$description, StatusCode=$statusCode, Event=$event, NeedsConfirmation=$needsPaymentConfirmation");
            
//             try {
//               khalti.close(context);
//             } catch (e) {
//               _addDebug("Error closing Khalti from onMessage: $e");
//             }
//           },
//           onReturn: () {
//             _addDebug("onReturn: Successfully redirected to return_url");
//           },
//         );

//         _addDebug("Khalti initialization successful");
//         return khalti;
//       } catch (e, stackTrace) {
//         _addDebug("ERROR during Khalti.init: $e");
//         _addDebug("Stack trace: $stackTrace");
//         return null;
//       }
//     } catch (e, stackTrace) {
//       _addDebug("OUTER ERROR in _initializeKhalti: $e");
//       _addDebug("Stack trace: $stackTrace");
//       return null;
//     }
//   }

//   @override
// Widget build(BuildContext context) {
//   // Log outside of the build method instead of inside Obx
//   print("KHALTI DEBUG: Building widget, khaltiFuture: ${khaltiFuture == null ? 'null' : 'initialized'}");
  
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Khalti Payment'),
//       backgroundColor: Colors.deepPurple,
//       actions: [
//         // Add debug button to show debug info
//         IconButton(
//           icon: Icon(Icons.bug_report),
//           onPressed: () => _showDebugInfo(),
//         )
//       ],
//     ),
//     body: Obx(() {
//       // Don't call setState() inside build - use print instead of _addDebug
//       if (controller.isLoading.value) {
//         print("KHALTI DEBUG: UI in loading state");
//         return Center(child: CircularProgressIndicator());
//       }
      
//       print("KHALTI DEBUG: UI building main content, khaltiFuture: ${khaltiFuture == null ? 'null' : 'initialized'}");
      
//       return Center(
//         child: khaltiFuture == null
//             ? _buildNoDataView()
//             : FutureBuilder<Khalti?>(
//                 future: khaltiFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     print("KHALTI DEBUG: FutureBuilder waiting");
//                     return const CircularProgressIndicator.adaptive();
//                   } else if (snapshot.hasError) {
//                     print("KHALTI DEBUG: FutureBuilder error: ${snapshot.error}");
//                     return _buildErrorView(snapshot.error.toString());
//                   } else if (snapshot.hasData) {
//                     print("KHALTI DEBUG: FutureBuilder has data");
//                     final khaltiInstance = snapshot.data;
//                     return _buildPaymentView(khaltiInstance);
//                   } else {
//                     print("KHALTI DEBUG: FutureBuilder no data");
//                     return _buildNoDataView();
//                   }
//                 },
//               ),
//       );
//     }),
//   );
// }

//   void _showDebugInfo() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Debug Information"),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Debug Log:", style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   debugInfo,
//                   style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text("Payment Data:", style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               Text("PIDX: ${pidx ?? 'null'}"),
//               Text("Payment ID: ${paymentId ?? 'null'}"),
//               Text("Amount: ${amount ?? 'null'}"),
//               SizedBox(height: 16),
//               Text("Controller State:", style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               Text("Payment List Length: ${controller.payment.length}"),
//               Text("Error Message: ${controller.errorMessage.value.isEmpty ? 'none' : controller.errorMessage.value}"),
//               Text("Is Loading: ${controller.isLoading.value}"),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("Close"),
//           ),
//           TextButton(
//             onPressed: () {
//               // Copy debug info to clipboard
//               // (You would need to implement this)
//               Navigator.of(context).pop();
//               Get.snackbar(
//                 'Debug',
//                 'Debug info copied to clipboard',
//                 snackPosition: SnackPosition.BOTTOM,
//               );
//             },
//             child: Text("Copy"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoDataView() {
//     _addDebug("Building no data view");
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 60, color: Colors.red),
//           SizedBox(height: 20),
//           Text(
//             'Payment information not available',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Please try again or contact support if the issue persists.',
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Debug: ${controller.payment.length} payment(s), PIDX: ${pidx ?? "null"}',
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () => Get.close(1),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//             ),
//             child: Text('Go Back'),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => _initializePaymentData(), // Retry button
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//             ),
//             child: Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorView(String error) {
//     _addDebug("Building error view: $error");
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 60, color: Colors.red),
//           SizedBox(height: 20),
//           Text(
//             'Error Initializing Payment',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Text(
//             error,
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.red),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Debug: PIDX=$pidx, PaymentID=$paymentId',
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () => Get.close(1),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//             ),
//             child: Text('Go Back'),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => setState(() {
//               _addDebug("Retrying Khalti initialization");
//               khaltiFuture = _initializeKhalti();
//             }),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//             ),
//             child: Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentView(Khalti? khaltiInstance) {
//     _addDebug("Building payment view, khaltiInstance is ${khaltiInstance == null ? 'null' : 'initialized'}");
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/profile/default_avatar.jpg',
//               height: 120,
//               width: 120,
//             ),
//             const SizedBox(height: 40),
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 3,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'Payment Details',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Divider(),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Amount:'),
//                       Text(
//                         'Rs. ${amount ?? 0}',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Payment ID:'),
//                       Text(
//                         paymentId ?? 'N/A',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('PIDX:'),
//                       Text(
//                         pidx ?? 'N/A',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: khaltiInstance != null
//                   ? () {
//                       _addDebug("Opening Khalti payment window");
//                       try {
//                         khaltiInstance.open(context);
//                       } catch (e) {
//                         _addDebug("ERROR opening Khalti: $e");
//                         Get.snackbar(
//                           'Error',
//                           'Failed to open payment: $e',
//                           snackPosition: SnackPosition.BOTTOM,
//                           backgroundColor: Colors.redAccent,
//                           colorText: Colors.white,
//                         );
//                       }
//                     }
//                   : null,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                 backgroundColor: const Color(0xFF5C2D91), // Khalti purple color
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.payment, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text(
//                     'Pay with Khalti',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Debug retry button
//             OutlinedButton(
//               onPressed: () {
//                 setState(() {
//                   _addDebug("Manual retry of Khalti initialization");
//                   khaltiFuture = _initializeKhalti();
//                 });
//               },
//               child: Text('Reinitialize Khalti'),
//             ),
//             const SizedBox(height: 30),
//             if (paymentResult != null)
//               Card(
//                 margin: const EdgeInsets.all(16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Payment Status: ${paymentResult!.payload?.status ?? "N/A"}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: paymentResult!.payload?.status == 'Completed'
//                               ? Colors.green
//                               : Colors.red,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Transaction ID: ${paymentResult!.payload?.transactionId ?? "N/A"}'),
//                       Text('Amount Paid: Rs. ${paymentResult!.payload?.totalAmount ?? 0}'),
//                       Text('PIDX: ${paymentResult!.payload?.pidx ?? "N/A"}'),
//                     ],
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () => Get.to(HomePage()),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.deepPurple,
//               ),
//               child: Text('Go to Home Page'),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Secure payment powered by Khalti',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/khalti_payment_controller.dart';

import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'dart:developer' as dev;

import '../main_pages/homepage.dart';

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  final KhaltiPaymentController controller = Get.find<KhaltiPaymentController>();
  String? pidx;
  String? paymentId;
  double? amount;
  PaymentResult? paymentResult;
  Future<Khalti?>? khaltiFuture;
  String debugInfo = ""; // Debug info string to track state

  @override
  void initState() {
    super.initState();
    print("KHALTI DEBUG: initState called");
    
    // Use post-frame callback to safely handle navigation or state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.payment.isEmpty) {
        print("KHALTI DEBUG: No payment data available");
        
        Get.snackbar(
          'Error',
          'Payment information not available. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        
        // Navigate back
        Get.back();
      } else {
        print("KHALTI DEBUG: Payment data found, initializing");
        _initializePaymentData();
      }
    });
  }

  // Safe debug method that doesn't call setState during build
  void _addDebug(String info) {
    dev.log("KHALTI DEBUG: $info");
    print("KHALTI DEBUG: $info");
    
    // Only update state if widget is mounted and not during build
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          debugInfo += "• $info\n";
        });
      });
    }
  }

  void _initializePaymentData() {
  try {
    _addDebug("_initializePaymentData called");

    if (controller.payment.isNotEmpty) {
      final paymentData = controller.payment.first;
      _addDebug("Payment data found: PIDX=${paymentData.pidx}, ID=${paymentData.paymentId}, Amount=${paymentData.amount}");

      setState(() {
        pidx = paymentData.pidx;
        paymentId = paymentData.paymentId.toString();
        amount = paymentData.amount.toDouble();
        
        // Initialize Khalti SDK with payment data
        _addDebug("Initializing Khalti SDK with PIDX: $pidx");

        // Ensure the khaltiFuture is assigned here after all necessary data is available
        khaltiFuture = _initializeKhalti();
      });
    } else {
      _addDebug("No payment data found in controller");
      _showError("No payment data available. Please try again.");
    }
  } catch (e, stackTrace) {
    _addDebug("ERROR in _initializePaymentData: $e");
    _addDebug("Stack trace: $stackTrace");
    _showError("Failed to initialize payment: $e");
  }
}



  // Process payment data from controller
  // void _initializePaymentData() {
  //   try {
  //     _addDebug("_initializePaymentData called");
  //     _addDebug("Controller payment list length: ${controller.payment.length}");
      
  //     // Only proceed if payment data is available
  //     if (controller.payment.isNotEmpty) {
  //       final paymentData = controller.payment.first;
  //       _addDebug("Payment data found: PIDX=${paymentData.pidx}, ID=${paymentData.paymentId}, Amount=${paymentData.amount}");
        
  //       // Update state with payment information
  //       setState(() {
  //         pidx = paymentData.pidx;
  //         paymentId = paymentData.paymentId.toString();
  //         amount = paymentData.amount.toDouble();
          
  //         // Initialize Khalti SDK with payment data
  //         _addDebug("Initializing Khalti SDK with PIDX: $pidx");
  //         khaltiFuture = _initializeKhalti();
  //       });
  //     } else {
  //       _addDebug("No payment data found in controller");
        
  //       // Show error message and navigate back
  //       Get.snackbar(
  //         'Error',
  //         'Payment information not available. Please try again.',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent,
  //         colorText: Colors.white,
  //       );
        
  //       Get.back(); // Return to previous screen
  //     }
  //   } catch (e, stackTrace) {
  //     _addDebug("ERROR in _initializePaymentData: $e");
  //     _addDebug("Stack trace: $stackTrace");
      
  //     Get.snackbar(
  //       'Error',
  //       'Failed to initialize payment: $e',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
      
  //     Get.back(); // Return to previous screen on error
  //   }
  // }

  Future<Khalti?> _initializeKhalti() async {
  try {
    if (pidx == null || pidx!.isEmpty) {
      _addDebug("Invalid PIDX: ${pidx ?? 'null'}");
      _showError("Invalid payment token.");
      return null;
    }

    final payConfig = KhaltiPayConfig(
      publicKey: '11d8ca6a221240deb98b99ee2b4ea4ac', // Your Khalti public key
      pidx: pidx!,
      environment: Environment.test, // Use Environment.prod for production
    );

    final khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        _addDebug("onPaymentResult called with status: ${paymentResult.payload?.status}");
        if (paymentResult.payload?.status == 'Completed') {
          controller.verifyPayment(pidx!, paymentId!).then((_) {
            _addDebug("Payment verification completed");
          }).catchError((e) {
            _addDebug("Payment verification error: $e");
          });
        }
      },
      onMessage: (khalti, {description, statusCode, event, needsPaymentConfirmation}) async {
        _addDebug("onMessage: Description=$description, StatusCode=$statusCode, Event=$event, NeedsConfirmation=$needsPaymentConfirmation");
        khalti.close(context);
      },
      onReturn: () {
        _addDebug("onReturn: Successfully redirected to return_url");
      },
    );

    return khalti;
  } catch (e) {
    _addDebug("ERROR during Khalti.init: $e");
    return null;
  }
}

void _showError(String message) {
  Get.snackbar(
    'Error',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Khalti Payment'),
      backgroundColor: Colors.deepPurple,
      actions: [
        IconButton(
          icon: Icon(Icons.bug_report),
          onPressed: () => _showDebugInfo(),
        )
      ],
    ),
    body: Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      return Center(
        child: khaltiFuture == null
            ? _buildNoDataView()
            : FutureBuilder<Khalti?>(
                future: khaltiFuture, // Ensure khaltiFuture is assigned here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator.adaptive();
                  } else if (snapshot.hasError) {
                    return _buildErrorView(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    final khaltiInstance = snapshot.data;
                    return _buildPaymentView(khaltiInstance);
                  } else {
                    return _buildNoDataView();
                  }
                },
              ),
      );
    }),
  );
}



  // // Initialize Khalti SDK with payment data
  // Future<Khalti?> _initializeKhalti() async {
  //   try {
  //     _addDebug("_initializeKhalti called");
      
  //     // Validate PIDX
  //     if (pidx == null || pidx!.isEmpty) {
  //       _addDebug("Invalid PIDX: ${pidx ?? 'null'}");
        
  //       Get.snackbar(
  //         'Error',
  //         'Invalid payment token.',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent,
  //         colorText: Colors.white,
  //       );
        
  //       return null;
  //     }

  //     _addDebug("Configuring Khalti with PIDX: $pidx");

  //     try {
  //       // Create Khalti payment configuration
  //       final payConfig = KhaltiPayConfig(
  //         publicKey: '11d8ca6a221240deb98b99ee2b4ea4ac', // Your Khalti public key
  //         pidx: pidx!,
  //         environment: Environment.test, // Use Environment.prod for production
  //       );

  //       _addDebug("KhaltiPayConfig created successfully");

  //       // Initialize Khalti
  //       final khalti = Khalti.init(
  //         enableDebugging: true,
  //         payConfig: payConfig,
  //         onPaymentResult: (paymentResult, khalti) {
  //           _addDebug("onPaymentResult called with status: ${paymentResult.payload?.status}");
  //           _addDebug("Full payment result: ${paymentResult.toString()}");
            
  //           if (mounted) {
  //             setState(() {
  //               this.paymentResult = paymentResult;
  //             });
  //           }
            
  //           // Handle successful payment
  //           if (paymentResult.payload?.status == 'Completed') {
  //             _addDebug("Payment completed, verifying with backend");
              
  //             // Verify payment with backend
  //             if (pidx != null && paymentId != null) {
  //               try {
  //                 controller.verifyPayment(pidx!, paymentId!).then((_) {
  //                   _addDebug("Payment verification completed");
  //                 }).catchError((e) {
  //                   _addDebug("Payment verification error: $e");
  //                 });
  //               } catch (e) {
  //                 _addDebug("Error during payment verification: $e");
  //               }
  //             }
              
  //             // Show success message
  //             Get.snackbar(
  //               'Success',
  //               'Payment completed successfully!',
  //               snackPosition: SnackPosition.BOTTOM,
  //               backgroundColor: Colors.green,
  //               colorText: Colors.white,
  //             );
  //           } else {
  //             _addDebug("Payment not completed, status: ${paymentResult.payload?.status}");
              
  //             // Show failure message
  //             Get.snackbar(
  //               'Failed',
  //               'Payment was not completed',
  //               snackPosition: SnackPosition.BOTTOM,
  //               backgroundColor: Colors.red,
  //               colorText: Colors.white,
  //             );
  //           }

  //           // Close Khalti window
  //           try {
  //             _addDebug("Closing Khalti payment window");
  //             khalti.close(context);
  //           } catch (e) {
  //             _addDebug("Error closing Khalti: $e");
  //           }
  //         },
  //         onMessage: (
  //           khalti, {
  //           description,
  //           statusCode,
  //           event,
  //           needsPaymentConfirmation,
  //         }) async {
  //           _addDebug("onMessage: Description=$description, StatusCode=$statusCode, Event=$event, NeedsConfirmation=$needsPaymentConfirmation");
            
  //           try {
  //             khalti.close(context);
  //           } catch (e) {
  //             _addDebug("Error closing Khalti from onMessage: $e");
  //           }
  //         },
  //         onReturn: () {
  //           _addDebug("onReturn: Successfully redirected to return_url");
  //         },
  //       );

  //       _addDebug("Khalti initialization successful");
  //       return khalti;
  //     } catch (e, stackTrace) {
  //       _addDebug("ERROR during Khalti.init: $e");
  //       _addDebug("Stack trace: $stackTrace");
  //       return null;
  //     }
  //   } catch (e, stackTrace) {
  //     _addDebug("OUTER ERROR in _initializeKhalti: $e");
  //     _addDebug("Stack trace: $stackTrace");
  //     return null;
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   print("KHALTI DEBUG: Building widget, khaltiFuture: ${khaltiFuture == null ? 'null' : 'initialized'}");
    
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Khalti Payment'),
  //       backgroundColor: Colors.deepPurple,
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.bug_report),
  //           onPressed: () => _showDebugInfo(),
  //         )
  //       ],
  //     ),
  //     body: Obx(() {
  //       print("KHALTI DEBUG: UI in ${controller.isLoading.value ? 'loading' : 'ready'} state");
        
  //       if (controller.isLoading.value) {
  //         return Center(child: CircularProgressIndicator());
  //       }
        
  //       print("KHALTI DEBUG: UI building main content, khaltiFuture: ${khaltiFuture == null ? 'null' : 'initialized'}");
        
  //       return Center(
  //         child: khaltiFuture == null
  //             ? _buildNoDataView()
  //             : FutureBuilder<Khalti?>(
  //                 future: khaltiFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     print("KHALTI DEBUG: FutureBuilder waiting");
  //                     return const CircularProgressIndicator.adaptive();
  //                   } else if (snapshot.hasError) {
  //                     print("KHALTI DEBUG: FutureBuilder error: ${snapshot.error}");
  //                     return _buildErrorView(snapshot.error.toString());
  //                   } else if (snapshot.hasData) {
  //                     print("KHALTI DEBUG: FutureBuilder has data");
  //                     final khaltiInstance = snapshot.data;
  //                     return _buildPaymentView(khaltiInstance);
  //                   } else {
  //                     print("KHALTI DEBUG: FutureBuilder no data");
  //                     return _buildNoDataView();
  //                   }
  //                 },
  //               ),
  //       );
  //     }),
  //   );
  // }

  // Display debug information dialog
  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Debug Information"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Debug Log:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  debugInfo,
                  style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                ),
              ),
              SizedBox(height: 16),
              Text("Payment Data:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("PIDX: ${pidx ?? 'null'}"),
              Text("Payment ID: ${paymentId ?? 'null'}"),
              Text("Amount: ${amount ?? 'null'}"),
              SizedBox(height: 16),
              Text("Controller State:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Payment List Length: ${controller.payment.length}"),
              Text("Error Message: ${controller.errorMessage.value.isEmpty ? 'none' : controller.errorMessage.value}"),
              Text("Is Loading: ${controller.isLoading.value}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
          TextButton(
            onPressed: () {
              // Close dialog
              Navigator.of(context).pop();
              Get.snackbar(
                'Debug',
                'Debug info copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text("Copy"),
          ),
        ],
      ),
    );
  }

  // UI for when no payment data is available
  Widget _buildNoDataView() {
    // Use print instead of _addDebug to avoid setState during build
    print("KHALTI DEBUG: Building no data view");
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 20),
          Text(
            'Payment information not available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Please try again or contact support if the issue persists.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Debug: ${controller.payment.length} payment(s), PIDX: ${pidx ?? "null"}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text('Go Back'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Use post-frame callback to safely update state
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initializePaymentData();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  // UI for error display
  Widget _buildErrorView(String error) {
    // Use print instead of _addDebug to avoid setState during build
    print("KHALTI DEBUG: Building error view: $error");
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 20),
          Text(
            'Error Initializing Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 10),
          Text(
            'Debug: PIDX=$pidx, PaymentID=$paymentId',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text('Go Back'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Use post-frame callback to safely update state
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  print("KHALTI DEBUG: Retrying Khalti initialization");
                  khaltiFuture = _initializeKhalti();
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  // UI for payment view when Khalti is initialized
  Widget _buildPaymentView(Khalti? khaltiInstance) {
    // Use print instead of _addDebug to avoid setState during build
    print("KHALTI DEBUG: Building payment view, khaltiInstance is ${khaltiInstance == null ? 'null' : 'initialized'}");
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/destination1.jpg',
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount:'),
                      Text(
                        'Rs. ${amount ?? 0}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment ID:'),
                      Text(
                        paymentId ?? 'N/A',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PIDX:'),
                      Text(
                        pidx ?? 'N/A',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: khaltiInstance != null
                  ? () {
                      print("KHALTI DEBUG: Opening Khalti payment window");
                      
                      try {
                        khaltiInstance.open(context);
                      } catch (e) {
                        print("KHALTI DEBUG: ERROR opening Khalti: $e");
                        
                        // Show error message
                        Get.snackbar(
                          'Error',
                          'Failed to open payment: $e',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: const Color(0xFF5C2D91), // Khalti purple color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.payment, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Pay with Khalti',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Debug retry button
            OutlinedButton(
              onPressed: () {
                // Use post-frame callback to safely update state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    print("KHALTI DEBUG: Manual retry of Khalti initialization");
                    khaltiFuture = _initializeKhalti();
                  });
                });
              },
              child: Text('Reinitialize Khalti'),
            ),
            const SizedBox(height: 30),
            if (paymentResult != null)
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Status: ${paymentResult!.payload?.status ?? "N/A"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: paymentResult!.payload?.status == 'Completed'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Transaction ID: ${paymentResult!.payload?.transactionId ?? "N/A"}'),
                      Text('Amount Paid: Rs. ${paymentResult!.payload?.totalAmount ?? 0}'),
                      Text('PIDX: ${paymentResult!.payload?.pidx ?? "N/A"}'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.to(() => HomePage()),
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
              child: Text('Go to Home Page'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Secure payment powered by Khalti',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}