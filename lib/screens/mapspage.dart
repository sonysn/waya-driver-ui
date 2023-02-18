import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  late final LatLng _center = _currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
        _currentLocation = LatLng(
            double.parse(locationDataSpot.latitude.toString()),
            double.parse(locationDataSpot.longitude.toString()));
        //mapController.move(myLocationHome, 17);
      });
    } else {
      super.dispose();
    }
    print(_currentLocation);
  }

  dynamic _currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentLocation != null
            ? SafeArea(
                child: Stack(children: [
                  GoogleMap(
                    markers: <Marker>{
                      Marker(
                        markerId: const MarkerId("1"),
                        position: _center,
                      ),
                    },
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 14.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 105, //MediaQuery.of(context).size.height / 5.2,
                        right: MediaQuery.of(context).size.width / 250),
                    child: Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: ElevatedButton(
                          onPressed: () {
                            findLoc();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                          ),
                          child:
                              const Icon(Icons.gps_fixed, color: Colors.black)),
                    ),
                  ),
                ]),
              )
            : const Center(child: Text('Loading...')));
  }
}
