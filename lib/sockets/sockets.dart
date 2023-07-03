import 'dart:async';

import 'package:waya_driver/colorscheme.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/constants/api_constants.dart';
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

class RideRequestCard extends StatefulWidget {
  final int riderId;
  final String name;
  final String pickupLocation;
  final String dropoffLocation;
  final int fare;
  final String riderPhoneNumber;
  final List pickupLocationPosition;
  final List dropoffLocationPostion;
  final VoidCallback? onRefreshHomePage;

  const RideRequestCard(
      {Key? key,
      required this.riderId,
      required this.name,
      required this.pickupLocation,
      required this.dropoffLocation,
      required this.fare,
      required this.riderPhoneNumber,
      required this.pickupLocationPosition,
      required this.dropoffLocationPostion,
      this.onRefreshHomePage})
      : super(key: key);

  @override
  State<RideRequestCard> createState() => _RideRequestCardState();
}

class _RideRequestCardState extends State<RideRequestCard> {
  late Completer<void> delayedCompleter;

  void buttonFunction() async {
    //!some of this data comes from the home page
    final response = await acceptRide(
        riderId: widget.riderId,
        riderPhoneNumber: widget.riderPhoneNumber,
        driverId: driverID,
        driverPhoto: driverPhoto,
        driverPhone: driverPhone,
        vehicleName: vehicleName,
        vehiclePlateNumber: vehiclePlateNumber,
        vehicleColour: vehicleColour,
        destinationLocation: widget.dropoffLocation,
        pickUpLocation: widget.pickupLocation,
        pickupLocationPosition: widget.pickupLocationPosition,
        dropoffLocationPostion: widget.dropoffLocationPostion,
        fare: widget.fare);
    //fetchHomepageNotifier.value = true;
    if (response == 404) {
      //TODO: DESIGN THIS
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Ride not found',
      )));
    }
  }

  @override
  void initState() {
    super.initState();
    delayedCompleter = Completer<void>();
    Future.delayed(const Duration(seconds: 10)).then((_) {
      if (!delayedCompleter.isCompleted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    if (!delayedCompleter.isCompleted) {
      delayedCompleter
          .complete(); // Complete the future if it hasn't completed yet
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: [
              Padding(
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
                      'Hello, ${widget.name} is requesting a ride',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ' ₦${widget.fare.toStringAsFixed(2)}',
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
                                ' ${widget.pickupLocation}',
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
                                widget.dropoffLocation,
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
                      onPressed: () async {
                        buttonFunction();
                        // print("ride accepted");
                        //?This Calls this value notifier of the homepage.dart file
                        await Future.delayed(const Duration(seconds: 1), () {
                          fetchHomepageNotifier.value = true;
                        });
                        // fetchHomepageNotifier.value = true;
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customPurple,
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
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
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
              const LoadingAnimation()
            ],
          ),
        );
      },
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  LoadingAnimationState createState() => LoadingAnimationState();
}

class LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  final double _maxValue = 1.0;
  final double _minValue = 0.0;
  final int _animationDuration = 10;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: _animationDuration));
    _animation =
        Tween<double>(begin: _maxValue, end: _minValue).animate(_controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //_controller.repeat();
            } else if (status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _animation.value,
      minHeight: 5.0,
      backgroundColor: Colors.grey,
      valueColor:
          const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 0, 0)),
    );
  }
}
