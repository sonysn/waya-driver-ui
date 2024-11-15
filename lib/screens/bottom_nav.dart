import 'package:flutter/material.dart';
import 'package:qunot_driver/screens/mapspage.dart';
import 'package:qunot_driver/screens/setting_tab.dart';
import 'package:qunot_driver/screens/walletpage.dart';
import 'package:qunot_driver/colorscheme.dart';
import 'package:qunot_driver/screens/homepage.dart';

class BottomNavPage extends StatefulWidget {
  final dynamic data;

  const BottomNavPage({Key? key, required this.data}) : super(key: key);

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 0;
  dynamic data;
  late final List<Widget> _childrenPages = <Widget>[
    HomePage(
      data: data,
    ),
    MapsPage(
      driverID: data.id,
    ),
    WalletPage(
      data: data,
    ),
    SettingTab(
      data: data,
    )
  ];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;
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
        selectedItemColor: customPurple,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        //type allows you have more than 1 item in bottom navigator
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: 'Maps'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph), label: 'Earnings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
