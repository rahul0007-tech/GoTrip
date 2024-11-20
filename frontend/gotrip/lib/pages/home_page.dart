import 'package:flutter/material.dart';
import 'package:gotrip/Constatnts/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Map<String, dynamic>? passengerData;

  void fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(retrivePassenger));
      // Decode the JSON response
      var data = json.decode(response.body); // Decodes to Map<String, dynamic>

      setState(() {
        passengerData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error is $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while data is loading
          : passengerData == null
          ? const Center(child: Text('Failed to load data'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${passengerData!['id']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Name: ${passengerData!['passengerName']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${passengerData!['passengerPhone']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${passengerData!['passengerEmail']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Verified: ${passengerData!['passengerVerified'] ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

