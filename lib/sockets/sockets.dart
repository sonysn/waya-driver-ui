import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waya_driver/constants/api_constants.dart';

class ConnectToServer {
  final int? id;
  ConnectToServer({this.id});
  //configure socket transport
  Socket socket = io(
    //api link here
      ApiConstants.baseUrl,
      OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
          .build());

  //connect to websockets
  connect(driverID){
    //connect to websockets
    String who = 'Driver';
    socket.connect();
    socket.emit("identifyWho", who + driverID.toString());
    //socket.on("ridenotifications", (data)=> print(data));
    //socket.on("ridenotification", (data) => print(data));

    // //handle socket events
    // socket.on('connection', (_) => print('connect: ${socket.id}'));
    // socket.on('disconnect', (_) => print('disconnect'));
  }

  //disconnect from websockets
  disconnect(){
    socket.disconnect();
  }

  void sendDriverLocation(data, id){
    socket.emit("driverLocationUpdates", {data, id});
  }

  Future getRideNotifications(StateSetter setState) async{
    dynamic dataF;
    final streamController = StreamController();
    final Completer c = Completer();
    socket.on("ridenotifications", (data)=> setState((){
      AlertDialog(content: Text(data),);
    }));
    //print('dataF');
    //return dataF;
    streamController.stream.listen((event) {
      print(event);
    });
  }
}

