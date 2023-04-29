import 'package:flutter/material.dart';
import '../../../colorscheme.dart';

class MyCard extends StatefulWidget {
  final dynamic data;
  const MyCard({Key? key, this.data}) : super(key: key);

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.88,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: customPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${widget.data.firstName} ${widget.data.lastName}", style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white)
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                              "YOUR BALANCE", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white)
                          ),
                          Text(
                              "₦10,000", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.white)
                          ),
                        ],
                      ),
                      const SizedBox(width: 70),

                    ],
              ),


              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

              )
            ],
          ),
        );
      },
    );
  }
}