import 'dart:io';

import 'package:flutter/material.dart';
import 'package:waya_driver/functions/location_functions.dart';
import 'package:waya_driver/sockets/sockets.dart';

class Settings extends StatefulWidget {
  dynamic data;
  Settings({Key? key, this.data}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

bool onlineStatus = false;

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.data.firstName} \n${widget.data.lastName}',
                      style:
                      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: (){
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (BuildContext context) {
                        //       return const EditProfilePage();
                        //     }));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                //this checks if profileImageUrl is null and returns blank profile picture from this link todo set this to asset image
                                image: widget.data.profilePhoto != null
                                    ? NetworkImage(widget.data.profilePhoto)
                                    : const NetworkImage(
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'))),
                      ),
                    )
                      ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Card(
                      color: Colors.white70,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                          bottom: Radius.circular(15),
                        ),
                      ),
                      child: SizedBox(
                        height: 80,
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.settings),
                            Text('Settings')
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                          bottom: Radius.circular(15),
                        ),
                      ),
                      child: SizedBox(
                        height: 80,
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.history), Text('Trips')],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                          bottom: Radius.circular(15),
                        ),
                      ),
                      child: SizedBox(
                        height: 80,
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.wallet), Text('Wallet')],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('offline'),
                    Switch.adaptive(
                        activeTrackColor: Colors.yellow,
                        activeColor: Colors.white,
                        value: onlineStatus,
                        onChanged: (value) {
                          setState(() => onlineStatus = value);
                          if(onlineStatus == false){
                            cancelLocationCallbacks();
                            ConnectToServer().disconnect();
                          } else {
                            ConnectToServer().connect();
                            locationCallbacks();
                          }
                        }),
                    const Text('online')
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //       return const MessagesNotificationPage();
                    //     }));
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.mail_outline,
                      color: Colors.black,
                    ),
                    title: Text("Messages"),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    color: Colors.black,
                  ),
                  title: Text("Help"),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  title: Text("Legal"),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text("Logout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}