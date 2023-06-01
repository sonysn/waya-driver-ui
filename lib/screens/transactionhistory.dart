import 'package:flutter/material.dart';
import 'package:waya_driver/screens/widgets/transaction_card.dart';

class TransactionHistory extends StatefulWidget {
  final dynamic data;
  final List transactions;

  const TransactionHistory({Key? key, this.data, required this.transactions}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List reversedTransactions = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      reversedTransactions = widget.transactions.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 40),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
                child: ListView.builder(
                  itemCount: widget.transactions.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TransactionCard(
                      data: widget.data,
                      depositAmount: reversedTransactions[index]['data']['amount'] / 100,
                      depositDate: reversedTransactions[index]['data']['paid_at'],
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
