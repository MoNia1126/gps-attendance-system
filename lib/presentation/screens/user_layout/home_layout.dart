import 'package:flutter/material.dart';
import 'package:gps_attendance_system/presentation/screens/home/check_in.dart';
import 'package:gps_attendance_system/presentation/screens/leaves/leaves_page.dart';
import 'package:gps_attendance_system/presentation/screens/profile/profile_page.dart';

final List<Widget> screens = [
  const Attendance(),
  const LeavesPage(),
  const ProfilePage(),
];

List<String> titles = [
  'Home',
  'Leaves',
  'Profile',
];

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Leaves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: screens[_currentIndex],
    );
  }
}
