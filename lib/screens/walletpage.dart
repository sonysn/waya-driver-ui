import 'package:flutter/material.dart';
import 'package:waya_driver/screens/cash_deposit_page.dart';
import '../../../colorscheme.dart';
import 'package:waya_driver/screens/widgets/earning_card.dart';
import 'package:waya_driver/screens/widgets/transaction_card.dart';
import 'package:waya_driver/screens/transactionhistory.dart';
import 'package:waya_driver/screens/widgets/my_card.dart';
import 'package:waya_driver/screens/earninghistorypage.dart';

class WalletPage extends StatefulWidget {
  final dynamic data;
  const WalletPage({Key? key, this.data}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 180,
                child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 8,
                      );
                    },
                    itemCount: 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MyCard(
                        data: widget.data,
                      );
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // navigate to withdrawal page or function
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CashDepositPage();
                            }));
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.money, size: 40),
                          SizedBox(height: 10),
                          Text("Deposit"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // navigate to withdrawal page or function
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.card_membership_sharp, size: 40),
                          SizedBox(height: 10),
                          Text("Withdraw"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // navigate to withdrawal page or function
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.exit_to_app, size: 40),
                          SizedBox(height: 10),
                          Text("Share"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Recent Earnings"),
                  Flexible(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return EarningHistory(
                          data: widget.data,
                        );
                      })),
                      child: const Text("View all",
                          style: TextStyle(color: customPurple)),
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: 0,
              ),
              ListView.separated(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    return EarningCard(
                      data: widget.data,
                    );
                  }),
              SizedBox(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Recent Transactions"),
                  Flexible(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return TransactionHistory(
                          data: widget.data
                        );
                      })),
                      child: const Text("View all",
                          style: TextStyle(color: customPurple)),
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 0,
              ),
              ListView.separated(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    return TransactionCard(
                      data: widget.data,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
