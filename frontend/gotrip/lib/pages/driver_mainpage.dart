// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gotrip/pages/driver_main_pages.dart/driver_bookingpage.dart';
// import 'package:gotrip/pages/driver_main_pages.dart/driver_homepage.dart';
// import 'package:gotrip/pages/driver_main_pages.dart/driver_profilepage.dart';
// import 'package:gotrip/pages/driver_main_pages.dart/driver_searchpage.dart';

// class DriverMainPage extends StatefulWidget {
//   @override
//   _DriverMainPageState createState() => _DriverMainPageState();
// }

// class _DriverMainPageState extends State<DriverMainPage> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     HomePage(),
//     SearchPage(),
//     DriverBookingsPage(),
//     DriverProfilepage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Bookings',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/pages/driver_main_pages.dart/driver_bookingpage.dart';
import 'package:gotrip/pages/driver_main_pages.dart/driver_homepage.dart';
import 'package:gotrip/pages/driver_main_pages.dart/driver_profilepage.dart';
import 'package:gotrip/pages/driver_main_pages.dart/driver_searchpage.dart';

class DriverMainPage extends StatefulWidget {
  @override
  _DriverMainPageState createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage> {
  int _currentIndex = 2; // Start with the search tab selected

  final List<Widget> _pages = [
    DriverHomePage(),
    DriverBookingsPage(), // Document/list page
    SearchPage(),         // Search/discovery page (now in middle)
    DriverProfilepage(),  // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Color(0xFF004D40), // Dark teal color for background
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home_outlined),
              _buildNavItem(1, Icons.article_outlined),
              _buildNavItem(2, Icons.search, isHighlighted: true),
              _buildNavItem(3, Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, {bool isHighlighted = false}) {
    final bool isSelected = _currentIndex == index;
    
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF00796B) : Colors.transparent, // Lighter green for active icon
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}