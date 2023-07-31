import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qunot_driver/api/actions.dart';
import 'package:qunot_driver/sockets/sockets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

StreamSubscription<LocationData>? _subscription;

locationCallbacks(
    {required int id,
    required int verificationStatus,
    required List driverDestPoint}) async {
  Location location = Location();
  location.enableBackgroundMode(enable: true);

  if (verificationStatus == 1) {
    bool verificationStatus = true;
    _subscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      ConnectToServer().sendDriverLocation(
        data: LatLng(double.parse(currentLocation.latitude.toString()),
            double.parse(currentLocation.longitude.toString())),
        id: id,
        verificationStatus: verificationStatus,
        driverDestPoint: driverDestPoint,
      );
    });
  } else {
    bool verificationStatus = false;
    _subscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      ConnectToServer().sendDriverLocation(
        data: LatLng(double.parse(currentLocation.latitude.toString()),
            double.parse(currentLocation.longitude.toString())),
        id: id,
        verificationStatus: verificationStatus,
        driverDestPoint: driverDestPoint,
      );
    });
  }
}

cancelLocationCallbacks() {
  _subscription?.cancel();
}

Future locationPingServer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('driverID');
  DateTime now = DateTime.now();
  String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  debugPrint("Driver saved id is ${id!}");
  try {
    Location location = Location();
    LocationData locationDataSpot;
    locationDataSpot = await location.getLocation();
    //location.enableBackgroundMode(enable: true);
    LatLng data = LatLng(double.parse(locationDataSpot.latitude.toString()),
        double.parse(locationDataSpot.longitude.toString()));
    await locationPing(
        driverID: id, locationPoint: data, timeStamp: formattedDateTime);
    debugPrint("Sent to Server at: $formattedDateTime");
  } catch (e) {
    debugPrint(e.toString());
  }
}

void timedPing() {
  Timer.periodic(const Duration(minutes: 30), (timer) {
    // Code to repeat every 30 minutes
    locationPingServer();
  });
}
