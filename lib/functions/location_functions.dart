import 'dart:async';
import 'dart:io';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waya_driver/sockets/sockets.dart';

StreamSubscription? _subscription;

locationCallbacks() async{
  Location location = Location();
  location.enableBackgroundMode(enable: true);
  _subscription = location.onLocationChanged.listen((LocationData currentLocation) {
    ConnectToServer().sendDriverLocation(LatLng(
        double.parse(currentLocation.latitude.toString()),
        double.parse(currentLocation.longitude.toString())
    ));
  });
}

cancelLocationCallbacks(){
  _subscription?.cancel();
}