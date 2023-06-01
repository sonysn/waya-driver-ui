import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:flutter/material.dart';
import 'package:waya_driver/screens/widgets/transaction_card.dart';
import '../../../colorscheme.dart';
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
      // currentRidesArray.add(response);
      currentRidesArray = response;
    });
    print(currentRidesArray);
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

  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < currentRidesArray.length; index++)
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            height: 200, // Increased container height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
                bottom: Radius.circular(15),
              ),
            ),
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                  bottom: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.phone,
                      color: customPurple,
                      size: 28,
                    ),
                  ),
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
                              child:  Text(
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
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                currentRidesArray[index]['pickUpLocation'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(width: 8.0),
                            Flexible(
                              child:  Text(
                                currentRidesArray[index]['destinationLocation'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),Container(
                              width: double.infinity,
                              height: 60, // Increased elevated button height
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: customPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 16.0), // Added spacing between containers

      ],
    );
  }
}