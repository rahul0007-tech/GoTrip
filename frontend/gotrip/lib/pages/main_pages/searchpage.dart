import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../bindings/add_vehicle_binding.dart';
import '../vehicles/add_vehicle_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for vehicles
    final List<Map<String, dynamic>> vehicles = [
      {
        'type': 'SUV',
        'comfort': 'Luxury',
        'seats': 6,
        'icon': LineAwesomeIcons.car_side_solid,
      },
      {
        'type': 'Sedan',
        'comfort': 'Comfort',
        'seats': 4,
        'icon': LineAwesomeIcons.car_solid,
      },
      {
        'type': 'Minivan',
        'comfort': 'Family',
        'seats': 7,
        'icon': LineAwesomeIcons.shuttle_van_solid,
      },
      {
        'type': 'Convertible',
        'comfort': 'Luxury',
        'seats': 2,
        'icon': LineAwesomeIcons.car_side_solid,
      },
      {
        'type': 'Hatchback',
        'comfort': 'Economy',
        'seats': 4,
        'icon': LineAwesomeIcons.car_solid,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Available Vehicles'),
        backgroundColor: Colors.teal,
        actions: [
          // Add vehicle button
          IconButton(
            icon: const Icon(LineAwesomeIcons.plus_solid),
            onPressed: () {
              Get.to(
                () => const AddVehiclePage(),
                binding: AddVehicleBinding(),
              )?.then((result) {
                if (result == true) {
                  // In a real app, you would refresh your vehicle list here
                  Get.snackbar(
                    'Success',
                    'Vehicle added successfully!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Search for Vehicles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for vehicle types, comfort level...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (BuildContext context, int index) {
                  final vehicle = vehicles[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(
                          vehicle['icon'],
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        vehicle['type'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comfort Level: ${vehicle['comfort']}'),
                          Text('Seats Available: ${vehicle['seats']}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.grey), 
                      onTap: () {
                        print('Selected vehicle: ${vehicle['type']}');
                        // Add navigation or action logic here
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}