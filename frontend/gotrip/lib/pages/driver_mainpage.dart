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
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    DriverBookingsPage(),
    DriverProfilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
