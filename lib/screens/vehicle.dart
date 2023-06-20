import 'package:flutter/material.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/colorscheme.dart';

class Vehicle extends StatefulWidget {
  final dynamic data;

  const Vehicle({Key? key, required this.data}) : super(key: key);

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
    super.initState();
    count();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vehicles',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customPurple,
      ),
      body: itemList != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Your Cars',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: itemList['result'].length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              '${itemList['result'][index]['VEHICLE_MAKE']}, ${itemList['result'][index]['VEHICLE_MODEL']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              itemList['result'][index]['VEHICLE_PLATE_NUMBER'],
                            ),
                            trailing: Text(
                              itemList['result'][index]['VEHICLE_COLOUR'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.car_rental,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Vehicles Found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You have no Registered vehicles',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
