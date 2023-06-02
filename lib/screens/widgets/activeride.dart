import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waya_driver/api/actions.dart';
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
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      border: Border(

                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: customPurple,
                          size: 28,
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
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 19,
                                  ),
                                  SizedBox(width: 8.0),
                                  Flexible(
                                    child: Text(
                                      currentRidesArray[index]['pickUpLocation'],
                                      style: TextStyle(
                                        fontSize: 15,
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
                                    child: Text(
                                      currentRidesArray[index]['destinationLocation'],
                                      style: TextStyle(
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Colors.orangeAccent,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "End",
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
          ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
