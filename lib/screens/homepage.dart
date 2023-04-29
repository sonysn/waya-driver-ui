import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waya_driver/colorscheme.dart';
import 'package:waya_driver/functions/location_functions.dart';
import 'package:waya_driver/screens/setting_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/actions.dart';
import '../sockets/sockets.dart';

class HomePage extends StatefulWidget {
  final dynamic data;

  const HomePage({Key? key, this.data}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  void findLoc() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationDataSpot;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationDataSpot = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    //check if widget is mounted
    if (mounted) {
      setState(() {
        currentLocation = LatLng(
            double.parse(locationDataSpot.latitude.toString()),
            double.parse(locationDataSpot.longitude.toString()));
        //mapController.move(myLocationHome, 17);
      });
    }
    print(currentLocation);
  }

  dynamic currentLocation;
  StreamController controller = StreamController();

  @override
  void initState() {
    super.initState();
    // Retrieve the stored value of the switch
    getSwitchValue();
    findLoc();
  }

  Future<void> getSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnline = prefs.getBool('isOnline') ?? false;
    setState(() {
      onlineStatus = isOnline;
    });
    if (onlineStatus == false) {
      cancelLocationCallbacks();
      ConnectToServer().disconnect();
      updateAvailability(0, widget.data.id);
    } else {
      ConnectToServer().connect(widget.data.id, context);
      locationCallbacks(widget.data.id);
      updateAvailability(1, widget.data.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(children: [
            Container(
              //color: Colors.yellow,
              height: 120,
              decoration: const BoxDecoration(
                  color: customPurple,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      //todo fix this error
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white,
                        child: widget.data.profilePhoto != "null"
                            ? ClipOval(
                                child: Image.network(
                                  '${widget.data.profilePhoto}',
                                  fit: BoxFit.cover,
                                  width: 60.0,
                                  height: 60.0,
                                ),
                              )
                            : const Icon(
                                Icons.account_circle,
                                size: 60.0,
                                color: Colors.black,
                              ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.data.firstName} ${widget.data.lastName}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text(
                                widget.data.rating.toString(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Earned Today'),
                                Text(
                                  '£250.65',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Total Trips'),
                                    Text(
                                      '15',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Time Online'),
                                    Text(
                                      '15h 30m',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Total Distance'),
                                    Text(
                                      '45 km',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}
