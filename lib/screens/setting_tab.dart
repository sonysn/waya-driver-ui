import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/api/auth.dart';
import 'package:waya_driver/functions/location_functions.dart';
import 'package:waya_driver/screens/bookings.dart';
import 'package:waya_driver/screens/homepage.dart';
import 'package:waya_driver/screens/legalpage.dart';
import 'package:waya_driver/screens/settingspage.dart';
import 'package:waya_driver/screens/messages.dart';
import 'package:waya_driver/screens/welcomepage.dart';
import 'package:waya_driver/screens/help.dart';
import 'package:waya_driver/sockets/sockets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingTab extends StatefulWidget {
  final dynamic data;

  const SettingTab({Key? key, this.data}) : super(key: key);

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  // Future<void> setSwitchValue(bool value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isOnline', value);
  // }
  void _initOnlineStatus() {
    //!Info: This is from the home page
    if (onlineStatus) {
      //print(true);
      ConnectToServer().connect(widget.data.id, context);
    } else {
      //print(false);
      ConnectToServer().disconnect();
    }
  }

  @override
  void initState() {
    super.initState();
    _initOnlineStatus();
  }

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
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
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
                    GestureDetector(
                      child: Card(
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
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SettingsPage(data: widget.data);
                        }));
                      },
                    ),
                    GestureDetector(
                      child: Card(
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
                              Icon(Icons.history),
                              Text('Trips')
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const BookingPage();
                        }));
                      },
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text('offline'),
                //     Switch.adaptive(
                //         activeTrackColor: Colors.yellow,
                //         activeColor: Colors.white,
                //         value: onlineStatus,
                //         onChanged: (value) async {
                //           setState(() => onlineStatus = value);
                //           // Store the value of the switch
                //           await setSwitchValue(value);
                //           if (onlineStatus == false) {
                //             cancelLocationCallbacks();
                //             ConnectToServer().disconnect();
                //             updateAvailability(0, widget.data.id);
                //           } else {
                //             ConnectToServer().connect(widget.data.id, context);
                //             locationCallbacks(widget.data.id);
                //             updateAvailability(1, widget.data.id);
                //           }
                //         }),
                //     const Text('online')
                //   ],
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const MessagesPage();
                    }));
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.mail_outline,
                      color: Colors.black,
                    ),
                    title: Text("Messages"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const HelpPage();
                    }));
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.mail_outline,
                      color: Colors.black,
                    ),
                    title: Text("Help"),
                  ),
                ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const LegalPage();
                    }));
              },
              child:const ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  title: Text("Legal"),
                ),),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    //define functions
                    void nav() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomePage()),
                      );
                    }

                    void showSnackBar(String message) {
                      final snackBar = SnackBar(
                        content: Text(message),
                        duration: const Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    logout() async {
                      try {
                        final response = await logOut(widget.data.id);
                        if (response == 'logout success') {
                          await cancelLocationCallbacks();
                          await ConnectToServer().disconnect();
                          await updateAvailability(0, widget.data.id);
                          // Remove the content of emailOrPhone and password
                          await prefs.remove('emailOrPhone');
                          await prefs.remove('password');
                          await prefs.remove('deviceID');
                          await prefs.remove('driverID');
                          await prefs.remove('isOnline');
                          nav();
                        }
                      } on SocketException catch (e) {
                        debugPrint(e.toString());
                        showSnackBar(
                            'Logout failed. Please check your internet connection.');
                      } on TimeoutException catch (e) {
                        debugPrint(e.toString());
                        showSnackBar(
                            'Request timed out. Please try again later.');
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    }

                    logout();
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    title: Text("Logout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
