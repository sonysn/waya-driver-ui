import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waya_driver/functions/location_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:waya_driver/functions/notification_service.dart';

import '../api/actions.dart';
import '../sockets/sockets.dart';

class HomePage extends StatefulWidget {
  dynamic data;

  HomePage({Key? key, this.data}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//DO NOT DISTURB
String? vehicleName;
String? vehiclePlateNumber;
String? vehicleColour;
String? vehicleBodyType;
String? driverPhone;
String? driverPhoto;

class _HomePageState extends State<HomePage> {
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
    // location.enableBackgroundMode(enable: true);
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

  Future getCar() async {
    final res = await getDriverCars(widget.data.id, widget.data.token);
    setState(() {
      vehicleName =
          "${res['result'][0]['VEHICLE_MAKE']}, ${res['result'][0]['VEHICLE_MODEL']}";
      vehiclePlateNumber = res['result'][0]['VEHICLE_PLATE_NUMBER'];
      vehicleColour = res['result'][0]['VEHICLE_COLOUR'];
      vehicleBodyType = res['result'][0]['VEHICLE_BODY_TYPE'];
      driverPhone = widget.data.phoneNumber;
      driverPhoto = widget.data.profilePhoto;
    });
    debugPrint(vehicleName);
    debugPrint(vehicleBodyType);
  }

  Future<void> setSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnline', value);
  }

  Future<void> getSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isOnlineSaved = prefs.getBool('isOnline');

    if (isOnlineSaved == null) {
      setState(() {
        onlineStatus = false;
      });
    } else {
      setState(() {
        onlineStatus = isOnlineSaved;
      });
    }
    if (isOnlineSaved == true) {
      // ignore: no_leading_underscores_for_local_identifiers
      void _connect() {
        ConnectToServer().connect(widget.data.id, context);
      }

      _connect();
      locationCallbacks(widget.data.id, widget.data.verified);
      updateAvailability(1, widget.data.id);
      getCar();
      await setSwitchValue(onlineStatus);
      timedPing();
    }
  }

  dynamic currentLocation;
  StreamController controller = StreamController();
  bool onlineStatus = false;
  DateTime?
      _lastPressedAt; // for tracking the time of the last back button press

  @override
  void initState() {
    super.initState();
    //findLoc();
    locationPingServer();
    getSwitchValue();
    //getCar();

    // Request permission for receiving push notifications (only for iOS)
    FirebaseMessaging.instance.requestPermission();

    // Configure Firebase Messaging & Show Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      NotificationService().showNotification('${message.notification?.title}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 2)) {
          // show a toast or snackbar to inform the user to press back again to exit
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ));
          _lastPressedAt = DateTime.now();
          return false; // prevent the app from closing
        }
        return true; // allow the app to close
      },
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //todo fix this error
                      widget.data.profilePhoto != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${widget.data.profilePhoto}'),
                              radius: 30.0,
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 30.0,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.data.firstName} ${widget.data.lastName}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star),
                              Text(
                                widget.data.rating.toString(),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        onlineStatus = !onlineStatus;
                      });

                      if (onlineStatus) {
                        ConnectToServer().connect(widget.data.id, context);
                        locationCallbacks(widget.data.id, widget.data.verified);
                        updateAvailability(1, widget.data.id);
                        getCar();
                        await setSwitchValue(onlineStatus);
                        timedPing();
                      } else {
                        cancelLocationCallbacks();
                        ConnectToServer().disconnect();
                        updateAvailability(0, widget.data.id);
                        await setSwitchValue(onlineStatus);
                        timedPing();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                          colors: onlineStatus
                              ? [
                                  const Color(0xFF1BE611),
                                  const Color(0xFF21E672)
                                ]
                              : [
                                  const Color(0xFFE62121),
                                  const Color(0xFFE66565)
                                ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Icon(
                                onlineStatus
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                onlineStatus
                                    ? Icons.toggle_on
                                    : Icons.toggle_off,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              onlineStatus ? 'Online' : 'Offline',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (BuildContext context) {
                      //       return const MessagesNotificationPage();
                      //     }));
                    },
                    child: const SizedBox(
                      height: 30,
                      //width: 20,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Card(
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                          bottom: Radius.circular(15),
                        ),
                        //      side: BorderSide(color: Colors.yellow, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Trips Summary',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
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
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                              bottom: Radius.circular(15),
                            ),
                            //      side: BorderSide(color: Colors.yellow, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.wallet),
                                const SizedBox(
                                  width: 75,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Your Balance',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "₦${widget.data.accountBalance}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                              bottom: Radius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      'https://www.sygic.com/blog/2019/we-have-android-smartphone-in-dash-connectivity-but-not-for-android-auto/web-blog.jpg',
                                      fit: BoxFit.fill,
                                      height: 120,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /* return Scaffold(
   body: ListView(
    children: [
       Stack(children: [
            Container(
              //color: Colors.yellow,
              height: 120,
              decoration: const BoxDecoration(
                  color: Colors.yellow,
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
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      //todo fix this error
                      widget.data.profilePhoto != null
                          ? CircleAvatar(
                        backgroundImage: NetworkImage('${widget.data
                            .profilePhoto}'),
                        radius: 30.0,
                      ) : const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 30.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.data.firstName} ${widget.data.lastName}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star),
                              Text(
                                widget.data.rating.toString(),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 1.1,
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
    );*/
}
