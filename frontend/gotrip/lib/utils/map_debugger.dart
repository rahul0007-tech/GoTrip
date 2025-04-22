import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDebugger extends StatefulWidget {
  const MapDebugger({Key? key}) : super(key: key);

  @override
  State<MapDebugger> createState() => _MapDebuggerState();
}

class _MapDebuggerState extends State<MapDebugger> {
  GoogleMapController? _controller;
  bool _mapCreated = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Debugger'),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            color: Colors.grey[300],
            child: Stack(
              children: [
                // Show a background in case map doesn't load
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.map_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Loading map...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // The map
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(28.2096, 83.9856), // Pokhara
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    setState(() {
                      _mapCreated = true;
                    });
                    print("Map was created successfully!");
                  },
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                ),
                
                if (!_mapCreated)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Map Status: ${_mapCreated ? 'Created Successfully' : 'Loading...'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _mapCreated ? Colors.green : Colors.orange,
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_controller != null) {
                      _controller!.animateCamera(
                        CameraUpdate.newLatLng(const LatLng(28.2096, 83.9856)),
                      );
                    }
                  },
                  child: const Text('Center on Pokhara'),
                ),
                const SizedBox(height: 8),
                Text('API Key used: ${getApiKeyIndicator()}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // This will force rebuild the widget
                    });
                  },
                  child: const Text('Refresh Map'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getApiKeyIndicator() {
    // Don't show the actual key for security reasons
    return 'AIzaSyB......Y1A (${isKeyComplete() ? 'Complete' : 'Incomplete'})';
  }

  bool isKeyComplete() {
    const String key = 'AIzaSyBemVpM6CJK1YnBXe7znQJlFZMN_dL5Y1A';
    return key.length >= 30;
  }
}