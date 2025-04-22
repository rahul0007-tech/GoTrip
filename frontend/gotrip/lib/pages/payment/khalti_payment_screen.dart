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
  String debugInfo = "";
  bool isVerifying = false;

  @override
  void initState() {
    super.initState();
    print("KHALTI DEBUG: initState called");
    
    // Initialize immediately since we're using Obx for controller state
    _initializePaymentData();
  }

  void _addDebug(String info) {
    dev.log("KHALTI DEBUG: $info");
    print("KHALTI DEBUG: $info");
    if (mounted) {
      setState(() {
        debugInfo += "• $info\n";
      });
    }
  }

  void _initializePaymentData() {
    try {
      _addDebug("_initializePaymentData called");

      if (!controller.isPaymentInitialized.value || controller.payment.isEmpty) {
        _addDebug("Payment not initialized or no payment data available");
        _showError("Payment not initialized properly");
        return;
      }

      final paymentData = controller.payment.first;
      _addDebug("Payment data found: PIDX=${paymentData.pidx}, ID=${paymentData.paymentId}, Amount=${paymentData.amount}");

      if (paymentData.pidx.isEmpty) {
        _addDebug("Invalid PIDX received from payment data");
        _showError("Invalid payment token received");
        return;
      }

      setState(() {
        pidx = paymentData.pidx;
        paymentId = paymentData.paymentId.toString();
        amount = paymentData.amount.toDouble();
        khaltiFuture = _initializeKhalti();
      });
    } catch (e, stackTrace) {
      _addDebug("ERROR in _initializePaymentData: $e");
      _addDebug("Stack trace: $stackTrace");
      _showError("Failed to initialize payment: $e");
    }
  }

  Future<Khalti?> _initializeKhalti() async {
    try {
      if (pidx == null || pidx!.isEmpty) {
        _addDebug("Invalid PIDX: ${pidx ?? 'null'}");
        _showError("Invalid payment token");
        return null;
      }

      _addDebug("Initializing Khalti with PIDX: $pidx");

      final payConfig = KhaltiPayConfig(
        publicKey: 'a6e3e662ccae4b40acf2e2c7f731a345',
        pidx: pidx!,
        environment: Environment.test,
      );

      final khalti = await Khalti.init(
        enableDebugging: true,
        payConfig: payConfig,
        onPaymentResult: (paymentResult, khalti) async {
          _addDebug("onPaymentResult called with status: ${paymentResult.payload?.status}");
          setState(() {
            this.paymentResult = paymentResult;
          });
          
          if (paymentResult.payload?.status == 'Completed') {
            _addDebug("Payment marked as completed, verifying...");
            await _verifyPayment();
          }
        },
        onMessage: (khalti, {description, statusCode, event, needsPaymentConfirmation}) async {
          _addDebug("onMessage: Description=$description, StatusCode=$statusCode, Event=$event, NeedsConfirmation=$needsPaymentConfirmation");
          
          if (event == KhaltiEvent.returnUrlLoadFailure) {
            // This is expected due to localhost URL, proceed with verification
            _addDebug("Return URL load failed (expected), proceeding with verification");
            await _verifyPayment();
                Get.offAll(() => HomePage());

            return;
          }
          
          if (needsPaymentConfirmation == true) {
            _addDebug("Payment needs confirmation, verifying...");
            await _verifyPayment();
            Get.offAll(() => HomePage());

          }
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

  Future<void> _verifyPayment() async {
    if (isVerifying) {
      _addDebug("Verification already in progress, skipping");
      return;
    }

    if (pidx == null || paymentId == null) {
      _addDebug("Cannot verify payment - missing pidx or paymentId");
      _showError("Payment verification failed - missing data");
      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      _addDebug("Starting payment verification for PIDX: $pidx, PaymentID: $paymentId");
      final success = await controller.verifyPayment(pidx!, paymentId!);
      
      if (success) {
        _addDebug("Payment verification successful");
        // Navigation will be handled by the controller
      } else {
        _addDebug("Payment verification failed or pending");
        // The controller will handle showing appropriate messages
      }
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
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
    // Add this after the error snackbar
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _addDebug("Attempting auto-retry of payment data initialization");
        _initializePaymentData();
      }
    });
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