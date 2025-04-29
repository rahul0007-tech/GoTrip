// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../network/http_client.dart'; // Import your Dio HTTP client
// import '../bookings_by_location_page.dart'; // Import the BookingDetailsPage
// import '../../model/booking_model/booking_model.dart'; // Import your model

// class SearchPage extends StatefulWidget {
//   const SearchPage({Key? key}) : super(key: key);

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   bool _isLoading = true;
//   List<LocationModel> _locations = [];
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocations();
//   }

//   Future<void> _fetchLocations() async {
//     try {
//       // Using your Dio HTTP client
//       final response = await httpClient.get('/bookings/search-location/');
      
//       // Dio automatically parses JSON and puts the data in response.data
//       if (response.statusCode == 200) {
//         final List<dynamic> locationsJson = response.data;
        
//         // Convert JSON to your model objects
//         setState(() {
//           _locations = locationsJson
//               .map((location) => LocationModel(
//                     id: int.parse(location['id'].toString()),
//                     name: location['name'].toString(),
//                     fare: double.parse(location['fare'].toString()),
//                   ))
//               .toList();
//           _isLoading = false;
//         });
//       } else if (response.statusCode == 404) {
//         // Handle the specific case when no locations are found
//         setState(() {
//           _error = 'No locations found';
//           _isLoading = false;
//         });
//       } else {
//         // Handle other error statuses
//         setState(() {
//           _error = 'Failed to load locations. Status code: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } on DioException catch (e) {
//       // Handle Dio specific errors
//       setState(() {
//         if (e.response != null) {
//           // The request was made and the server responded with a status code
//           // that falls out of the range of 2xx
//           _error = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
//         } else if (e.type == DioExceptionType.connectionTimeout ||
//                   e.type == DioExceptionType.receiveTimeout) {
//           _error = 'Connection timeout. Please check your internet connection.';
//         } else {
//           _error = 'Error: ${e.message}';
//         }
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Exception: ${e.toString()}';
//         _isLoading = false;
//       });
//     }
//   }

//   void _onLocationSelected(LocationModel location) {
//     // Navigate to BookingDetailsPage
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => BookingDetailsPage(
//           locationId: location.id,
//           locationName: location.name,
//         ),
//       ),
//     );
//   }

//   // Helper method to format fare
//   String formatFare(double fare) {
//     return '\$${fare.toStringAsFixed(2)}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Available Locations'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Select a Location',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : _error != null
//                     ? Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
//                     : Expanded(
//                         child: _locations.isEmpty
//                             ? Center(child: Text('No locations available'))
//                             : ListView.builder(
//                                 itemCount: _locations.length,
//                                 itemBuilder: (context, index) {
//                                   final location = _locations[index];
//                                   return Card(
//                                     margin: EdgeInsets.symmetric(vertical: 8),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: ListTile(
//                                       contentPadding: EdgeInsets.all(12),
//                                       title: Text(
//                                         location.name,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       subtitle: Text(
//                                         'Fare: ${formatFare(location.fare)}',
//                                         style: TextStyle(fontSize: 14),
//                                       ),
//                                       trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
//                                       onTap: () => _onLocationSelected(location),
//                                     ),
//                                   );
//                                 },
//                               ),
//                       ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../network/http_client.dart';
import '../bookings_by_location_page.dart';
import '../../model/booking_model/booking_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<LocationModel> _locations = [];
  String? _error;
  TextEditingController _searchController = TextEditingController();
  List<LocationModel> _filteredLocations = [];
  AnimationController? _animationController;
  final List<String> _imagePlaceholders = [
    'asset/images/destination1.jpg',
    'asset/images/destination2.jpg',
    'asset/images/destination3.jpg',
    'asset/images/destination4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    
    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    
    // Fetch locations data
    _fetchLocations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = List.from(_locations);
      } else {
        _filteredLocations = _locations
            .where((location) =>
                location.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await httpClient.get('/bookings/search-location/');
      
      if (response.statusCode == 200) {
        final List<dynamic> locationsJson = response.data;
        
        setState(() {
          _locations = locationsJson
              .map((location) => LocationModel(
                    id: int.parse(location['id'].toString()),
                    name: location['name'].toString(),
                    fare: double.parse(location['fare'].toString()),
                    locationImage: location['location_image']?.toString(),
                  ))
              .toList();
          _filteredLocations = List.from(_locations);
          _isLoading = false;
        });
        
        // Start the animation after data is loaded
        _animationController?.forward();
      } else if (response.statusCode == 404) {
        setState(() {
          _error = 'No locations found';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load locations. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        if (e.response != null) {
          _error = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
        } else if (e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout) {
          _error = 'Connection timeout. Please check your internet connection.';
        } else {
          _error = 'Error: ${e.message}';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Exception: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onLocationSelected(LocationModel location) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingDetailsPage(
          locationId: location.id,
          locationName: location.name,
        ),
      ),
    );
  }

  String formatFare(double fare) {
    return '\$${fare.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Curved app bar with gradient
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2A9D8F),
                      Color(0xFF264653),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      left: -60,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Explore",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.refresh, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _fetchLocations();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Discover amazing destinations",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 25),
                            // Search container
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: _filterLocations,
                                decoration: InputDecoration(
                                  hintText: 'Where would you like to go?',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF2A9D8F),
                                    size: 22,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            _filterLocations('');
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Destinations header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF2A9D8F),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Popular Destinations",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Main content
          _isLoading
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2A9D8F)),
                            strokeWidth: 3,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Finding the best destinations for you...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _error != null
                  ? SliverFillRemaining(child: _buildErrorState())
                  : _filteredLocations.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState())
                      : SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final location = _filteredLocations[index];
                                
                                // Changed the animation implementation to prevent errors
                                if (_animationController == null) {
                                  return _buildLocationCard(location, index);
                                }
                                
                                return FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _animationController!,
                                      curve: Interval(
                                        (index * 0.1).clamp(0.0, 0.9),
                                        ((index * 0.1) + 0.6).clamp(0.0, 1.0),
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  ),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(0, 0.2),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _animationController!,
                                        curve: Interval(
                                          (index * 0.1).clamp(0.0, 0.9),
                                          ((index * 0.1) + 0.6).clamp(0.0, 1.0),
                                          curve: Curves.easeOut,
                                        ),
                                      ),
                                    ),
                                    child: _buildLocationCard(location, index),
                                  ),
                                );
                              },
                              childCount: _filteredLocations.length,
                            ),
                          ),
                        ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(LocationModel location, int index) {
    // Get fallback image if location image is null
    final fallbackImage = _imagePlaceholders[index % _imagePlaceholders.length];
    
    return Container(
      height: 220,
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onLocationSelected(location),
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image - using CachedNetworkImage for real API images
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: location.locationImage != null
                    ? CachedNetworkImage(
                        imageUrl: location.locationImage!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 220,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2A9D8F),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          fallbackImage,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        fallbackImage,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "4.${(location.id * 7) % 10}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A9D8F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            formatFare(location.fare),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      location.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${(location.id * 5) % 100 + 50} km away",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Top right bookmark icon
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red[300],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              _error!,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _fetchLocations();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                "Try Again",
                style: TextStyle(fontSize: 16),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2A9D8F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 70,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 30),
          Text(
            "No destinations found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "We couldn't find any destinations matching your search",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              _filterLocations('');
            },
            icon: Icon(Icons.refresh),
            label: Text(
              "Clear Search",
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2A9D8F),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}