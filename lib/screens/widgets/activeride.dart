import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/screens/widgets/transaction_card.dart';
import '../../../colorscheme.dart';
import 'package:waya_driver/screens/bottom_nav.dart';
class DriverWidget extends StatefulWidget {
  final dynamic data;

  const DriverWidget({Key? key, this.data}) : super(key: key);

  @override
  State<DriverWidget> createState() => _DriverWidgetState();
}

class _DriverWidgetState extends State<DriverWidget> {
  Future<void> getCurrentRides() async {
    final response = await driverGetCurrentRides(driverID: widget.data.id);
    setState(() {
      currentRidesArray = response;
    });
    print(currentRidesArray);
  }
  bool _showDialog = false;

  void _startRefreshing() {
    setState(() {
      _showDialog = true;
    });

    // Simulating a delay of 2 seconds for the refresh process
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showDialog = false;
      });
      // Once the refresh is complete, navigate to the homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavPage()),
      );
    });
  }
  Future driverCancelTrip({required int xindex}) async {
    final response = await onDriverCancelRide(
        driverID: widget.data.id,
        riderID: currentRidesArray[xindex]['riderID']);
    if (response == 200) {
      print("OK RIDE CANCELLED");
    }
  }

  Future driverEndTrip({required int xindex}) async {
    final response = await onRideCompleted(
        driverID: widget.data.id,
        riderID: currentRidesArray[xindex]['riderID']);
    if (response == 200) {
      print("OK RIDE COMPLETED");
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
            onPressed: () {
          Navigator.of(context).pop(); // Close the dialog
          // Perform the end trip action
          driverEndTrip(xindex: indexPos);
          // Start the refreshing process
          _startRefreshing();
        },
        style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < currentRidesArray.length; index++)
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    decoration: BoxDecoration(
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
                              child: Icon(
                                Icons.phone,
                                color: customPurple,
                                size: 28,
                              ),
                            ),
                            onPressed: () {
                              launch(
                                  "tel:${currentRidesArray[index]['riderPhoneNumber']}");
                            },
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_car,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
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
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: customPurple,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 19,
                                  ),
                                  SizedBox(width: 8.0),
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
                              primary: Colors.orangeAccent,
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
                              primary: customPurple,
                            ),
                            child: Text(
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
        SizedBox(height: 16.0),
      ],
    );
  }
}
