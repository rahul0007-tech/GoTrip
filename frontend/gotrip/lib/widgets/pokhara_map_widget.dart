import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gotrip/controllers/create_booking_controller.dart';
import 'package:geocoding/geocoding.dart';

class PokharaMapWidget extends StatelessWidget {
  final CreateBookingController controller;
  
  const PokharaMapWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,  // Fixed height for the map
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(28.2096, 83.9856), // Pokhara center coordinates
                zoom: 13,
              ),
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              },
              markers: controller.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              onTap: (LatLng position) {
                // Check if position is within Pokhara bounds
                const LatLng pokharaSW = LatLng(28.1496, 83.9256);
                const LatLng pokharaNE = LatLng(28.2696, 84.0456);
                
                bool isInPokhara = position.latitude >= pokharaSW.latitude &&
                                 position.latitude <= pokharaNE.latitude &&
                                 position.longitude >= pokharaSW.longitude &&
                                 position.longitude <= pokharaNE.longitude;
                
                if (isInPokhara) {
                  controller.selectedLocation.value = position;
                  controller.updateMarkerAndAddress(position); // Updated to use new method
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a location within Pokhara city limits'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            // Loading indicator while getting current location
            if (controller.isLoadingCurrentLocation.value)
              const Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}