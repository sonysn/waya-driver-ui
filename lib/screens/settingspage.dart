import 'package:flutter/material.dart';
import 'package:waya_driver/screens/vehicle.dart';
import 'package:waya_driver/screens/notification.dart';
import 'package:waya_driver/screens/aboutpage.dart';
import '../main.dart';
import 'package:url_launcher/url_launcher.dart';
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
                  color: Colors.black,

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
            leading: Icon(Icons.security,       color: Colors.black,),
            title: Text('Privacy & Security'),
            onTap: () {
              // Navigate to the Privacy & Security screen
            },
          ),

          ListTile(
            leading: Icon(Icons.info,       color: Colors.black,),
            title: Text('About'),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const AboutPage(
                
                    );
                  }));
            },
          ),
          ListTile(
            leading: Icon(Icons.web,       color: Colors.black,),
            title: Text('Website'),
            onTap: () {
              // Open the website link
               Example: launch('https://www.qunot.com');
            },
          ),
        ],
      ),
    );
  }
}



