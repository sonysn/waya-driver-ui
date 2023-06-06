import 'dart:async';
import '../../../colorscheme.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/constants/api_constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:waya_driver/functions/notification_service.dart';
import 'package:waya_driver/main.dart';
import 'package:waya_driver/screens/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConnectToServer {
  final int? id;

  ConnectToServer({this.id});

  // //
  // final socketResponse = StreamController();

  // void get addResponse => socketResponse.sink.add;

  // Stream get getResponse => socketResponse.stream;

  // void dispose() {
  //   socketResponse.close();
  // }

  //configure socket transport
  Socket socket = io(
      //api link here
      ApiConstants.baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect() // for Flutter or Dart VM
          .build());

//connect to websockets
  connect(driverID, BuildContext context) {
    //connect to websockets
    String who = 'Driver';
    socket.connect();
    socket.emit("identifyWho", who + driverID.toString());
    print('helloo');
    // socket.on("ridenotifications", (data) {
    //   print(data);
    //   print(data['dropoffLocation']);
    //   NotificationService().showNotification((data['dropoffLocation']));
    // });
    //THIS FUNCTION NOTIFIES AND CREATES A DIALOG BOX
    void myFunction(BuildContext context) {
      socket.on("ridenotifications", (data) {
        print(data);
        if (data != null) {
          //NotificationService().showNotification("Hi, John Doe is requesting a ride at ${data['dropoffLocation']}");

          try {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return RideRequestCard(
                  riderId: data['userId'],
                  name: 'Someone',
                  pickupLocation: data['pickupLocation'],
                  dropoffLocation: data['dropoffLocation'],
                  fare: data['estFare'],
                  riderPhoneNumber: data['riderPhone'],
                  pickupLocationPosition: data['pickupLocationPosition'],
                  dropoffLocationPostion: data['dropoffLocationPostion'],
                );
              },
            );
          } catch (e) {
            print('Error showing bottom sheet: $e');
          }
        }
      });
    }

    myFunction(context);

    //socket.on("ridenotification", (data) => print(data));

    // //handle socket events
    // socket.on('connection', (_) => print('connect: ${socket.id}'));
    // socket.on('disconnect', (_) => print('disconnect'));
  }

//disconnect from websockets
  disconnect() {
    socket.dispose();
  }

  void sendDriverLocation(
      {required LatLng data,
      required int id,
      required bool verificationStatus,
      required List driverDestPoint}) {
    //List driverDestPoint = [6.518751, 3.391288];
    socket.emit("driverLocationUpdates",
        {data, id, verificationStatus, driverDestPoint});
  }

//   Stream getRideNotifications() async* {
//     dynamic dataF;
//     final streamController = StreamController();
//     final Completer c = Completer();
//     socket.on("ridenotifications", (data) => c.complete(data));
//     //print('dataF');
//     //return dataF;
//     streamController.stream.listen((event) {
//       print(event);
//     });
//   }
}

class RideRequestCard extends StatelessWidget {
  final int riderId;
  final String name;
  final String pickupLocation;
  final String dropoffLocation;
  final int fare;
  final String riderPhoneNumber;
  final List pickupLocationPosition;
  final List dropoffLocationPostion;

  const RideRequestCard({
    Key? key,
    required this.riderId,
    required this.name,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.riderPhoneNumber,
    required this.pickupLocationPosition,
    required this.dropoffLocationPostion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Card(
                    elevation: 0,
                    color: Colors.black,
                    child: SizedBox(
                      height: 7,
                      width: MediaQuery.of(context).size.width / 2.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Hello, $name is requesting a ride',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  ' ₦${fare.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'From: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            ' $pickupLocation',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Center(
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'To: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            dropoffLocation,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                  ],
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    //!some of this data comes from the home page
                    acceptRide(
                        riderId: riderId,
                        riderPhoneNumber: riderPhoneNumber,
                        driverId: driverID,
                        driverPhoto: driverPhoto,
                        driverPhone: driverPhone,
                        vehicleName: vehicleName,
                        vehiclePlateNumber: vehiclePlateNumber,
                        vehicleColour: vehicleColour,
                        destinationLocation: dropoffLocation,
                        pickUpLocation: pickupLocation,
                        pickupLocationPosition: pickupLocationPosition,
                        dropoffLocationPostion: dropoffLocationPostion,
                        fare: fare);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: customPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
