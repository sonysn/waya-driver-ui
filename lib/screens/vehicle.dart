import 'package:flutter/material.dart';
import 'package:waya_driver/api/actions.dart';

class Vehicle extends StatefulWidget {
  dynamic data;

  Vehicle({Key? key, this.data}) : super(key: key);

  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  Future count() async {
    final res = await getDriverCars(widget.data.id, widget.data.token);
    setState(() {
      itemList = res;
    });
  }

  int itemCount = 0;
  dynamic itemList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getDriverCars(widget.data.id, widget.data.token);
    count();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Cars',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey,
        ),
        body: itemList != null
            ? Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                    itemCount: itemList['result'].length,
                    itemBuilder: (context, index) {
                      const Text(
                        'Your Cars',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      );
                      return ListTile(
                        title: Text(
                            '${itemList['result'][index]['VEHICLE_MAKE']}, ${itemList['result'][index]['VEHICLE_MODEL']}'),
                        subtitle: Text(
                          itemList['result'][index]['VEHICLE_PLATE_NUMBER'],
                        ),
                        trailing: Text(
                          itemList['result'][index]['VEHICLE_COLOUR'],
                        ),
                      );
                    }),
              )
            : Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Center(
                  child: Text('No Vehicles found or go back!'),
                )));
  }
}
