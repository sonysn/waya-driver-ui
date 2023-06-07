import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waya_driver/functions/location_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waya_driver/screens/widgets/transaction_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:waya_driver/functions/notification_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../colorscheme.dart';
import '../api/actions.dart';
import '../sockets/sockets.dart';
import 'package:waya_driver/screens/widgets/activeride.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as locationGeocodingPackage;

class HomePage extends StatefulWidget {
  dynamic data;

  HomePage({Key? key, this.data}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//!DO NOT DISTURB
String? vehicleName;
String? vehiclePlateNumber;
String? vehicleColour;
String? vehicleBodyType;
String? driverPhone;
String? driverPhoto;
int? driverID;
bool onlineStatus = false;

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
      driverID = widget.data.id;
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
      locationCallbacks(
          id: widget.data.id,
          verificationStatus: widget.data.verified,
          driverDestPoint: driverDestLatLng!);
      updateAvailability(1, widget.data.id);
      getCar();
      await setSwitchValue(onlineStatus);
      timedPing();
    }
  }

  Future<void> getCurrentRides() async {
    final response = await driverGetCurrentRides(driverID: widget.data.id);
    setState(() {
      // currentRidesArray.add(response);
      currentRidesArray = response;
    });
    print(currentRidesArray);
  }

  Future<void> getApikey() async {
    const url = 'https://sea-lion-app-m46xn.ondigitalocean.app/getAPIKEY';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        gApiKey = data['KEY'];
      });
      // print(data['KEY']);
    }
  }

  Future<void> _fetchSuggestions(String input) async {
    String apiKey = gApiKey!; // Replace with your own API key
    const countryCode = "NG";
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:$countryCode&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List<dynamic>;
      final suggestions = predictions
          .map((prediction) => prediction['description'] as String)
          .toList();

      setState(() {
        _suggestions = suggestions;
      });
    }
  }

  Future getDriverDestinationCoordinates({required String address}) async {
    try {
      List<locationGeocodingPackage.Location> locations =
          await locationGeocodingPackage.locationFromAddress(address);
      print(locations[0].latitude);
      print(locations[0].longitude);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('driverDestinationPoint', [
        locations[0].latitude.toString(),
        locations[0].longitude.toString()
      ]);
      await prefs.setString('driverDestinationAddress', address);
    } catch (e) {
      print('Error getting location from address: $e');
      return null;
    }
  }

  void getDriverDestData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('driverDestinationAddress');
    if (address != null) {
      setState(() {
        driverDestinationLocationController.text = address;
      });
    }
  }

  void clearDriverDestData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('driverDestinationPoint', []);
    await prefs.remove('driverDestinationAddress');
    setLatLng();
  }

  void setLatLng() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List? p = prefs.getStringList('driverDestinationPoint');
    setState(() {
      driverDestLatLng = p;
    });
  }

  dynamic currentLocation;
  String? gApiKey;
  DateTime?
      _lastPressedAt; // for tracking the time of the last back button press
  List currentRidesArray = [];
  List<String> _suggestions = [];
  TextEditingController driverDestinationLocationController =
      TextEditingController();
  List? driverDestLatLng;

  @override
  void initState() {
    super.initState();
    //findLoc();
    //setLatLng();
    getDriverDestData();
    locationPingServer();
    getSwitchValue();
    getCurrentRides();
    //getCar();
    getApikey();

    // Request permission for receiving push notifications (only for iOS)
    FirebaseMessaging.instance.requestPermission();

    // Configure Firebase Messaging & Show Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      NotificationService().showRideNotification(
          dataTitle: '${message.notification?.title}',
          dataBody: '${message.notification?.body}');
    });
  }

  Future _refreshItems() async {
    await getCurrentRides();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isDestinationSet = false;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: Colors.orangeAccent,
        backgroundColor: customPurple,
        onRefresh: _refreshItems,
        child: WillPopScope(
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
              body: ListView(children: [
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
                                  backgroundImage: NetworkImage(
                                      '${widget.data.profilePhoto}'),
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
                            // ... online status logic ...
                            ConnectToServer().connect(widget.data.id, context);
                            locationCallbacks(
                                id: widget.data.id,
                                verificationStatus: widget.data.verified,
                                driverDestPoint: driverDestLatLng!);
                            updateAvailability(1, widget.data.id);
                            getCar();
                            locationPingServer();
                            await setSwitchValue(onlineStatus);
                            timedPing();
                          } else {
                            // ... offline status logic ...
                            cancelLocationCallbacks();
                            ConnectToServer().disconnect();
                            updateAvailability(0, widget.data.id);
                            await setSwitchValue(onlineStatus);
                            locationPingServer();
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
                          height: 15,
                        ),
                      ),
                      AbsorbPointer(
                        absorbing: onlineStatus,
                        child: Listener(
                          behavior: HitTestBehavior.opaque,
                          onPointerDown: (event) {
                            if (onlineStatus) {
                              // Prevent pointer events when online
                              return;
                            }
                            // Handle pointer events as usual
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                TextFormField(
                                  controller:
                                      driverDestinationLocationController,
                                  onChanged: _fetchSuggestions,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    hintText: 'Enter destination',
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: SizedBox(
                                        width: 12.0,
                                        height: 24.0,
                                        child: Icon(
                                          Icons.location_on,
                                          color: onlineStatus
                                              ? Colors.black
                                              : Colors.orangeAccent,
                                        ),
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        driverDestinationLocationController
                                            .clear();
                                        clearDriverDestData();
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 68.0),
                                        child: Icon(
                                          Icons.clear,
                                          color: onlineStatus
                                              ? Colors.black
                                              : Colors.orangeAccent,
                                        ),
                                      ),
                                    ),
                                    fillColor: Colors.grey[150],
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  readOnly:
                                      onlineStatus, // Make the TextFormField read-only when online
                                  showCursor:
                                      !onlineStatus, // Hide the cursor when online
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 60.0,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: onlineStatus
                                          ? Colors.grey
                                          : Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (onlineStatus ||
                                            driverDestinationLocationController
                                                .text.isEmpty) {
                                          // Prevent button click when online or text field is empty
                                          return;
                                        }
                                        await getDriverDestinationCoordinates(
                                          address:
                                              driverDestinationLocationController
                                                  .text,
                                        );
                                        setLatLng();

                                        setState(() {
                                          isDestinationSet =
                                              true; // Set the flag to true when the destination is set
                                        });

                                        // Show the flash message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            content: Row(
                                              children: const [
                                                Icon(Icons.check,
                                                    color: Colors.white),
                                                SizedBox(width: 8.0),
                                                Text('Destination set'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Center(
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_suggestions.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 56.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    constraints:
                                        const BoxConstraints(maxHeight: 200),
                                    child: ListView.builder(
                                      itemCount: _suggestions.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: const SizedBox(
                                            width: 24.0,
                                            height: 24.0,
                                            child: Icon(Icons.location_on,
                                                color: Colors.orangeAccent),
                                          ),
                                          title: Text(_suggestions[index]),
                                          onTap: () {
                                            driverDestinationLocationController
                                                .text = _suggestions[index];
                                            setState(() {
                                              _suggestions = [];
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                                bottom: Radius.circular(15),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [customPurple, Colors.orangeAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                  bottom: Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.wallet,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Your Balance',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "₦${widget.data.accountBalance}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                        child: Card(
                          elevation: 15,
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "https://img.freepik.com/premium-vector/taxi-city_1270-526.jpg?w=2000",
                                    ),
                                  ),
                                ),
                              ),
                              FutureBuilder(
                                future: Future.delayed(const Duration(
                                    milliseconds: 500)), // Simulating a delay
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.orangeAccent),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(); // Render nothing when image is loaded
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DriverWidget(
                        data: widget.data,
                      ),
                    ],
                  ),
                ),
              ]),
            )));
  }
}
