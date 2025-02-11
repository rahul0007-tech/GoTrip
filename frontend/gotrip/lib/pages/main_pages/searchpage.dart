import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
        'icon': LineAwesomeIcons.car_alt_solid,
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
        'icon': LineAwesomeIcons.car_crash_solid,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Available Vehicles'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Search for Vehicles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for vehicle types, comfort level...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (BuildContext context, int index) {
                  final vehicle = vehicles[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comfort Level: ${vehicle['comfort']}'),
                          Text('Seats Available: ${vehicle['seats']}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.grey), // Optional trailing icon
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
