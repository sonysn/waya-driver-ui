import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';
import 'package:qunot_driver/api/actions.dart';
import 'package:qunot_driver/colorscheme.dart';

class DriverWidget extends StatefulWidget {
  final dynamic data;
  final int refreshCount;
  final VoidCallback? onRefreshHomePage;

  const DriverWidget({
    Key? key,
    this.data,
    required this.refreshCount,
    this.onRefreshHomePage,
  }) : super(key: key);

  @override
  State<DriverWidget> createState() => DriverWidgetState();
}

class DriverWidgetState extends State<DriverWidget> {
  Future<void> getCurrentRides() async {
    final response = await driverGetCurrentRides(
        driverID: widget.data.id, authBearer: widget.data.authToken);
    setState(() {
      currentRidesArray = response;
    });
    print(currentRidesArray);
  }

  Future driverCancelTrip({required int xindex}) async {
    final response = await onDriverCancelRide(
        driverID: widget.data.id,
        authBearer: widget.data.authToken,
        riderID: currentRidesArray[xindex]['riderID'],
        dbObjectID: currentRidesArray[xindex]['objectId']);
    if (response == 200) {
      print("OK RIDE CANCELLED");
    }
  }

  Future driverEndTrip({required int xindex}) async {
    final response = await onRideCompleted(
        driverID: widget.data.id,
        authBearer: widget.data.authToken,
        riderID: currentRidesArray[xindex]['riderID'],
        dbObjectID: currentRidesArray[xindex]['objectId']);
    if (response == 200) {
      print("OK RIDE COMPLETED");
      getCurrentRides(); // Refresh the rides list
    }
  }

  List currentRidesArray = [];

  //CURRENT TRIP DETAILS
  String? driverPhoto;
  String? driverVehicleName;
  String? driverVehiclePlateNumber;
  String? vehicleColour;
  String? driverPhoneNumber;
  String? pickUpLocation;
  String? destination;
  int? fare;
  double? rating;

  @override
  void initState() {
    super.initState();
    getCurrentRides();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _endTrip({required int indexPos}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'End Trip',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to end the trip?',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Perform the end trip action
                await driverEndTrip(xindex: indexPos);
                // Refresh the rides list
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                'End',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: Colors.grey,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelTrip({required int indexPos}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'Cancel Trip',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel the trip?',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform the cancel trip action
                driverCancelTrip(xindex: indexPos);
                widget.onRefreshHomePage?.call();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                getCurrentRides();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: Colors.grey,
              ),
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant DriverWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshCount != oldWidget.refreshCount) {
      getCurrentRides();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < currentRidesArray.length; index++)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    decoration: const BoxDecoration(
                      border: Border(),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: IconButton(
                            icon: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: customPurple.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: customPurple,
                                size: 28,
                              ),
                            ),
                            onPressed: () {
                              // ignore: deprecated_member_use
                              launch(
                                  "tel:${currentRidesArray[index]['riderPhoneNumber']}");
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.directions_car,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Expanded(
                                    child: Text(
                                      "Your Trip",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "₦ ${currentRidesArray[index]['fare']}",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: customPurple,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 19,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Flexible(
                                    child: Text(
                                      currentRidesArray[index]
                                          ['pickUpLocation'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Flexible(
                                    child: Text(
                                      currentRidesArray[index]
                                          ['destinationLocation'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _endTrip(indexPos: index);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              backgroundColor: Colors.orangeAccent,
                            ),
                            child: const Text(
                              "End",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _cancelTrip(indexPos: index);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              backgroundColor: customPurple,
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
