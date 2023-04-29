import 'package:flutter/material.dart';
import 'package:waya_driver/screens/widgets/transaction_card.dart';


class TransactionHistory extends StatefulWidget {
  final dynamic data;
  const TransactionHistory({Key? key, this.data}) : super(key: key);

  @override
  State<TransactionHistory> createState() =>
      _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [const SizedBox(
            height: 10,
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Transaction History',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                ListView.separated(
                    itemCount: 12,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      return TransactionCard(
                        data: widget.data
                      );})



              ]),
            ),SizedBox(
              height: 10,
            ),
          ],));
  }
}