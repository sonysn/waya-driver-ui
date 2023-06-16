import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/models/ride_history.dart';

class RideHistoryPage extends StatefulWidget {
  final dynamic driverID;
  const RideHistoryPage({Key? key, this.driverID}) : super(key: key);

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<dynamic> ridesArray = [];

  Future<void> getRides() async {
    final response = await getRideHistory(driverID: widget.driverID);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ridesArray = data.reversed.toList();
      });
      print(ridesArray);
    }
    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body) as List<dynamic>;
    //   final reversedBookingList = data.reversed.toList();
    //   final bookingList = reversedBookingList.asMap().entries.map((entry) {
    //     //final index = entry.key;
    //     final booking = entry.value;
    //     return RideHistory.fromJson(booking);
    //   }).toList();
    //   setState(() {
    //     ridesArray = bookingList.toList();
    //   });
    // }
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    getRides();
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
              "My Bookings",
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
                  child: TabBar(
                    indicator: const BoxDecoration(
                      //color: Colors.yellow[100],
                      border: Border(
                          bottom: BorderSide(width: 3.0, color: Colors.yellow)),
                    ),
                    labelColor: Colors.yellow[600],
                    unselectedLabelColor: Colors.black,
                    tabs: const [
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
                const Expanded(
                    child: TabBarView(
                  children: [ActivePage(), CompletedPage(), CancelledPage()],
                ))
              ],
            ),
          )),
    );
  }
}

class ActivePage extends StatelessWidget {
  const ActivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/booking.png"),
        const Text(
          'You have no Active Bookings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    ));
  }
}

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/booking.png"),
        const Text(
          'You have no Completed Bookings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    ));
  }
}

class CancelledPage extends StatelessWidget {
  const CancelledPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/booking.png",
        ),
        const Text(
          'You have no Cancelled Bookings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    ));
  }
}
