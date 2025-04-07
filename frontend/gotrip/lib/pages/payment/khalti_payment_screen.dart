// import 'package:flutter/material.dart';
// import 'package:gotrip/controllers/khalti_payment_controller.dart';
// import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
// import 'dart:developer';


// class KhaltiSDKDemo extends StatefulWidget {

  

  
//  KhaltiSDKDemo({super.key});

//   @override
//   State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
// }

// class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {

  
  
//   PaymentResult? paymentResult;
//   late Future<Khalti?>
//       khaltiFuture; // Future to initialize Khalti SDK asynchronously

//   @override
//   void initState() {
//     super.initState();
//     // Access pidx from the MembershipProvider state and initialize Khalti SDK
   
//   }

//   void initializeKhalti(){}


//   // Initialize Khalti SDK
//   Future<Khalti?> _initializeKhalti() async {
//     // if (pidx.isEmpty) {
//     //   return null;
//     // }

//     // final payConfig = KhaltiPayConfig(
//     //   publicKey:
//     //       '7c631d753a7a499f954a1498abfd0b86', // Replace with your actual live public key
//     //   pidx: pidx,
//     //   environment: Environment.test, // Can be Environment.prod for live
//     // );

//     // final khalti = Khalti.init(
//     //   enableDebugging: true,
//     //   payConfig: payConfig,
//     //   onPaymentResult: (paymentResult, khalti) {
//     //     log(paymentResult.toString());
//     //     setState(() {
//     //       this.paymentResult = paymentResult;
//     //     });
//     //     print(paymentResult);
//     //     if (paymentResult.payload?.status == 'Completed') {
//     //       final provider =
//     //           Provider.of<MembershipProvider>(context, listen: false);
//     //       provider.verifyPayment(context, transactionId, "Completed");
//     //       showCoolSnackBar(context, "Payment Successful", true);
//     //     } else {
//     //       showCoolSnackBar(context, "Payment Failed", false);
//     //     }

//     //     khalti.close(context);
//     //   },
//     //   onMessage: (
//     //     khalti, {
//     //     description,
//     //     statusCode,
//     //     event,
//     //     needsPaymentConfirmation,
//     //   }) async {
//     //     log(
//     //       'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
//     //     );
//     //     khalti.close(context);
//     //   },
//     //   onReturn: () => log('Successfully redirected to return_url.'),
//     // );

//     // return khalti; // Return the khalti instance to be used in the FutureBuilder
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FutureBuilder<Khalti?>(
//           future: khaltiFuture, // The FutureBuilder now uses khaltiFuture
//           initialData: null,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator.adaptive();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (snapshot.hasData) {
//               final khaltiInstance = snapshot.data;

//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/profile/default_avatar.jpg', // Your image asset

//                     height: 200,
//                     width: 200,
//                   ),
//                   const SizedBox(height: 120),
//                   Text(
//                     // replace with actual price
//                     'payable amount',
//                     style: const TextStyle(fontSize: 25),
//                   ),
//                   const Text('1 day fee'),
//                   OutlinedButton(
//                     onPressed: () {
//                       // Open Khalti payment page
//                       khaltiInstance?.open(context);
//                     },
//                     child: const Text('Pay with Khalti'),
//                   ),
//                   const SizedBox(height: 120),
//                   paymentResult == null
//                       ? Text(
//                           'pidx: pidx',
//                           style: const TextStyle(fontSize: 15),
//                         )
//                       : Column(
//                           children: [
//                             Text('pidx: ${paymentResult!.payload?.pidx}'),
//                             Text('Status: ${paymentResult!.payload?.status}'),
//                             Text(
//                                 'Amount Paid: ${paymentResult!.payload?.totalAmount}'),
//                             Text(
//                                 'Transaction ID: ${paymentResult!.payload?.transactionId}'),
//                           ],
//                         ),
//                   const SizedBox(height: 120),
//                   OutlinedButton(
//                       onPressed: () {
//                         // context.pushNamed('membershipPlans');
//                       },
//                       child: const Text('Go to Membership Sceen')),
//                   const Text(
//                     'Demo Payment Using Khalti.',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ],
//               );
//             } else {
//               return const Text('No Khalti SDK data available.');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/khalti_payment_controller.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'dart:developer';

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  final KhaltiPaymentController controller = Get.find<KhaltiPaymentController>();
  PaymentResult? paymentResult;
  Future<Khalti?>? khaltiFuture; // Make nullable instead of late
  String? pidx;
  String? paymentId;
  double? amount;

  @override
  void initState() {
    super.initState();
    // Initialize data and Khalti in initState
    _setupPaymentData();
  }

  void _setupPaymentData() {
    // Check if payment data is available
    if (controller.payment.isNotEmpty) {
      final paymentData = controller.payment.first;
      
      setState(() {
        // Get values from payment data
        pidx = paymentData.pidx;
        paymentId = paymentData.paymentId.toString();
        amount = paymentData.amount.toDouble();
        
        // Now initialize khaltiFuture
        khaltiFuture = _initializeKhalti();
      });
    } else {
      // Show error if no payment data
      Get.snackbar(
        'Error',
        'Payment information not available. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      
      // Navigate back after a short delay
      Future.delayed(Duration(seconds: 2), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Get.back();
      });
    }
  }

  // Initialize Khalti SDK
  Future<Khalti?> _initializeKhalti() async {
    if (pidx == null || pidx!.isEmpty) {
      return null;
    }

    print("Initializing Khalti with pidx: $pidx");

    final payConfig = KhaltiPayConfig(
      publicKey: '7c631d753a7a499f954a1498abfd0b86', // Replace with your actual public key
      pidx: pidx!,
      environment: Environment.test, // Change to Environment.prod for production
    );

    final khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log("Payment result: ${paymentResult.toString()}");
        setState(() {
          this.paymentResult = paymentResult;
        });
        
        if (paymentResult.payload?.status == 'Completed') {
          // Verify payment with backend
          if (pidx != null && paymentId != null) {
            controller.verifyPayment(pidx!, paymentId!);
          }
          _showSuccessSnackbar();
        } else {
          _showFailureSnackbar();
        }

        khalti.close(context);
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
        khalti.close(context);
      },
      onReturn: () => log('Successfully redirected to return_url.'),
    );

    return khalti;
  }

  void _showSuccessSnackbar() {
    Get.snackbar(
      'Success', 
      'Payment completed successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showFailureSnackbar() {
    Get.snackbar(
      'Failed', 
      'Payment was not completed',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khalti Payment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Center(
          child: khaltiFuture == null
            ? _buildNoDataView()
            : FutureBuilder<Khalti?>(
                future: khaltiFuture,
                initialData: null,
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

  Widget _buildNoDataView() {
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
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
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
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentView(Khalti? khaltiInstance) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/profile/default_avatar.jpg',
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
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: khaltiInstance != null 
                ? () => khaltiInstance.open(context)
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
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
              child: Text('Back to Booking'),
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
