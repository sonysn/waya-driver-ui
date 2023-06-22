import 'package:flutter/material.dart';
import 'package:waya_driver/screens/passwordsettings.dart';
import 'package:waya_driver/screens/privacypolicy.dart';
import 'package:waya_driver/screens/vehicle.dart';
import 'package:waya_driver/screens/aboutpage.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final dynamic data;
  const SettingsPage({Key? key, required this.data}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          GestureDetector(
            child: const ListTile(
                leading: Icon(
                  Icons.key_outlined,
                  color: Colors.black,
                ),
                title: Text("Vehicles")),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return Vehicle(data: widget.data);
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.security,
              color: Colors.black,
            ),
            title: const Text('Security'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return PasswordSettings(
                    driverID: widget.data.id, authToken: widget.data.authToken);
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip,
              color: Colors.black,
            ),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const DriverPrivacyPolicyPage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.black,
            ),
            title: const Text('About'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const AboutPage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.web,
              color: Colors.black,
            ),
            title: const Text('Website'),
            onTap: () {
              // Open the website link
              //Example:
              // ignore: deprecated_member_use
              launch('https://www.qunot.com');
            },
          ),
        ],
      ),
    );
  }
}
