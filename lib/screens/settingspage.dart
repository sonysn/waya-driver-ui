import 'package:flutter/material.dart';
import 'package:waya_driver/screens/vehicle.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  dynamic data;
  SettingsPage({Key? key, this.data}) : super(key: key);

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
        title: Text(
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

                ),
                title: Text("Vehicles")
            ),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return Vehicle(
                        data: widget.data
                    );
                  }));
            },
          ),

          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification Settings'),
            onTap: () {
              // Navigate to the Notification Settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacy & Security'),
            onTap: () {
              // Navigate to the Privacy & Security screen
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Navigate to the Language selection screen
            },
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Navigate to the About screen
            },
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text('Website'),
            onTap: () {
              // Open the website link
              // Example: launch('https://www.example.com');
            },
          ),
        ],
      ),
    );
  }
}



