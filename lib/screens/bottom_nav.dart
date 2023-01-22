import 'package:flutter/material.dart';
import 'package:waya_driver/screens/bookings.dart';
import 'package:waya_driver/screens/mapspage.dart';
import 'package:waya_driver/screens/settings.dart';
import '/colorscheme.dart';
import 'homepage.dart';

class BottomNavPage extends StatefulWidget {

  const BottomNavPage({Key? key}) : super(key: key);

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 0;
  static const List<Widget> _childrenPages = <Widget>[
    HomePage(),
    MapsPage(),
    BookingsPage(),
    Settings()
  ];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _childrenPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //this disables the bottomNavBarItem label
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.yellow,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        //type allows you have more than 1 item in bottom navigator
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_sharp),
              label: 'Maps'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph), label: 'Earnings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
