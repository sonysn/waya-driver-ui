import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/colorscheme.dart';
import 'package:waya_driver/models/ride_history.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

//TODO: ADD A SPINNER WHILE WAITING FOR DATA TO FETCH
class RideHistoryPage extends StatefulWidget {
  final int driverID;
  final String authToken;
  const RideHistoryPage(
      {Key? key, required this.driverID, required this.authToken})
      : super(key: key);

  @override
  State<RideHistoryPage> createState() => RideHistoryPageState();
}

class RideHistoryPageState extends State<RideHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  // List<dynamic> ridesArray = [];
  List<dynamic> activeRides = [];
  List<dynamic> completedRides = [];
  List<dynamic> cancelledRides = [];

  Future<void> getRides({required int driverID}) async {
    final response =
        await getRideHistory(driverID: driverID, authBearer: widget.authToken);

    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   setState(() {
    //     ridesArray = data.reversed.toList();
    //   });
    //   print(ridesArray);
    // }
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      final reversedBookingList = data.reversed.toList();
      final bookingList = reversedBookingList.asMap().entries.map((entry) {
        //final index = entry.key;
        final booking = entry.value;
        return RideHistory.fromJson(booking);
      }).toList();
      setState(() {
        // ridesArray = bookingList.toList();
        //This code filters a list of bookings into three separate lists based on their status: active rides, completed rides, and cancelled rides.
        activeRides = bookingList
            .where((element) => element.status == 'Pending')
            .toList();
        completedRides = bookingList
            .where((element) => element.status == 'Completed')
            .toList();
        cancelledRides = bookingList
            .where((element) => element.status == 'Cancelled')
            .toList();
      });
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    getRides(driverID: widget.driverID);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text(
              "Trip History",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 40),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 0,
                ),
                Container(
                  height: 45,
                  decoration: const BoxDecoration(
                      //color: Colors.grey[300],
                      // border: Border(
                      //   bottom: BorderSide(width: 3.0, color: Colors.grey)
                      // ),
                      ),
                  child: const TabBar(
                    indicator: BoxDecoration(
                      //color: Colors.yellow[100],
                      border: Border(
                          bottom: BorderSide(
                              width: 3.0, color: Colors.orangeAccent)),
                    ),
                    labelColor: Colors.orangeAccent,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'Active Now',
                      ),
                      Tab(
                        text: 'Completed',
                      ),
                      Tab(
                        text: 'Cancelled',
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  children: [
                    ActivePage(data: activeRides, driverID: widget.driverID),
                    CompletedPage(
                        data: completedRides, driverID: widget.driverID),
                    CancelledPage(
                        data: cancelledRides, driverID: widget.driverID),
                  ],
                ))
              ],
            ),
          )),
    );
  }
}

class ActivePage extends StatelessWidget {
  final List data;
  final int driverID;
  const ActivePage({super.key, required this.data, required this.driverID});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: Colors.orangeAccent,
        backgroundColor: customPurple,
        onRefresh: () {
          return RideHistoryPageState().getRides(driverID: driverID);
        },
        child: Center(
            child: data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/booking.png"),
                      const Text(
                        'You have no Active Bookings',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // Map<String, dynamic> rideData =
                      //     ridesArray[index];

                      // Extract the data from the rideData map
                      String requestDate = data[index].requestDate;
                      String pickupLocation = data[index].pickupAddress;
                      String dropoffLocation = data[index].dropOffAddress;
                      int fare = data[index].fare;
                      String status = data[index].status;

                      // Format the date
                      DateTime date = DateTime.parse(requestDate);
                      String formattedDate =
                          DateFormat('MMM dd, yyyy').format(date);

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ride Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 3),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Request Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                formattedDate,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Pickup Location',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                pickupLocation,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Dropoff Location',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                dropoffLocation,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Fare',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '₦$fare',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )));
  }
}

class CompletedPage extends StatelessWidget {
  final List data;
  final int driverID;
  const CompletedPage({super.key, required this.data, required this.driverID});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: Colors.orangeAccent,
        backgroundColor: customPurple,
        onRefresh: () {
          return RideHistoryPageState().getRides(driverID: driverID);
        },
        child: Center(
            child: data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/booking.png"),
                      const Text(
                        'You have no Completed Bookings',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // Map<String, dynamic> rideData =
                      //     ridesArray[index];

                      // Extract the data from the rideData map
                      String requestDate = data[index].requestDate;
                      String pickupLocation = data[index].pickupAddress;
                      String dropoffLocation = data[index].dropOffAddress;
                      int fare = data[index].fare;
                      String status = data[index].status;

                      // Format the date
                      DateTime date = DateTime.parse(requestDate);
                      String formattedDate =
                          DateFormat('MMM dd, yyyy').format(date);

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ride Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 3),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Request Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                formattedDate,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Pickup Location',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                pickupLocation,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Dropoff Location',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                dropoffLocation,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Fare',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '₦$fare',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )));
  }
}

class CancelledPage extends StatelessWidget {
  final List data;
  final int driverID;
  const CancelledPage({super.key, required this.data, required this.driverID});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: Colors.orangeAccent,
        backgroundColor: customPurple,
        onRefresh: () {
          return RideHistoryPageState().getRides(driverID: driverID);
        },
        child: Center(
            child: data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/booking.png",
                      ),
                      const Text(
                        'You have no Cancelled Bookings',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // Map<String, dynamic> rideData =
                      //     ridesArray[index];

                      // Extract the data from the rideData map
                      String requestDate = data[index].requestDate;
                      String pickupLocation = data[index].pickupAddress;
                      String dropoffLocation = data[index].dropOffAddress;
                      int fare = data[index].fare;
                      String status = data[index].status;

                      // Format the date
                      DateTime date = DateTime.parse(requestDate);
                      String formattedDate =
                          DateFormat('MMM dd, yyyy').format(date);

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ride Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 3),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Request Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                formattedDate,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Pickup Location',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                pickupLocation,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Dropoff Location',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                dropoffLocation,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Fare',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '₦$fare',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )));
  }
}
