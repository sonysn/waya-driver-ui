import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waya_driver/constants/api_constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:waya_driver/functions/notification_service.dart';
import 'package:waya_driver/main.dart';

class ConnectToServer {
  final int? id;

  ConnectToServer({this.id});

  final socketResponse = StreamController();

  void get addResponse => socketResponse.sink.add;

  Stream get getResponse => socketResponse.stream;

  void dispose() {
    socketResponse.close();
  }

  //configure socket transport
  Socket socket = io(
      //api link here
      ApiConstants.baseUrl,
      OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
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
        print(data['dropoffLocation']);
        NotificationService().showNotification(data['dropoffLocation']);

        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(data['pickupLocation']),
                    Text(data['dropoffLocation']),
                  ],
                ),
              ),
            );
          },
        );
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
    socket.disconnect();
  }

  void sendDriverLocation(data, id) {
    socket.emit("driverLocationUpdates", {data, id});
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