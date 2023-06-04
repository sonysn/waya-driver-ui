import 'package:flutter/material.dart';
import 'package:waya_driver/screens/widgets/earning_card.dart';

class EarningHistory extends StatefulWidget {
  final dynamic data;
  final List credits;

  const EarningHistory({Key? key, this.data, required this.credits}) : super(key: key);

  @override
  State<EarningHistory> createState() => _EarningHistoryState();
}

class _EarningHistoryState extends State<EarningHistory> {
  List reversedTransactions = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      reversedTransactions = widget.credits.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 25,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Earning History',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          widget.credits.isNotEmpty
              ? Container(
            padding: const EdgeInsets.only(top: 40),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  itemCount: widget.credits.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return EarningCard(

                      amountTransferred: reversedTransactions[index]['amountTransferred'],
                      dateTransferred: reversedTransactions[index]['datePaid'],
                    );
                  },
                ),
              ],
            ),
          )
              : Center(
            child: Container(
              margin: const EdgeInsets.all(45),
              child: const Text(
                'No Earnings Yet',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
