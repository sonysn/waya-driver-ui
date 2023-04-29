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
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style:
                  TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
