import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              //color: Colors.yellow,
              height: 120,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: DefaultTabController(
                length: 3,
                child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "My Bookings",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 20,
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
              ),
          ],
        ),
      ),
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
            Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwxbCTjXKukWVGo0TTWhg2iUHQQ9nmrplLWg&usqp=CAU'),
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
            Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwxbCTjXKukWVGo0TTWhg2iUHQQ9nmrplLWg&usqp=CAU'),
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
            Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwxbCTjXKukWVGo0TTWhg2iUHQQ9nmrplLWg&usqp=CAU'),
            const Text(
              'You have no Cancelled Bookings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
