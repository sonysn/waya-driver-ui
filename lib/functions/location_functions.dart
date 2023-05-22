import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/sockets/sockets.dart';
import 'package:shared_preferences/shared_preferences.dart';

StreamSubscription<LocationData>? _subscription;

locationCallbacks(id, verificationStatus) async {
  Location location = Location();
  location.enableBackgroundMode(enable: true);

  if (verificationStatus == 1) {
    bool verificationStatus = true;
    _subscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      ConnectToServer().sendDriverLocation(
          LatLng(double.parse(currentLocation.latitude.toString()),
              double.parse(currentLocation.longitude.toString())),
          id,
          verificationStatus);
    });
  } else {
    bool verificationStatus = false;
    _subscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      ConnectToServer().sendDriverLocation(
          LatLng(double.parse(currentLocation.latitude.toString()),
              double.parse(currentLocation.longitude.toString())),
          id,
          verificationStatus);
    });
  }
}

cancelLocationCallbacks() {
  _subscription?.cancel();
}

Future locationPingServer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('driverID');
  debugPrint("Driver saved id is ${id!}");
  try {
    Location location = Location();
    LocationData locationDataSpot;
    locationDataSpot = await location.getLocation();
    //location.enableBackgroundMode(enable: true);
    LatLng data = LatLng(double.parse(locationDataSpot.latitude.toString()),
        double.parse(locationDataSpot.longitude.toString()));
    await locationPing(driverID: id, locationPoint: data);
    debugPrint("Sent to Server at: ${DateTime.now()}");
  } catch (e) {
    debugPrint(e.toString());
  }
}

void timedPing() {
  Timer.periodic(const Duration(minutes: 30), (timer) {
    // Code to repeat every 10 seconds
    locationPingServer();
  });
}
