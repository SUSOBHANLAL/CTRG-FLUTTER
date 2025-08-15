// screens/bottom_navigation.dart

import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/sessions_screen.dart';
import 'home_screen.dart';
import 'schedule_screen.dart';
import 'map_screen.dart';
import 'venue_screen.dart';
import 'contact_us_screen.dart';
import 'logout_screen.dart';

class BottomNavigation extends StatefulWidget {
  final String userId;
  final String phone;
  final String deviceId;
  final String osType;

  const BottomNavigation({
    super.key,
    required this.userId,
    required this.phone,
    required this.deviceId,
    required this.osType,
  });

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        userId: widget.userId,
        phone: widget.phone,
        deviceId: widget.deviceId,
        osType: widget.osType,
      ),
      ScheduleScreen(),
      MapScreen(),
      VenueScreen(),
      SessionsScreen(),
      ContactUsScreen(),
      LogoutScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        iconSize: 28,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_outlined),
            activeIcon: Icon(Icons.location_city),
            label: 'Venue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Session',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings_outlined),
          //   activeIcon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
      ),
    );
  }
}
