import 'dart:async';
import 'dart:io';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waya_driver/sockets/sockets.dart';

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
